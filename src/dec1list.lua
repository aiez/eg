local l   = require "lib"
local Num = require "num"
local Sym = require "sym"
local Div = require "div"

--[[
Build a decision list. At each level,
make decision using the `N=1` best ranges.

Inputs a list of list of rows.
--]]
local Dec1list = l.class()
function Dec1list:_init(all)
  self.min= 8
end
--[[
Find the best range across all columns.
--]]
function Dec1list:best(headers, a,      best,r,tmp)
  best = math.maxinteger
  for i,txt in pairs(headers) do
    r=  l.num(txt) and self:num(i,txt,a) or self:sym(i,txt,a)
    for _,range in pairs(r) do
      tmp = range.v
      if tmp < best then
        best, out = tmp, range end end
  end
  return out
end
--[[
Using the best range to peel off some rows into `leaf`.
Recurse on the rest (if there are enough of them)
the  maybe recurse on the rest.
XXXX revsr is rest > 10
--]]
function Dec1list:div(all,      rest,v,tmp)
  local n, leaf, rule = 0, {}, self:ibest(all)
  local out= {rule= rule, best= leaf, leafp=true rest= all}
  for i,rows in pairs(all) do
    local rest = {}
    n = n + #rows
    for _,row in pairs(rows) do
      if want then
        v = row.cell[ rule.pos ]
        tmp = v >= rule.lo and v <= rule.hi and leaf or rest
        tmp[ #tmp+1 ] = row
      else
        rest[ #rest+1 ] = row end
    end
    all[i] = rest
  end
  if   n >= self.min
  then out.leafp = true
       out.rest  = Dec1list:div(out.rest)
  end
  return out
end

function Dec1list:num(pos, txt, a) return Div(pos, txt, a) end

function Dec1list:sym(pos, txt, a)
  local out,n = {}, 0
  for _,rows in pairs(a) do
    for _,row in pairs(rows) do
      local x = row.cells[pos]
      if x ~= "?" then
         n = n+1
         out[x]= out[x] or {
                 pos=pos, txt=txt, lo=x, hi=x ,v=Sym(pos,pos)}
         a[x].y:add( id(one) ) end end 
  for _,tmp in pairs(out) do 
    out.v = out.v:var()*out.v.n/n 
  end
  return out
end

return Dec1list

