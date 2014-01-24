**************************************************************
**  
**************************************************************
**  DBMAX 2.5 - LIBRARY MODULE (derived from DBFree 3.0.1)
**  (c) by G.Napolitano
**
**  Project start: Prato 4 ott 2013
**  vers. 0.0.1 - Prato 05 ott 2013
**  vers. 0.0.2 - Prato 23 Dic 2013 (saveRecord)
**************************************************************
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



//-------------------------------------
function optByDb(cTab,cFld)
//-------------------------------------
//-- popola le option di una select usando un DB come fonte
//   la tabella deve essere sul percorso dati corrente
//   Ese. <%=optByDb("GNX_UTENTI","USR_NAME")%>
//
local cOut
cOut :=""
use (cTab) in 0 alias THISDB
if not used()
   return "<option>ERRORE:" + cTab +"</option>"
endif
go top
do while ! eof()
   cOut += "<option>"+fieldcont(cFld)+"</option>"
   skip
enddo
close THISDB
return cOut


*-------------------------------------------------------------------------------
function displayRecord(nRec, nStyle)
*-------------------------------------------------------------------------------
//-- AUTOMATICALLY DISPLAY A READ-ONLY FORM TAKING FIELDS FROM CURRENT RECORD
//-- retrieving the total fields of current record
//  parameters:
//              Record number to go to
//              nStyle to apply 0=clean 1=row num 2=show type 3=type and size
//  Usage: < % =displayRecord(recno(),1) % >
//
if type(nRec) = "C"
   nRec := val(nRec)
endif
if pcount()=1
   nStyle :=1
endif

if not used()
   return("ERROR: NO DATABASE OPEN")
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
      mVal   := fieldcont(cLabel)
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
cOut += [<form name="form_] + zz(recno()) + [" action="] + zz(cUrl) + ["  method="post" class="webform">]  + CR_LF

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
cOut += [<table class="t_tbl">] + CR_LF
if pcount()>0
   cOut += [<tr><td colspan="2"class="t_row1" nowrap>]+"<b>"+ dbf() +"</b> [Rec."+zz(recno())+" of "+zz(lastrec())+"]"+[</td><td class="t_row1" align="right"><input type="submit" name="PB_OK1" value="Save changes"></td></tr>] + CR_LF
endif
cOut +=  [<tr><td class="t_head" align="left" width="2%">Field</td><td class="t_head" align="right">Fieldname/</td><td class="t_head" align="left">Input value</td></tr>] + CR_LF
for iii = 1 to nFields
   cLabel := fieldname(iii)
   mVal   := fieldcont(fieldname(iii))
   cTyp   := type(fieldname(iii)) // fieldtype(iii)
   do case
   case (cTyp = "C" .or. cTyp = "M")
      mVal := zz(mVal)
   case cTyp = "N"
      mVal := zz(mVal)
   case cTyp = "L"
      mVal := iif(mVal,"Y","N")
   endcase
   cOut +=  [<tr>]  + CR_LF
   cOut +=  [<td class="t_head" width="2%" align="center">] + ltrim(str(iii)) + [</td>] + CR_LF
   cOut +=  [<td class="t_cell" align="right">] + capital(cLabel) + " (" + cTyp + ")" + [&nbsp;</td>] + CR_LF
   if cTyp = "M"
      cOut +=  [<td class="t_cell" align="left"><div class="example"><textarea style="width:100%;" rows="5" name="EF_] + fchar(cLabel) + [">] + mVal + [</textarea></div></td>] + CR_LF
   else
      cOut +=  [<td class="t_cell" align="left"><input type="text" size="]+fieldsize(iii)+[" name="EF_] + fchar(cLabel) + [" value="] + zz(mVal) + ["></td>] + CR_LF
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
return cOut

*-------------------------------------------------------------------------------
function saveRecord(nRec, aWebVarList )
*-------------------------------------------------------------------------------
//-- si deve passare come array aWebVarList (che sarebbe aVars)
//   l'array è in realta una matrice quadrata con la prima colonna contente MSPFieldName
//   e la seconda MSPFieldValue
//
local cMsg,iii,nnn, cType, mVal
cMsg :=""
if pcount()<2
   ? "ERROR - [saveRecord()] requires 2 parameters: 1=nRec, 2=aVars (array of webvars)"+CR_LF
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
         *if not empty(mVal)
            cOldCont := fieldcont(cFld)
            cType := type(cOldCont)
            cMsg := "REPLACING ["+cFld +"] WITH [" +mVal + "] FIELDTYPE ["+ cType +"]"
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
            case cType = "U"
               mVal := "" 
            endcase
            repl &cFld with mVal
         *endif
      next
      unlock
      cAction := "EDIT"
      cMsg    := "RECORD " + zz(nRec) + " SAVED!"
   else
      cMsg := "ERROR: could not lock record " + str(nRec)
   endif
else
   cMsg := "ERROR: di not receive the number of the record to go to"
endif
return cMsg


*-------------------------------------------------------------------------------
function showMaster(aOfFlds)
*-------------------------------------------------------------------------------
//-- show master record
//
local cOut,nFields,iii
cOut := ""
nFields := fcount()

if pcount()=0 or not type(aOfFlds)="A"
   declare aOfFlds[nFields]
   for iii=1 to nFields
      aOfFlds[iii] := iii
   next
endif

cOut += [<table border="1" cellspacing="0">] + CR_LF
//-- intestazione riga
cOut +=  [<tr><td bgcolor="orange" colspan=] + wstr(nFields) + [>Record N.] + wstr(recno()) + [</td></tr>]  + CR_LF
cOut +=  [<tr>]  + CR_LF
for iii = 1 to aLen(aOfFlds)
   cLabel := fieldname(aOfFlds[iii]) + " (" + wstr(aOfFlds[iii]) + ")"   
   cOut +=  [<td bgcolor="C0C0C0"><font size="1"><i>] + cLabel + [</i></font></td>] + CR_LF
next
cOut +=  [</tr><tr>]  + CR_LF

//-- riga con i campi
for iii = 1 to aLen(aOfFlds)
   mVal   := fieldcont(fieldname(aOfFlds[iii]))
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
function showSlave(aOfFlds)
*-------------------------------------------------------------------------------
//-- show slave record
//
local cOut,nFields,iii
cOut := ""
nFields := fcount()

if pcount()=0 or not type(aOfFlds)="A"
   declare aOfFlds[nFields]
   for iii=1 to nFields
      aOfFlds[iii] := iii
   next
endif
cOut += [<table border="1" cellspacing="0">] + CR_LF
//-- riga del record con tutti i campi
for iii = 1 to alen(aOfFlds)
   cLabel := fieldname(aOfFlds[iii]) + " (" + wstr(aOfFlds[iii]) + ")" 
   mVal   := fieldcont(fieldname(aOfFlds[iii]))
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

******************************************
function CloneRecord(nRec)
******************************************
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

*************************************************
function hyperlink(cUrl,cDescr, cTarget)
*************************************************
//-- returns a string to be used in the HTML part of the page as link
local cOut
if type(cDescr)="U"
   cDescr := cUrl
endif
if type(cTarget)="U".or.empty(cTarget)
   cTarget := "_self"
endif
cOut := '<a href="' + alltrim(cUrl) + '" title="' + cUrl+ '" target="' + cTarget + '">' + cDescr + '</a>'
return cOut


***********************************************
function inputRadio(cName, cValue, varToMatch)
***********************************************
// cName  --> NAME OF THE WEBVAR TO BE CREATED FOR THIS BUTTON
// cValue --> THE VALUE TO RETURN IF THE BUTTON IS SELECTED
// varToMatch --> THE LOCAL VAR TO USE AS CHECKOUT FO BUTTON

local cOut := ""
cOut := [<input type="radio" ]
if type(varToMatch)<>"U"
   if varToMatch = cValue
      cOut += "checked "
   endif
   endif
cOut += [name="]+ cName+[" value="] + cValue + [">]
return cOut

*************************
function strSafe(strText)
*************************
//-- returns safe code for preloading in the RTE
local tmpString

tmpString := alltrim(strText)

//-- convert all types of single quotes
tmpString := strTran(tmpString, chr(145), chr(39))
tmpString := strTran(tmpString, chr(146), chr(39))
tmpString := strTran(tmpString, "'", "&#39;")

//-- convert all types of double quotes
tmpString := strTran(tmpString, chr(147), chr(34))
tmpString := strTran(tmpString, chr(148), chr(34))
tmpString := strTran(tmpString, '""', '\""')

//-- replace carriage returns & line feeds
tmpString := strTran(tmpString, chr(10), " ")
tmpString := strTran(tmpString, chr(13), " ")

return(tmpString)

***********************************
function linkit(cUrl,cLabel,cTarg)
***********************************
//-- produces a link from a field (function to be used in commands)
//
// Usage:
// cLink := "customers.msp?VAR_FILTER="
// use countries
// list off iif(empty(CODE),"...",CODE), linkit( cLink+CODE, COUNTRY, "frm2")
//
local cOut :=""
if type(cLabel)="U"
   cLabel := "Click here"
endif
if type(cTarg)="U"
   cTarg := "_self"
endif
cOut += '<a target="' + cTarg + '" a href="' + cUrl + '">'
cOut += cLabel + '</a>'
return cOut

********************************
function setStyle(cStyle)
********************************
//-- sets the styles for bootstrap use
//   no parameters=default.css, 0=bootstrap, 1=bootstrap-theme
//   2=theme, 3=takes the name from CSS entry in mspconfig file
//
local cOut := ""
do case
case type(cStyle)="U"
   cOut :="/css/default.css"
case cStyle=0
   cOut :="/bootstrap/css/bootstrap.min.css"
case cStyle=1
   cOut :="/bootstrap/css/bootstrap-theme.min.css"
case cStyle=2
   cOut :="/css/theme.css"
case cStyle=3
   cOut := MspCfgVar("CSS")
endcase
return [<link rel="stylesheet"  type="text/css" href="]+cOut+[">]


************************************************
function link2menu( cDir, cChoiches, xDebug )
************************************************
//-- returns a link from a list of possibilities in the given directory
//   by default looks into current directory, passing a zero looks in 
//   upper one
//   If an alternative list is passed this must be in form of a string
//   with filenames (incl. extension) separated by asterisks
//
local iii, cLink, cFile, cPath, cMsg, nnn, cTyp


cPath := upDir(curDosDir())
cTyp := type(cDir)
do case
case cTyp="C"
   if left(cDir,1)="/"
      cPath := webroot()+cDir
   else
      cPath := cDir
   endif
case cTyp="N"
   cPath := upDir(curDosDir())
otherwise
   cPath := curDosDir()
endcase

cPath := fixslash(cPath)
if type(cDir)<>"C"
   cDir := "#ERROR: use link2app() instead"
endif
if not isDir(cPath)
   cPath := curDosDir()+cDir
endif

if type(cChoiches)="U"
   ainit("aChances","login.msp","booter.msp","index_full.msp","index_mix.msp","index_compact.msp","index_apps.msp","index_files.msp","index_imgs.msp","index_test.msp","index_tools.msp","index.msp","console.msp","start.msp","home.msp")
else
   declare aChances[1]
   strToArr(aChances,"*",cChoiches)
endif

if not isdir(cPath)
   cLink := "#NOFOLDER--" + cPath
endif
cMsg  := ""
cFile := ""
nnn   := len(aChances)
cLink := "#DEBUG-looking into <" + cPath + "> for " + zz(nnn) + " choices" 
for iii=1 to nnn
   cFile := cPath | aChances[iii]
   if (dos2web(cFile) = pagename())
      cLink := "#RECURS-{" + pagename() + "}--"
   else
      if file(cFile)
         cMsg += "[**"+cPath + aChances[iii]+"**]"
         cLink := dos2web(cFile) 
         exit
      else
         cMsg += "[" | cPath | aChances[iii] | "]"
      endif
   endif
next
if not type(xDebug)="U"
   return cMsg
endif
return cLink

**********************************
function link2app( cDir, xDebug )
**********************************
local iii, cLink, cFile, cPath, cMsg, nnn, cTyp

if not type(cDir)="U"
   do case
   case left(cDir,1)="/"
      cPath := webroot() + cDir
   case left(cDir,1)="1"
      cPath := curDosDir() + cDir
   otherwise
      cPath := cDir
   endcase
else
   cPath := curDosDir()
endif
cPath := fixslash(cPath)
if not isDir(cPath)
   return( "#ERROR:NO SUCH FOLDER--" + cPath )
endif

ainit("aChances","booter.msp","start.msp","go.msp","index.msp")
nnn   := len(aChances)

cLink := "#" 
cMsg  := "DEBUG-looking into <" + cPath + "> for " + zz(nnn) + " file names"
cFile := ""
for iii=1 to nnn
   cFile := cPath + "\" + aChances[iii]
   if (dos2web(cFile) = pagename())
      cMsg  := "ERROR:RECURSIVE-{" + pagename() + "}--"
   else
      if file(cFile)
         cMsg := cLink := dos2web(cFile) 
         exit
      else
         cMsg += "CHK[" + cFile + "]"
      endif
   endif
next
if not type(xDebug)="U"
   clink := "javascript:alert('"+ escape(cMsg) +"');"
endif
return cLink

*--eof
