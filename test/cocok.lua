require "ok"

local Cocomo = require "coc" 

ok{ coc = function(    c)
  print ""
  for i=1,10 do
    c = Cocomo()
    print(c:effort(), c:risk())
  end
end}

local pcat=function (z) return print(table.concat(z,", ")) end

ok{ coc1 = function( c)
    c = Cocomo()
    pcat( c:header() )
end}
