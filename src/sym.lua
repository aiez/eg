local lib = require "lib"
local Sym = lib.class()

function Sym:_init(txt,pos)
  self.txt  = txt
  self.pos  = pos
  self.seen = {}
  self.n, self.most, self.mode = 0,0,nil
end

function Sym:add (x,    c)
  if x ~= "?" then 
    c = (self.seen[x] or 0) + 1
    if c > self.most then self.most,self.mode = c,x end 
    self.seen[x] = c
    self.n = self.n + 1
  end
  return x
end

function Sym:adds(a) 
  lib.map(a, function(z) self:add(z) end) 
  return self
end

function Sym:dist(x,y) 
  if x=="?" and y=="?" then return 1 end
  return x==y and 0 or 1 
end

function Sym:ent(    e,p)
  e = 0
  for _,f in pairs(self.seen) do
    if f > 0 then
      p = f/self.n
      e = e - p* math.log(p,2) end end
  return e
end

function Sym:mid() return self.mode  end

function Sym:show() 
  return string.format("%s = %s", self.txt, self.mode) end

function Sym:sub (x,     seen,n)
  if x ~= "?" then
    n = self.seen[x]
    if n and n > 0 then
      self.n    = self.n - 1
      self.seen[x] = self.seen[x] - 1 end end
  return x
end

function Sym:var() return self:ent() end

function Sym:xpect(other)
  local n1,n2 = self.n, other.n
  return n1/(n1+n2) * self:var() + n2/(n1+n2)*other:var()
end

return Sym
