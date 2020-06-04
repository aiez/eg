--[[
# Tree

Extract some structure from some distance.
--]]

local lib = require "lib"
local Sym = require "sym"
local Num = require "num"

local Tree = lib.class()
function Tree:_init(distance,rows)
  local ls,rs
  self.distance  = distance
  self.size = #rows
  if #rows >= 2*distance.min then
    self.c,self.n,self.l,self.r,ls,rs = distance:div(rows)
    if #ls < #rows and #rs < #rows then
      self.ls   = Tree(distance,ls)
      self.rs   = Tree(distance,rs) end end
end

function Tree:show(pre)
  pre = pre or ""
  print(pre .. self.size)
  if self.ls then self.ls:show(pre .. '|.. ') end
  if self.rs then self.rs:show(pre .. '|.. ') end
end

function Tree:weird(x) return self:place(x):outlier(x) end

function Tree:outlier(row)
   x  = self.distance:project(row, self.l, self.r, self.c)
   lo = self.n * self.distance.strange
   hi = self.n + (1 - self.n)* self.distance.strange
   return x < lo or x > hi
end

function Tree:place(row,      x,kid)
  if    self.l 
  then  x   = self.distance:project(row,self.l,self.r,self.c)
        kid = x <= self.n and self.ls or self.rs
        return kid:place(row)
  else  return self
  end
end

return Tree
