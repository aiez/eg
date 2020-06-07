local l   = require "lib"
local cp  = l.copy
local Num = require "num"
local Sym = require "sym"

local DivNum = l.class()
function DivNum:_init(col,all,best,out)
  self.all    = all
  self.col    = col
  self.best   = best
  self.out    = out or {}
  self.cohen  = l.the.div.cohen
  self.better = l.the.div.better
  self.min     = (#all)^l.the.div.min
end

function DivNum:div()
  table.sort(self.all, function(a,b) return a.x < b.x end)
  local xs,ys = Num(), Sym)_
  for _,one in pairs(all) do
    xs:add(one.x)
    ys:add(one.y)
  end
  self.cohen= self.xs:var()*self.cohen
  self:div1(1, #a, xs, ys)
  return self.out
end

function DivNum:div1(lo, hi, xs, ys)
  local xl,yl,xr,yr,best = Num(),Sym(),cp(xs),cp(ys)
  local cut,xl1,yl1,xr1,yr1,x1
  local best = ys:var()
  local a = self.all
  if hi - li >= 2*min then
    for i = lo,hi do
      xl:add( xr:sub( a[i].x ) )
      yl:add( yr:sub( a[i].y ) )
      if         xl.n >= self.min     and
                 xr.n >= self.min     and
               a[i].x ~= a[i+1].x       and
           self.cohen <  xr.mu - xl.mu  and 
                 best >  self.better*yl:xpect(yr)
      then  cut, best =  i, yl:xpect(yr)
             xl1, yl1 =  cp(xl), cp(yl)
             xr1, yr1 =  cp(xr), cp(yr) end end
  end
  if   cut 
  then self:div1(lo,   cut, xl, yl)
       self:div1(cut+1, hi, xr, yr)
  else self.out[ (#self.out)+1i ]={
               col   =  self.col.pos,
               txt   =  self.col.txt,
               lo    =  xs.lo, 
               hi    =  xs.hi, 
               bore  =  ys:bore(self.best),
               ent   =  ys:var()*ys.n/#a} end
  return out
end

return DivNum
