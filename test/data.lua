require "ok"
local lib   = require "lib"
local Data = require "data"


function _data(    d)
  d = Data():import("data/raw/weather.csv")
  lib.oo(d:show())
end

_data()
