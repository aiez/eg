from model import *

class Cocomo(Model):
  def say(o,x,a,b,kloc,sum,prod,exp,effort):
    for i,j in x.items():  
      if i=="kloc": print i,j
      else: print i,j,str(o.all[i].y(j))
    print ":a",a,":b",b,":kloc",kloc,":exp",exp,\
          ":sum",sum,":prod",prod, "effort",effort
  def sumSfs(o,x,out=0): 
    for i in ["prec","flex","arch","team","pmat"]:
      out += o.all[i].y(x[i])
    return out
  def prodEms(o,x,out=1):
    for i in ["rely","data","cplx","ruse","docu",
               "time","stor","pvol","acap","pcap",
               "pcon","aexp","pexp","ltex","tool",
               "site","sced"]:
       out *= o.all[i].y(x[i])
    return out
  def xy(o,verbose=False):
    x     = o.x()
    a     = x["b"]  # a little tricky... "a" is the x of "b"
    b     = o.all["b"].y(a)
    kloc  = o.all["kloc"].x()
    sum   = o.sumSfs(x)
    prod  = o.prodEms(x)
    exp   = b + 0.01 * sum
    effort = a*kloc**exp*prod
    if verbose: o.say(x,a,b,kloc,sum,prod,exp,effort)
    return x,effort 
  def about(o):
    def sf(what) : return Sf(what,1,5)
    def emn(what,lo=1,hi=5) : return Emn(what,lo,hi)
    def emp(what,lo=1,hi=5) : return Emp(what,lo,hi) 
    return [Range("kloc",2,1000), 
            B(  "b",3,10,wild=True),
            sf( "prec"),
            sf( "flex"), 
            sf( "arch"),
            sf( "team"), 
            sf( "pmat"), 
            emp("rely"),
            emp("data", 2,5),
            emp("cplx", 1,6),
            emp("ruse", 2,6),
            emp("docu", 1,5),
            emp("time", 3,6),
            emp("stor", 3,6),
            emp("pvol", 2,5),
            emn("acap"),
            emn("pcap"),
            emn("pcon"),
            emn("aexp"),
            emn("pexp"),
            emn("ltex"),
            emn("tool"),
            emn("site",1,6),
            emn("sced")]

class Sf(Range):
   def y(o,x): return o.m()*(x - 6)
   def m(o)  : return random.uniform(-0.972,-0.648)

class Em(Range):
   def y(o,x): return o.m()*(x-3)+1

class Emp(Em):
   def m(o): return random.uniform(0.055,0.15)

class Emn(Em):
   def m(o): return random.uniform(-0.166,-0.075)

class B(Range):
   def y(o,x): 
     return -0.036 * x + 1.1 - 0.1*random.random() -0.05

def coced0():
 print Cocomo().xy(verbose=True)

def coced1(max=1000):
  import matplotlib.pyplot as plt
  random.seed(1)
  c = Cocomo()
  n = 0
  out= sorted([c.xy() for x in range(max)],key=lambda x: x[1])
  xs=[]
  ys=[]
  for x,y in out:
    n += 1
    xs.append(n)
    ys.append(y)
  p1, = plt.plot(xs,ys,'ro')
  p2,=  plt.plot(xs,[x*2 for x in ys],'bo')
  plt.legend([p2,p1],["small","bigger"],loc=4)
  plt.xlim(0,1050)
  plt.yscale('log')
  plt.ylabel('effort')
  plt.xlabel('all efforts, sorted')

  plt.show()
  #plt.savefig('coced1.png')

#coced1()

def coced2(max=1000,rounds=10):
  #random.seed(1)
  c = Cocomo()
  coced2a(rounds,c,max)

def coced2a(r,c,max,updates={}):
  def h100(x,r=250) : return int(x/r) * r
  if r > 0:
    for k in updates:
      c.all[k].sample = updates[k]
    out = [c.xy() for x in range(max)]
    efforts = Rsteps("effort[%s]" % r,final=h100)
    for _,effort in out: 
      efforts.all.append(effort)
    somed0(efforts,n=max)
    better = elite(out)
    #for k,v in better.items():
     # print "\n",k
      #somed0(v,n=max)
    coced2a(r-1,c,max,better)
  


 
#coced2() 

def coced3(max=1000,rounds=20):
  random.seed(1)
  c = Cocomo()
  import matplotlib.pyplot as plt
  #plt.yscale('log')
  plt.ylabel('effort')
  plt.xlabel('all efforts, sorted')
  styles=["r-","m-","c-","y-","k-","b-","g-"]  
  plots=[]
  legends=[]
  coced3a(0,len(styles)-1,c,max,plt,styles,plots=plots,legends=legends)
  plt.legend(plots,legends,loc=2)
  plt.xlim(0,1050)
  plt.show()

def coced3a(round,rounds,c,max,plt,styles,updates={},plots=[],legends=[]):
  def h100(x,r=250) : return int(x/r) * r
  if round <= rounds:
    for k in updates:
      c.all[k].sample = updates[k]
    out = [c.xy() for x in range(max)]
    better = elite(out)
    plot = plt.plot([x for x in range(1000)],
                    sorted([effort for _,effort in out]),
                    styles[round],linewidth=round+1)
    plots.append(plot)
    legends.append("round%s" % round)

    coced3a(round+1,rounds,c,max,plt,styles,updates=better,
            plots=plots,legends=legends)

def coced4(samples=1000,rounds=15):
  #random.seed(1)
  c = Cocomo()
  import matplotlib.pyplot as plt
  #plt.yscale('log')
  xs = []
  medians=[]
  spreads=[]
  mosts=[]
  coced4a(0,rounds,c,samples,{},xs,medians,spreads,mosts)
  plt.ylabel('effort')
  plt.xlabel('round')
  plt.legend([plt.plot(xs,medians),plt.plot(xs,spreads)],
              ["median","spread"],
              loc=1)
  plt.xlim(-0.5,len(medians)+0.5)
  plt.ylim(0,1.05*max(medians + spreads + mosts))
  plt.show()

def coced4a(round,rounds,c,samples,updates={},xs=[],medians=[],spreads=[],mosts=[]):
  if round <= rounds:
    print round
    for k in updates:
      if not c.all[k].wild:
        c.all[k].sample = updates[k]
        somed0(c.all[k].sample,n=100)
    out = [c.xy() for x in range(samples)]
    better = elite(out)
    ys = sorted([x for _,x in out])
    p25,p50,p75= [int(len(ys)*n) for n in [0.25,0.5,0.75]]
    medians.append(ys[p50])
    spreads.append(ys[p75] - ys[p25])
    xs.append(round)
    coced4a(round+1,rounds,c,samples,updates=better,
            xs=xs,medians=medians,spreads=spreads,mosts=mosts)  

def elite(xy,bins=7,top=0.2,final=float,key=lambda x:x[1]):
  def r(x) : return "%3.2f" % x
  def keep(lst):
    keeper = {}
    for how,_ in lst:
      if not keeper:
        for k in how: 
          keeper[k] = Rsteps(k,bins,final)
      for k,v in how.items():
        keeper[k].put(v)
    return keeper
  n     = int(top*len(xy))
  xy    = sorted(xy,key=key)
  bests = keep(xy[:n])
  rests = keep(xy[n:])
  for k,v in bests.items():
    print k, bests[k] - rests[k]
  return bests

coced4()
:
