local l   = require "lib"
local cp  = l.copy
local Num = require "num"
local Sym = require "sym"

local Div = l.class()
function Div:_init(pos,txt,data,klass)
  self.pos    = pos
  self.txt    = txt
  self.data   = data
  self.max    = l.the.div.max
  self.cohen  = l.the.div.cohen
  self.better = l.the.div.better
  self.klass  = data:using(l.klass)[1]
  self.min    = function (z) return (#z)^l.the.div.min end
end

-- xxx need the majorit y class
function Div:some(klass)
  local c = self.pos
  local a, n, xs, ys = {}, 0, Num(c,c), Sym(c,c)
  for _,one in pairs(self.all) do n=n + #one end
  for _,one in pairs(self.all) do n=n + #one end
  for i,rows in pairs(one) do
    for _,row in pairs(rows) do
      local x = row.cells[c]
      if x ~= "?" then
        if rand() < self.max/n then
          a[#a+1] = {x = xs:add( x ), 
                     y = ys:add( i )} end end end 
  end
  table.sort(a, function(z1,z2) return z1.x < z2.x end)
  return a, xs, ys
end

function Div:div()
  local a,xs,ys = Div:some(self.pos, self.all)
  self.mins     = self.min(xs.n)
  self.cohens   = xs:var()*self.cohen
  local out     = {}
  self:div1(1, #a, xs, ys, a,out)
  return out
end

function Div:div1(lo, hi, xs, ys, a,out)
  local xl,yl,xr,yr,best = Num(),Sym(),cp(xs),cp(ys)
  local cut,xl1,yl1,xr1,yr1,x1
  local best = ys:var()
  if hi - li >= 2*min then
    for i = lo,hi do
      xl:add( xr:sub( a[i].x ) )
      yl:add( yr:sub( a[i].y ) )
      if         xl.n >= self.mins      and
                 xr.n >= self.mins      and
               a[i].x ~= a[i+1].x       and
          self.cohens <  xr.mu - xl.mu  and 
                 best >  self.better*yl:xpect(yr)
      then  cut, best =  i, yl:xpect(yr)
             xl1, yl1 =  cp(xl), cp(yl)
             xr1, yr1 =  cp(xr), cp(yr) end end
  end
  if   cut 
  then self:div1(lo,   cut, xl, yl, a, out)
       self:div1(cut+1, hi, xr, yr, a, out)
  else b[#b+1]={
         pos   =  self.pos,
         txt   =  self.txt,
         lo    =  xs.lo, 
         hi    =  xs.hi, 
         bore  =  ys:bore(1),
         ent   =  ys:var()*ys.n/#a} end
end

return Div
