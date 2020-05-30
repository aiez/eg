--[[

# Mib Tricks

--]]
local M = {}

M.the   = require "the" 
M.class = require "class" 
--[[

## Maths Stuff

--]]
function M.round(num, places)
  local mult = 10^(places or 0)
  return math.floor(num * mult + 0.5) / mult
end
--[[

## Print Stuff

--]]
function M.o(z) print(table.concat(z,",")) end

function M.oo(t,pre,    indent,fmt)
  pre=pre or ""
  indent = indent or 0
  if indent < 10 then
    for k, v in pairs(t) do
      if not (type(k)=='string' and k:match("^_")) then
        fmt = pre .. string.rep("|  ", indent) .. k .. ": "
        if type(v) == "table" then
          print(fmt)
          M.oo(v, pre, indent+1)
        else
          print(fmt .. tostring(v)) end end end end
end
--[[

## List Stuff

--]]
function M.same(z) return z end

function M.any(a) 
  return a[1 + math.floor(#a*math.random())] end

function M.anys(a,n,   t) 
  t={}
  for i=1,n do t[#t+1] = M.any(a) end
  return t
end

local function what2do(t,f)
  if not f                 then return M.same end
  if type(f) == 'function' then return f end
  if type(f) == 'string'   then
    return function (z) return z[f] end
  end
  local m = getmetable(t)
  return m and m[f] or assert(false,"bad function")
end

function M.select(t,f,     g,u)
  u, g = {}, what2do(t, f)
  for _,v in pairs(t) do
    if g(v) then u[#u+1] = v  end end
  return u
end

function M.cache(f)
  return setmetatable({}, {
      __index=function(t,k) t[k]=f(k);return t[k] end})
end

function M.keys(t)
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

function M.klass(x) return c(x,"!") end 
function M.goal(x)  return c(x,"<") or c(x,">") end
function M.num(x)   return c(x,"$") or M.goal(x) end
function M.y(x)     return M.klass(x) or M.goal(x) end
function M.x(x)     return not M.y(x) end
function M.sym(x)   return not M.num(x) end
function M.xsym(z)  return M.x(z) and M.sym(z) end
function M.xnum(z)  return M.x(z) and M.num(z) end
--[[

## File  stuff

--]]
function M.s2t(s,     sep,t)
  t, sep = {}, sep or ","
  for y in string.gmatch(s,"([^"..sep.."]+)") do 
     local z = tonumber(y) or y
     t[#t+1] = z end
  return t
end

function M.csv(file,     stream,tmp,row)
  stream = file and io.input(file) or io.input()
  tmp    = io.read()
  return function()
    if tmp then
      tmp= tmp:gsub("[\t\r ]*","") -- no whitespace
      row= M.s2t(tmp)
      tmp= io.read()
      if #row > 0 then return row end
    else
      io.close(stream) end end   
end
--[[

## Return  stuff

--]]
return M
