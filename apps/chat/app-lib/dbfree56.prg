*************************************************************************
* DBFree Library 5.41 for cross-server programming      
*
* DBFREE 2.0           
*
* Contiene : Elementi del linguaggio, sistema di log, orientamento
*        
*
***  vers. 0.0.4 - Prato 12 dic 2010
***  vers. 0.0.5 - Prato 21 mar 2011

#define CR_LF chr(13)+chr(10)

cDBroot := MSPConfigVar("DataDir")+"\"
if not file(cDBroot)
   md (cDBroot)
endif
set default to (cDBroot) 

*************************************************
**  compile with MAXCOMPILER dbfree56 -m -msp
*************************************************
set proc to lib-strings, lib-dates, lib-dbf, lib-files, lib-html, lib-sessions, lib-arrays, extended

zcDataSource := MSPConfigVar("DATADIR")
if not file(zcDataSource)
   md (zcDataSource)
endif

initSessions()

*-------------------------------------------------------------------------------
function default(Var, Value)
*-------------------------------------------------------------------------------
return iif(type(Var)="U",Value,Var)


*-------------------------------------------------------------------------------
function libInfo()
*-------------------------------------------------------------------------------
//-- sostituisce le precedenti
return "DBFREE LIB 5.5.7 (c)2003-2011 G.Napolitano Build 2011-03-21"

*-------------------------------------------------------------------------------
function libVer()
*-------------------------------------------------------------------------------
return libInfo()

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
local cCaller, nPos
cStr := ""
cCaller := getenv("HTTP_REFERER")
cCaller := strTran(cCaller,"http://","")
cCaller := cutAt(cCaller,":")
nPos := at("/",cCaller )
if nPos > 0
   cCaller := subs(cCaller ,nPos+1,len(cCaller )-nPos)
endif
cCaller := "/" + cCaller 
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


*--eof


