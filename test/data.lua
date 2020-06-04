require "ok"
local l   = require "lib"
local Data = require "data"

function _data(    d)
  d = Data():import("data/raw/weather.csv")
  l.ooo(d)
end

_data()
