local lib = {}

lib.the   = require "the" 
lib.class = require "class" 

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

function lib.keys(t,   u)
  local i,u = 0,{}
  for k,_ in pairs(t) do u[#u+1] = k end
  table.sort(u)
  return function ()
    if i <= #u then
      i = i + 1
      local k = u[i-1]
      print("::",k, u[i-1])
      return k,  t[ k ] end end 
end

local function c(s,k) return string.sub(s,1,1)==k end

function lib.klass(x) return c(x,"!") end 
function lib.goal(x)  return c(x,"<") or c(x,">") end
function lib.num(x)   return c(x,"$") or lib.goal(x) end
function lib.y(x)     return lib.klass(x) or lib.goal(x) end
function lib.x(x)     return not lib.y(x) end
function lib.sym(x)   return not lib.num(x) end
function lib.xsym(z)  return lib.x(z) and lib.sym(z) end
function lib.xnum(z)  return lib.x(z) and lib.num(z) end

function lib.s2t(s,     sep,t)
  t, sep = {}, sep or ","
  for y in string.gmatch(s,"([^"..sep.."]+)") do t[#t+1]=y end
  return t
end

function lib.csv(file,     stream,tmp,row)
  stream = file and io.input(file) or io.input()
  tmp    = io.read()
  return function()
    if tmp then
      tmp= tmp:gsub("[\t\r ]*","") -- no whitespace
      row= lib.split(tmp)
      tmp= io.read()
      if #row > 0 then return row end
    else
      io.close(stream) end end   
end

return lib
