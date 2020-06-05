local l = require "lib"

local Delta = l.class()
function Delta:_init(d1,d2, syms, nums)
  for _,col in pair(syms) do
    self:sym(col.pos,d1.rows,d2,rows)
  end
end

function Delta:sym(pos,as,bs)
  local s = Sym()
  for i,lst in pairs({as,bs}) do
    for _,row in pairs(lst) do
      v= row.cells[pos]
      s[v] = s[v] or Sym()
      s[v]:add{i} end end

end
return Delta
