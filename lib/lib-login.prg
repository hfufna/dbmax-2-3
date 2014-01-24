**************************************************************
**  
**************************************************************
**  DBMAX 2.5 - LIBRARY MODULE (derived from DBFree 3.0.1)
**  (c) by G.Napolitano
**
**  Project start: Prato 4 ott 2013
**  vers. 0.0.1 - Prato 05 ott 2013
**  vers. 0.0.2 - Prato 21 nov 2013
**
**************************************************************
#define CR_LF chr(13)+chr(10)

*
**************************************
function isLocal(cIpAddr)
**************************************
local lOk := .f.

if vtype("cIpAddr")="U"
   cIpAddr := getenv("REMOTE_ADDR")
endif

//-- using an array to store the IP allowed
declare aAllowed[4]
aAllowed[1]:="192.168"
aAllowed[2]:="172.16"
aAllowed[3]:="10.0"
aAllowed[4]:="127.0.0.1"

//-- checking the user IP against the list
for iii=1 to alen(aAllowed)
   if left(cIpAddr,len(aAllowed[iii])) = aAllowed[iii]
      lOk :=.t.
   endif
next
return lOk

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

//-----------------------------------------------
function setId()
//-----------------------------------------------
//-- for compatibility
return ""

************************************************
function displaySess(cSess)
************************************************
local cOut, cFile, iii
cFile := getMemFile(cSess)
cOut := "<p>"
ainit("aVV","xAppId","xMemDir","xRoot","xMemFile","xCargoFile","xGlobals","xStarter","xDateTime","xUser","xUserIp", "xPsw","xHome","xBack")
for iii=1 to len(aVV)
   xxx :=  aVV[iii]
   if not vtype(xxx)="U"
      cOut += "<i>" | aVV[iii] | "</i> =" | &xxx | "<br>"
   else
      cOut += "<i><b>" | aVV[iii] | "</b></i> = not defined!<br>"
   endif
next
return cOut

************************************************
function clearSess(cSess)
************************************************
local cFile
cFile := getMemFile(cSess)
if file(cFile)
   delete file (cFile)
endif
return ""
