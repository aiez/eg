require "ok"
local l    = require "lib"
local Data = require "data"

local id = l.id

function _dist(    data,t) 
  data = Data():import("../test/data/raw/auto93.csv") 
  t = data:tree()
  t:show()
  print(100, #t.space.data.rows)
  for _,l in pairs(t.space.leaves) do
    data:clone(l)
  end
end

ok { _dist = _dist }
