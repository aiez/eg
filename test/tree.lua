require "ok"
local l    = require "lib"
local Data = require "data"

local id = l.id

function _dist(    data,t,mids) 
  data = Data():import("../test/data/raw/auto93.csv") 
  t = data:tree(l.y,1024)
  t:show()
  l.oo(data:show(l.y))
  mids = {}
  for i,leaf in pairs(t.space.leaves) do
    d=data:clone(leaf)
    l.oo(d:show(l.y))
    mids[i] = d:mid()
  end
  doms ={}
  local cols = l.cols(d.cols,l.y)
  for i,a in pairs(mids) do
    for j,b in pairs(mids) do
       if i > j then
         if a:dominates(b,cols) then
            doms[i] = (doms[i] or 0) + 1
  end end end end 
  for i,j in pairs(doms) do
    print(i,j)
   end
end

_dist()
