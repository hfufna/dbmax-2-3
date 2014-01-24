**************************************************************
**  
**************************************************************
**  DBMAX 2.5 - LIBRARY MODULE (derived from DBFree 3.0.1)
**  (c) by G.Napolitano
**
**  Project start: Prato 4 ott 2013
**  vers. 0.0.1 - Prato 05 ott 2013
**  vers. 0.0.2 - Prato 15 gen 2014
**************************************************************
#define CR_LF chr(13)+chr(10)

*
*
** esempio di utilizzo
*
*x2 := "WORLD"
*? savememory("x*")
*clear memory
*? restmemory()
*? x1, x2

******************************
function savememory(ddd,ppp)
******************************
local cFile, cPath, cDrive, cDef, cMask
cMask :="*"
cFile := "memory.mem"
cDef  := mspconfigvar("DATADIR") +"\mem\"
cDrive := curDrive()

if not type("ppp")="U"  //-- passata maschera
   cMask := zz(ppp)
endif
if not type(ddd)="U"  //-- passato file
   cPath := filepath(ddd)
   cFile := filename(ddd)+".mem"
endif
if empty(cPath)  //-- passato solo nome file
   cPath := cDef
endif
if empty(filedrive(cPath))
   cPath := curDrive()
endif
cFile := cPath + "\" + cFile
cFile := strtran(cFile,"\\","\")
if not file(cPath)
   md (cPath)
endif
save all like (cMask) to (cFile)
return cFile

*****************************
function restmemory(ddd)
*****************************
local cFile, cCode
cCode := 0
if type(ddd)="U"
   ddd := mspconfigvar("DATADIR") +"\mem\"
endif
ddd := filepath(ddd)
cFile := ddd +  "\memory.mem"
cFile := strtran(cFile,"\\","\")
? "Restoring from " | cFile
if file(cFile)
   restore from (cFile) additive public
   cCode := 1
else
   cCode := 3  //-- error code
endif
return cCode

*-------------------------------------------------------------------------------
function loadIniVars(cFile)
*-------------------------------------------------------------------------------
return loadIni(cFile)

*-------------------------------------------------------------------------------
function loadini(cFile)
*-------------------------------------------------------------------------------
//-- reads an ini file standard and initialies the 
//   variables with their values
//   it returns a list of names for vars created
//   separated by spaces
//
local nOut,cTxt,iii,cRes
nOut := 0
declare aRec[1,3]
cTxt := iniToStr(cFile)
cTxt := strTran(cTxt,"{}","")

cRes := ""
if not empty(cTxt)
   *-- searching for variable names and values pairs
   *   and load them into aRec array as pairs of elements
   nOut := parseStr(cTxt,"{","}","=")
endif
   
if nOut > 0
   *-- if something extracted...
   for iii = 1 to nOut
      *--- building a string to name a variable
      xxx := aRec[iii,1]
      if not empty(xxx)
         cRes +=  xxx | " "  //-- list of vars created
         *--- declaring the variable and intializing its value
         public &xxx
         &xxx := aRec[iii,2]
         *--- printing out (only for demonstration)
         *? xxx | "=" | &xxx
      endif
   next
endif
return cRes

*****************************************************
function getMemFile(cSeedStr, vEncrypt, vUsePort)
*****************************************************
local cOut, cIp, cPath, cDec
cDec := set("DECIMALS")
set decimals to 0
cOut := ""
if type(vEncrypt)="U"
   cIp := zz(ip2num(getenv("REMOTE_ADDR")))
else
   cIp := getenv("REMOTE_ADDR")
endif
cIp := strTran(cIp,".","_")
if type(vUsePort)="U"
   cIp := cIp +"-"+getenv("SERVER_PORT")
endif

cPath := getMemDir()
if not isDir(cPath)
   createDir(cPath)
endif
if not right(cPath,1)="\"
   cPath+= "\"
endif
if type(cSeedStr)="U" 
   cOut := cPath + cIp + "-" + zz(seconds()*100) + ".mem"
else 
   if not type(cSeedStr)="N"
      cSeedStr := zz(cSeedStr)
   endif
   cOut := cPath + cIp + "-" + cSeedStr + ".mem"
endif
set decimals to val(cDec)
return cOut



****************************************
function makeSeed()
****************************************
local cOut :=""
set decimals to 0
cOut := zz(seconds()*100)
cOut := strTran(cOut,".","")
set decimals to 0
return cOut


****************************************
function getseed()
****************************************
return makeSeed()


**********************************
function getMemDir()
**********************************
return MSPconfigVar("DATADIR")+"\mem"

**********************************
function getMemPath()
**********************************
return MSPconfigVar("DATADIR")+"\mem"


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


*************************************
function undefined(cVarName)
*************************************
if type(cVarName)="U"
   return .t.
endif
return .f.

*-- eof