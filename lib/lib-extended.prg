**************************************************************
**  
**************************************************************
**  DBMAX 2.5 - LIBRARY MODULE (derived from DBFree 3.0.1)
**  (c) by G.Napolitano
**
**  Project start: Prato 4 ott 2013
**  vers. 0.0.1 - Prato 05 ott 2013
**
**************************************************************
#define CR_LF chr(13)+chr(10)


*****************************************
function range(nVar,nMin,nMax)
*****************************************
if nVar > nMax
   nVar := nMax
elseif nVar < nMin
   nVar := nMin
endif
return nVar

*-------------------------------------------------------------------------------
function default(Var, Value)
*-------------------------------------------------------------------------------
return iif(vtype(&Var)="U",Value,Var)

*-------------------------------------------------------------------------------
function keepVal( cStr, nLow, nHigh)
*-------------------------------------------------------------------------------
local nRet
if empty(cStr)
   nRet := 1
else
   nRet := val(alltrim(cStr))
   if nRet < nLow
      nRet := nLow
   elseif nRet > nHigh
      nRet := nHigh
   endif
endif
return str(nRet,2,0,"0")

*--eof