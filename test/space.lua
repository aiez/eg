require "ok"
local l   = require "lib"
local Data  = require "data"
local Space = require "space"

local id = l.id

function _dist(    data,space) 
  data  = Data():import("../test/data/raw/auto93.csv") 
  space = data:space(l.x)
  for _,r1 in pairs(data.rows) do
    local n = space:neighbors(r1, data.rows)
    local d1, d2  = n[2].d, n[#n].d
    assert(d1 < d2)
  end 
end

ok { _dist = _dist }
