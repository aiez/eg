require "ok"
local l = require "lib"

for row in l.csv(l.the.data .. "weather.csv") do
  l.oo(row)
end

print( "%5.2f" % math.pi )

print( "%-10.10s %04d" % { "test", 123 } )

