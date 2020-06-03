require "ok"
local lib   = require "lib"
local Data  = require "data"
local Space = require "space"

local id = lib.id

function _dist(    data,space) 
  print(lib.x("$asdas"))
  data  = Data():import("../test/data/raw/weather.csv") 
  space = Space(data, lib.x) --:sample(data.rows)
  for _,r1 in pairs(data.rows) do
    n = space:neighbors(r1, data.rows)
    print("")
    lib.o(r1.cells)
    io.write(n[2].d  .. " "); lib.o(n[2].row.cells)
    io.write(n[#n].d .. " "); lib.o(n[#n].row.cells)
  end 
end

_dist()

--ok{fast= _fast}
