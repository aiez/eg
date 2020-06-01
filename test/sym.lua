require "ok"

local lib = require "lib" 
local Sym = require "sym" 

ok {ent1 = function (m)
  m = Sym():adds {"a","b","b","c","c","c","c"}
  near(m:var(), 1.378)
end}

ok { step = function (   s,n,t,v)
  t,v = {},{}
  n   = Sym()
  math.randomseed(1)
  s={"a","a","b","c","c","c","d","d","d","e","e",
     "e","e","f","f","f","f","g","g","g","g","g"}
  for i = 1,100 do t[#t+1] = lib.any(s) end
  for i = 1,100 do
    n:add( t[i] )
    v[i] = n:var()
  end
  for i = 100,1,-1 do
    near( v[i],  n:var() )
    n:sub( t[i] )
  end
end}
