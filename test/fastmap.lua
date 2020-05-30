require "ok"
local lib= require "lib"
local Fastmap= require "fastmap"

a={}
head={}
for r in lib.csv("../test/data/raw/auto93.csv") do
   if head then a[#a+1] =r else header = r end
end
Fastmap(head, r):rdiv(r)
