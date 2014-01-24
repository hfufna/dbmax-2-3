**************************************************************
**
**  DBMAX->DBFREE 2.0 - STRING HANDLING LIBRARY
**
**
**  Progetto iniziato a Prato il 10 ago 2010
**
**  vers. 0.0.3 - Prato 02 ott 2010
**  vers. 0.0.4 - Prato 07 ott 2010
**
**************************************************************

#define CR_LF chr(13)+chr(10)
#define S_T  chr(10)
#define E_T chr(13)

*-------------------------------------------------------------------------------
function include(cFil)
*-------------------------------------------------------------------------------
//-- usage:
//   ? include(cTextFile) html
//
local cTem
cTem := cFil
if not file(cTem)
   cTem := curDosDir() + cFil
   if not file(cTem)
      cTem := documentRoot() + "\" + cFil
   endif
endif
if not file(cTem)
   return "Not found " + cTem
endif
return memoread(cTem)


*-------------------------------------------------------------------------------
function trimRight( cStr, nPos )
*-------------------------------------------------------------------------------
// accorcia una stringa a destra di nPos caratteri
local nLen, cout
nLen = len(cStr)
cOut = subs(cStr,1,nLen-nPos)
return cOut


*-------------------------------------------------------------------------------
function trimLeft( cStr, nPos )
*-------------------------------------------------------------------------------
// accorcia una stringa a sinistra di nPos caratteri
local nLen, cout
nLen = len(cStr)
cOut = subs(cStr,nPos+1, nLen-nPos)
return cOut


*-------------------------------------------------------------------------------
function cutAt( cString, cKey)
*-------------------------------------------------------------------------------
//-- taglia una stringa da sinistra sino al punto in cui trova cKey
local n1
if pcount() = 2
   n1 = at(cKey,cString)
   if n1 > 0
      return left(cString,n1-1)
   endif
endif
return cString

*-------------------------------------------------------------------------------
function trimLeftAt(c1, c2)
*-------------------------------------------------------------------------------
return cutAt(c1, c2)


*-------------------------------------------------------------------------------
function trimRightAt(cString, cKey)
*-------------------------------------------------------------------------------
local nPos
if pcount() = 2
   nPos = at(cKey,cString)
   if nPos > 0
      cString := subs(cString ,nPos+1,len(cString)-nPos)
   endif
endif
return cString


*-------------------------------------------------------------------------------
function StripChars( cTxt )
*-------------------------------------------------------------------------------
//-- leva i caratteri non stampabili
for nPos = 1 to len(cTxt)
  cByte = subs(cTxt,nPos,1)
  if asc( cByte ) < 65 or asc( cByte ) > 254
     stuff( cTxt, nPos, 1, chr(20) )
  endif
next
return cTxt


*-------------------------------------------------------------------------------
function cleanUp( cVar )
*-------------------------------------------------------------------------------
cVar := alltrim(cVar)
cVar := strTran(cVar,"<","[")
cVar := strTran(cVar,">","]")
cVar := strTran(cVar,'"',"*")
cVar := strTran(cVar,"'","°")
cVar := strTran(cVar,chr(10)," ")
cVar := strTran(cVar,chr(13)," ")
cVar := strTran(lower(cVar),"href"," ")
cVar := strTran(lower(cVar),"script"," ")
return cVar


*-------------------------------------------------------------------------------
function cleanStr( cVar )
*-------------------------------------------------------------------------------
*--- da usare con wz_tooltip.js
cVar := cleanUp( cVar )
cVar := strTran(cVar,"'","/'")
cVar := strTran(cVar,"(","[")
cVar := strTran(cVar,")","]")
return cVar

*-------------------------------------------------------------------------------
function fChar( val )
*-------------------------------------------------------------------------------
local cOut
cOut = ""
do case
   case type(val) = "N"
      cOut = str(val)
   case type(val) = "D"
      cOut = dtoc(val)
   case type(val) = "L"
      cOut = iif(val,"Y","N")
   case type(val) = "C"
      cOut = val
    case type(val) = "A"
      cOut = "ARRAY"
   case type(val) = "U"
      cOut = "UNDEF"
    otherwise
      cOut = "UNKOWN"
   endcase
return cOut



*-------------------------------------------------------------------------------
function WordRight( cStr, cSep )
*-------------------------------------------------------------------------------
// Riceve una stringa e restituisce la parola piu' a destra (identificata dal 
//   separatore passato come secondo parametro) 
//
local nPos, nLen, cOut
cSep := iif( type(cSep)="U", " ", cSep)
cOut = ""
nPos = 0
if not empty( cStr )
   cStr = alltrim(cStr)
   nlen = len( cStr)
   nPos  = Rat( cSep,cStr )
   if nPos > 0
      cOut = subs(cStr,nPos,nLen-nPos+1)
   endif
endif
return cOut 


*-------------------------------------------------------------------------------
function WordLeft( cStr, cSep )
*-------------------------------------------------------------------------------
local nPos, cOut
cSep := iif( type(cSep)="U", " ", cSep)
cOut = ""
nPos = 0
if not empty( cStr )
   cStr = alltrim(cStr)
   nPos  = At( cSep,cStr )
   if nPos > 0
      cOut = subs(cStr,1,nPos-1)
   else
      cOut = cStr
   endif
endif
return cOut 

*-------------------------------------------------------------------------------
function padl( cString, nLength, cCaratt )
*-------------------------------------------------------------------------------
local nChars, cOut, cStr, nlen, cCar
cStr := iif(type(cString)="U","",cString)
nLen := iif(type(nLength)="U",1,nLength)
cCar := iif(type(cCaratt)="U"," ",cCaratt)

cOut = cStr
cOut = "" + cStr
nPos = len(cOut)
nChars = nLen - nPos
 if nChars > 0 
   cOut = repli(cCar,nChars) + cOut
endif
return cOut


*-------------------------------------------------------------------------------
function padc( cString, nLength, cCaratt )
*-------------------------------------------------------------------------------
local nChars, cOut, nSize , cStr, nlen, cCar
cStr := iif(type(cString)="U","",cString)
nLen := iif(type(nLength)="U",1,nLength)
cCar := iif(type(cCaratt)="U"," ",cCaratt)

cOut = cStr
cOut = fchar(cStr)
nSize  = len(cOut)
nChars = int(nLen - nSize) /2
if nChars > 0 
   cOut = repli(cCar,nChars) + cOut + repli(cCar,nChars)
endif
return cOut

*-------------------------------------------------------------------------------
function padr( cString, nLength, cCaratt )
*-------------------------------------------------------------------------------
local nChars, cOut, cStr, nlen, cCar
cStr := iif(type(cString)="U","",cString)
nLen := iif(type(nLength)="U",1,nLength)
cCar := iif(type(cCaratt)="U"," ",cCaratt)

cOut := "" + cStr
nPos := len(cOut)
nChars := nLen - nPos
if nChars > 0 
   cOut = cStr + repli(cCar,nChars)
endif
return cOut

*---------------------------------------------------------------
function Capital( cStr )
*---------------------------------------------------------------
local cOut, nLen
cStr := lower(fchar(cStr))
cOut := upper(left(cStr,1))
nLen := len(cStr)
cOut += right(cStr,nLen-1)
return cOut


*-------------------------------------------------
function fixSlash(cTxt)
*-------------------------------------------------
cTxt := strTran(cTxt,"/","\")
cTxt := strTran(cTxt,"\\","\")
return cTxt

//---------------------------------------------
function rslash(cTxt)
//---------------------------------------------
if right(rtrim(cTxt),1) <> "\"
   cTxt:= cTxt+"\"
endif
return cTxt


*-----------------------------------------------
function noSpaces(cStr)
*-----------------------------------------------
strTran(cStr," ","")
return cStr

*-----------------------------------------------
function splitVal(cStr,nVal,cSep)
*-----------------------------------------------
//-- recupera da una stringa la porzione di testo
//   prima o dopo il separatore <cSep>
//   Se <nVal=0> la porzione sinistra, altrimenti
//   la destra. Per recuperare la coppia completa
//   chiamarla due volte. Es:
//   cTxt := "mario/rossi"
//   c1 := splitVal(cTxt,0,"/")
//   c2 := splitVal(cTxt,1,"/")
//   Utile per leggere le coppie dai file INI
//
local cOut,n1
cOut :=""
cSep := iif(type(cSep)="U","-",cSep)
nVal := iif(type(nVal)="U",0,nVal)
cStr := alltrim(cStr)
n1 := at(cSep,cStr)
if n1 > 0
   cOut := subStr(cStr,1,n1-len(cSep))
   if nVal > 0
      cOut := subStr(cStr,n1+len(cSep))
   endif
endif
return cOut


//-----------------------------------------
function zz(aa)
//-----------------------------------------
//-- forza un valore a stringa senza spazi
//   davanti e dietro da usare negli URL
//   accetta di tutto
local iii, cOut
cOut :=""
do case
case type(aa)="N"
   cOut:= wstr(aa)
case type(aa)="C"
   cOut:= alltrim(aa)
case type(aa)="D"
   cOut:= dtoc(aa)
case type(aa)="L"
   cOut:= IIF(aa,"Y","N")
case type(aa)="M"
   cOut:= alltrim(aa)
case type(aa)="A"
   for iii=1 to len(aa)
      cOut += "[" + fchar(aa[iii]) + "] "
   next
endcase
return alltrim(cOut)

//-----------------------------------------
function wstr(nVal)
//-----------------------------------------
//-- web string, senza spazi davanti e dietro
//   usata per passare valori via URL
local cTxt, cTyp
cTyp := type(nVal)
do case
case cTyp ="N"
   cTxt := str(nVal)
   cTxt := alltrim(cTxt)
   cTxt := strTran(cTxt," ","")
case cTyp ="D"
   cTxt := dotc(nVal)
case cTyp ="L"
   cTxt := iif(nVal=.t.,"Y","N")   
otherwise
   cTxt := fchar(nVal)
endcase
return cTxt

//-----------------------------------------
function jslash(cTxt)
//-----------------------------------------
//-- double the forward slash to allow use of stringds
//   returning DOS paths into javascripts
return strTran(cTxt,"\","\\")


//-----------------------------------
function dblSlash(cTxt)
//-----------------------------------
return strTran(cTxt,"\","\\")


//-----------------------------------------
function dslash(cTxt)
//-----------------------------------------
//-- raddoppia i forward slash per uso con javascript
cTxt := strTran(cTxt,"\","\\")
return cTxt

************************************
function readIniVar(cFile,cVarname)
************************************
* Ritorna il valore di una variabile presa dal file INI
* precedentemente salvata con writeIniVar
* 
local cOpenTag,cCloseTag,cTokenTag,nnn,nCount
local nPos1,nPos2,nSize,nLen,mVal,cStr
local cToken, cCargo, cOut

if not file(cFile)
   return "ERROR: file " + cFile + " does not exist"
endif

cStr := memoread(cFile) 

cOpenTag  := S_T
cCloseTag := E_T
cTokenTag := "="
nnn    := 1
nCount :=0
cOut   := ""
*
do while nnn < 1024
   // cerchiamo i tag di apertura e chiusura nella stringa
   nPos1  := at(cOpenTag  ,cStr)
   if nPos1 = 0
      nPos1 := 1
   endif
   nPos2  := at(cCloseTag ,cStr)
   nSize  := nPos2-nPos1+1
   nLen   := len(cStr)-nPos1
   
   // carichiamo la porzione di testo compresa fra i tag
   mVal := substr(cStr,nPos1+1,nSize-2)
   *
   // accorciamo la stringa eliminando la parte già esaminata
   cStr := substr(cStr,nPos2+1)
   *
   // cerchiamo dentro alla porzione il token 
   cToken := wordLeft(mVal,"=")
   cCargo := wordRight(mVal,"=")
   *
   if cToken == cVarname
      cOut := trimLeft(cCargo,1)
   endif
   *
   if at(cOpenTag ,cStr)=0
      exit
   endif
   nnn++
enddo
return cOut


//------------------
function writeIniVar(cFile1,cVar1,cValue1)
//------------------
* Salva una variabile e il suo valore in un file ini
* di tipo DBFree 
* Se il file non esiste viene creato
* Ritorna il nome del file INI in cui ha scritto
*
local cTxt, cTest, cXcg1, cXcg2
if not empty(cVar1)
   *-- controlliamo se esiste già
   cTxt := memoread(cFile1)
   if IniVar(cFile1,cVar1)
      cTest :=readIniVar(cFile1,cVar1)
      cXcg1 := cVar1 + "=" + cTest
      cXcg2 := cVar1 + "=" + cValue1
      cTxt := strTran(cTxt,cXcg1,cXcg2)
   else
      cTxt += S_T + cVar1 + "=" + zz(cValue1) + E_T
      cTxt := nospaces(cTxt)
   endif
   memowrit(cFile1,cTxt)
   cAction :=""
endif
return cFile1

************************************
function iniVar(cFile,cVarname)
************************************
* Ritorna vero o falso se esiste la variabile
* 
local cOpenTag,cCloseTag,cTokenTag,nnn,nCount
local nPos1,nPos2,nSize,nLen,mVal,cStr
local cToken, cCargo, lOk

if not file(cFile)
   return .f.
endif

cStr := memoread(cFile) 

cOpenTag  := S_T
cCloseTag := E_T
cTokenTag := "="
nnn    := 1
nCount := 0
lOk := .f.
*
do while nnn < 1024
   // cerchiamo i tag di apertura e chiusura nella stringa
   nPos1  := at(cOpenTag  ,cStr)
   if nPos1 = 0
      nPos1 := 1
   endif
   nPos2  := at(cCloseTag ,cStr)
   nSize  := nPos2-nPos1+1
   nLen   := len(cStr)-nPos1
   
   // carichiamo la porzione di testo compresa fra i tag
   mVal := substr(cStr,nPos1+1,nSize-2)
   *
   // accorciamo la stringa eliminando la parte già esaminata
   cStr := substr(cStr,nPos2+1)
   *
   // cerchiamo dentro alla porzione il token 
   cToken := wordLeft(mVal,"=")
   cCargo := wordRight(mVal,"=")
   *
   if cToken == cVarname
      lOk :=.t.
   endif
   *
   if at(cOpenTag ,cStr)=0
      exit
   endif
   nnn++
enddo
return lOk


*--eof

