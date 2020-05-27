
--[[
# `Ok` : unit tests
--]]

package.path = '../src/?.lua;' .. package.path

local pass,fail,seed,tiny = 0,0,1,0.00001

local function rogues()
  local no = {the=true, TESTING=true,
              jit=true, utf8=true, math=true, package=true,
              table=true, coroutine=true, bit=true, os=true,
              io=true, bit32=true, string=true, arg=true,
              debug=true, _VERSION=true, _G=true }
  for k,v in pairs( _G ) do
    if type(v) ~= "function" and not no[k] then
      if k:match("^[^A-Z]") then
        print("-- ROGUE local ["..k.."]") end end end
end

function nok(t) return true end

function ok(t)
  local pre=TESTING  or ""
  pre= "-- test "..pre.." : " 
  for s,x in pairs(t) do  
    io.write(pre .. s .. " ") 
    pass = pass + 1
    local t1 = os.clock()
    math.randomseed(1)
    local passed,err = pcall(x) 
    local t2= os.clock()
    print(string.format (" : %8.6f secs", t2-t1))
    if not passed then   
      fail = fail + 1
      print("Failure: ".. err .. pass/(pass+fail+tiny)) end 
  end 
  rogues()
end

function near(x,y,z)
  z= z or 0.01
  assert(math.abs(x - y) <= z, 
         'too big: ['..math.abs(x - y)..']')
end
