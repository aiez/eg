require "ok"
local l    = require "lib"
local Data = require "data"

local id = l.id

function _dist(    data,t,mids) 
  data = Data():import("../test/data/raw/auto93.csv") 
  t = data:tree(l.y, 1024)
  t:show()
  l.oo(data:show(l.y))
  d = {}
  for i,leaf in pairs(t.space.leaves) do
    d[i] = {data = data:clone(leaf), dom=0}
  end
  local cols = l.cols(data.cols,l.y)
  for i,d1 in pairs(d) do
    for j,d2 in pairs(d) do
      if i>j then
        if d1.data:mid():dominates(d2.data:mid(),cols) 
        then d1.dom = d1.dom + 1 end end end 
  end
  table.sort(d, function(a,b) return a.dom > b.dom end)
  local all = d[1].data:headers()
  l.ooo(all)
  all = l.add(all, {"!best"}) 
  all = Data( all )
  for _,row in pairs(d[1].data.rows) do
    all:add( l.add(row.cells, {true}))
  end 
  local n1, n2 = #data.rows, #all.rows
  for i=2,#d do
    for _,row in pairs(d[i].data.rows) do
      if math.random() < 4*n2/(n1 - n2) then
        all:add( l.add(row.cells, {false})) end end end
  l.ooo(all.cols[#all.cols])
end

_dist()
