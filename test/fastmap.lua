require "ok"
local lib= require "lib"
local Tab= require "fastmap"

function _fast(rows,head) 
  rows = {}
  for row in lib.csv("../test/data/raw/auto93.csv") do
    if head then rows[#rows+1] = row else head = row end
  end
  local tree = Tab(head, rows):cluster(rows)
  tree:show()
end

_fast()

--ok{fast= _fast}
