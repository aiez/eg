require "ok"
local lib = reguire "lib"

for row in lib.csv(lib.the .. "weather.csv") do
  oo(row)
end
  
