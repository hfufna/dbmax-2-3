*************************************************************************
* DBFree Library for cross-server programming 
*   version 0.0.2  Prato 30/08/2011   
*   version 0.0.3  Menton 11/09/2011 
*   version 0.0.5  Prato  26/09/2011 bug fix
*   version 0.0.6  Prato  06/10/2011
*   version 0.0.61 Prato 03/01/2012 mod. strings
*   version 0.0.62 Prato 25/01/2012 (strings)
*   version 0.0.7  Prato 21 Apr 2012  addedd lib-mem
*
* TELECOMANDE1 LIBRARY      
*   version 0.0.1  Vada 8 Agosto 2012    
*
**  compile with MAXCOMPILER dbmax -m  -msp
*************************************************
#define CR_LF chr(13)+chr(10)
set proc to lib-strings, lib-dates, lib-dbf, lib-files, lib-html, lib-sessions, lib-arrays, lib-mem, extended
public  xSessFile, xSessDir, xWebRoot

*-------------------------------------------------------------------------------
function libVer()
*-------------------------------------------------------------------------------
return "TELECOMANDE LIB 0.0.1 (c)2012 G.Napolitano Build 2012-08-08"


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
   return "<b>ATTENTION</b>:Clipper Extensions are NOT ENABLED with this configuration of DBFree!"
endif

*********************
function enableFox()
*********************
cFile := MspConfigVar("MSPDIR")+"\MSPCBOXBC-CDX.dll"
if not file(cFile)
   return "<b>ATTENTION</b>:FoxPro Extensions are NOT ENABLED with this configuration of DBFree!"
endif

*********************
function enableDbase()
*********************
cFile := MspConfigVar("MSPDIR")+"\MSPCBOXBC-MDX.dll"
if not file(cFile)
   return "<b>ATTENTION</b>:dBase Multiple Indexes and DBF level 5 are NOT ENABLED with this configuration of DBFree!"
endif

*****************************
function openSlot(cFile)
*****************************
if pcount()=0 .or. empty(cFile)
   cFile:= "c:\dbfree\bin\mspserver.ctl"
endif
return freeslot(cFile)

*****************************
function Slot(xVal)
*****************************
*  ERROR CODES
*  0=ok
*  1=could not open
*  2=write error (less than 72 bytes)
*  4=wrong filename in wrapper
*
//-- usage: Slot(1) - Slot(0) - or pass filename
//
if pcount()=0 .or. type(xVal)<>"C"
   cFile:= curdrive() + "\dbfree\bin\mspserver.ctl"
endif
if not "mspserver.ctl" $ cFile
   return 4
endif
return freeslot(cFile)


*****************************
function freeSlot(cTarg)
*****************************
*  ERROR CODES
*  0=ok
*  1=could not open
*  2=write error (less than 72 bytes)
*  4=wrong filename in wrapper
*
nErr := 0
if pcount()=0 .or. empty(cTarg)
   cTarg := "c:\dbfree\bin\mspserver.ctl"
endif

nHandle := fopen(cTarg,5)
if nHandle < 1
   delete file (cTarg)
   nhandle := fcreate(cTarg,2)
   nErr := 1
endif

declare aX[72]
aX[01] := 27
aX[02] := 26
aX[03] := 00
aX[04] := 00
aX[05] := 03
aX[06] := 00
aX[07] := 00
aX[08] := 00
aX[09] := 26
aX[10] := 25
aX[11] := 00
aX[12] := 00
aX[13] := 48
aX[14] := 48
aX[15] := 48
aX[16] := 46
aX[17] := 48
aX[18] := 48
aX[19] := 48
aX[20] := 46
aX[21] := 48
aX[22] := 48
aX[23] := 48
aX[24] := 46
aX[25] := 48
aX[26] := 48
aX[27] := 48
aX[28] := 00
aX[29] := 00
aX[30] := 00
aX[31] := 00
aX[32] := 00
aX[33] := 48
aX[34] := 48
aX[35] := 48
aX[36] := 46
aX[37] := 48
aX[38] := 48
aX[39] := 48
aX[40] := 46
aX[41] := 48
aX[42] := 48
aX[43] := 48
aX[44] := 46
aX[45] := 48
aX[46] := 48
aX[47] := 48
aX[48] := 00
aX[49] := 00
aX[50] := 00
aX[51] := 00
aX[52] := 00
aX[53] := 48
aX[54] := 48
aX[55] := 48
aX[56] := 46
aX[57] := 48
aX[58] := 48
aX[59] := 48
aX[60] := 46
aX[61] := 48
aX[62] := 48
aX[63] := 48
aX[64] := 46
aX[65] := 48
aX[66] := 48
aX[67] := 48
aX[68] := 00
aX[69] := 00
aX[70] := 00
aX[71] := 00
aX[72] := 00

xVal := ""
for iii=1 to 72
   xVal += chr(aX[iii])
next

vvv := fwrite(nHandle,xVal)
if vvv < 72
   nErr := 2
endif
fclose(nHandle)
return nErr


******************************************** ex MAX2.MAX ***************************************************
*------------------------------------------------
function initMax(cLibrary)
*------------------------------------------------
if pcount()=0
   cLibrary := ""
endif

//-- loads values to public vars
//-- depicting location for current library
//
xWebRoot :=  strTran(getenv("DOCUMENT_ROOT"),"/","\")
if "IIS" $ getenv("SERVER_SOFTWARE")
   p1 := strTran(getenv("PATH_TRANSLATED"),"/","\")
   p2 := strTran(getenv("SCRIPT_NAME"),"/","\")
   xWebRoot := strTran(p1,p2,"")
endif
xLibDir := strTran(xWebRoot,"/","\")+"\lib\"
if not file(xLibDir)
   md(xLibDir)
endif

xSessDir  := MspConfigVar("MSPDIR")+"\sessions"

//-- initializing system variables to be saved into memory file
//
ainit("MEMORY","mWebRoot","mLibDir","mDataDir","mIniFile","mMemArray","mMemFile")
for iiii=1 to len(MEMORY)
   xxx := MEMORY[iiii]
   &xxx := ""
next
mWebRoot  := xWebRoot
mLibDir   := xLibDir
mMemArray := "MEMORY"
mMemFile  := xSessFile
mDataDir  := MspConfigVar("DATADIR")
mIniFile  := xWebRoot + "\dbfree.ini"

//-- loading the real working library
if not empty(cLibrary)
   xcLib := xLibDir + cLibrary + ".max"
   if file(xcLib)
      set maxlib to &xcLib
    else
	   ? "Library " + xcLib + " not found!"
	endif
endif

//-- establishing an INI file with relevant values
//
if not file(mIniFile)
   cTxt := "[LocalApp]" + CR_LF
   for iiii=1 to len(MEMORY)
      var := MEMORY[iiii] 
      cTxt += var + "=" + &var + CR_LF
   next
   memowrit(mInifile,cTxt)
endif

save all like m* to (xSessFile)

return xSessFile

*------------------------------------------------
function listMem(memArray)
*------------------------------------------------
local nVars
if type(memArray) <> "A"
   return "ERROR! usage: listMem(MEMORY) "
endif
nVars := len(memArray)
for iii=1 to nVars
   xyz := memArray[iii]
   ? xyz | "=" |  &xyz
next
return ""


*------------------------------------------------
function resetMax(xSessFile)
*------------------------------------------------
xSessFile := getSessFile()
if file(xSessFile)
   delete file xSessFile
endif
return


*-------------------------------------------------------------------------------
function default(Var, Value)
*-------------------------------------------------------------------------------
return iif(type(Var)="U",Value,Var)



*-------------------------------------------------------------------------------
function listWebVars(aArr, nStyle)
*-------------------------------------------------------------------------------
if pcount()=1
   nStyle := 1
endif
cOutArrStr := ""
for iii = 1 to len(aArr)
   do case 
   case nStyle=0
      cOutArrStr += "*" + zz(aArr[iii,1])+"|" +zz(aArr[iii,2])+"*"
   case nStyle=1
      cOutArrStr += "[" + zz(aArr[iii,1])+"=" +zz(aArr[iii,2])+"]"
   case nStyle=2
      cOutArrStr += "{" + zz(aArr[iii,1])+":" +zz(aArr[iii,2])+"}"
   endcase
next
return cOutArrStr 


*-------------------------------------------------------------------------------
function callingpage()
*-------------------------------------------------------------------------------
//-- updated Sept 6,2011 - to strip server port in case
local cCaller, cServer, cPort, nPos
cStr := ""
cServer := getenv("SERVER_NAME")
cPort   := getenv("SERVER_PORT")
cCaller := getenv("HTTP_REFERER")

if not empty(cPort)
   cPort :=":"+cPort
endif
cCaller := strTran(cCaller,"http://","")
cCaller := strTran(cCaller,cServer,"")
cCaller := strTran(cCaller,cPort,"")
cCaller := trimRightAt(cCaller,":")

return cCaller 


*-------------------------------------------------------------------------------
function passVars(aArr)
*-------------------------------------------------------------------------------
local cParm
cParm := ""
if len(aArr) > 0
   for nnn = 1 to len(aArr)
      if aArr[nnn,1] <> "PB" .and. .not. empty(aArr[nnn,2])
         cParm += "&" + aArr[nnn,1]+"="+aArr[nnn,2]
      endif
   next
   if left(cParm,1)="&"
      cParm := subs(cParm,2,len(cParm)-1)
   endif
endif
cParm := cleanUp(cParm)
cParm := cleanStr(cParm)
return cParm 


*-------------------------------------------------------------------------------
function passFields(aArr)
*-------------------------------------------------------------------------------
local cParm
cParm := ""
if len(aArr) > 0
   for nnn = 1 to len(aArr)
      if aArr[nnn,1] <> "PB" .and. .not. empty(aArr[nnn,2])
         if upper(aArr[nnn,1]) <> "VAR_ACTION"
            cParm += '<input type="hidden" name="' + aArr[nnn,1]+'" value="' + aArr[nnn,2]+ '">'
         endif
      endif
   next
endif
return cParm 

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


*-------------------------------------------------------------------------------
function scriptName()
*-------------------------------------------------------------------------------
local cOut, cServer
cServer := upper(getenv("SERVER_SOFTWARE"))
do case
case cServer = "APACHE"
   cOut := getenv("PATH_INFO")
case cServer = "XITAMI"
   cOut := getenv("SCRIPT_NAME")
otherwise
   cOut := getenv("SCRIPT_NAME")
endcase
return cOut



*-------------------------------------------------------------------------------
function getAppVer()
*-------------------------------------------------------------------------------
local cScript,cZac,cWebDir,cWebRoot,cFile
cFile :=""
cScript := filepath(scriptName())
if not empty(cScript)
   cZac    := wordRight(cScript,"/") 
   cWebDir := strTran(cScript,cZac,"")
   cWebDir := strTran(cWebDir,"/","\")
   cWebRoot := MSPConfigVar("MSPDIR")
   cFile:= cWebRoot + cWebDir + "\release.txt"
   cFile:= fixSlash(cFile)
   if not file(cFile)
      memowrit(cFile,"No Version Yet")
   endif 
   cFile:= alltrim(memoread(cFile))
endif
return cFile






*-------------------------------------------------------------------------------
function here()
*-------------------------------------------------------------------------------
//-- ritorna il percorso DOS della cartella fisica
// del server che contiene il file MSP attualmente in esecuzione
// 
local cRoot
cRoot := documentRoot() + pagename()
if right(cRoot,1)="\"
   cRoot := trimRight(cRoot,1)
endif
return strTran(cRoot,"/","\")





*-------------------------------------------------------------------------------
function setDb(cDbPos)
*-------------------------------------------------------------------------------
//-- chiamata da tutte le pagine che necessitano
//   di accedere al database
//   Esempio:
//   - setDb("gnx") per settare come cartella corrente dei db 
//   la sottocartella GNX sotto a DATADIR (se non esiste viene creata)
//   - setDb()
//   per settare DATADIR come default, ovvero lo stesso che non usare setDb()
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
   cDbPos:= cDBroot + cDbPos
   if not file(cDbPos)
      md (cDbPos)
   endif
   set default to (cDbPos) 
endif
return rslash(cDbPos) 


*-------------------------------------------------------------------------------
function setID(cTxt,cUsr,cGrp,cRole)
*-------------------------------------------------------------------------------
//-- da usare con il template nella sezione 5 SAFETY SYSTEM
//   ritorna la stringa da passare alle pagine per la sicurezza
local cSymb
cSymb := "&"
if ! empty(cTxt)
   if at("?",cTxt) = 0
      cSymb := "?"
   endif
endif
if type(cRole)="N"
   cRole := wstr(cRole)
endif
return cTxt + cSymb + "VAR_USR_NAME=" + alltrim(cUsr) + "&VAR_USR_GRP=" + alltrim(cGrp) + "&VAR_USR_ROLE=" + alltrim(cRole)


*-------------------------------------------------------------------------------
function chkLogFile(cDbType)
*-------------------------------------------------------------------------------
local cDbPath, cDb, cMdx, cNtx, cMtx, cDbPath, cDbType
cDbPath := MSPConfigVar("DataDir")+"\"
cDb   := cDBpath + "SITE_LOG.DBF"
cMtx  := cDBpath + "SITE_LOG.MTX"
cMdx  := cDBpath + "SITE_LOG.MDX"
cNtx  := cDBpath + "SITE_LOG.NTX"
if not file(cDb)
  ainit( "aField","LOG_ID","D_REG","T_REG","MSG","USR_NAME","IP_ADDR","CLASS","CARGO","COD_OP","T_TIME")
  ainit( "aType","C","D","C","M","C","C","C","M","C","N")
  ainit( "aSize",20,8,10,10,20,16,35,10,20,5)
  ainit( "aDec",0,0,0,0,0,0,0,0,0,2)
  create (cDb) from aField, aType, aSize, aDec
  ? "Rebuilt table " + cDb
endif

if pcount()=0
   cDbType =""
   if not file(cMtx)
      use (cDb) in 0 index (cMtx) key USR_NAME
      ? "Rebuilt dBase index " + cMtx
      use
   endif
endif

if cDbType = "DBASE"
   if not file(cMdx)
     use (cDb) excl
    if used()
        index on USR_NAME tag USR_NAME
        ? "Rebuilt dBase index " + cMdx
     else
        ? "ERROR could not open, Index not created" html
     endif
   endif
   use
endif

if cDbType = "CLIPPER"
   if not file(cNtx)
     use (cDb) excl
    if used()
        index on USR_NAME to (cNtx)
        ? "Rebuilt Clipper index " + cNtx
     else
        ? "ERROR could not open, Index not created" html
     endif
   endif
   use
endif
return


*-------------------------------------------------------------------------------
function logwrite( cMsg, cUsrName, cCodOp, cCargo, nTTime, cClass )
*-------------------------------------------------------------------------------
local cDbPath, cDb, cMdx, cNtx, cMtx, cDbPath, cDbType
local cMsg, cUsrName,cCargo,nTTime,cDbRoot,cCodOp,cClass,lErr,nTot
local nRec,lOk,cOraReg,cNow,cFile,cIpAddr,nnn

cDbPath := MSPConfigVar("DataDir")+"\"
cDb   := cDBpath + "SITE_LOG.DBF"
cMtx  := cDBpath + "SITE_LOG.MTX"
cMdx  := cDBpath + "SITE_LOG.MDX"
cNtx  := cDBpath + "SITE_LOG.NTX"

cMsg     := iif( type(cMsg)="U", "Messaggio non specificato: usare cMsg, cUsrName, cCodOp, cCargo, nTTime, cClass", cMsg)
cUsrName := iif( type(cUsrName)="U", getenv("REMOTE_USER"), cUsrName )
cCargo   := iif( type(cCargo)="U", "", cCargo)
nTTime   := iif( type(nTTime)="U", 0, nTTIme)
nTTime   := iif( type(nTTime)="C", val(nTTime), nTTIme)
cDbRoot  := MSPConfigVar("DataDir")
cCodOp   := iif( type(cCodOp)="U", "LOG", cCodOp)
cClass   := iif( type(cClass )="U", "0", cClass )
lErr     :=.f.
nTot     := 0
nRec     := 0
lOk      := .f.
cOraReg  := time()
cNow     := dtoc(date())+"-"+time()+"-"+right(wstr(seconds()),2)
cNow     := strTran(cNow,":","")
cFile    := cDbRoot + "log_" + cNow
cIpAddr  := getenv("REMOTE_ADDR")

cTxt := ""
      cTxt += "[LOG_ID=" +cNow + "]"
      cTxt += "[D_REG=" + dtoc(date()) + "]"
      cTxt += "[T_REG=" + cOraReg + "]"
      cTxt += "[MSG=" + cMsg + "]"
      cTxt += "[USR_NAME=" + cUsrName + "]"
      cTxt += "[T_TIME=" + str(nTtime) + "]"
      cTxt += "[COD_OP=" + cCodOp + "]"
      cTxt += "[CLASS=" + fchar(cClass) + "]"
      cTxt += "[IP_ADDR=" + cIpAddr  + "]"
      cTxt += "[CARGO=" + cCargo + "]"

//--
if not file(cDb)
   chkLogFile()
endif
use (cDb) in 0 alias xlog shared

cDbType := dbtype()

do case
case cDbType ="MAX"
      set index to (cMtx)
case cDbType = "DBASE"
   set index to (cMdx) 
   set order to tag USR_NAME
case cDbType = "CLIPPER"
     set index to (cNtx)
endcase

cFile := "logErr-" + alltrim(LOG_ID) + ".txt"
if used()
   nnnR := reccount()
   append blank
   if rlock(1)
      repl xLog->LOG_ID   with cNow
      repl xLog->D_REG with date()
      repl xLog->T_REG  with cOraReg
      repl xLog->USR_NAME with cUsrName
      repl xLog->T_TIME   with nTTime
      repl xLog->COD_OP   with cCodOp 
      repl xLog->CLASS    with fchar(cClass) 
      repl xLog->IP_ADDR  with cIpAddr  
      repl xLog->CARGO    with cCargo 
      repl xLog->MSG      with cMsg
      unlock
   else //-- not lock?
      //-- impossibile bloccare? recupero errori
      memowrit(cFile,cTxt)
   endif
   //-- non ha aggiunto il record? recupero errori
   if nnnR <= reccount()
      memowrit(cFile,cTxt)
   endif
   close xlog
else //-- not used?
   memowrit(cFile,cTxt)
endif   
return cTxt



*-------------------------------------------------------------------------------
function curDataDir()
*-------------------------------------------------------------------------------
return MSPconfigVar("DATADIR")


*-------------------------------------------------------------------------------
function webRoot(lNoprot)
*-------------------------------------------------------------------------------
local cRoot, ddd, aaa
cRoot:= documentRoot()
ddd := getenv("SERVER_NAME")
aaa :=  ddd + cRoot+"/"
return cRoot

*-------------------------------------------------------------------------------
function pageName()
*-------------------------------------------------------------------------------
//-- per compatibilità con apache: da usare al posto di getenv("SCRIPT_NAME") 
//
local cSelf, cSrvr
cSrvr :=  getenv("SERVER_SOFTWARE")
do case
case cSrvr = "X"
   //-- xitami
   cSelf   := getenv("SCRIPT_NAME")
case cSrvr = "A"
   //-- apache
   cSelf   := getenv("PATH_INFO")
case cSrvr = "I"
   //-- IIS
   cSelf   := getenv("SCRIPT_NAME")
otherwise
   return(getenv("SCRIPT_NAME"))
endcase
return cSelf



*-------------------------------------------------------------------------------
function webHome()
*-------------------------------------------------------------------------------
return "/"     



*-------------------------------------------------------------------------------
function documentRoot(nStyle)
*-------------------------------------------------------------------------------
//-- nStyle 1=DOS, 2=DOS Nodrive
//-- IIS fix
cRoot := MSPConfigVar("MSPDIR")
cSrvr := upper(getenv("SERVER_SOFTWARE"))
do case
case "IIS" $ cSrvr
   p1 := rslash(getenv("PATH_TRANSLATED"))
   p1 := strTran(p1,"/","\")
   p2 := rslash(getenv("SCRIPT_NAME"))
   p2 := strTran(p2,"/","\")
   cRoot := strTran(p1,p2,"")
case "XITAMI" $ cSrvr
   cRoot := getenv("DOCUMENT_ROOT")
case "APACHE"  $ cSrvr
   cRoot := getenv("DOCUMENT_ROOT")
endcase
*
cRoot := strTran(cRoot,"/","\")
if pcount()>0
   do case
   case nStyle=1
      cRoot := strTran(cRoot,"/","\")
   case nStyle=2
      cRoot := trimRightAt(cRoot,":")
   endcase
endif
return(cRoot)


//------------------
function setSafe(cCode, xPost)
//------------------
//-- riceve la stringa di sicurezza creata dall'header e restituisce i relativi campi
//   nascosti da impiantare in un form - uso (dentro ad un form, prima del submit):
//   < setsafe(cSafety) >  FONDAMENTALE NEI FORM
//  Passando un qualsiasi parametro (meglio usare 1) prepara una stringa da usare nell'url
//
local cTxt, cName, cVal
cTxt :=""
cCode := alltrim(cCode)
if left(cCode,1) = "&"
   cCode := trimLeft(cCode,1)
endif
if right(cCode,1) <> "&"
   cCode += "&"
endif
*? cCode
nnn := 1
do while nnn >0
   // cerchiamo i tag di separazione (ampersand)
   nPos := at("&" ,cCode)
   cStr := subs(cCode,1,nPos-1)
   
   //--ora tagliamo via il pezzo letto
   cCode := trimLeft(cCode,nPos)
   
   //--dentro al risultato cerchiamo il separatore (equal)
   n1 := at("=",cStr )
   if n1 > 0
      cName := subStr(cStr ,1,n1-1)
      cVal := subStr(cStr ,n1+1)
   endif
   if pcount()>1
      cTxt += upper(cName) + '=' + cVal + '&'
   else
      cTxt += '<input type="hidden" name="' + cName + '" value="' + cVal + '">'
   endif
   nnn := len(cCode)
enddo
if right(cTxt,1)="&"
   cTxt := trimRight(cTxt,1)
endif
return cTxt

//------------------
function showSafe(cCode)
//------------------
//-- accetta la stringa di sicurezza preparata dall'header
//   e restituisce un testo con i valori da usare nei display della scheda
//   Esempio: ? showSafe(cSafety)
//
local cTxt, cName, cVal
cTxt :=""
cCode := alltrim(cCode)
if left(cCode,1) = "&"
   cCode := trimLeft(cCode,1)
endif
if right(cCode,1) <> "&"
   cCode += "&"
endif
*? cCode
nnn := 1
do while nnn >0
   // cerchiamo i tag di separazione (ampersand)
   nPos := at("&" ,cCode)
   cStr := subs(cCode,1,nPos-1)
   
   //--ora tagliamo via il pezzo letto
   cCode := trimLeft(cCode,nPos)
   
   //--dentro al risultato cerchiamo il separatore (equal)
   n1 := at("=",cStr )
   if n1 > 0
      cName := subStr(cStr ,1,n1-1)
      do case
      case cName = "VAR_USR_NAME"
         cName := " Usr:"
      case cName = "VAR_USR_GRP"
         cName := " Grp:"
      case cName = "VAR_USR_ROLE"
         cName := " RL:"
      otherwise
         cName :=""
      endcase
      cVal := subStr(cStr ,n1+1)
   endif
   cTxt += cName + cVal
   nnn := len(cCode)
enddo
return cTxt




//---------------------------------------------
function fileScan(cFile)
//---------------------------------------------
nHandle   := fopen(cFile)
nLastByte := fseek(nHandle,0,2)
cChunk := ""
nFirstByte := fseek(nHandle,0,0)
nThisPos   := fseek(nHandle,0,1)
rrr := 0
do while nThisPos < nLastByte
   if lower(cChunk) = "function"
      rrr++
      ? str(rrr,2,0,"0")+": " + cChunk
   endif
   cChunk   := freadstr(nHandle,132, chr(10))
   nThisPos := fseek(nHandle, nThisPos+len(cChunk)+1, 0)
enddo
fclose(nHandle)
return ""

//---------------------------------------------
function listFunc(cFile)
//---------------------------------------------
nHandle   := fopen(cFile)
nLastByte := fseek(nHandle,0,2)
cChunk := ""
nFirstByte := fseek(nHandle,0,0)
nThisPos   := fseek(nHandle,0,1)
rrr := 0
lOk :=.f.
do while nThisPos < nLastByte
   if lower(cChunk)="function"
      lOk :=.t.
      ? cChunk
   endif
   if lOk
      if cChunk = "//"
         ? cChunk
      endif
   endif
   if lower(cChunk)="return"
      lOk := .f.
      ?
   endif
   cChunk   := freadstr(nHandle,132, chr(10))
   nThisPos := fseek(nHandle, nThisPos+len(cChunk)+1, 0)
enddo
fclose(nHandle)
return ""


*------------------------------------------------
function getSessFile(cDir)
*------------------------------------------------
//-- ritorna un nome utile da usare come file di sessione
local cFile
if pcount()=0
   cDir := MspConfigVar("MSPDIR")+"\sessions"
endif

//-- load values to public vars
//-- depicting location for current library
//
xWebRoot :=  strTran(getenv("DOCUMENT_ROOT"),"/","\")
if "IIS" $ getenv("SERVER_SOFTWARE")
   p1 := strTran(getenv("PATH_TRANSLATED"),"/","\")
   p2 := strTran(getenv("SCRIPT_NAME"),"/","\")
   xWebRoot := strTran(p1,p2,"")
endif
xLibDir := strTran(xWebRoot,"/","\")+"\lib\"
if not file(xLibDir)
   md(xLibDir)
endif

xSessDir  := MspConfigVar("MSPDIR")+"\sessions"

//-- checking session directory and creating if missing
//
if not file(xSessDir)
   md(xSessDir)
endif
cFile  := "SS-" + strTran(getenv("REMOTE_ADDR"),".","-") + "_" + dtoc(date())
cFile := xSessDir + "\" + cFile +".mem"
return cFile


*-------------------------------------------------------------------------------
function libInfo(cLibPath,lVerbose)
*-------------------------------------------------------------------------------
if type(lVerbose)="U"
   lVerbose:=.f.
else
   lVerbose:=.t.
endif


if type(cLibPath)="U"
   xLibDir := strTran(documentRoot(),"/","\")+"\lib\"
   cMask1 := curdir() + "\lib\*.max"
   cMask2 := curdir() + "\lib\*.prg"
else
   xLibDir := zz(cLibPath)
   cMask1 := xLibDir + "*.max"
   cMask2 := xLibDir + "*.prg"
endif
? "LIBRARY INFO for DBFree/DBMax"
? "(c) by maxsis"
?


? "Assuming libraries in this folder : " + xLibDir

$extended

nLibs = adir( cMask1, aLibs)
 ? zz(nLibs) + " libraries found: "
for iii=1 to nLibs
   ? "--" +  filebone(aLibs[iii])
next
?

nFiles = adir( cMask2, aNames, aSizes, aDates, aTimes, aAttr)

*-- apre la lista e uno per uno li esamina
? "These libraries make use of following modules:"
cTxt := cMask2 + CR_LF
for iii=1 to nFiles
   ?
   ? "Module: " + upper(filebone(aNames[iii]))
   ? ":"
   if lVerbose
      listFunc(aNames[iii])
      ?
   else
      filescan(aNames[iii])
   endif
next
return ""

*****************************************
function range(nVar,nMin,nMax)
*****************************************
if nVar > nMax
   nVar := nMax
elseif nVar < nMin
   nVar := nMin
endif
return nVar

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
return zz(int(nnn/60))+":"+zz(mod(nnn,60))

*---eof

