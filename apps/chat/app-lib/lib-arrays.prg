**************************************************************
**
**  DBMAX->DBFREE 2.0 - DBF EXTEND FUNCTIONS LIBRARY
**
**  Progetto iniziato a Prato il 10 ago 2010
**
**  vers. 0.0.2 - Prato 29 set 2010
**  vers. 0.0.3 - Prato 02 ott 2010
**  vers. 0.0.4 - Prato 12 dic 2010
**  vers. 0.0.5 - Prato 13 gen 2011
**  vers. 0.0.6 - Prato 16 gen 2011
**************************************************************


***********************************
function WebVars2url(aArr, cExclude)
***********************************
//-- trasforma tutte le webVar dell'array in una stringa da URL
local iii,cOut,cExclusionList
cOut := ""
cExclusionList := "VAR_ACTION VO "
if pcount()>1
   cExclusionList += cExclude
endif
for iii=1 to len(aArr)
   if upper(aArr[iii,1]) $ (cExclusionList)
      //-- scarta il valore
   elseif upper(left(aArr[iii,1],3))="PB_"
   else
      cOut += "&" + aArr[iii,1]+"="+aArr[iii,2]
   endif
next
return cOut

***************************************
function WebVars2Fields(aArr, cExclude)
***************************************
//-- trasforma tutte le webVar dell'array in campi hidden
local iii,cOut,cExclusionList
cExclusionList := "VAR_ACTION VO "
cOut := ""
if pcount()>1
   cExclusionList += cExclude
endif
for iii=1 to len(aArr)
   if upper(aArr[iii,1]) $ (cExclusionList)
      //-- scarta il valore
   elseif upper(left(aArr[iii,1],3))="PB_"
   else
      cOut += '<input type="hidden" name="' + aArr[iii,1] + '" value="' + aArr[iii,2] + '">'
   endif
next
return cOut



//--------------------------------
function aSize( MyArray )
//--------------------------------
local iii, cResponse,cActVal
private cTest
nDimens   := adim( MyArray )
cTest     := "MyArray"
cResponse := ""
cActVal   := ""
for iii = 1 to nDimens
   cResponse += ltrim( str( len( &cTest ) ) ) + ;
   iif( iii != nDimens, ",", "" )
   cActVal += iif( iii != 1, ",", "" )+"1"
   cTest = "MyArray[ " + cActVal + " ]"
next
return cResponse


//----------------------------
function StrToNumArr(cStr, cSep, aaa)
//----------------------------
// Esempio:
// cString := "100&12&5&24"
// aInit("myArray","")
// strToNumArr(cString,"&",myArray)
// restituisce un array con i numeri estratti dalla stringa

local nLen,iii,ccc,eee
nLen := len(cStr)
aOut := ""
if empty(cSep)
   cSep := ","
endif

eee := 0
nnn := 0
if nLen > 0
   do while len(cStr) > 0 or nnn < 100
      nnn++
      nPos := at(cSep,cStr)
      ccc := subs(cStr,1,nPos-1)
      eee++
      aRedim(aaa,eee)
      aaa[eee] := val(ccc)
      cStr := subs(cStr,nPos+1,nLen)
      if nPos = 0
         exit
      endif
   enddo
endif
return


//----------------------------
function StrToArr(cStr, cSep, aaa)
//----------------------------
// Esempio:
// cString := "mia&martini&grande&cantante"
// aInit("myArray","")
// strToNumArr(cString,"&",myArray)
// restituisce un array con i numeri estratti dalla stringa

local nLen,iii,ccc,eee
nLen := len(cStr)
aOut := ""
if empty(cSep)
   cSep := ","
endif

eee := 0
nnn := 0
if nLen > 0
   do while len(cStr) > 0 or nnn < 100
      nnn++
      nPos := at(cSep,cStr)
      ccc := subs(cStr,1,nPos-1)
      eee++
      aRedim(aaa,eee)
      aaa[eee] := ccc
      cStr := subs(cStr,nPos+1,nLen)
      if nPos = 0
         exit
      endif
   enddo
endif
return

//--------------------------------
function atos(aArray)
//--------------------------------
//-- array to string
local cTxt
cTxt := ""
if type(aArray)="A"
   nCols := adim(aArray)
   *? "Cols:" + zz(nCols)
   nRows := alen(aArray)/nCols
   *? "Rows:" + zz(nRows)
   if nCols = 1
      for iii=1 to nRows
         cTxt += "[" + zz(aArray[iii]) + "]"
      next
   else
      for iii=1 to nRows
         for nnn=1 to nCols
            cTxt += "[" + zz(aArray[iii,nnn]) + "]"
         next
      next
   endif
endif
return cTxt


*-------------------------------------------------------------------------------
function vector2str(aArr, cSep)
*-------------------------------------------------------------------------------
//-- trasforma un array (vettore) in stringa
//   parametro: tipo di separatore
if pcount()=1
   cSep := "§"
endif
cStrArray := cSep
for iii = 1 to len(aArr)
   cStrArray += cSep + zz(aArr[iii])
next
cStrArray += cSep
return cStrArray 


*-------------------------------------------------------------------------------
function square2str(aArr, cSep, cDiv)
*-------------------------------------------------------------------------------
//-- trasforma un array (matrice quadra) in stringa
//   parametro: tipo di separatore
if pcount()=1
   cSep := "§"
   cDiv := "^"
endif
cStrArray := ""
for iii = 1 to len(aArr)
   cStrArray += cSep + zz(aArr[iii,1])+ cDiv + zz(aArr[iii,2])+ cSep
next
return cStrArray 

*-------------------------------------------
function aGrow(aaa)
*-------------------------------------------
local nnn
if type(aaa) = "A"
   nnn := alen(aaa)
   aRedim(aaa,nnn+1)
else
endif
return nnn+1

*-------------------------------------------
function aadd(aaa, xVal)
*-------------------------------------------
local nnn
if type(aaa) = "A"
   nnn := alen(aaa)
   nnn+=1
   aRedim(aaa,nnn)
   aaa[nnn] := xVal
else
endif
return nnn

*****************************
function aprint(aaa, cSep)
*****************************
local rrr,ccc,cTxt
local nRows,nCols
if pcount()<2
   cSep := ":"
endif
cTxt := cSep
nRows  := len(aaa)
if adim(aaa)=1
   for rrr=1 to nRows
      cTxt += cSep + zz(aaa[rrr]) + cSep
   next
else
   for rrr=1 to nRows
      for ccc=1 to len(aaa[rrr])
         cTxt += cSep + zz(aaa[rrr,ccc]) + cSep
      next
   next
endif
return cTxt


*****************************
function adimens( aaa)
*****************************
//-- Return a string with all dimensions of given array
//-- notice the macro evaluation used by this function
local iii, cResponse,cActVal
private cTest
nDimens   := adim( aaa)
cTest     := "aaa"
cResponse := ""
cActVal   := ""
for iii = 1 to nDimens
   cResponse += ltrim( str(len( &cTest ))) + iif( iii != nDimens, ",", "" )
   cActVal += iif( iii != 1, ",", "" )+"1"
   cTest := "aaa[ " + cActVal + " ]"
next
return cResponse

*--eof
