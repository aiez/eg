local l   = require "lib"
local Num = require "num"
local Sym = require "sym"
local Div = require "div"
--[[

Build a decision list. At each level, make decision using
the `N=1` best ranges.

Inputs a list of list of rows. Each `row`  has values in
`row.cells`.  In the list of list or rows, the  list at
position 1 is the `target`  class.

Recursion terminates when the target list is exhausted (i.e.
when there are less than `self.min` items remaining). At
termination, we do what we can to split the remaining data
into target and non-target.

--]]
local Dec1list = l.class()
function Dec1list:_init(headers, all)
  self.min     = 8
  self.max     = 1024
  self.all     = all
  self.headers = headers
end
--[[

Using the best range to peel off some rows into `leaf`.
Recurse on the rest (if there are enough of them) then
maybe recurse on the rest.

--]]
function Dec1list:div(all)
  local rs={}
  for i,h in pairs(self.headers) do
    rs[#rs+1]= l.num(h) and self:num(i,h,a) or self:sym(i,h,a)
  end
  local range,best,all1,_ = self:select(all,rs, 
           function (a,b) return a.ent  < b.ent end)
  if rest > self.min then
    return {pos=  range.pos, txt=  range.txt, 
            lo=   range.lo,  hi=   range.hi,  
            used= best,      rest= self:div(all1)}
  end
  local range,best,_,finally = self:select(all,rs, 
           function(a,b) return a.bore>b.bore end)
  return   {pos=  range.pos, txt=  range.txt, 
            lo=   range.lo,  hi=   range.hi, 
            used= best,      rest= finally}
end

function Dec1list:select(all1,rs,goal)
  table.sort(rs,goal)
  local range, best,all2,finally = rs[1], {},{},{}
  for i,rows in pairs(all1) do
    local rest = {}
    for _,row in pairs(rows) do
      v = row.cell[ range.pos ]
      if v ~= "?" then
        if   v >= range.lo and v <= range.hi 
        then best[#best+1] = row
        else rest[#rest+1] = row
             finally[#finally+1] = row end end end
    all2[i] = rest
  end
  return range, best, all2, finally
end
--[[

Divide numeric or symbolic columns.

--]]
function Dec1list:num(pos, txt, all) 
  return Div(self.max, pos, txt, all) end

function Dec1list:sym(pos, txt, all)
  local a, b, c, n = {}, {}, {}, 0
  for _,one in pairs(self.all) do n=n + #one end
  for i,rows in pairs(all) do
    for _,row in pairs(rows) do
      local x = row.cells[pos]
      if x ~= "?" then
        if rand() < self.max/n then
           a[ #a+1 ] = {x= x, y=i} end end end end
  for _,xy in pairs(a) do 
    b[xy.x] = b[xy.x] or Sym(pos,pos)
    b[xy.x]:add( xy.y )
  end
  for x,ys in pairs(b) do c[#c+1] = {
          pos   =  pos,
          txt   =  txt,
          lo    =  x,
          hi    =  x,
          bore  =  ys:bore(1),
          ent   =  ys:var()*ys.n/#a } end
  return c
end

return Dec1list
