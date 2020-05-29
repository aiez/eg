--[[

# Lib Tricks

--]]
local L = {}

L.the   = require "the" 
L.class = require "class" 
--[[

## Maths Stuff

--]]
function L.round(num, places)
  local mult = 10^(places or 0)
  return math.floor(num * mult + 0.5) / mult
end
--[[

## Print Stuff

--]]
function L.o(z) print(table.concat(z,",")) end

function L.oo(t,pre,    indent,fmt)
  pre=pre or ""
  indent = indent or 0
  if indent < 10 then
    for k, v in pairs(t) do
      if not (type(k)=='string' and k:match("^_")) then
        fmt = pre .. string.rep("|  ", indent) .. k .. ": "
        if type(v) == "table" then
          print(fmt)
          L.oo(v, pre, indent+1)
        else
          print(fmt .. tostring(v)) end end end end
end
--[[

## List Stuff

--]]
function L.same(z) return z end

function L.any(a) 
  return a[1 + math.floor(#a*math.random())] end

function L.anys(a,n,   t) 
  t={}
  for i=1,n do t[#t+1] = any(a) end
  return t
end

local function what2do(t,f)
  if not f                 then return L.same end
  if type(f) == 'function' then return f end
  if type(f) == 'string'   then
    return function (z) return z[f] end
  end
  local m = getmetable(t)
  return m and m[f] or assert(false,"bad function")
end

function L.select(t,f,     g,u)
  u, g = {}, what2do(t, f)
  for _,v in pairs(t) do
    if g(v) then u[#u+1] = v  end end
  return u
end

function L.cache(f)
  return setmetatable({}, {
      __index=function(t,k) t[k]=f(k);return t[k] end})
end

function L.keys(t)
  local i,u = 0,{}
  for k,_ in pairs(t) do u[#u+1] = k end
  table.sort(u)
  return function () 
    if i < #u then 
      i = i+1
      return u[i], t[u[i]] end end 
end
--[[

## Data stuff

--]]
function c(s,k) return string.sub(s,1,1)==k end

function L.klass(x) return c(x,"!") end 
function L.goal(x)  return c(x,"<") or c(x,">") end
function L.num(x)   return c(x,"$") or L.goal(x) end
function L.y(x)     return L.klass(x) or L.goal(x) end
function L.x(x)     return not L.y(x) end
function L.sym(x)   return not L.num(x) end
function L.xsym(z)  return L.x(z) and L.sym(z) end
function L.xnum(z)  return L.x(z) and L.num(z) end
--[[

## File  stuff

--]]
function L.s2t(s,     sep,t)
  t, sep = {}, sep or ","
  for y in string.gmatch(s,"([^"..sep.."]+)") do t[#t+1]=y end
  return t
end

function L.csv(file,     stream,tmp,row)
  stream = file and io.input(file) or io.input()
  tmp    = io.read()
  return function()
    if tmp then
      tmp= tmp:gsub("[\t\r ]*","") -- no whitespace
      row= L.split(tmp)
      tmp= io.read()
      if #row > 0 then return row end
    else
      io.close(stream) end end   
end
--[[

## Return  stuff

--]]
return L
