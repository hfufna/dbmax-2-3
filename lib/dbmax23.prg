**************************************************************
**  
**************************************************************
**  DBMAX 2.3 - LIBRARY MODULE (derived from DBFree 3.0.1)
**  (c) by G.Napolitano
**
**  Project start: Prato 4 ott 2013
**  vers. 0.0.1 - Prato 05 ott 2013
**  vers. 0.0.2 - Prato 24 ott 2013
**  vers. 0.0.3 - Prato 12 nov 2013
**  compile with MAXCOMPILER dbmax -m  -msp

**************************************************************
#define CR_LF chr(13)+chr(10)
*************************************************************************

** MODULES TO COMPILE
set proc to lib-strings, lib-dates, lib-dbf, lib-files, lib-html, lib-arrays, lib-mem, lib-login, lib-web, lib-bootstrap, lib-extended

*-------------------------------------------------------------------------------
function libVer()
*-------------------------------------------------------------------------------
//* Returns a string with the version number and build date of current library
return "DBMAX LIB 2.3.5 (c)2003-2013 G.Napolitano Build 2013-11-19"

*-------------------------------------------------------------------------------
function chkConfig()
*-------------------------------------------------------------------------------
//-- CHECKING CONFIG FILE FOR APPROPRIATE DBMAX VARIABLES
//* Checks the DBMAX configuration file for all necessary entries
//* If missing they are added. Returns values added as string.
//
local cMspDir, cDrive
cMspDir := mspconfigvar("MSPDIR")
cDrive  := left(cMspDir,3)
declare av[5,2]
av[1,1] := "WEBROOT"
av[1,2] := cMspDir + "\MAXSIS"
av[2,1] := "LIB"
av[2,2] := cMspDir+ "\lib\"
av[3,1] := "MEM"
av[3,2] := cMspDir+ "\mem\"
av[4,1] := "INI"
av[4,2] := cMspDir+ "\ini\"
av[5,1] := "LOGDIR"
av[5,2] := cMspDir+ "\logs\"

kFile := MspConfigVar("MSPDIR")+"\bin\MspServer.cfg"
if not type(cFile)="U"
   kFile := cFIle
endif

for kkk=1 to len(av)
  if empty(MspConfigVar(av[kkk,1]))
     kTxt := av[kkk,1] | "=" | av[kkk,2]+CR_LF
     kTmp := memoread(kFile)+CR_LF+kTxt
     memowrit(kFile,kTmp)
  endif
next
release all like k*
return( atos(av))

*-------------------------------------------------------------------------------
function freeSlot(cTarg)
*-------------------------------------------------------------------------------
//* Automatically manage (opens and close) communication slot for web connections
//*  ERROR CODES
//*  0=ok
//*  1=could not open the proxy file
//*  2=write error (proxy lenght less than 72 bytes)
//*  4=proxy file not found 
*
local xVal, cErr 

cErr := "0: OK! SLOT ASSIGNED"
if pcount()=0 .or. empty(cTarg)
   cTarg := MspConfigVar("MSPDIR") + "\bin\mspserver.ctl"
endif

if not file(cTarg)
   return("4: MISSING OR DAMAGED PROXY FILE!")
endif

nHandle := fopen(cTarg,5)
if nHandle < 1
   delete file (cTarg)
   nhandle := fcreate(cTarg,2)
   cErr := "1: NO HANDLES FOR PROXY FILE"
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
   cErr := "2: PROXY FILE CRC ERROR"
endif
fclose(nHandle)
return cErr


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
function listFunc(cFile)
*-------------------------------------------------------------------------------
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
? "LIBRARY INFO for DBMAX/DBMax"
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




*-------------------------------------------------------------------------------
function loadini(cFile)
*-------------------------------------------------------------------------------
//-- reads an ini file standard and intitialies the 
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
      xxx := "x" + capital(aRec[iii,1])
      cRes +=  xxx | " "  //-- list of vars created
      *--- declaring the variable and intializing its value
      public &xxx
      &xxx := aRec[iii,2]
      *--- printing out (only for demonstration)
      *? xxx | "=" | &xxx
   next
endif
return cRes

*************************************
function undefined(cVarName)
*************************************
if type(cVarName)="U"
   return .t.
endif
return .f.
*-- eof