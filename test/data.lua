require "ok"
local lib   = require "lib"
local Data = require "data"

function _data(    d)
  d = Data():import("data/raw/weather.csv")
end

_data()
