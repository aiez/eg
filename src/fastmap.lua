--[[
# Tab

Given rows and columns of data,
extract some structure (a hierarchical clustering).
--]]

local lib = require "lib"
local Sym = require "sym"
local Num = require "num"

local function cells(x) return x.cells and x.cells or x  end
local function zero1(z) return -math.max(0,math.min(1,z)) end

local Tree = lib.class()
function Tree:_init(geometry,rows)
  local ls,rs
  self.geometry  = geometry
  self.size = #rows
  if #rows >= 2*geometry.min then
    self.c,self.n,self.l,self.r,ls,rs = geometry:div(rows)
    if #ls < #rows and #rs < #rows then
      self.ls   = Tree(geometry,ls)
      self.rs   = Tree(geometry,rs) end end
end

function Tree:show(pre)
  pre = pre or ""
  print(pre .. self.size)
  if self.ls then self.ls:show(pre .. '|.. ') end
  if self.rs then self.rs:show(pre .. '|.. ') end
end

function Tree:weird(x) return self:place(x):outlier(x) end

function Tree:outlier(row)
   x  = self.geometry:project(row, self.l, self.r, self.c)
   lo = self.n * self.geometry.strange
   hi = self.n + (1 - self.n)* self.geometry.strange
   return x < lo or x > hi
end

function Tree:place(row,      x,kid)
  if    self.l 
  then  x   = self.geometry:project(row,self.l,self.r,self.c)
        kid = x <= self.n and self.ls or self.rs
        return kid:place(row)
  else  return self
  end
end

-- ---------------------------------------
local Table = lib.class()
function Table:_init(headers, rows)
  self.cols = {}
  self.rows = {}
  self.headers(headers or {})
  for _,row in pairs(rows or {}) do
    self:add(row)
  end
end

function Table:add(a)
  if #self.cols == 0 then self:headers(a) else self:row(a) end
  return a
end

function Table:headers(a)
  for i,s in pairs( cells(a) ) do
    self.cols[i]= lib.num(s) and Num(s,i) or Sym(s,i) end
end

function Table:row(a)
  local b = cells(a)
  for _,col in pairs(self.cols) do col:add( b[col.pos] ) end
end

function Table:clone(rows)
  return Table( lib.map(self.cols, "txt"), rows)
end
  
-- ---------------------------------------
local Geometry = lib.class()
function Geometry:_init(headers, rows, using)
  self.far     = 0.9
  self.p       = 2
  self.debug   = false
  self.min     = (#rows)^0.5
  self.max     = 256
  self.strange = 0.2 -- lower numbers mean less things are strange
  self.logs    = {}
  for i,s in pairs(headers) do
   self.logs[i]= lib.num(s) and Num(s,i) or Sym(s,i)
  end
  self.use     = lib.select(self.logs, function(z) 
                              return lib.goal(z.txt) end)
end

function Geometry:rows(rows)
  lib.map(rows, function(row) self:row(row) end)
end

function Geometry:row(a, b)
  b = cells(a)
  lib.map(self.logs, function(col) col:add( b[col.pos] ) end)
  return a
end

function Geometry:cluster(a)
  local b = {}
  if   #a <= self.max 
  then for _,r in pairs(a) do b[#b+1]= r          end
  else for i = 1,self.max  do b[#b+1]= lib.any(a) end
  end
  self:rows(b)
  lib.map(b, function (z) self:row(z) end)
  self.tree = Tree(self,b)
  return self.tree
end
 
function Geometry:div(rows)
  local any,l,r,c,x,n,xrows,ls,rs,tmp
  any = lib.any(rows)
  l   = self:distant(any, rows)
  r   = self:distant(l,   rows)
  c   = self:dist(l, r)
  n,xrows = 0,{}
  for _,row in pairs(rows) do
    x = self:project(row,l,r,c)
    n = n + x/#rows
    xrows[ #xrows+1 ] = {d=x, row=row}
  end
  ls, rs = {}, {}
  for _,xrow in pairs(xrows) do
    local tmp   = xrow.d <= n and ls or rs
    tmp[#tmp+1] = xrow.row
  end
  return c,n,l,r,ls,rs
end

function Geometry:project(row,l,r,c,     a,b,x)
  a = self:dist(row, l)
  b = self:dist(row, r)
  x = zero1( (a^2 + c^2 - b^2) / (2*c))
  return x
end

function Geometry:distant(row1,rows,   a)
  a = {}
  for _,row2 in pairs(rows) do 
    a[#a+1]={row=row2,  d=self:dist(row1,row2)} 
  end
  table.sort(a, function(x,y) return x.d < y.d end)
  return a[ math.floor( #a * self.far ) ].row
end

function Geometry:dist(r,s,       d)
  d, r, s = 0, cells(r), cells(s)
  for _,c in pairs(self.use) do
    d  = d + c:dist( r[c.pos], s[c.pos])^self.p
  end
  return (d/(#self.use))^(1/self.p) 
end

return Geometry
