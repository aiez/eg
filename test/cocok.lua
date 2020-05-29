require "ok"
local lib = require("lib")

local Cocomo = require "coc" 

ok{ coc = function(    c)
  print ""
  for i=1,10 do
    c = Cocomo()
    print(c:effort(), c:risk())
  end
end}


ok{ coc1 = function( c)
       c = Cocomo()
       lib.o( c:header() )
       for row in Cocomo.rows(10) do
          lib.o(row)
       end
end} 
