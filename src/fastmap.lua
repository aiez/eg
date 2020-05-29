local lib = require "lib"

local function two(y,z) return y[1] < z[1]  end

local function want(t,f,   u) 
  u,f = {}, f or lib.klass
  for i,k in pairs(t or {}) do 
    if f(k) u[#u+1]=i then end
  return u
end

local Fastmap= lib.class()
function Fmap:_init(headers, using)
  self.far = 0.9
  self.p   = 2
  self.tree= nil
  self.debug=false
  self.hi ={}
  self.lo ={}
  self.use = want(headers, using)
end

function Fastmap:split(lst,f)
  local lo,hi = self.lo, self.hi
  local use   = nil
  local norm,dist,distant,div
  -- ----------------------------------------
  function dist(r,s,      d,x,y)
    d = 0
    for _,c in pair(self.use) do
      x,y = r[c], s[c]
      x,y = norm(x, c), norm(x, c)
      d   = d + math.abs( x-y )^self.p
    end
    return (d/#use)^(1/self.p)
  end
  -- ----------------------------------------
  function norm(x,c) 
    return (x-lo[c])/(hi[c]-lo[c]+0.001) end
  -- ----------------------------------------
  function distant(r,a,    b)
    b={}
    for s in pairs(a) do b[#b+1]={dist(r,s),s} end
    table.sort(b, two)
    return b[ math.floor( #a * self.far ) ][1]
  end
  -- ----------------------------------------
  function div(l0)
    local any, left, right, c, t
    any   = l0[ math.floor(#lst * math.random()) ]
    left  = distant(any,  l0)
    right = distant(left, l0)
    c     = dist(left, right)
    sum,xrows = 0,{}
    for _,row in pairs(l0) do
      a   = dist(row, left)
      b   = dist(row, right)
      x   = (a^2 + b^2 - c^2) / (2*c)
      x   = math.max(0, math.min(1, x))
      sum = sum + x
      xrows[#xrows+1] = {x, row}
    end
    local l1,l2 = {}, {}
    for _,xrow in pairs(xrows) do
      local tmp = xrow[1] <= sum/#a and l1 or l2
      tmp[#tmp+1] = xrow[2]
    end
    return {left=left,right=right,c=c,half=sum/#a,l1=l1,l2=l2}
  end
  -- ----------------------------------------
  
  
    
end

end

function fmap(headers,lst,g) 
  for ro


end


