******************************
function timeDiff(cStr1,cStr2)
******************************
local nHour,cVal1,cVal2
if not left(upper(cStr1),2) $ "AMPM"
   nHour := val(left(cStr1,2)) 
   cStr1 := cStr1 +" "+iif(nHour>=12,"pm","am")
endif

if not left(upper(cStr2),2) $ "AMPM"
   nHour := val(left(cStr2,2)) 
   cStr2 := cStr2 +" "+iif(nHour>=12,"pm","am")
endif
return elaptime(cStr1,cStr2)

**************************************************
function CtimeDiff(cTime1,cTime2)
**************************************************
local c1,c2,h1,h2,m1,m2
c1 := zz(cTime1)
c2 := zz(cTime2)
h1 := val(left(c1,2))
h2 := val(left(c2,2))
m1 := val(subs(c1,4,2))
m2 := val(subs(c2,4,2))
if h2<h1
   h2 += 24
endif
nnn := (h2*60+m2)-(h1*60+m1)
return zz(int(nnn/60))+":"+zz(mod(nnn,60))%>

*****************************************
function range(nVar,nMin,nMax)
*****************************************
if nVar > nMax
   nVar := nMax
elseif nVar < nMin
   nVar := nMin
endif
return nVar