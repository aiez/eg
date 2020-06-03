local lib = require "lib"
local Row = lib.class()

function Row:_init(a) 
  self.cells = a.cells and a.cells or a
  lib.id(self)
end

function Row:dist(other,cols,    p,    d,n,inc)
  d, n, p = 0, 0.0001, p or 2
  for _,c in pairs(cols) do
    inc = c:dist(self.cells[c.pos], other.cells[c.pos])
    d   = d + inc^p
    n   = n + 1
  end
  return (d/n)^(1/p) 
end

return Row
