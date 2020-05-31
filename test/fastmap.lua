require "ok"
local lib= require "lib"
local Fastmap= require "fastmap"

function _fast(rows,head) 
  rows = {}
  for row in lib.csv("../test/data/raw/auto93.csv") do
    if head then rows[#rows+1] = row else head = row end
  end
  Fastmap(head, rows):divs(rows):show()
end

_fast()

--ok{fast= _fast}
