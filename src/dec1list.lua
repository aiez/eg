local l   = require "lib"
local DivNum = require "divnum"
local DivSym = require "divsym"
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
function Dec1list:_init(data, best)
  self.min     = l.the.dec1list.min
  self.max     = l.the.dec1list.max
  self.data    = data
  self.headers = headers
end
--[[

Using the best range to peel off some rows into `leaf`.
Recurse on the rest (if there are enough of them) then
maybe recurse on the rest.

--]]
function Dec1list:div()
  local maybes = self:candidates()
  if data:klass().seen[self.best] > self.min 
  then 
    local want, best, rest = self:minEnt(maybes)
    return {pos=  want.pos, txt=  want.txt, 
            lo=   want.lo,  hi=   want.hi,  
            best= best,     rest= self:div(rest,self.best),
            leaf= false}
  else 
    local want, best, rest = self:maxBore(maybes)
    return {pos=  want.pos, txt=  want.txt, 
            lo=   want.lo,  hi=   want.hi, 
            best= best,     rest= rest,
            leaf= true} 
  end
end

--- XYZ: has to to carry the same out over all cols
function Dec1list:candidates()
  local function xys(col)
    local a, n = {}, self.max/#(self.data.rows)
    for i,rows in pairs(self.data.rows) do
      local x = row.cells[self.col.pos]
      if x ~= "?" then
        if rand() < t then
          a[#a+1] = {x = x, 
                     y = row.cells[self.klass.pos]}  end end
    return a
  end
  local a={}
  for _,col in pairs(self.data.cols) do
    local a = xys(col)
    l.num(col.txt) and self:num(col,a) or self:sym(col,a) end
  return a
end

function Dec1list:minEnt()
  return self:select(ranges, function (a,b) 
                             return a.ent  < b.ent end)
end

function Dec1list:num(col,ranges) 
  return Div(col, self.pairs(cols),   self.best,ranges)
end
function Dec1list:select(ranges,goal)
  table.sort(ranges,goal)
  local want = ranges[1]
  local best, rest = self.data:clone(), self.data:clone()
  for i,rows in pairs(self.data.rows) do
    v = row.cell[ want.pos ]
     if   v ~= "?" and v >= want.lo and v <= want.hi 
     then best:add(row)
     else rest:add(row)
     end end
  return want, best, rest
end

function Dec1list:sym(col, ranges)
  local a = self:paris(col)
  local b = {}
  for _,xy in pairs(a) do
    b[xy.x] = b[xy.x] or Sym()
    b[xy.x]:add( xy.y )
  end
  for x,ys in pairs(b) do ranges[#ranges+1] = {
          pos   =  col.pos,
          txt   =  col.txt,
          lo    =  x,
          hi    =  x,
          bore  =  ys:bore(self.best),
          ent   =  ys:var()*ys.n/#a } end
end

return Dec1list
