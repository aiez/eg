local lib = require "lib"

local Space = lib.class()
function Space:_init(data, using)
  self.far     = 0.9
  self.p       = 2
  self.debug   = false
  self.min     = (#data.rows)^0.5
  self.max     = 256
  self.strange = 0.2 
  self.data    = data:clone()
  using        = using or lib.goal
  self.use     = self:wanted(using)
  self.leaves  = {}
end

function Space:leaf(x)
  self.leaves[ #self.leaves+1 ] = x
end
function Space:wanted(f)
  return lib.select(self.data.cols, 
                     function(z) return f(z.txt) end)
end

function Space:sample(    rows)
  rows = rows or self.data.rows
  if   #rows <= self.max 
  then for _,r in pairs(rows) do self.data:row(r)        end
  else for i=1,self.max do self.data:row(lib.any(rows)); end
  end
  return self
end
 
function Space:div(rows)
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

function Space:project(row,l,r,c,     a,b)
  a = self:dist(row, l)
  b = self:dist(row, r)
  return math.max(0, math.min(1, (a^2 + c^2 - b^2) / (2*c)))
end

function Space:neighbors(r1,rows,   a)
  a = {}
  for _,r2 in pairs(rows) do 
    a[#a+1]={row=r2,  d=self:dist(r1,r2)} end
  table.sort(a, function(x,y) return x.d < y.d end)
  return a
end

function Space:distant(row1,rows,   a)
  a= self:neighbors(row1, rows)
  return a[ math.floor( #a * self.far ) ].row
end

function Space:dist(r,s) return r:dist(s,self.use,self.p) end

return Space
