**************************************************************
**  
**************************************************************
**  DBMAX 2.5 - LIBRARY MODULE (derived from DBFree 3.0.1)
**  (c) by G.Napolitano
**
**  Project start: Prato 4 ott 2013
**  vers. 0.0.1 - Prato 05 ott 2013
**  vers. 0.0.4 - Prato 20 nov 2013
**
**************************************************************
#define CR_LF chr(13)+chr(10)

//------------------------------------------------------
function container(flag)
//------------------------------------------------------
local cOut
flag := iif(type(flag)="U",1,0)
if flag=1
   cOut :=[<div class="container">]+CR_LF
else
   cOut := [</div><!-- end container //-->]+CR_LF
endif
return cOut

//------------------------------------------------------
function well(flag)
//------------------------------------------------------
local cOut
cOut := iif(type(flag)="U",'<div class="well">','</div><!-- end well //-->')
return cOut


//------------------------------------------------------
function navbar(cOption,cMsg)
//------------------------------------------------------
local cOut :=""
if type(cMsg)="U"
   cMsg := ""
endif
if type(cOption)="U"
   cOption=upDir(curDosDir())
endif
if type(cOption)="N"
   cOption := zz(cOption)
endif

do case
case cOption = "0"
   cOption=curDosDir()
case cOption = "1"
   cOption=upDir(curDosDir())
otherwise
   cOption := fixslash(cOption)
endcase

cOut += [<!-------------------------------- NAVBAR(]+zz(cOption)+[,]+zz(cMsg)+[) //------------------------------//-->]+CR_LF
cOut += [<div class="heading" style="margin-top:4px;">]+CR_LF      
cOut += [<div class="row" style="margin-top:0px;">]+CR_LF
cOut += [<div class="col-sm-6 col-md-6">]+CR_LF
cOut += [<font color="gray">]+cMsg+[</font></div>]+CR_LF
cOut += [<div class="col-sm-6 col-md-6" align="right">]+CR_LF
cOut += [<a href="]+link2menu(cOption)+[" title="" class="btn btn-primary">Back</a>]+CR_LF
cOut += [</div></div></div>]+CR_LF
return cOut


//----------------------------------------------------------------------------
function box(cId, cTitle, cText, cImg, cLink, cFrame, cLabel, cClass, cStyle)
//----------------------------------------------------------------------------
//-- 1=div id (string)
//   2=panel title (string)
//   3=content text (string)
//   4=image file (url)
//   5=file link (url)
//   6=frame to use (name)
//   7=text for button
//   8=columns class for page layout (default 3col)
//   9=style to apply (string w/o delimiters)
local cOut, cTmp, cStr
cOut :=""
if type(cId)="U"
   cId := "div_box"
endif
cTitle := iif(type(cTitle)="U","P2-MyTitle",cTitle)
cText  := iif(type(cText)="U","P3-MyText",cText)
cImg   := iif(type(cImg)="U","",cImg)
cLink  := iif(type(cLink)="U","P5-MyLink",cLink)
cFrame := iif(type(cFrame)="U","_self",cFrame)
cLabel := iif(type(cLabel)="U","P7-MyLabel",cLabel)
cClass := iif(type(cClass)="U","col-sm-4 col-md-3",cClass)
cStyle := iif(type(cStyle)="U","",cStyle)

cOut += [<!-- ---- BOX ] + cId + [//-->]+CR_LF
cOut += [<div id="]+cId+[" class="]+ cClass +[">] 
cOut += [<div class="panel panel-default" style="] + cStyle + [">]
cOut += [<div class="panel-body" style="margin-top:-10px;">]
cOut += [<a href="]+cLink+[" target="">]
cOut += [<img class="thumbnail" align="left" style="margin-right:15px" src="]+cImg+["></a>]
cOut += cTitle     
cOut += [</div><div class="panel-body">]+cText+[</div>]
cOut += [<div class="panel-footer">]      
cOut += [ <p align="right"><a href="]+cLink+[" class="btn btn-primary" target="]+cFrame+[">]+cLabel+[</a></4>]
cOut += [</div></div></div>]
cOut += CR_LF + [<!-- ---- END BOX ----//-->]
return cOut






*--eof
