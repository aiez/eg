local ml = {}
local select,pairs = select,pairs
local function_arg

table.unpack = table.unpack or unpack

--- add the key/value pairs of arrays to the first array.
-- For sets, this is their union. For the same keys,
-- the values from the first table will be overwritten.
-- @param t table to be updated
-- @param ... tables containg more pairs to be added
-- @return the updated table
function ml.update (t,...)
    for i = 1,select('#',...) do
        for k,v in pairs(select(i,...)) do
            t[k] = v
        end
    end
    return t
end

-- Bring modules or tables into 't`.
-- If `lib` is a string, then it becomes the result of `require`
-- With only one argument, the second argument is assumed to be
-- the `ml` table itself.
-- @param t table to be updated, or current environment
-- @param lib table, module name or `nil` for importing 'ml'
-- @return the updated table
function ml.import(t,...)
    local other
    -- explicit table, or current environment
    -- this isn't quite right - we won't get the calling module's _ENV
    -- this way. But it does prevent execution of the not-implemented setfenv.
    t = t or _ENV or getfenv(2)
    local libs = {}
    if select('#',...)==0 then -- default is to pull in this library!
        libs[1] = ml
    else
        for i = 1,select('#',...) do
            local lib = select(i,...)
            if type(lib) == 'string' then
                local value = _G[lib]
                if not value then -- lazy require!
                    value = require (lib)
                    -- and use the module part of package for the key
                    lib = lib:match '[%w_]+$'
                end
                lib = {[lib]=value}
            end
            libs[i] = lib
        end
    end
    return ml.update(t,table.unpack(libs))
end

---------------------------------------------------
-- Classes.
-- @section class
---------------------------------------------------

--- create a class with an optional base class.
--
-- See  @{readme.md.Classes}
-- The resulting table can be called to make a new object, which invokes
-- an optional constructor named `_init`. If the base
-- class has a constructor, you can call it as the `super()` method.
-- Every class has a `_class` and a maybe-nil `_base` field, which can
-- be accessed through the object.
--
-- All metamethods are inherited.
-- The class is given a function `Klass.classof(obj)`.
-- @param base optional base class
-- @return the callable metatable representing the class
function ml.class(base)
    local klass, base_ctor = {}
    if base then
        ml.import(klass,base)
        klass._base = base
        base_ctor = rawget(base,'_init')
    end
    klass.__index = klass
    klass._class = klass
    klass.classof = function(obj)
        local m = getmetatable(obj) -- an object created by class() ?
        if not m or not m._class then return false end
        while m do -- follow the inheritance chain --
            if m == klass then return true end
            m = rawget(m,'_base')
        end
        return false
    end
    setmetatable(klass,{
        __call = function(klass,...)
            local obj = setmetatable({},klass)
            if rawget(klass,'_init') then
                klass.super = base_ctor
                local res = klass._init(obj,...) -- call our constructor
                if res then -- which can return a new self..
                    obj = setmetatable(res,klass)
                end
            elseif base_ctor then -- call base ctor automatically
                base_ctor(obj,...)
            end
            return obj
        end
    })
    return klass
end

return ml

