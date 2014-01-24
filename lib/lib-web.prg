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

*****************************
function ip2num(cStr)
*****************************
local nOut,a,b,c,d, cDec
cDec := set("DECIMALS")
set decimals to 0
a := val(wordLeft(cStr,"."))
cStr:= trimRightAt(cStr,".")
b := val(wordLeft(cStr,"."))
cStr:= trimRightAt(cStr,".")
c := val(wordLeft(cStr,"."))
cStr:= trimRightAt(cStr,".")
d := val(wordLeft(cStr,"."))
nOut := d + c*(256) + b*(256^2) + a*(256^3)
set decimals to val(cDec)
return nOut

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

********************************
function listWebs(cThisDir)
********************************
local nnn,fff,iii,cThis, cOut
cOut := ""
   $extended
   nnn = adir( cThisDir+"\*.", aDName, aDSize, aDDate, aDTime, aDAttr )
   for iii = 1 to nnn
      cThis := filename(aDName[iii])
      if left(cThis,1) $ "._"
      else
         fff :=  adir( aDName[iii]+"\*.*", aFName )
         cOut := '<li><b>' + upper(cThis) + '</b> ('+ zz(fff-2) + ' files)</li>'
      endif
   next 
return cOut

***********************
function DnsList(cFile)
***********************
local cOut,cBuffer,nLastByte,nFirstByte
local nThisPos,xPrev,xVal,cOut
*
cOut := ""
cBuffer := fopen(cFile)
nLastByte := fseek(cBuffer,0,2)
//? "Source of file:" | cFile | " size:" | nLastByte | "<hr>" HTML
nFirstByte := fseek(cBuffer,0,0)
nThisPos := fseek(cBuffer,0,1)
*
xPrev :="^"
do while nThisPos < nLastByte
   xVal := freadstr(cBuffer,1)
   if xVal= CR_LF
      cOut += CR_LF
   elseif xVal=" "
      if xVal <> xPrev
         cOut += "|"       
      endif
   else
      cOut += xVal
   endif
   xPrev := xVal
   nThisPos++
enddo
fclose(cBuffer)
return cOut

*************************
function folderBar(cHere)
*************************
//-- returns a string containing navigation links 
//   that take to current folder
//
local cRoot,cHere,cOut,aFolders,cDrive
local nnn, iii, cLink, cLabel,nPos

cRoot := webRoot()
if pcount()=0
   cHere := curDosDir()
endif
cOut := ""
nnn := 0
declare aFolders[1]
aFolders[1] := cHere
cDrive := subs(cHere,1,at(":",cHere))

do while nnn < 50
   nPos := rat("\",cHere)
   cHere := subs(cHere,1,nPos-1)
   if cHere == cDrive
      exit
   else
      if cHere <> aFolders[1]
         agrow(aFolders,1)
         aFolders[len(aFolders)] := cHere
         *? cHere
      endif
   endif
   nnn++
enddo

for iii=len(aFolders) to 1 step -1
   cLink := strTran(aFolders[iii],cRoot,"")
   cLabel := filebone(aFolders[iii])
   do case
   case empty(cLink)
      cLink := "\"
   case cLink = cDrive
      cLink := ""
   case right(cLink,1)="\"
      cLink := ""
   endcase
   if not empty(cLink)
      cOut += '<a href="' + cLink + '">' + cLabel + '</a>' +" >> "
   endif
next
cOut += filebone(pagename())
return cOut



