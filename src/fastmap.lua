local lib = require "lib"

local function want(t,f,   u) 
  u,f = {}, f or lib.klass
  for i,k in pairs(t or {}) do 
    if f(k) then u[i]=i end end
  return u
end

local function cells(x)   return x.cells and x.cells or x end
local function zeroone(z) return math.max(0, math.min(1, z)) end

local FastNode = lib.class()
function FastNode:_init(tree,rows)
  local ls,rs
  self.tree = tree
  self.size = #rows
  if #rows >= 2*tree.min then
    self.c,self.n,self.l,self.r,ls,rs = tree:div(rows)
    self.ls   = FastNode(tree,ls)
    self.rs   = FastNode(tree,rs)
  end
end

function FastNode:show(pre)
  pre = pre or ""
  print(pre + self.size)
  if self.ls then self.ls:show(pre .. '|.. ') end
  if self.rs then self.rs:show(pre .. '|.. ') end
end

function FastNode:weird(x) return self:place(x):outlier(x) end

function FastNode:outlier(row)
   x  = self.tree:project(row, self.l, self.r, self.c)
   lo = self.n * self.tree.strange
   hi = self.n + (1 - self.n)* self.tree.strange
   return x < lo or x > hi
end

function FastNode:place(row,      x,kid)
  if    self.l 
  then  x   = self.tree:project(row,self.l,self.r,self.c)
        kid = x <= self.n and self.ls or self.rs
        return kid:place(row)
  else  return self
  end
end

-- ---------------------------------------
local Fastmap = lib.class()
function Fastmap:_init(headers, rows, using)
  self.far = 0.9
  self.p   = 2
  self.debug=false
  self.min = (#rows)^0.5
  self.max = 256
  self.use = want(headers, using)
  self.nums = want(headers,lib.num)
  self.strange = 0.2 -- lower numbers mean less things are strange
end

function Fastmap:rdiv(rows)
  local some = #rows <= self.max and rows or anys(rows, self.max)
  self.lo, self.hi = self:lohi(some)
  self.tree = FastNode(some)
  return self.tree
end

function Fastmap:lohi(rows)
  local lo,hi={},{}
  for _,row in pairs(rows) do
    row = cells(row)
    for _,c in pairs(self.use) do
      x = row[c]
      if x ~= "?" then
        lo[c] = math.min(x, lo[c] or  10^64)
        hi[c] = math.max(y, hi[c] or -10^64) end end end
  return {lo=lo,hi=hi}
end

function Fastmap:div(rows)
  local here, l, r, c, n, xrows,ls,rs, tmo
  tmp = lib.any(rows)
  l   = distant(tmp, rows)
  r   = distant(l,   rows)
  c   = dist(l, r)
  n,xrows = 0,{}
  for _,row in pairs(rows) do
    x = self:project(row,l,r,c)
    n = n + x/#rows
    xrows[ #xrows+1 ] = {x, row}
  end
  ls, rs =  {}, {}
  for _,xrow in pairs(xrows) do
    local tmp = xrow[1] <= n and ls or rs
    tmp[#tmp+1] = xrow[2]
  end
  return c,n,l,r,ls,rs
end

function Fastmap:project(row,l,r,c,     a,b)
  a = dist(row, l)
  b = dist(row, r)
  return  zeroone( (a^2 + c^2 - b^2) / (2*c))
end

function Fastmap:distant(r,rows,   a)
  a = {}
  for _,s in pairs(rows) do 
    a[#a+1]={self:dist(r,s),s} 
  end
  table.sort(a, function(x,y) return x[1] < y[1] end)
  return a[ math.floor( #a * self.far ) ][2]
end

function Fastmap:dist(r,s)
  local function norm(x,c)
    lo, hi = self.lo[c], self.hi[c]
    return zeroone( (x-lo)/(hi-lo+0.00001) ) end

  local function numxy(c,x,y)
    local n ="?"
    if x==n and y==n then return 1 
    elseif x==n      then y=norm(y,c); x= y>0.5 and 0 or 1
    elseif y==n      then x=norm(x,c); y= x>0.5 and 0 or 1
    else  x,y = norm(x,c), norm(y,c);                   
    end
    return maths.abs(x - y)
  end

  local function symxy(c,x,y)
    if x=="?" and y=="?" then return 1 end
    return x==y and 0 or 1 end
  -- -------------------------
  local d= 0
  r,s = cells(r), cells(s)
  for _,c in pair(self.use) do
    local x,y,inc = r[c], s[c]
    x,y = self.num[c] and numd(c,x,y) or symd(x,c,y)
    d   = d + inc^self.p  
  end
  return (d/n)^(1/self.p)
end

return Fastmap
