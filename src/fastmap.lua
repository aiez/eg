--[[
# Tab

Given rows and columns of data,
extract some structure (a hierarchical clustering).
--]]

local lib = require "lib"
local Sym = require "sym"
local Num = require "num"
local Data= require "data"

local function cells(x) return x.cells and x.cells or x  end
local function zero1(z) return math.max(0,math.min(1,z)) end

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
local Geometry = lib.class()
function Geometry:_init(data, using)
  self.far     = 0.9
  self.p       = 2
  self.debug   = false
  self.min     = (#rows)^0.5
  self.max     = 256
  self.strange = 0.2 
  self.data    = data:clone( data.rows )
  self.use     = lib.select(self.data.cols, 
                     function(z) return lib.goal(z.txt) end)
end

function Geometry:cluster(    rows)
  rows = self.data.rows
  if   #rows <= self.max 
  then for _,r in pairs(rows) do self.data:row(r)          end
  else for i=1,self.max    do self.data:row(lib.any(rows)) end
  end
  return Tree(self,self.data.rows)
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

function Geometry:dist(r,s) return r:dist(s,self.use,self.p) end

return Geometry
