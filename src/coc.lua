local lib=require "lib"

local r     = math.random
local within= function(a,b) return a + r()*(b-a) end

local Range= lib.class()
function Range:_init(lo,hi)
  self.name = name
  self.lo   = lo or 1
  self.hi   = hi or 5
  self.x    = within(self.lo, self.hi)
end

function Range:xx()  return within(self.lo, self.hi) end
function Range:yy(_) return self:xx() end

local Ranges = lib.class()
function Ranges:_init(xs)
  local r = lib.round
  self._meta = {}
  xs = xs or {}
  for i,x in pairs(xs) do
    if type(x) == 'number' then self[i] = x end
     self._meta[#self._meta+1] = i
  end
  for i,x in pairs(xs) do 
    self[i]= r(self[i] or x:yy(self),s32) end
end

function Ranges:__tostring()
  local t={}
  for i,_ in pairs(i._meta) do
    t[#t+1] = self[i]
  end
  return table.concat(t,",")
end
local Em = lib.class(Range)
function Em:yy(_) return self:mm()*(self:xx() - 3) + 1 end

local Emp = lib.class(Em)
function Emp:mm() return within( 0.073,  0.21)  end

local Emn = lib.class(Em)
function Emn:mm() return within(-0.178, -0.078) end

local Sf = lib.class(Range)
function Sf:yy(_) return self:mm()*(self:xx() - 6)     end
function Sf:mm()  return within(-1.56,  -1.014) end

local B = lib.class(Range)
function B:yy(all)   
  local m = (0.85 - 1.1) / (9.18 - 2.2)
  return m*all.a + 1.1+ (1.1-0.8)*.5 end

Cocomo = lib.class(Ranges)
function Cocomo:_init()
   self:super {
     kloc = Range(2,1000), 
     a    = within(2.2, 9.18),
     b    = B(3,10),
     -- ----------------------------------------
     -- exponential influences
     prec = Sf(), flex = Sf(), arch = Sf(), 
     team = Sf(), pmat = Sf(), 
     -- ----------------------------------------
     -- linearly influential
     rely = Emp(),    data = Emp(2,5), cplx = Emp(1,6),
     ruse = Emp(2,6), docu = Emp(), time = Emp(3,6),
     stor = Emp(3,6), pvol = Emp(2,5),
     -- ----------------------------------------
     -- negatively linearly influential
     acap = Emn(), pcap = Emn(),    pcon = Emn(),
     aexp = Emn(), plex = Emn(),    ltex = Emn(),
     tool = Emn(), site = Emn(1,6), sced = Emn() 
     }
end
function Cocomo:sum()
   local i = self
   return i.prec + i.flex + i.arch + i.team + i.pmat
end
function Cocomo:prod()
  local i = self
  return i.rely*i.data*i.cplx*i.ruse*i.docu*i.time*i.stor*
         i.pvol*i.acap*i.pcap*i.pcon*i.aexp*i.plex*i.ltex*
         i.tool*i.site*i.sced
end
function Cocomo:effort()
  local i = self
  return i.a*i.kloc^(i.b+0.01*i:sum())*i:prod()
end
c=Cocomo()

print(c, c:effort())

