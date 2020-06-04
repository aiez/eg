local lib = require "lib"
local Num = lib.class()

function Num:_init(txt,pos)
  self.txt = txt
  self.pos = pos
  self.hi  = math.mininteger
  self.lo  = math.maxinteger
  self.w   = lib.less(txt or "") and -1 or 1
  self.n, self.mu, self.m2, self.sd = 0,0,0,0
end

function Num:mid() return self.mu end
function Num:var() return self.sd end
function Num:adds(a) 
  lib.map(a, function(z) self:add(z) end) 
  return self
end

function Num:show()
   return string.format("%s%s = %.2f", 
               self.w < 0 and "<" or ">", self.txt, self.mu)
end

function Num:add (x,    d)
  if x ~= "?" then 
    self.n  = self.n + 1
    d       = x - self.mu
    self.mu = self.mu + d / self.n
    self.m2 = self.m2 + d * (x - self.mu) 
    self.sd = self:sd0()
    self.lo = math.min(x, self.lo)
    self.hi = math.max(x, self.hi)
  end
  return x
end

function Num:sub (x,     d)
  if x ~= "?" then
    self.n  = self.n - 1
    d       = x - self.mu
    self.mu = self.mu - d / self.n
    self.m2 = self.m2 - d * (x - self.mu)
    self.sd = self:sd0()
  end
  return x
end

function Num:sd0()
  if self.n  < 2 then return 0 end
  if self.m2 < 0 then return 0 end
  return (self.m2 / (self.n - 1))^0.5
end

function Num:norm(x,y)
  return x=="?" and x or (x-self.lo)/(self.hi-self.lo+10^-64)
end

function Num:dist(x,y)
  if     x == "?" and  y == "?" then return 1  
  elseif x == "?" then y = self:norm(y); x=y>0.5 and 0 or 1
  elseif y == "?" then x = self:norm(x); y=x>0.5 and 0 or 1
  else   x = self:norm(x)
         y = self:norm(y)                   
  end
  return math.abs(x - y)
end


return Num
