**************************************************************
**
**  DBMAX->DBFREE 2.0 - HTML EDIT/SAVE HANDLING LIBRARY
**
**  Progetto iniziato a Prato il 10 ago 2010
**
**  vers. 0.0.2 - Prato 29 set 2010
**  vers. 0.0.3 - Prato 02 ott 2010
**  vers. 0.0.4 - Prato 19 ott 2010
**
**************************************************************
********************************************


#define CR_LF chr(13)+chr(10)

*-------------------------------------------------------------------------------
function printIni()
*-------------------------------------------------------------------------------
//-- visualizza in HTML il contenuto di un file ini
local rrr,nPos1,nPos2,cStr,rrr

// CR_LF := chr(13)+chr(10)
*
rrr :=0
nPos1  := 1
do while rrr < 100
   rrr++
   nPos2  := at(CR_LF,cStr)
   if nPos2 = 0
      exit
   endif
   ? str(rrr,4,0,"0") + ":" + subs(cStr,1,nPos2) + "(" + str(nPos2,3) + ")"
   nPos1  := nPos2     
   cStr := subs(cStr,nPos2+1)
enddo
return

*-------------------------------------------------------------------------------
function raiseError(cDb,cProc)
*-------------------------------------------------------------------------------
local cTxt
iif(type(cDb)="U","sconosciuta",cDb)
cTxt := {{<font color="red"><b>ERROR IN PROGRAM LOGIC</b></font><br> Table is not accessible:<br>
Contact the tech support and report this message<font color="red">}}
cTxt += " Support request type[ Maintenance ]"
cTxt += " Table missing or locked ["+ cDb +"]"
cTxt += " Offending procedure [" + cProc + "]</font>"       
return cTxt




*-------------------------------------------------------------------------------
function htm_tHead(aaa)
*-------------------------------------------------------------------------------
local nnn,cOut
nnn := aLen(aaa)
cOut := "<tr>"
for iii = 1 to nnn
   cOut += '<td class="t_head">' + fchar(aaa[iii]) + '</td>'
next
cOut += '</tr>'
return cOut


*-------------------------------------------------------------------------------
function htm_tRow(aaa)
*-------------------------------------------------------------------------------
local nnn, cOut
nnn := aLen(aaa)
cOut := '<tr>'
for iii = 1 to nnn
   cOut+= '<td class="t_row">' + fchar(aaa[iii]) + '</td>'
next
cOut+= '</tr>'
return cOut


*-------------------------------------------------------------------------------
function htm_tCell(cStr)
*-------------------------------------------------------------------------------
local nnn,cOut
cOut := '<td class="t_cell">' + zz(cStr) + '</td>'
return cOut

*-------------------------------------------------------------------------------
function htm_table()
*-------------------------------------------------------------------------------
local cOut
if pcount() = 0
   cOut := '<table class="t_tbl" border="1" cellspacing="1" bgcolor="#EAEAEA">'
else
   cOut := '</table>'
endif
return cOut
//-------------------------------------
function optByDb(cTab,cFld)
//-------------------------------------
//-- popola le option di una select usando un DB come fonte
//   la tabella deve essere sul percorso dati corrente
//   Ese. <%=optByDb("GNX_UTENTI","USR_NAME")%>
//
local cOut
cOut :=""
use (cTab) alias FONTE new
if not used()
   return "<option>ERRORE:" + cTab +"</option>"
endif
go top
do while ! eof()
   cOut += "<option>"+fieldcont(cFld)+"</option>"
   skip
enddo
close FONTE
return cOut


*-------------------------------------------------------------------------------
function displayRecord(nRec, nStyle)
*-------------------------------------------------------------------------------
//-- AUTOMATICALLY DISPLAY A READ-ONLY FORM TAKING FIELDS FROM CURRENT RECORD
//-- retrieving the total fields of current record
//  parameters:
//              Record number to go to
//              nStyle to apply 0=clean 1=row num 2=show type 3=type and size
//  Usage: < %=displayRecord(recno(),1)% >
//
if pcount()=1
   nStyle :=1
endif
cOutRecTab := ""
cRecSize   := "10"

if nRec >0 and nRec <= lastrec()
   nFields := fcount()

   //-- building a table to host all the fields and their values
   cOutRecTab += [<table border="0" cellspacing="0" bgcolor="#C0C0C0" width="100%">] + CR_LF
   
   if nStyle=0
      cOutRecTab +=  [<tr><th>Field</th><th>Fieldname</th><th>Input value</th></tr>] + CR_LF
   endif
   
   for iii = 1 to nFields
      cLabel := fieldname(iii)
      mVal   := fieldcont(fieldname(iii))
      do case
      case type(mVal) = "M"
         mVal  := alltrim(mVal)
         cTyp  := "Memo"
         cRecSize := "1000"
      case type(mVal) = "C"
         mVal  := alltrim(mVal)
         cTyp  := "Char "
         cRecSize := wstr(len(mVal))
      case type(mVal) = "N"
         mVal := ltrim(str(mVal))
         cTyp  := "Num "
      case type(mVal) = "L"
         mVal := iif(mVal,"Y","N")
         cTyp  := "Bool"
         cRecSize := "1"
      case type(mVal) = "D"
         mVal := dtoc(mVal)
         cTyp  := "Day "
         cRecSize := "12"
      endcase
      
      cOutRecTab +=  [<tr>]  + CR_LF
      if nStyle=0
         cOutRecTab +=  [<td>] + ltrim(str(iii)) + [</td>] + CR_LF
         cOutRecTab +=  [<td align="right">] + capital(cLabel) + [&nbsp;</td>] + CR_LF
      endif
      do case
      case nStyle=1
         cOutRecTab +=  [<td align="right">] + capital(cLabel) + [&nbsp;</td>] + CR_LF
      case nStyle=1
         cOutRecTab +=  [<td align="right">] + capital(cLabel) + [&nbsp;(] + cTyp + [)</td>] + CR_LF
      case nStyle>=2
         cOutRecTab +=  [<td align="right">] + capital(cLabel) + [&nbsp;(] + cTyp + [) ] + cRecSize +[&nbsp;</td>] + CR_LF
      otherwise
         cOutRecTab +=  [<td align="right">] + capital(cLabel) + [&nbsp;</td>] + CR_LF
      endcase
      
      if val(cRecSize) > 128
         cOutRecTab += [<td><textarea readonly style="width:100%" rows="5">] + MSPdecode(mVal) + [</textarea] + CR_LF
      else
         cOutRecTab +=  [<td align="left"><input readonly]
         cOutRecTab +=  [ size="] + cRecSize + [" type="text" name="EF_] + fchar(cLabel) + [" value="] + MSPDecode(mVal) + [" style="color:gray"></td>] + CR_LF
      endif
      
      cOutRecTab +=  [</tr>]  + CR_LF
   next
   cOutRecTab += [</table>]  + CR_LF
endif
return cOutRecTab


*-------------------------------------------------------------------------------
function editRecord( cUrl, aFieldsToDisplay)
*-------------------------------------------------------------------------------
//-- AUTOMATICALLY PRODUCE A FORM TAKING FIELDS FROM CURRENT RECORD
//   cUrl: the target file to call submitting the form (defalt self)
//   aFieldsToDisplay: array of fields to display (default all)
//
local nFields, cOut, aArr
if pcount()=0
   cUrl := "" //-- DISPLAY ONLY
endif

cOut := ""
cOut += [<form name="form_] + zz(recno()) + [" action="] + cUrl + ["  method="post" class="webform">]  + CR_LF

//-- if passed 2 parameters the second is the array containing field names to display
//   so we parse this array and build a form field for each element
//
if pcount()=2
   if type(aFieldsToDisplay)="A"
      if len(aFieldsToDisplay) > 0
         for nnn = 1 to len(aFieldsToDisplay)
             if aFieldsToDisplay[nnn,1] <> "PB" .and. .not. empty(aFieldsToDisplay[nnn,2])
                if upper(aFieldsToDisplay[nnn,1]) <> "VAR_ACTION"
                   cOut += '<input type="hidden" name="' + aFieldsToDisplay[nnn,1]+'" value="' + aFieldsToDisplay[nnn,2]+ '">'  + CR_LF
                endif
             endif
         next
      endif
   endif
endif

//-- retrieving the total fields of current record
nFields := fcount()

//-- building a table to host all the fields and their values
cOut += [<table border="0" cellspacing="0" bgcolor="#C0C0C0" class="t_tbl">] + CR_LF
if pcount()>0
   cOut += [<tr><td colspan="2"class="t_row1" nowrap>Record ]+zz(recno())+[/]+zz(lastrec())+[</td><td class="t_row1" align="right"><input type="submit" name="PB_OK1" value="Save changes"></td></tr>] + CR_LF
endif
cOut +=  [<tr><td class="t_head" align="left" width="2%">Field</td><td class="t_head" align="right">Fieldname/</td><td class="t_head" align="left">Input value</td></tr>] + CR_LF
for iii = 1 to nFields
   cLabel := fieldname(iii)
   mVal   := fieldcont(fieldname(iii))
   cTyp   := fieldtype(iii)
   do case
   case (cTyp = "C" .or. cTyp = "M")
      mVal := alltrim(mVal)
   case cTyp = "N"
      mVal := ltrim(str(mVal))
   case cTyp = "L"
      mVal := iif(mVal,"Y","N")
   endcase
   cOut +=  [<tr>]  + CR_LF
   cOut +=  [<td class="t_head" width="2%" align="center">] + ltrim(str(iii)) + [</td>] + CR_LF
   cOut +=  [<td class="t_cell" align="right">] + capital(cLabel) + [&nbsp;</td>] + CR_LF
   if cTyp = "M"
      cOut +=  [<td class="t_cell" align="left"><div class="example"><textarea style="width:100%;" rows="10" name="EF_] + fchar(cLabel) + [">] + mVal + [</textarea></div></td>] + CR_LF
   else
      cOut +=  [<td class="t_cell" align="left"><input type="text" size="]+fieldsize(iii)+[" name="EF_] + fchar(cLabel) + [" value="] + fchar(mVal) + ["></td>] + CR_LF
   endif
   cOut +=  [</tr>]  + CR_LF
next
cOut += [</table>]  + CR_LF

//-- if parameters were passed we made up a form to submit, so we need to put some button on it
//   adding addictional parameters as well
//
if pcount()>0
   cOut += [<input type="hidden" name="VAR_ACTION" value="SAVE">]+CR_LF
   cOut += [<input type="hidden" name="VAR_RECNO" value="] + wstr(recno()) + [">]+CR_LF
   cOut += [<input type="submit" name="PB_OK2" value="Save Changes">]+CR_LF
endif

if type(aVars)="U"
   cOut += "<!--- aVars not passed! //-->" + CR_LF
else
   for iii=1 to len(aVars)
     if aVars[iii,1] $ "VAR_ACTION VAR_RECNO PB_OK1 PB_OK2"
        cOut += "<!--- webVar " + aVars[iii,1] + " skipped //-->" + CR_LF
     else
        cOut += [<input type="hidden" name="]+aVars[iii,1]+[" value="]+aVars[iii,2]+[">]+CR_LF
     endif
   next
endif

cOut += [</form>]  + CR_LF         
cOut += "<!------------------- end auto generation of edit form //--------------->" +CR_LF

return cOut

*-------------------------------------------------------------------------------
function saveRecord(nRec, aWebVarList )
*-------------------------------------------------------------------------------
//-- si deve passare come array aWebVarList (che sarebbe aVars)
//   l'array è in realta una matrice quadrata con la prima colonna contente MSPFieldName
//   e la seconda MSPFieldValue
//
if pcount()<2
   ? "LIBRARY ERROR - saveRecord requires 2 parameters: 1=nRec, 2=aVars (array of webvars)"
endif
if type(nRec)<>"N"
   nRec := val(nRec)
endif
if nRec > 0
   go nRec

   //--- we build an array of two fields (columns) to store temp values
   declare aValues[2,1]
 
   //-- now we loop into incoming variables (e.g. the fields of the previous form)
   //   and consider only those starting with prefix EF_ (entryfield) like those
   //   we wisely named that way to identify them
   nnn :=1
   for iii= 1 to len(aWebVarList)
      if aWebVarList[iii,1] = "EF_"
         //-- this is for debug: shows the incoming vars
         *? str(nnn) + aWebVarList[iii,1] html
         //-- we fill the array
         aRedim(aValues[2],nnn)
         cFld := strTran(aWebVarList[iii,1],"EF_","")
         mVal := aWebVarList[iii,2]
         aValues[1,nnn] := cFld
         aValues[2,nnn] := mVal
         nnn++
      endif
   next

   //-- now that we collected changed values from the form we write them in the record
   //   in the same exact order we retrieved them when we built the form  
   if rlock(2)
      for iii = 1 to len(aValues[2])
         cFld  := aValues[1,iii]
         mVal  := aValues[2,iii]
         if not empty(mVal)
            cOldCont := fieldcont(cFld)
            cType := type(cOldCont)
            *? "REPLACING ["+cFld +"] WITH [" +mVal + "] FIELDTYPE ["+ cType +"]"
            do case
            case cType = "N"
               mVal := val(mVal)
            case cType = "D"
               mVal := ctod(mVal)
            case cType = "L"
               mTmp := zz(mVal)
               if mTmp $ "YSJO"
                  mVal :=.t.
               elseif mTmp $ "N"
                  mVal :=.f.
               endif
            endcase
            repl &cFld with mVal
         endif
      next
      unlock
      cAction := "EDIT"
      cMsg    := "SAVED!"
   else
      ? "ERROR: could not lock record " + str(nRec) html
   endif
else
   ? "ERROR: di not receive the number of the record to go to" html
endif
return

*-------------------------------------------------------------------------------
function showMaster(aCampi)
*-------------------------------------------------------------------------------
local cOut,nFields,iii
cOut := ""
nFields := fcount()

if pcount()=0 or not type(aCampi)="A"
   declare aCampi[nFields]
   for iii=1 to nFields
      aCampi[iii] := iii
   next
endif

cOut += [<table border="1" cellspacing="0">] + CR_LF
//-- intestazione riga
cOut +=  [<tr><td bgcolor="orange" colspan=] + wstr(nFields) + [>Record N.] + wstr(recno()) + [</td></tr>]  + CR_LF
cOut +=  [<tr>]  + CR_LF
for iii = 1 to aLen(aCampi)
   cLabel := fieldname(aCampi[iii]) + " (" + wstr(aCampi[iii]) + ")"   
   cOut +=  [<td bgcolor="C0C0C0"><font size="1"><i>] + cLabel + [</i></font></td>] + CR_LF
next
cOut +=  [</tr><tr>]  + CR_LF

//-- riga con i campi
for iii = 1 to aLen(aCampi)
   mVal   := fieldcont(fieldname(aCampi[iii]))
   if type(mVal) = "C" .or. type(mVal) = "M"
      mVal := alltrim(mVal)
   elseif type(mVal) = "N"
      mVal := ltrim(str(mVal))
   elseif type(mVal) = "L"
      mVal := iif(mVal,"S","N")
   endif
   cOut +=  [<td align="left"><input type="text" name="EF_] + fchar(cLabel) + [" value="] + fchar(mVal) + ["></td>] + CR_LF
next

cOut +=  [</tr>]  + CR_LF
cOut += [</table>]  + CR_LF
return cOut


*-------------------------------------------------------------------------------
function showSlave(aCampi)
*-------------------------------------------------------------------------------
local cOut,nFields,iii
cOut := ""
nFields := fcount()

if pcount()=0 or not type(aCampi)="A"
   declare aCampi[nFields]
   for iii=1 to nFields
      aCampi[iii] := iii
   next
endif
cOut += [<table border="1" cellspacing="0">] + CR_LF
//-- riga del record con tutti i campi
for iii = 1 to alen(aCampi)
   cLabel := fieldname(aCampi[iii]) + " (" + wstr(aCampi[iii]) + ")" 
   mVal   := fieldcont(fieldname(aCampi[iii]))
   if type(mVal) = "C" .or. type(mVal) = "M"
      mVal := alltrim(mVal)
   elseif type(mVal) = "N"
      mVal := ltrim(str(mVal))
   elseif type(mVal) = "L"
      mVal := iif(mVal,"S","N")
   endif
   cOut += [<tr>]
   cOut += [<td align="right" bgcolor="C0C0C0"><font size="1"><i>] + fchar(cLabel) + [</i></font></td>]
   cOut += [<td align="left"><input type="text" name="EF_] + fchar(cLabel) + [" value="] + fchar(mVal) + ["></td>] + CR_LF
   cOut += [</tr>]
next
cOut += [</table>]  + CR_LF
return cOut

*--eof
