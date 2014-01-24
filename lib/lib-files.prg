**************************************************************
**  
**************************************************************
**  DBMAX 2.5 - LIBRARY MODULE (derived from DBFree 3.0.1)
**  (c) by G.Napolitano
**
**  Project start: Prato 4 ott 2013
**  vers. 0.0.1 - Prato 05 ott 2013
**  fix- 06 nov 2013 (include)
**  fix- 16 Dic 2013 (dos2web)
**  fix- 23 Dic 2013 (plainpath)
**************************************************************
#define CR_LF chr(13)+chr(10)

*------------------------------------------
function include(cFil)
*------------------------------------------
//-- usage:
//   ? include(cTextFile) html
//
local cTem, cMsg :=""
do case
case left(cFil,1)="/"   //-- a web path
   cTem := webroot()+cFil
case subs(cFil,2,1)=":" //- a dos path
   cTem := cFil
case left(cFil,1)="\" //- incomplete dos path
   cTem := curdosdir()+cFil
otherwise
   cTem := curdosdir()+cFil
endcase

cTem := fixslash(cTem)
cMsg += "1 - searching for including: " + cTem + "<br>"
if not file(cTem)
   cTem := web2dos(cFil)
   cMsg += "2- trying with:" + cTem + "<br>"
   if not file(cTem)
      cTem := fixslash(webroot() + "\" + cFil)
      cMsg += "3 - Retring with:" + cTem + "<br>"
   endif
   //cTem := fixslash(curDosDir() + cFil)
endif

cMsg += "4 - finally:" + cTem + "<br>"
if not file(cTem)
   return ("[" + cTem + "] not found<br>" + cMsg)
endif
return memoread(cTem)


*-------------------------------------------------------------------------------
function curDataDir()
*-------------------------------------------------------------------------------
return MSPconfigVar("DATADIR")

//---------------------------------------------
function documentRoot()
//--------------------------------------------
return webRoot()

//---------------------------------------------
function fileScan(cFile)
//---------------------------------------------
//-- display file in hex-like mode
//
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


*-------------------------------------------------------------------------------
function webRoot(nStyle)
*-------------------------------------------------------------------------------
//-- nStyle 1=DOS, 2=DOS Nodrive
//-- compatible with MonGoose Web Server
//
local cMsp, cRoot, cSrvr
cMsp  := MSPConfigVar("MSPDIR")
cSrvr := upper(getenv("SERVER_SOFTWARE"))
cRoot := getenv("DOCUMENT_ROOT")
if empty(cRoot) or not isdir(cRoot)
   p1 := rslash(getenv("PATH_TRANSLATED"))
   p1 := strTran(p1,"/","\")
   p2 := rslash(getenv("SCRIPT_NAME"))
   p2 := strTran(p2,"/","\")
   cRoot := strTran(p1,p2,"")
endif
cRoot := strTran(cRoot,"/","\")
cRoot := strTran(cRoot,"\\","\")
if not type(nStyle)="U"
   do case
   case nStyle=1
      cRoot := strTran(cRoot,"/","\")
   case nStyle=2
      cRoot := trimRightAt(cRoot,":")
   endcase
endif
return(cRoot)

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


*----------------------------
function getBytes(cFile,nStart,nBytes)
*----------------------------
private nHANDLE, nPOS, cVar
if type(nStart)="U"
   nStart := 1
endif
if type(nBytes)="U"
   nBytes :=1
endif
cVar := ""
nHANDLE = fopen( cFile,3)
if nHANDLE != -1
   nPOS= fseek( nHANDLE, nStart-1, 0 )
   fread(nHANDLE,@cVar,nBytes)
   fclose( nHANDLE )
else
   nSIZE = 0
   ? "File open error"
endif
return( cVar)


*-------------------------------------------------------------------------------
function pageFile()
*-------------------------------------------------------------------------------
//-- shows the DOS path and name of current web page
local c1,c2,c3
c1 := curDosDir()
c2 := pageName()
c2 := strTran(c2,"/","\")
c3 := c1 + filename(c2)
if not file(c3)
   return "ERROR: file " + c3 + " not found!"
endif
return c3


*-------------------------------------------------------------------------------
function curDosDir(lNoDrive)
*-------------------------------------------------------------------------------
//-- shows the path of current DOS dir, optionally omitting drive letter
local cTxt, cName, cRoot
cRoot := documentRoot() + pagename()
if right(cRoot,1)="\"
   cRoot := trimRight(cRoot,1)
endif
cTxt  := strTran(cRoot,"/","\")
cName := pagename()
cName := fileclean(cName)
cTxt  := strTran(cTxt,cName,"")
if pcount()>0
   cTxt := fileNoDrive(cTxt)
endif
return cTxt


*-------------------------------------------------------------------------------
function curDosPage()
*-------------------------------------------------------------------------------
return curDosDir() + curWebPage()


*-------------------------------------------------------------------------------
function dos2web(cFile)
*-------------------------------------------------------------------------------
//-- trasforma un percorso DOS in percorso web
//   a partire dalla document root del server web
//
local cDocRoot,cDirLink 
cFile := lower(fixSlash(cFile))
cDocRoot:= lower(documentRoot())
cDocRoot:= strTran(cDocRoot,"/","\")
cDirLink := strTran(cFile,cDocRoot,"")
cDirLink := fixSlash(cDirLink)
cDirLink := strTran(cDirLink,"\","/")
return cDirLink


*-------------------------------------------------------------------------------
function web2dos(cFile)
*-------------------------------------------------------------------------------
//-- trasforma un percorso web in percorso dos
//
if not empty(cFile)
   cFile := rslash(curDosDir()) + fileclean(cFile)
   cFile := fixSlash(cFile)
endif
return cFile

*-------------------------------------------------------------------------------
function subDir(cTxt)
*-------------------------------------------------------------------------------
if right(cTxt,1)="\"
   cTxt := trimRight(cTxt,1)
endif
cTxt := wordright(cTxt,"\")
return cTxt


*-------------------------------------------------------------------------------
function upDir(cTxt)
*-------------------------------------------------------------------------------
local cComp
cComp := lower(MSPConfigVar("MSPDIR"))
cComp := rslash(fixslash(cComp ))
if lower(cTxt) == cComp
else
   if right(cTxt,1)="\"
      cTxt := trimRight(cTxt,1)
   endif
   nPos := rat("\",cTxt)
   cTxt := subs(cTxt,1,nPos)
endif
return cTxt


*-------------------------------------------------------------------------------
function web2java(cTxt)
*-------------------------------------------------------------------------------
* DA RIVEDERE
cTxt := strTran(cTxt,"\","\\")
cTxt := "http://"+getenv("SERVER_NAME")+"/"+cTxt
return cTxt


*-------------------------------------------------------------------------------
function curWebDir(full)
*-------------------------------------------------------------------------------
//-- ritorna il percorso web della cartella che contiene 
//   il file MSP attualmente in esecuzione
// 
local cPath,cRoot,cPage,cOut
cOut := ""
cPath := pageName()
cRoot := documentRoot(2)
cPage := fileBone(cPath)+fileExt(cPath)
cPath := strTran(cPath,cPage,"")
cOut := cPath
if pcount()>0
   cOut  := cRoot + cPath
endif
return cOut 


*-------------------------------------------------------------------------------
function curWebPage()
*-------------------------------------------------------------------------------
local cFullPath,p1,p2
cFullPath:= pageName()
p1 := fileBone(cFullPath)
p2 := fileExt(cFullPath)
return p1+p2


*-------------------------------------------------------------------------------
function curDrive()
*-------------------------------------------------------------------------------
local cSrvr, cRoot
cSrvr := getenv("SERVER_SOFTWARE")
cRoot := MSPConfigVar("MSPDIR")
if "IIS" $ cSrvr
   cRoot := getenv("PATH_TRANSLATED")
endif
return left(cRoot ,2)

//-----------------------------------
function fileDrive(cPathName)
//-----------------------------------
nlen := len(cPathName)
if len(cPathName)>2
   cPathName := subs(cPathName,1,2)
   if not ":" $ cPathName
      return ""
   endif   
endif
return cPathName

*-------------------------------------------------------------------------------
function FileNoDrive( cPathName)
*-------------------------------------------------------------------------------
local cDrive ,cOut
cDrive := curDrive()
cOut:= strTran(cPathName,cDrive ,"")
return cOut


*-------------------------------------------------------------------------------
function fileclean(cFile)
*-------------------------------------------------------------------------------
//-- estrae da un nome file DOS completo di percorso
//   il nome del file con la sola estensione
//
return filebase(cFile)+fileext(cFile)


*-------------------------------------------------------------------------------
function FileBase( cFullFileName, noSlash )
*-------------------------------------------------------------------------------
//-- noSlash elimina slash finale se presente
LOCAL cBase ,nPosition
cBase = ""
nPosition = 0

if not empty( cFullFileName )
   nPosition = RAt( "\", cFullFileName )
   if nPosition > 0
      cBase = subs( cFullFileName, nPosition+1, len(cFullFileName)-nPosition )
   else
      cBase = cFullFileName
   endif
   nPosition = RAt( "/", cFullFileName )
   if nPosition > 0
      cBase = subs( cFullFileName, nPosition+1, len(cFullFileName)-nPosition )
   else
      cBase = cFullFileName
   endif
   nPosition =  at( ".", cBase )
   if nPosition > 0
      cBase = subs(cBase,1,nPosition-1)
   endif
   if empty(cBase)
      cBase = cFullFileName
   endif
   if pcount()>0
      if right(cBase,1)="\"
         cBase := trimRight(cBase,1)
      endif
   endif
endif
RETURN cBase


*-------------------------------------------------------------------------------
function filefolder(cFullFileName )
*-------------------------------------------------------------------------------
return (filename(filebase(cFullFileName )))


*-------------------------------------------------------------------------------
function FileName( cFullFileName )
*-------------------------------------------------------------------------------
local cBase,nPosition
cBase := ""
nPosition := RAt( "\", cFullFileName )

if not empty( cFullFileName )
	if nPosition > 0
      cBase = subs( cFullFileName, nPosition+1, len(cFullFileName)-nPosition )
   else
      cBase = cFullFileName
   endif
endif
return cBase


*-------------------------------------------------------------------------------
function FilePath( cFullFileName, lNoDrive )
*-------------------------------------------------------------------------------
LOCAL cPathName, nPosition

lNoDrive :=.t.
if pcount()=1
   lNoDrive := .f.
endif

cPathName := ""
nPosition := 0

cPathName := alltrim(cFullFileName)
if not empty( cPathName )
  do while .t.
     nPosition := RAt( "\", cPathName )
     if nPosition > 0
        cPathName := Left( cPathName, nPosition )
     endif
     nPosition :=  at( ".", cPathName )
     if nPosition > 0
        cPathName = Left( cPathName, nPosition-1 )
     else
        exit
     endif
   enddo
   *
   if lNoDrive
      nlen := len(cPathName)
      cPathName := subs(cPathName,3,nLen-2)
   endif
endif
RETURN cPathName


*-------------------------------------------------------------------------------
function fileBone( cFile )
*-------------------------------------------------------------------------------
//-- ritorna l'ossatura del nome del file (niente path, niente estensione)
local cExcl, cOut
cExcl := filepath(cFile)
cOut  := filebase(cFile)
cOut  :=  strTran(cOut,cExcl,"")
return cOut


//---------------------------------------------
function fileExt(cFilename)
//---------------------------------------------
cFilename:= wordRight(cFilename,".")
return alltrim(cFilename)

//---------------------------------------------
function fileSource(cFile,nLineLen)
//---------------------------------------------
//-- visualizza il contenuto di un file di testo (di solito un PRG)
//   con numero di riga
//
if pcount()=1
  nLineLen := 128
endif

nHandle   := fopen(cFile)
nLastByte := fseek(nHandle,0,2)
cChunk := ""
nFirstByte := fseek(nHandle,0,0)
nThisPos   := fseek(nHandle,0,1)
rrr := 0
do while nThisPos < nLastByte
   rrr++
   ? str(rrr,5,0,"0")+": " + cChunk
   cChunk   := freadstr(nHandle,nLineLen, chr(10))
   nThisPos := fseek(nHandle, nThisPos+len(cChunk)+1, 0)
enddo
fclose(nHandle)
return ""


*************************
function isDir(cFolder)
*************************
local lRes :=.f.
if right(cFolder,1)="\"
   cFolder := trimRight(cFolder,1)
endif
if file(cFolder)
   lRes := .t.
endif
return lRes

**********************************
function createDir(cPath)
**********************************
local aFolders, iii, cDrive
local nPos:= 0, cTest := cPath
local nnn := 0, lOk := .f.

declare aFolders[1]
aFolders[1] := cPath
cDrive := subs(cPath,1,at(":",cPath))
do while nnn < 10
   nPos := rat("\",cTest)
   cTest := subs(cTest,1,nPos-1)
   if cTest == cDrive
      exit
   else
      agrow(aFolders,1)
      aFolders[len(aFolders)] := cTest
   endif
   nnn++
enddo
for iii=len(aFolders) to 1 step -1
   if not isDir( aFolders[iii])
      *? "BUILDING FOLDER " | aFolders[iii]
      md(aFolders[iii])
   endif
next
return isDir(cPath)




***********************************************
function listFiles(cThisFolder,cMask)
***********************************************
local nnn,iii,cThis,cOut:=""
$extended
if type(cMask)="U"
   cMask := "*.*"
endif
nnn = adir( cThisFolder+"\"+cMask, aFName, aFSize, aFDate, aFTime, aFAttr )
declare aFiles[nnn]
for iii = 1 to nnn
   cThis := aFName[iii]
   if aFSize[iii]>0  //-- we want only files
      cThis :=  fixslash(aFName[iii])
      if not (left(cThis,1) $ "._" or right(cThis,1)=".")
            ? ">" | cThis | "<"
            aadd(aFiles,cThis)
      endif
   endif
next 
if nnn=0
   cOut := "No files found."
else
   *cOut := atos(afiles)
   for uuu=1 to len(afiles)
      *? uuu | " " | type(uuu) | " " | afiles[uuu]
   next
endif
return cOut

******************************************
function listFolders(cThisDir,xFlag)
******************************************
local nnn,iii,cThis,lOk, cOut, cLst
lOk := type(lRetArr)
cOut :="*" + cThisDir + "*"
cLst := ""
$extended
nnn = adir( cThisDir+"\*.", aDirName, aDirSize, aDirDate, aDirTime, aDirAttr )
for iii = 1 to nnn
   cThis := filename(aDirName[iii])
   if aDirSize[iii]=0  //-- we want only folders
      if not ( right(cThis,1)="." or left(cThis,1)="_" )
         cOut +="*" + cThis + "*"
         cLst+='<delim><a class="xlst" href="' + dos2web(aDirName[iii]) + '">'+plainPath(aDirName[iii])+'</a></delim>'
      endif
   endif
next 
do case
case type(xFlag)="U"
   return atos(aDirName)  //-- names between asterisks
case zz(xFlag)="1"
   return cOut    //-- default: names between square brakets
case zz(xFlag)="2"
   return nnn   //-- number of folders
case zz(xFlag)="3"
   return cLst  //-- an HTML string with all links
endcase
return .f.


***********************************************************************
function storage(any)
***********************************************************************
//-- returns the database storage position
// if any parameter passed then returns a string representing
// the total of databases plus the storage position
//
local cOut,nnn,iii,vvv:=0
local aD3Name, aD3Size, aD3Date, aD3Time, aD3Attr
cOut:= mspconfigvar("DATADIR")
if pcount()=0
   return cOut
else
$extended
nnn = adir( cOut+"\*.", aD3Name, aD3Size, aD3Date, aD3Time, aD3Attr )
for iii = 1 to nnn
   if aD3Size[iii]=0
      vvv++
   endif
   next 
endif
return(ltrim(str(vvv)) + " databases in " + cOut)


*****************************
function dirName(cFullpath)
****************************
local nPos
if right(cFullPath,1)="\"
   cFullPath := trimRight(cFullPath,1)
endif
nPos := rat("\", cFullPath)
return trimLeft(cFullPath,nPos)




******************************
function plainPath(cPath)
**************************
local c1, c2
cPath := dirName(cPath)
c1 := fixslash(cPath)
c1 := filebone(c1)
c2 := upper(trimRightAt(c1,"\"))
if empty(c2)
   return(cPath)
endif
return strTran(c2,"\","")

*-------------------------------------------------------------------------------
function dir( cLink )
*-------------------------------------------------------------------------------
//-- se passato cLink e contiene | viene sostituito con il filename della tabella
* Esempio:
* cLnk := "/apps/assistant/browse-edit.msp?VAR_TABLE=|"
* <%=dir(cLnk)%>
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

*************************************************
function file2str(cFile)
*************************************************
//-- reads a file and return all the content as a string of only one line
//   adapted to be passed to javascript function escape()
///
if not file(cFile)
   return "File [" + cFile + "] not found!"
endif
cOut :=""
cExclude   := chr(10)+chr(13) + chr(10)
cBuffer    := fopen(cFile)
nLastByte  := fseek(cBuffer,0,2)
nFirstByte := fseek(cBuffer,0,0)
nThisPos   := fseek(cBuffer,0,1)
rrr := 0
do while nThisPos < nLastByte
   rrr++
   xVal := freadstr(cBuffer,1)
   //cOut += str(asc(xVal),4,0,"0")+":"   
   if xVal $ cExclude
      if xVal = " "
         cOut += " "
      endif
   else
      cOut += xVal
   endif
   if rrr > 9
      rrr:=0
   endif
   nThisPos++
enddo
fclose(cBuffer)
return cOut


*--- eof
