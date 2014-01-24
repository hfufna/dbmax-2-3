**************************************************************
**
**  DBMAX->DBFREE 2.0 - DBF HANDLING LIBRARY
**
**  Progetto iniziato a Prato il 10 ago 2010
**
**  vers. 0.0.2 - Prato 29 set 2010
**  vers. 0.0.3 - Prato 02 ott 2010
**  vers. 0.0.4 - Prato 21 dic 2010
**
**************************************************************

#define CR_LF chr(13)+chr(10)

*-------------------------------------------------------------------------------
function ftype(fieldNum)
*-------------------------------------------------------------------------------
cTxt := type(fieldname(fieldNum))
return cTxt

*-------------------------------------------------------------------------------
function fieldType(fldNameorNum)
*-------------------------------------------------------------------------------
local mVal
if type(fldNameorNum) ="C"
   cTxt :=  type(fldNameorNum)
elseif type(fldNameorNum) ="N"
   cTxt := type(fieldname(fldNameorNum))
endif
return cTxt

*-------------------------------------------------------------------------------
function fieldlen(cField)
*-------------------------------------------------------------------------------
xVal := fchar(fieldcont(cField))
return str(len(xVal),3,0)

*-------------------------------------------------------------------------------
function fieldsize(fldNameorNum)
*-------------------------------------------------------------------------------
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
function fsize(nField)
*-------------------------------------------------------------------------------
xVal := fchar(fieldname(nField))
return str(len(xVal),3,0)

*-------------------------------------------------------------------------------
function fieldval(nFld)
*-------------------------------------------------------------------------------
return fieldcont(fieldname(nFld))


*-------------------------------------------------------------------------------
function fieldcount()
*-------------------------------------------------------------------------------
return fcount()



*-------------------------------------------------------------------------------
function fieldfit(cFldname, xCargo)
*-------------------------------------------------------------------------------
//-- riceve una stringa *xCargo* e restituisce un tipo di valore adatto
//   ad essere salvato nel campo *cFldname* 
//   Il campo deve esistere nella tabella attualmente aperta
//
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

*-------------------------------------------------------------------------------
function dir( cLink )
*-------------------------------------------------------------------------------
//-- se passato cLink e contiene | viene sostituito con il filename della tabella
* Esempio:
* cLnk := "/apps/assistant/browse-edit.msp?VAR_TABLE=|"
* <%=dir(cLnk)%>
*
*
*
*


local nFiles,aList,iii,cOut
if pcount()=0
   cLink := ""
endif
cOut := ""
nFiles := mdir( cDbPath + "*.dbf", aList )
if nFiles > 0
cOut := '<table class="dir_tb">'
cOut += '<tr><td>Table</td><td>Kb</td><td colspan="3">last modified</td></tr>'
   for iii=1 to nFiles
      cOut += '<tr class="dir_tr">'
      if empty(cLink)
         cOut += '<td class="dir_td"><b>' + capital(filebone(aList[1,iii])) + '</b></td>'
      else
         cLink := strTran(cLink,"|",lower(aList[1,iii]))
         cOut += '<td class="dir_td">' + '<a href="' + cLink + '">' + filebone(aList[1,iii]) + '</a></td>'      
      endif
      cOut += '<td class="dir_td" align="right">' + str(aList[2,iii]/1024,8,2) + '</td>'
      cOut += '<td class="dir_td" align="right">' + dmy(aList[3,iii]) + '</td>'
      cOut += '<td class="dir_td">' + aList[4,iii] + '</td>'
      cOut += '</tr>'
   next
cOut += '</table>'
endif
return cOut


*--eof

