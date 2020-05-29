local _ = 0

-- bounded by 1..5
local ne=   {{_,_,_,1,2,_}, -- bad if lohi 
             {_,_,_,_,1,_},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_}}
local  nw=  {{2,1,_,_,_,_}, -- bad if lolo 
             {1,_,_,_,_,_},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_}}
local  nw4= {{4,2,1,_,_,_}, -- very bad if  lolo 
             {2,1,_,_,_,_},
             {1,_,_,_,_,_},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_}}
local  sw4= {{_,_,_,_,_,_}, -- very bad if  hilo 
             {_,_,_,_,_,_},
             {1,_,_,_,_,_},
             {2,1,_,_,_,_},
             {4,2,1,_,_,_},
             {_,_,_,_,_,_}}

-- bounded by 1..6
local ne46= {{_,_,_,1,2,4}, -- very bad if lohi
             {_,_,_,_,1,2},
             {_,_,_,_,_,1},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_}}
local sw26= {{_,_,_,_,_,_}, -- bad if hilo
             {_,_,_,_,_,_},
             {_,_,_,_,_,_},
             {_,_,_,_,_,_},
             {1,_,_,_,_,_},
             {2,1,_,_,_,_}}
local sw46= {{_,_,_,_,_,_}, -- very bad if hilo
             {_,_,_,_,_,_},
             {_,_,_,_,_,_},
             {1,_,_,_,_,_},
             {2,1,_,_,_,_},
             {4,2,1,_,_,_}}

return { 
  cplx= {acap=sw46, pcap=sw46, tool=sw46}, --12
  ltex= {pcap=nw4},  -- 4
  pmat= {acap=nw,  pcap=sw46}, -- 6
  pvol= {plex=sw2}, --2
  rely= {acap=sw4,  pcap=sw4,  pmat=sw4}, -- 12
  ruse= {aexp=sw46, ltex=sw46},  --8
  sced= {
    cplx=ne46, time=ne46, pcap=nw4, aexp=nw4, acap=nw4,  
    plex=nw4, ltex=nw, pmat=nw, rely=ne, pvol=ne, tool=nw}, -- 34
  stor= {acap=sw46, pcap=sw46}, --8
  team= {aexp=nw,  sced=nw,  site=nw}, --6
  time= {acap=sw46, pcap=sw46, tool=sw26}, --10
  tool= {acap=nw,  pcap=nw,  pmat=nw} -- 6
}
