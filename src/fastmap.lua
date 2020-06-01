--[[
# Tab

Given rows and columns of data,
extract some structure (a hierarchical clustering).
--]]

local lib = require "lib"
local Sym = require "sym"
local Num = require "num"

local function want(t,f,   u) 
  u,f = {}, f or lib.klass
  for i,k in pairs(t or {}) do if f(k) then u[i]=i end end
  return u
end

local function cells(x) return x.cells and x.cells or x  end
local function zero1(z) return z end --math.max(0,math.min(1,z)) end

local Tree = lib.class()
function Tree:_init(dots,rows)
  local ls,rs
  self.dots = dots
  self.size = #rows
  if #rows >= 2*dots.min then
    self.c,self.n,self.l,self.r,ls,rs = dots:div(rows)
    if #ls < #rows and #rs < #rows then
      self.ls   = Tree(dots,ls)
      self.rs   = Tree(dots,rs)
    end
  end
end

function Tree:show(pre)
  pre = pre or ""
  print(pre .. self.size)
  if self.ls then self.ls:show(pre .. '|.. ') end
  if self.rs then self.rs:show(pre .. '|.. ') end
end

function Tree:weird(x) return self:place(x):outlier(x) end

function Tree:outlier(row)
   x  = self.dots:project(row, self.l, self.r, self.c)
   lo = self.n * self.dots.strange
   hi = self.n + (1 - self.n)* self.dots.strange
   return x < lo or x > hi
end

function Tree:place(row,      x,kid)
  if    self.l 
  then  x   = self.dots:project(row,self.l,self.r,self.c)
        kid = x <= self.n and self.ls or self.rs
        return kid:place(row)
  else  return self
  end
end

-- ---------------------------------------
local Tab = lib.class()
function Tab:_init(headers, rows, using)
  self.far     = 0.9
  self.p       = 2
  self.debug   = false
  self.min     = (#rows)^0.5
  self.max     = 256
  self.use     = want(headers,lib.goal)
  self.nums    = want(headers,lib.num)
  self.strange = 0.2 -- lower numbers mean less things are strange
  self.logs    = {}
  for i,s in pairs(headers) do
   self.logs[i]= lib.num(s) and Num(s,i) or Sym(s,i)
  end
end

function Tab:log(a,  b)
  b = cells(a)
  for i,c in pairs(self.logs) do b[i] = c:add(b[c.pos]) end
  return a
end

function Tab:divs(a)
  local b = {}
  if   #a <= self.max 
  then for _,r in pairs(a) do b[#b+1]= self:log(r)          end
  else for i = 1,self.max  do b[#b+1]= self:log(lib.any(a)) end
  end
  self.tree = Tree(self,b)
  return self.tree
end

function Tab:div(rows)
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

function Tab:project(row,l,r,c,     a,b,x)
  a = self:dist(row, l)
  b = self:dist(row, r)
  x = zero1( (a^2 + c^2 - b^2) / (2*c))
  print(x)
  return x
end

function Tab:distant(row1,rows,   a)
  a = {}
  for _,row2 in pairs(rows) do 
    a[#a+1]={row=row2,  d=self:dist(row1,row2)} 
  end
  table.sort(a, function(x,y) return x.d < y.d end)
  return a[ math.floor( #a * self.far ) ].row
end

function Tab:dist(r,s,       d,n,x,y,inc)
  d, n = 0, 0.0001
  r, s = cells(r), cells(s)
  for _,c in pairs(self.use) do
    x, y = r[c], s[c]
    inc  = self.logs[c]:add(x,y)
    d    = d + inc^self.p  
    n    = n + 1
  end
  return (d/n)^(1/self.p) 
end

return Tab
