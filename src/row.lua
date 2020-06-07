local lib = require "lib"
local Row = lib.class()

function Row:_init(a) 
  a = a.cells and a.cells or a
  self.cells = {} 
  for i,x in pairs(a or {}) do self.cells[i] = x end
  self.best  = false
  lib.id(self)
end

function Row:dist(other,cols,    p,    d,n,inc)
  d, n, p = 0, 0.00001, p or 2
  for _,c in pairs(cols) do
    inc = c:dist(self.cells[c.pos], other.cells[c.pos])
    d   = d + inc^p
    n   = n + 1
  end
  return (d/n)^(1/p) 
end

function Row:dominates(other,cols,    s1,s2,n,x,y,x1,y1)
   s1,s2,n = 0,0,(#cols + 0.00001)
   for _,col in pairs(cols) do
     x  = self.cells[col.pos]
     y  = other.cells[col.pos]
     x1 = col:norm(x)
     y1 = col:norm(y)
     s1 = s1 - 10^(col.w*(x1-y1)/n)
     s2 = s2 - 10^(col.w*(y1-x1)/n)
   end
  return s1/n < s2/n 
end

return Row
