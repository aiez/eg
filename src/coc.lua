local lib  = require "lib"
local risk = require "cocrisk"

local r     = math.random
local within= function(a,b) return a + r()*(b-a) end

--[[
## `Range` = one data point
--]]

local Range, Constant, Em, Emp, Emn, Sf,B

Range= lib.class()
function Range:_init(lo,hi,name)
  self.name = name
  self.lo   = lo or 1
  self.hi   = hi or 5
  self.x    = lib.round(within(self.lo, self.hi),0)
end

function Range:yy(_) return self.x end

Constant = lib.class(Range)
function Constant:_init(x,name)
  self.name = name
  self.lo   = x
  self.hi   = x
  self.x    = x
end

Em = lib.class(Range)
function Em:yy(_) return self:mm()*(self.x - 3) + 1 end

Emp = lib.class(Em)
function Emp:mm() return within( 0.073,  0.21)  end

Emn = lib.class(Em)
function Emn:mm() return within(-0.178, -0.078) end

Sf = lib.class(Range)
function Sf:yy(_) return self:mm()*(self.x - 6)     end
function Sf:mm()  return within(-1.56,  -1.014) end

B = lib.class(Range)
function B:yy(all)   
  local m = (0.85 - 1.1) / (9.18 - 2.2)
  return m*all.a + 1.1+ (1.1-0.8)*.5 end

--[[
## `Ranges` = a set of "Range"s
--]]

local Ranges = lib.class()
function Ranges:_init(xs)
  self._meta = {}
  for i,z in pairs(xs or {}) do
    local range = type(z)=='number' and Constant(z,i) or z 
    range.name = i
    self._meta[i] = range
    self[i] = range.x
  end
  for i,range in pairs(self._meta) do 
    self[i]= range:yy(self)
  end
end

--[[
## `Cocomo` = a kind of Ranges
--]]

local Cocomo = lib.class(Ranges)
function Cocomo:_init()
  self:super {
    ['>kloc'] = Range(2,1000), 
    a    = within(2.2, 9.18),
    b    = B(3,10),
    -- exponential influences
    prec = Sf(), flex = Sf(), arch = Sf(), 
    team = Sf(), pmat = Sf(), 
    -- linearly influential
    rely = Emp(),    data = Emp(2,5), cplx = Emp(1,6),
    ruse = Emp(2,6), docu = Emp(), time = Emp(3,6),
    stor = Emp(3,6), pvol = Emp(2,5),
    -- negatively linearly influential
    acap = Emn(), pcap = Emn(),    pcon = Emn(),
    aexp = Emn(), plex = Emn(),    ltex = Emn(),
    tool = Emn(), site = Emn(1,6), sced = Emn() 
  }
end

function Cocomo:effort()
  local i = self
  local sfs= i.prec + i.flex + i.arch + i.team + i.pmat
  local ems= i.rely*i.data*i.cplx*i.ruse*i.docu*i.time*i.stor*
             i.pvol*i.acap*i.pcap*i.pcon*i.aexp*i.plex*i.ltex*
             i.tool*i.site*i.sced
  return i.a*i['>kloc']^(i.b+0.01*sfs)*ems
end

function Cocomo:risk()
  local r = 0
  for a,rules in pairs(risk) do
    for b,rule in pairs(rules) do 
      local x,y = self._meta[a].x, self._meta[b].x
      r = r + rule[ x ][ y ] 
    end
  end
  return r / 104
end

function Cocomo.header()
  local t, c = {}, Cocomo()
  for k,_ in lib.keys(c._meta) do t[#t+1] = k end
  t[#t+1] = "<effort"
  t[#t+1] = "<risk"
  return t
end

function Cocomo.rows(n)
  n = n or 100
  return function ()
    if n > 0 then
      n = n - 1
      local t = {}
      local c= Cocomo()
      for _,range in lib.keys(c._meta) do
        t[#t+1] = math.floor(range.x)
      end
      t[#t+1] = c:effort()
      t[#t+1] = c:risk()
      return t end end
end

return Cocomo
