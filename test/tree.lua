require "ok"
local l    = require "lib"
local Data = require "data"

local id = l.id

function _dist(    data,t) 
  data = Data():import("../test/data/raw/auto93.csv") 
  t = data:tree()
  t:show()
  l.oo(data:show(l.y))
  for _,leaf in pairs(t.space.leaves) do
    l.oo(data:clone(leaf):show(l.y))
  end
end

_dist()
