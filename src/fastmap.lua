local lib = require "lib"


local function want(t,f,   u) 
  u,f = {}, f or lib.klass
  for i,k in pairs(t or {}) do 
    if f(k) then u[i]=i end
  return u
end

local function cells(x) return x.cells and x.cells or x end

end
local Fastmap= lib.class()
function Fmap:_init(headers, rows, using)
  self.far = 0.9
  self.p   = 2
  self.debug=false
  self.min = (#rows)^0.5
  self.max = 256
  self.use = want(headers, using)
  self.nums = want(headers,L:num)
end

function Fastmap:dist(r,s)
  local function norm(x,c)
    lo, hi = self.bounds.lo[c], self.bounds.hi[c]
    return (x-lo)/(hi-lo+0.00001) end

  local function numd(c,x,y)
    if      x=="?" and y=="?" then return 1 
    else if x=="?" then y=norm(y,c); x=y>0.5 and 0 or 1 
    else if y=="?" then x=norm(x,c); y=x>0.5 and 0 or 1 
    else    x, y = norm(x,c), norm(y,c)
    end
    return math.abs(x-y) end

  local function symd(c,x,y)
    if x=="?" and y=="?" then return 1 end
    return x==y and 0 or 1 end
  -- -------------------------
  local d= 0
  r,s = cells(r), cells(s)
  for _,c in pair(self.use) do
    local x,y,inc = r[c], s[c]
    inc = self.num[c] and numd(c,x,y) or symd(x,c,y)
    d   = d + inc^self.p  
  end
  return (d/n)^(1/self.p)
end

function Fastmap:distant(r,rows,   a)
  a = {}
  for _,s in pairs(rows) do a[#a+1]={self:dist(r,s),s} end
  table.sort(a, function(x,y) 
                  return x[1] < y[1] end)
  return a[ math.floor( #a * self.far ) ][2]
end

function Fmap:project(rows,left,right,c)
  local n,xrows,a,b,x,xrows
  n, xrows = 0,{}
  for _,row in pairs(rows) do
    a = dist(row, left)
    b = dist(row, right)
    x = (a^2 + c^2 - b^2) / (2*c)
    x = math.max(0, math.min(1, x))
    n = n + x
    xrows[#xrows+1] = {x, row}
  end
  return n / #rows, xrows
end

function Fastmap:div(rows)
  local here, here, there, c, n, xrows,l1,l2
  here    = lib.any(rows)
  bottom  = distant(any,  rows)
  top     = distant(bottom, rows)
  c       = dist(top, bottom)
  n,xrows = self:project(rows,bottom,top,c)
  down,up   = {}, {}
  for _,xrow in pairs(xrows) do
    local tmp = xrow[1] <= n and down or up
    tmp[#tmp+1] = xrow[2]
  end
  return c,n,bottom,top,down,up
end

function Fastmap:lohi(rows)
  local lo,hi={},{}
  for _,row in pairs(rows) do
    row = cells(row)
    for _,c in pairs(self.use) do
      x = row[c]
      if x ~= "?" then
        lo[c] = math.min(x, lo[c] or  10^64)
        hi[c] = math.max(y, hi[c] or -10^64) end end
  return {lo=lo,hi=hi}
end

function Fastmap:rdiv(rows)
  if n
  if not self.rows then
    if #rows < self.max 
    then  #rows > self.max then
    self.rows = self.rows or anys(rows,self.max)
  end
  self.bounds = self.bounds or self:lohi(rows) 
  local left,right,   
  
    self:rdiv1(rows)
end

function Fastmap:rdiv1(rows)
  if #rows < 2*self.min then return nil end
  local left,righ,c,half,l1,l2 = self:div(rows)
end


