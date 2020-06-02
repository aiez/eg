require "ok"
local lib= require "lib"
local Data= require "data"
local Geometry = require "fastmap"

function _fast(    d) 
  d = Data():import("../test/data/raw/auto93.csv") 
  --local tree = Geometry(ds):cluster()
  --ree:show()
end

_fast()

--ok{fast= _fast}
