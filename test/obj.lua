require "ok"

local obj    = require "obj"
local Person = obj.class()

function Person:_init(name)
  self.name=name
end

function Person:__tostring()
  return 'Person.' .. self.name 
end

local Emp = obj.class(Person)

function Emp:_init(name,class)
  self:super(name)
  self.class = class
end

function Emp:__tostring()
  return Person.__tostring(self) .. '::' .. self.class
end

ok{ok = function(  a,b) 
  a= tostring(Emp('tim','manager'))
  b= 'Person.tim::manager'
  assert(a== b)
end}

