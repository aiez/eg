require "ok"
local l   = require "lib"
local Data  = require "data"
local Space = require "space"

local id = l.id

function _dist(    data,space) 
  print(l.x("$asdas"))
  data  = Data():import("../test/data/raw/weather.csv") 
  space = Space(data, l.x) --:sample(data.rows)

   for _,r1 in pairs(data.rows) do
     for _,r2 in pairs(data.rows) do
       if id(r1) < id(r2) then
         print(r1._id,r2._id, space:dist(r1,r2)) end end end
   if false then
     for _,r1 in pairs(data.rows) do
      
       n = space:neighbors(r1, data.rows)
       print("")
       l.o(r1.cells)
       io.write(n[2].d  .. " "); l.o(n[2].row.cells)
       io.write(n[#n].d .. " "); l.o(n[#n].row.cells)
    end
   end 
end

_dist()

--ok{fast= _fast}
