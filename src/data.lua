--[[
# `Table`s of rows and columns

Inside a `Table`, the `cols` summarize the columns of each `rows`.
--]]
local lib  = require "lib"
local Num  = require "num"
local Sym  = require "sym"
local Data = lib.class()

local function cells(x) 
  return x.cells==nil and x.cells or x end

function Data:_init(headers, rows)
  self.cols = {}
  self.rows = {}
  self:add(headers or {})
  for _,row in pairs(rows or {}) do self:add(row) end
end

function Data:add(a) 
  return #self.cols==0 and self:head(a) or self:row(a) end

function Data:head(a)
  for i,s in pairs( cells(a) ) do
    print(":",i,s)
    self.cols[i]= lib.num(s) and Num(s,i) or Sym(s,i) end
end

function Data:row(a)
  local b = cells(a)
  lib.oo(b)
  print("n",#self.cols)
  for _,c in pairs(self.cols) do print("pos",c.pos); c:add( b[c.pos] ) end
end

function Data:clone(rows) 
  return Data(lib.map(self.cols,"txt"),rows or {}) end

function Data:show(cols) 
  return lib.map( cols or i.cols, "show") end

function Data:import(f)
  for row in lib.csv(f) do self:add(row) end
  return self
end

return Data
