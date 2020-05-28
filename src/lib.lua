local lib = {}

lib.class = require("class")

function lib.round(num, places)
  local mult = 10^(places or 0)
  return math.floor(num * mult + 0.5) / mult
end

 
function lib.cache(f)
  return setmetatable({}, {
      __index=function(t,k) t[k]=f(k);return t[k] end})
end

function lib.oo(t,pre,    indent,fmt)
  pre=pre or ""
  indent = indent or 0
  if indent < 10 then
    for k, v in pairs(t) do
      if not (type(k)=='string' and k:match("^_")) then
        fmt = pre .. string.rep("|  ", indent) .. k .. ": "
        if type(v) == "table" then
           print(fmt)
           lib.oo(v, pre, indent+1)
        else
           print(fmt .. tostring(v)) end end end end
end

return lib
