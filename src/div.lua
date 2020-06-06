local l   = require "lib"
local cp  = l.copy
local Num = require "num"
local Sym = require "sym"

local Div = l.class()
function Div:_init(pos,classes)
  self.pos    = pos
  self.all    = classes
  self.max    = 1024
  self.cohen  = 0.3
  self.min    = 0.5
  self.better = 1.025
end

function Div:divs()
  local a, n, xs, ys = {}, 0, Num(), Sym()
  for i,one in pairs(self.all) do n=n + #one.rows end
  for y,one in pairs(self.all) do
    for _,row in pairs(one.rows) do
      local x = row.cells[self.pos]
      if x ~= "?" then
        if rand() < self.max/n then
          a[#a+1] = {x=xs:add(x), y=ys:add(y)} end end end 
  end
  table.sort(a, function(z1,z2) return z1.x < z2.x end)
  local b = {}
  self:divs1(1, #a, a, xs, ys, (#a)^self.min, 
             self.better, xs:var()*self.cohen, 
             b)
  return b
end

function Div:divs1(lo, hi, a,xs, ys, min, bt, tiny, b)
  local xl,yl,xr,yr,best = Num(),Sym(),cp(xs),cp(ys),ys:var()
  local cut,xl1,yl1,xr1,yr1,x1
  if hi - li >= 2*min then
    for i = lo,hi do
      xl:add( xr:sub( a[i].x ) )
      yl:add( yr:sub( a[i].y ) )
      if        xl.n   >= min 
           and  xr.n   >= min 
           and  a[i].x ~= a[i+1].x 
           and  tiny   <  xr.mu - xl.mu  
           and  best   >  bt*yl:xpect(yr)
      then cut, best   =  i, yl:xpect(yr)
           xl1, yl1    =  cp(xl), cp(yl)
           xr1, yr1    =  cp(xr), cp(yr) end end
  end
  if     cut 
  then   self:divs1(lo,   cut, a, xl, yl, min, bt, tiny, b)
         self:divs1(cut+1, hi, a, xr, yr, min, bt, tiny, b)
  elseif hi ~= #a then b[#b+1] = a[hi].x  
  end
end

return Div
