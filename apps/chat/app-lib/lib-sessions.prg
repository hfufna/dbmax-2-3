**************************************************************
**
**  DBMAX->DBFREE 2.0 - SESSION HELPER FUNCTIONS LIBRARY
**
**  Progetto iniziato a Prato il 10 ago 2010
**
**  vers. 0.0.3 - Prato 02 ott 2010
**
**************************************************************

#define _SYSDB  "sys.dbf"
#define _NDX_USR "sys_usrname.mtx"
#define _NDX_SES "sys_sessid.mtx"
#define _SETDB   "sys"

set exact on
set dele on

***************************************************
function initSys()
***************************************************
cPath := setDb(_SETDB)
   
   //-- controllo e ricreazione tabella
   if not file(cPath + _SYSDB)
      ainit( "aField","SESS_NO","USR_NAME","CARGO")
      ainit( "aType","C","C","M")
      ainit( "aSize",14,20,10)
      ainit( "aDec",3,0,0)
      create (_SYSDB) from aField, aType, aSize, aDec
      openDbSys()
      close SYS
   endif
return file(cPath + _SYSDB)

***************************************************
function openDbSys()
***************************************************
cPath := setDb(_SETDB)
use (cPath + _SYSDB) in 0 alias SYS index (cPath + _NDX_USR) key upper(USR_NAME), (cPath + _NDX_SES) key SESS_NO
return used()


***************************************************
function infoSys()
***************************************************
cPath := setDb(_SETDB)
return "DB:" + (cPath + _SYSDB) + " - NDX1:" + (cPath + _NDX_USR) + " - NDX2:" + (cPath + _NDX_SES)


***************************************
function openSession(cUsrName)
***************************************
cPath   := setDb(_SETDB)
cSessNo := val(cUsrName)

if ! empty(cUsrName)
   //-- apertura tabella e indici
   if ! openDbSys()
      return "00000000000"
   endif

   sele SYS
   set order to 1
   
   //-- cerchiamo il nome nella tabella
   seek upper(cUsrName)
   if found()
      //-- se esiste vediamo se ha una sessione
      if not empty(sys->SESS_NO)
         //-- se ha una sessione recuperiamo i dati
         cSessNo := sys->SESS_NO
      else
         //-- altrimenti si apre una nuova sessione
         cSession := str(seconds(),15,3)
      endif
   else
      //-- se non si trova utente lo aggiungiamo
      cSession := str(seconds(),15,3)
      append blank
      if rlock(2)
         repl sys->USR_NAME with cUsrName
         repl sys->SESS_NO  with cSession
         cSessNo := cSession
         unlock
      endif
   endif
   close SYS
endif
return cSessNo


*************************************
function deleteSession(cSessNo)
*************************************
//-- fornendo il numero sessione la elimina dalla lista
lOk :=.f.
cPath := setDb(_SETDB)
openDbSys()
sele SYS
set order to 2
seek cSessno
if found()
   delete
   lOk := .t.
endif
close SYS
return lOk


*************************************
function getSession(cSessNo)
*************************************
//-- fornendo il numero sessione ritorna le variabili salvate nel cargo
cOut := ""
if ! empty(cSessNo)
   cPath := setDb(_SETDB)
   openDbSys()
   sele SYS
   set order to 2
   seek cSessno
   if found()
      cOut := alltrim(CARGO)
   else
      cOut := "GETSESSION-ERROR-NOTFOUND [" + cSessNo + "]"
   endif
   close SYS
endif
return cOut

*************************************
function saveSession(cSessNo,cCargo)
*************************************
//-- fornendo il numero di sessione e il cargo salva nella tabella
lOk :=.f.
cPath := setDb(_SETDB)
openDbSys()
sele SYS
set order to 2
seek cSessno
if found()
   if rlock(2)
      repl CARGO with cCargo
      unlock
     lOk := .t.
   endif
endif
close SYS
return lOk
