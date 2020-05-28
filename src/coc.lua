local lib=require "lib"

local r     = math.random
local within= function(a,b) return a + r()*(b-a) end

local Range, Sf, Em, Emp, Emn, A,B

local Range= lib.class()

function Range:_init(lo,h)
  self.name = name
  self.lo   = lo or 1
  self.hi   = hi or 5
  self.x    = within(self.lo, self.hi)
  self.y    = self:yy()
end

function Range:xx()  return within(self.lo, self.hi) end
function Range:yy(_) return self:xx() end

Sf  = lib.class(Range)
Em  = lib.class(Range)
Emp = lib.class(Em)
Emn = lib.class(Em)
A   = lib.class(Range)
B   = lib.class(Range)

for i=1,10 do
  print(i, within(-1.56, -1.014))
end

function Sf:mm()  return within(-1.56,  -1.014) end
function Emp:mm() return within( 0.073,  0.21)  end
function Emn:mm() return within(-0.178, -0.078) end

function Sf:yy(_)  return self:mm()*(self:xx() - 6)     end
function Em:yy(_)  return self:mm()*(self:xx() - 3) + 1 end
function A:yy(_)   return  within(2.2, 9.18)
function B:yy(all)   
  local rise,run
  local m = (0.85 - 1.1) / (9.18 - 2.2)
  return m*self.a + 1.1+ (1.1-0.8)*.5 end

Ranges = lib.class()

function Ranges:_init()
  self.all = {}
  self.y   = {}
  for x,range in pairs(self:about()) do
    range.name = x
    self.all[x] = range 
  end
end

function Ranges:__tostring() 
  return table.concat( self:ys(), ",") end

function Ranges:ys(    t)
  t = {} 
  for _,x in pairs(self.all) do t[#t+1] = self.y[x.name] end
  return t 
end

Cocomo = lib.class(Ranges)
function Cocomo:about() 
   return { 
     kloc = Range(2,1000), 
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
     tool = Emn(), site = Emn(1,6), sced = Emn() }
end

math.randomseed(1)
t={}
for i=1,10 do
  c= Cocomo()
  t[#t+1] = string.format('%.2f',c.y.acap) 
  for i=1,10 do
    print(100,i,c.y.acap, c.all["acap"]:m(),c.all["acap"]:y())
  end
  break
end
table.sort(t)
print(table.concat(t,","))
