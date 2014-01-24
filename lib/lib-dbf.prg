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


*********************
function enableOdbc()
*********************
cFile := MspConfigVar("MSPDIR")+"\MSPODBCOXBC.dll"
if not file(cFile)
   return "<b>ATTENTION</b>:not running DBMax!<br>ODBC Extensions NOT SUPPORTED by this version of MaxScript!"
endif

*********************
function enableClipper()
*********************
cFile := MspConfigVar("MSPDIR")+"\MSPCBOXBC-NTX.dll"
if not file(cFile)
   return "<b>ATTENTION</b>:Clipper Extensions are NOT ENABLED with this configuration of DBMAX!"
endif

*********************
function enableFox()
*********************
cFile := MspConfigVar("MSPDIR")+"\MSPCBOXBC-CDX.dll"
if not file(cFile)
   return "<b>ATTENTION</b>:FoxPro Extensions are NOT ENABLED with this configuration of DBMAX!"
endif

*********************
function enableDbase()
*********************
cFile := MspConfigVar("MSPDIR")+"\MSPCBOXBC-MDX.dll"
if not file(cFile)
   return "<b>ATTENTION</b>:dBase Multiple Indexes and DBF level 5 are NOT ENABLED with this configuration of DBMAX!"
endif


*-------------------------------------------------------------------------------
function setDb(cDbPos, xRelative)
*-------------------------------------------------------------------------------
//-- chiamata da tutte le pagine che necessitano di accedere al database
//   il secondo parametro indica se usare la DB ROOT o una sottoposizione
//   Esempio:
//   - setDb("gnx") per settare come cartella corrente dei db 
//   la sottocartella GNX sotto a DATADIR (se non esiste viene creata)
//   - setDb()
//   per settare DATADIR come default, ovvero lo stesso che non usare setDb()
//   - setDb(xAppId,1) usa una sottocartella LOCAL di xAppId e la usa come DBRoot
//
cDataDir := MSPconfigVar("DATADIR")
cDbRoot  := cDataDir+"\"

if pcount()=0
   cDbPos := ""
endif
if empty(cDbPos)
   set default to (cDbRoot)
   if not file(cDataDir)
      md (cDataDir)
   endif
   return cDbRoot
else
   if not type(xRelative)="U"
      cDbPos:= cDBroot + cDbPos + "\local" 
   else
      cDbPos:= cDBroot + cDbPos
   endif
   if not isDir(cDbPos)
      createDir(cDbPos)
   endif
   set default to (cDbPos) 
endif
return rslash(cDbPos) 


******************************************
function dbOpen(aDbList, cOpenList)
******************************************
* riceve una matrice 2D di 3 colonne con nome DBF, nome MTX e ALIAS
* il secondo parametro è una stringa di numeri separati da virgole
* per determinare quali tabelle aprire (numero elemento dell'array)
* se si passa zero come primo numero della lista visualizza tutto il contenuto
*

local iii, nnn, cDb, cXb, cXa, aCtrlList
if pcount()=1
   for iii=1 to len(aDbList)
      select (iii)
      use (aDbList[iii,1]) index (aDbList[iii,2]) alias (aDbList[iii,3])
   next
elseif pcount()=2 and not empty(cOpenList)
   if cOpenList="0"
      for iii=1 to len(aDbList)
         ? zz(iii) + " DB[" + aDbList[iii,1] + "] NDX[" + aDbList[iii,2] + "] As[" + aDbList[iii,3] +"]"
      next
      return ""
   else
      ainit("aCtrlList","")
      strToNumArr(cOpenList,",",aCtrlList)
      for iii=1 to len(aCtrlList)
         nnn := aCtrlList[iii]
         select (iii)
         use (aDbList[nnn,1]) in 0 index (aDbList[nnn,2]) alias (aDbList[nnn,3])
         *? zz(iii) | zz(nnn) | dbf()
      next
   endif
endif
return alias()



*-------------------------------------------------------------------------------
function ftype(fieldNum)
*-------------------------------------------------------------------------------
//-- returns the data-type of a given field (expects a number)
//
cTxt := type(fieldname(fieldNum))
return cTxt

*-------------------------------------------------------------------------------
function fieldtype(fldNameorNum)
*-------------------------------------------------------------------------------
//-- returns the data-type of a given field (expects a name or a number)
//
local mVal, cFld
if type(fldNameorNum) ="C"
   cFld := fldNameorNum
elseif type(fldNameorNum) ="N"
   cFld := fieldname(fldNameorNum)
endif
xVal := fieldcont(cFld)
return type(xVal)


*-------------------------------------------------------------------------------
function fieldsize(fldNameorNum)
*-------------------------------------------------------------------------------
//-- returns the maximun size of a given field (expects a name or a number)
//
local xVal
if type(fldNameorNum) ="C"
   xVal := fieldcont(cField)
elseif type(fldNameorNum) ="N"
   xVal := fieldcont(fieldname(fldNameorNum))
endif
cTyp := type(xVal)
do case
   case cTyp = "N"
      xVal := str(xVal)
   case cTyp = "L"
      return "3"
   case cTyp = "D"
      return "10"
endcase
return zz(len(xVal))

*-------------------------------------------------------------------------------
function fieldlen(cField)
*-------------------------------------------------------------------------------
//-- returns the ACTUAL size of the content of a given field (expects a name)
//
local xVal
xVal := fchar(fieldcont(cField))
return str(len(xVal),3,0)


*-------------------------------------------------------------------------------
function fsize(nField)
*-------------------------------------------------------------------------------
//-- returns the ACTUAL size of the content of a given field (same as fieldlen
//   but expects a number)
//
local xVal
xVal := fchar(fieldname(nField))
return str(len(xVal),3,0)

*-------------------------------------------------------------------------------
function fieldval(nFld)
*-------------------------------------------------------------------------------
//-- returns the actual content of a given field (expects a number)
return fieldcont(fieldname(nFld))


*-------------------------------------------------------------------------------
function fieldcount()
*-------------------------------------------------------------------------------
//-- return the number of fields per record of currently open table
return fcount()



*-------------------------------------------------------------------------------
function fieldfit(cFldname, xCargo)
*-------------------------------------------------------------------------------
//-- riceve una stringa *xCargo* e restituisce un tipo di valore adatto
//   ad essere salvato nel campo *cFldname* 
//   Il campo deve esistere nella tabella attualmente aperta
//
if type(cFldName)="U" or empty(cFldname)
   return("ERROR D111 FIELDFIT(): missing field name")
endif
if type(cFldname)="N"
   cFldname := fieldname(cFldname)
endif
xType  := fieldcont(cFldname)
cType  := vtype(cFldname)
do case
case cType = "N"
   xCargo := val(xCargo)
case cType = "C"
   xCargo := alltrim(xCargo)
case cType = "D"
   xCargo := ctod(xCargo)
case cType = "L"
   xCargo := upper(xCargo)
    if (xCargo="S" .or. xCargo="1" .or. xCargo="Y")
       xCargo :=.t.
    else
       xCargo := .F.
    endif
case cType = "M"
   xCargo := alltrim(xCargo)
endcase
return xCargo


***********************
function CloneRec(nRec)
***********************
local cVal,nFlds,iii,aCargo,nNewRec
//-- record to be duplicated
go nRec

//-- loading values into an array
cVal := ""
nFlds := afields()
declare aCargo[nFlds,2]
for iii=1 to nFlds
   aCargo[iii,1] := fieldname(iii)
   aCargo[iii,2] := fieldval(iii)
next

//-- creating the new record
append blank
nNewRec := recno()
if rlock()
   for iii=1 to len(aCargo)
      cFxx := aCargo[iii,1]
      repl &cFxx with aCargo[iii,2]
   next
   unlock
endif
return nNewRec

*-------------------------------------------------------------------------------
function fieldfitter(cFldname, xCargo)
*-------------------------------------------------------------------------------
//-- riceve una stringa *xCargo* e restituisce un tipo di valore adatto
//   ad essere salvato nel campo *cFldname* 
//   Il campo deve esistere nella tabella attualmente aperta
//
if empty(cFldName) or empty(xCargo)
   return ""
else
   xType  := fieldcont(cFldname)
   cType  := vtype(cFldname)
   do case
   case cType = "N"
      xCargo := val(xCargo)
   case cType = "C"
      xCargo := alltrim(xCargo)
   case cType = "D"
      xCargo := ctod(xCargo)
   case cType = "L"
      xCargo := upper(xCargo)
       if (xCargo="S" .or. xCargo="1" .or. xCargo="Y")
          xCargo :=.t.
       else
          xCargo := .F.
       endif
   case cType = "M"
      xCargo := alltrim(xCargo)
   endcase
endif
return xCargo

***********************************
function pageCount( nRecs, nPgRows)
***********************************
//-- pages required to display all rows of a table
local nOut
nOut := nRecs/nPgRows + iif(mod(nRecs,nPgRows)>0,1,0)
return nOut

************************
function getDbSet(cPath)
************************
//-- extracts the DBSET vaue from a fully qualified path and filename
local cOut, c1, c2
*-- getting path
cOut := ""
c1 := filepath(cPath)
c2 := MspConfigVar("DATADIR")
cOut:= strTran(c1,c2,"")
return strTran(cOut,"\","")

$extended

*-------------------------------------------------------------------------------
function fieldNum(cStr)
*-------------------------------------------------------------------------------
//-- ritorna la posizione di un campo fornendo il nome
//   Uso: nPos := fieldNum(cFldName)
//
local ttt,mmm,aaa
ttt := aFields(aaa)
mmm := ascan(aaa,cStr)
return mmm

*-------------------------------------------------------------------------------
function fieldList(xVal)
*-------------------------------------------------------------------------------
//-- se si passa un array come parametro lo riempie con i nomi dei campi
//   e restituisce il numero di campi esistenti
//   altrimenti restituisce una stringa con i nomi separati da virgole
//   Uso: 
//   ainit("myArray","")
//   fieldlist(myArray)
//
local xFldLst,iii
if type(xVal)="A"
   nnn := aFields(xVal)
   return nnn
else
   cOut :=""
   nnn := aFields(xFldLst)
   for iii=1 to nnn
       cOut += zz(xFldLst[iii]) +","
   next
   if right(cOut,1)=","
      cOut := trimRight(cOut,1)
   endif
endif
return cOut


***************************
function setdbtype( cType)
***************************
//-- da usare al posto del comando omonimo per evitare
//   errori quando si passa una stringa vuota (che il comando
//   infatti non accetta)
//   Accetta anche i tipi MAX DBFREE e DBMAX
if not type(cType)="U"
   if not empty(cType)
      if upper(cType) $ "MAX DBFREE DBMAX"
         set dbtype to
      else      
         set dbtype to (cType)
      endif
   else
      set dbtype to
   endif
endif
return dbtype()



*--eof

