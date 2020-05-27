<a name=top><img align=right width=280 src="https://pngimage.net/wp-content/uploads/2019/05/silueta-planetas-png-.png">
<h1><a href="/README.md#top">Is AI Easy?</a></h1> 
<p> <a
href="https://github.com/aiez/eg/blob/master/LICENSE">license</a> :: <a
href="https://github.com/aiez/eg/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/aiez/eg/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/aiez/eg/issues">issues</a> :: <a
href="https://github.com/aiez/eg/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/aiez/eg/blob/master/CONTACT.md#top">contact</a> </p><p> 
<img src="https://img.shields.io/badge/license-mit-red"><img 
src="https://img.shields.io/badge/language-lua-orange"><img 
src="https://img.shields.io/badge/purpose-ai,se-blueviolet"><img 
src="https://img.shields.io/badge/platform-mac,*nux-informational"><a 
     href="https://travis-ci.org/github/sehero/lua"><img 
src="https://travis-ci.org/aiez/eg.svg?branch=master"></a><a 
     href="https://zenodo.org/badge/latestdoi/263210595"><img 
src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a><a 
     href='https://coveralls.io/github/aiez/lua?branch=master'><img i
src='https://coveralls.io/repos/github/aiez/eg/badge.svg?branch=master' alt='Coverage Status' /></a></p>
<em>The computing scientists main challenge is not to get confused by the complexities of (their) own making.</em><br>  
-- E.W. Dijkstra<hr>

# `Obj`: defined classes

Taken from the excellent Microlight library.

```lua

local ml = {}
local select,pairs = select,pairs
local function_arg

table.unpack = table.unpack or unpack

```

## Classes.

Create a class with an optional base class.

The resulting table can be called to make a new object, which invokes
an optional constructor named `_init`. If the base
class has a constructor, you can call it as the `super()` method.
Every class has a `_class` and a maybe-nil `_base` field, which can
be accessed through the object.

All metamethods are inherited.
The class is given a function `Klass.classof(obj)`.

```lua

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

```
This code uses some lower-level tools:

## Update

Add the key/value pairs of arrays to the first array.
For sets, this is their union. For the same keys,
the values from the first table will be overwritten.
```lua

function ml.update (t,...)
    for i = 1,select('#',...) do
        for k,v in pairs(select(i,...)) do
            t[k] = v
        end
    end
    return t
end

```
## Import

Bring modules or tables into 't`.
If `lib` is a string, then it becomes the result of `require`
With only one argument, the second argument is assumed to be
the `ml` table itself.
```lua

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

return ml.class

```

