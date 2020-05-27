local class=require "class"

local r     = math.random
local within= function(a,b) return a + r()*(b-a) end

print(within(10,20))
local Range= class()

function Range:_init(name,lo,hi)
  self.name = name
  self.lo   = lo or 1
  self.hi   = hi or 6
end

function Range:show(y)
  y = y or self:y()
  local fmt = y > 10 and "%.0f" or "%4.2f"
  return string.format(fmt,y)
end

function Range:x() return within(self.lo, self.hi) end
function Range:y() return self:x() end

local Sf = class(Range)

function Sf:y() return self:m()*(self:x() - 6) end
function Sf:m() return within(-0.972,-0.648) end

local Em = class(Range)
function Em:y() return self:m()*(self:x()-3) + 1 end

local Emp = class(Em)
function Emp:m() return within(0.055,0.15) end

local Emn = class(Em)
function Emn:m() return within(-0.166,-0.075) end

local B = class(Range)
function B:y() 
  return -0.036 * self:x() + 1.1 - 0.1*r() -0.05 end

function cocomo() 
  return {  Range("kloc",2,1000), 
            B(  "b",3,10),
            Sf( "prec"),
            Sf( "flex"), 
            Sf( "arch"),
            Sf( "team"), 
            Sf( "pmat"), 
            Emp("rely"),
            Emp("data", 2,5),
            Emp("cplx", 1,6),
            Emp("ruse", 2,6),
            Emp("docu", 1,5),
            Emp("time", 3,6),
            Emp("stor", 3,6),
            Emp("pvol", 2,5),
            Emn("acap"),
            Emn("pcap"),
            Emn("pcon"),
            Emn("aexp"),
            Emn("pexp"),
            Emn("ltex"),
            Emn("tool"),
            Emn("site",1,6),
            Emn("sced")}
end

for i=1,100 do
  local t={} 
  for _,one in pairs(cocomo()) do
     t[#t+1] = one:show() end
  print(table.concat(t,","))
end
