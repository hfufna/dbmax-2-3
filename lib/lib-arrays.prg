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



***********************************
function WebVars2url(aArr, cExclude)
***********************************
//-- trasforma tutte le webVar dell'array in una stringa da URL
local iii,cOut,cExclusionList
cOut := ""
cExclusionList := "VAR_ACTION VAR_OPTION "
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
cExclusionList := "VAR_ACTION VAR_OPTION "
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
function str2arr(cStr, cSep, aaa)
//----------------------------
// wrapper for StrToArr()
//
return (strToArr(cStr, cSep, aaa))

//----------------------------
function StrToArr(cStr, cSep, aaa)
//----------------------------
// Esempio:
// cString := "mia&martini&grande&cantante"
// aInit("myArray","")
// strToArr(cString,"&",myArray)
// restituisce un array con gli elementi presi dalla stringa
//
local nLen,iii,ccc,eee
if type(cStr)<>"C"
   return("LIB-ARRAY ERROR: StrToArray needs a string, a separator and an array where to store values")
else
   nLen := len(cStr)
   aOut := ""
   if type(cSep)<>"C"
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
endif
return(len(aaa))

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

*************************************************
function aseek(aArr,cKey,cDelim)
*************************************************
//-- evolution of aScan()
//
local rrr, ccc, cOut, nCols, nRows, cTxt, cTyp
cOut := ""
if type(cDelim)="U"
   cDelim := "|"
endif
cTyp := type(cKey)
nnn := ascan(aArr,cKey)
if not empty(cDelim)
   cOut := zz(nnn)+cDelim
else
   cOut := "["+zz(nnn)+"]"
endif
rrr := nnn+1
do while rrr < len(aArr)
   nnn := ascan(aArr,cKey,rrr)
   if nnn = 0
      *? "No other correspondances"
      exit
   else
      if not empty(cDelim)
         cOut += zz(nnn)+ cDelim
      else
         cOut += "["+zz(nnn)+"]"
      endif
      rrr := nnn+1
   endif
enddo
if nnn>0 and not empty(cDelim)
   cOut := trimRight(cOut,1)
endif
return cOut

*************************************************
function amfind(aArr,cKey)
*************************************************
local rrr, ccc, cOut, nCols, nRows, cTxt, cTyp
cOut := ""
cTyp := type(cKey)
nnn := ascan(aArr,cKey)
cOut := "["+zz(nnn)+"]"
rrr := nnn+1
do while rrr < len(aArr)
   nnn := ascan(aArr,cKey,rrr)
   if nnn = 0
      ? "No other correspondances"
      exit
   else
      cOut += "["+zz(nnn)+"]"
      rrr := nnn+1
   endif
enddo
return cOut

******************************************************
function newarray(cName)
******************************************************
//-- declares an array monodimensional
//   returns the empty array
//
public &cName
ainit(cName,"")
return( cName )

******************************************************
function amSize(MyArray)
******************************************************
//-- returns a string representing the size of
//   a multidimensional array 
//
local N_DIM, readnow,f
N_DIM = adim( MyArray )
yName = "MyArray"
returnValue = ""
readnow = ""
for F = 1 to N_DIM
   ReturnValue += ltrim( str( len( &yName ) ) ) + ;
   iif( F != N_DIM, ",", "" )
   readnow += iif( F != 1, ",", "" )+"1"
   yName = "MyArray[ " + readnow + " ]"
next
return ReturnValue

***********************************
function matrix(aName, nRows, nCols)
***********************************
//-- creates a rectangular (bi-dimensional) 2D matrix
//   filled with strings that represent the cell address
//   in form row-column
//
local iii,vvv
public &aName
declare &aName[ nRows, nCols ]
for iii = 1 to nRows
  for vvv = 1 to nCols
     &aName[iii,vvv] := "R"+zz(iii)+"-C"+zz(vvv)
  next
next
return(aName)


**************************************
function amprint(aArr)
**************************************
//-- prints out the content of a 2D array
//
local iii, vvv, rrr,ccc, cSize, cOut
cOut :=""
if type(aArr)="A"
   cSize := amsize(aArr)
   rrr := val(wordleft(cSize,","))
   ccc := val(wordRight(cSize,",",1))
   for iii=1 to rrr
      for vvv=1 to ccc
          cOut += zz( aArr[iii,vvv] ) + " "
      next
         cOut += CR_LF
   next
endif
return cOut

*--eof
