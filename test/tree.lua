require "ok"
local lib      = require "lib"
local Data     = require "data"
local Tree     = require "tree"
local Distance = require "distance"

function _fast(    data,dist) 
  data = Data():import("../test/data/raw/auto93.csv") 
  dist = Distance(data, lib.goal)i:sample(data.rows)
  Tree(dist, data.rows):show()
end

-- _fast()

--ok{fast= _fast}
