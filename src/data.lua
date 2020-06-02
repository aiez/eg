--[[
# `Data`s = rows and columns

Inside a `Data`, the `cols` summarize the columns of each `rows`.
--]]
local lib  = require "lib"
local Num  = require "num"
local Sym  = require "sym"
local Row  = require "row"
local Data = lib.class()

function Data:_init(headers, rows)
  self.cols = {}
  self.rows = {}
  self:add(headers or {})
  for _,row in pairs(rows or {}) do self:add(row) end
end

function Data:add(a) 
  if #self.cols==0 then self:head(a) else self:row(a) end
end

function Data:head(a)
  for i,s in pairs(a) do
    self.cols[i]= lib.num(s) and Num(s,i) or Sym(s,i) end
end

function Data:add(rows) 
  for _,row in pairs(rows) do self:row(row) end end

function Data:row(a)
  local row = Row(a)
  for _,c in pairs(self.cols) do 
    c:add( row.cells[c.pos] ) 
  end
  self.rows[#self.rows + 1] = row
  return a
end

function Data:clone(rows) 
  return Data(lib.map(self.cols,"txt"), rows or {}) end

function Data:show(cols) 
  return lib.map( cols or self.cols, 
                  function(c) return c:show() end) end

function Data:import(f)
  for row in lib.csv(f) do self:add(row) end
  return self
end

return Data
