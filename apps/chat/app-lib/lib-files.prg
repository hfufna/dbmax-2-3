**************************************************************
**
**  DBMAX->DBFREE 2.0 - FILE HANDLING LIBRARY
**
**  Progetto iniziato a Prato il 10 ago 2010
**
**  vers. 0.0.2 - Prato 29 set 2010
**  vers. 0.0.3 - Prato 02 ott 2010
**  vers. 0.0.4 - Prato 21 Dic 2010
**
**************************************************************

#define CR_LF chr(13)+chr(10)


*-------------------------------------------------------------------------------
function curDosDir(lNoDrive)
*-------------------------------------------------------------------------------
local cTxt,cName
cTxt  := here()
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
cDirLink := strTran(cFile,cDocRoot,"")
cDirLink := fixSlash(cDirLink)
cDirLink := strTran(cDirLink,"\","/")
return cDirLink


*-------------------------------------------------------------------------------
function web2dos(cFile)
*-------------------------------------------------------------------------------
//-- trasforma un percorso web in percorso dos
//   a partire dalla document root del server web
//
if not empty(cFile)
   cFile := rslash(here()) + fileclean(cFile)
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
FUNCTION FileBase( cFullFileName, noSlash )
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
function fileSource(cFile)
//---------------------------------------------
nHandle   := fopen(cFile)
nLastByte := fseek(nHandle,0,2)
cChunk := ""
nFirstByte := fseek(nHandle,0,0)
nThisPos   := fseek(nHandle,0,1)
rrr := 0
do while nThisPos < nLastByte
   rrr++
   ? str(rrr,5,0,"0")+": " + cChunk
   cChunk   := freadstr(nHandle,132, chr(10))
   nThisPos := fseek(nHandle, nThisPos+len(cChunk)+1, 0)
enddo
fclose(nHandle)
return ""
