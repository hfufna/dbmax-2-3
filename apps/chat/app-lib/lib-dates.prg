**************************************************************
**
**  DBMAX->DBFREE 2.0 - CALENDAR DATES LIBRARY
**
**  Progetto iniziato a Prato il 10 ago 2010
**
**  vers. 0.0.2 - Prato 29 set 2010
**  vers. 0.0.3 - Prato 02 ott 2010
**  vers. 0.0.4 - Prato 21 mar 2011
**
**************************************************************


#define CR_LF chr(13)+chr(10)

*-------------------------------------------------------------------------------
function nowstr()
*-------------------------------------------------------------------------------
local cDate,cTime,cOut
cDate = dtoc(date())
cTime = time()
cOut = "20" + subs(cDate,7,2) + subs(cDate,4,2)+subs(cDate,1,2) + "-" + subs(cTime,1,2)+"."+subs(cTime,4,2)+"."+subs(cTime,7,2)
return cOut



*-------------------------------------------------------------------------------
function timestamp( cParam )
*-------------------------------------------------------------------------------
local cOut, cTime
if pcount()=0
   cParam := "T"
endif
cParam := upper(cParam)
*
cOut :="" 
c1 := str( year(date()),4,0,"0")
c2 := str( month(date()),2,0,"0")
c3 := str( day(date()),2,0,"0")

cOut := c1+c2+c3
cTime := time()
do case
   case cParam = "H"
     cOut += "-" + subs(time(),1,2)
     *
   case cParam = "M"
     cOut += "-" + subs(time(),1,5)
     *
   case cParam = "S"
     cOut += "-" + time()
     *
   case cParam = "T"
     cOut = dtoc(date()) + " - " + left(time(),5)
     *
   case cParam = "D"
     cOut = "" + str(year(date()),4,0,"0") + "." + str(month(date()),2,0,"0") + "." + str(day(date()),2,0,"0")
     *
   case cParam = "I"
     cOut = "" + str(day(date()),2,0,"0") +"-"+ str(month(date()),2,0,"0") 
     cOut +=  "-" + str(year(date())) + "_"+left(time(),2)+"_"+subs(time(),4,2)
     *
   case cParam = "C"
     cOut = str(year(date()),4,0,"0") + "-" + str(month(date()),2,0,"0") + str(day(date()),2,0,"0")
     cOut += "-" + left(time(),2)+subs(time(),4,2)
     cOut += "-" + left(str( int(seconds())),2)
   otherwise

endcase
cOut := strTran(cOut,".","-")
cOut := strTran(cOut," ","")
cOut := strTran(cOut,":","")

return cOut

*-------------------------------------------------------------------------------
function itDow(ddd, lFullname)
*-------------------------------------------------------------------------------
local aDays, nDay, cOut
lFullname := iif(pcount()=2,.t.,.f.)
nDay  := dow(ddd)
cOut  := " "
if nDay > 0
   declare aDays[7]
   aDays[1] := "Domenica"
   aDays[2] := "Lunedi"
   aDays[3] := "Martedi"
   aDays[4] := "Mercoledi"
   aDays[5] := "Giovedi"
   aDays[6] := "Venerdi"
   aDays[7] := "Sabato"
   cOut := aDays[nDay]
   if not lFullname
      cOut := left(cOut,3)
   endif
endif
return cOut 

*-------------------------------------------------------------------------------
function itDate(dDate, lFullname)
*-------------------------------------------------------------------------------
local aMesi, nMese, cOut, cMese
lFullname := iif(pcount()=2,.t.,.f.)
nMese := month(dDate)
cOut  := " "
if nMese > 0
   declare aMesi[12]
   aMesi[1]  := "Gennaio"
   aMesi[2]  := "Febbraio"
   aMesi[3]  := "Marzo"
   aMesi[4]  := "Aprile"
   aMesi[5]  := "Maggio"
   aMesi[6]  := "Giugno"
   aMesi[7]  := "Luglio"
   aMesi[8]  := "Agosto"
   aMesi[9]  := "Settembre"
   aMesi[10] := "Ottobre"
   aMesi[11] := "Novembre"
   aMesi[12] := "Dicembre"
   cMese := aMesi[nMese]
   if ! lFullname
      cMese = left(cMese,3)
   endif
   cOut := str(day(dDate),2,0,"0") + " " + cMese + " " + str(year(dDate),4,0)
endif
return cOut


*--------------------------------------------------
function optMonthIt(dDate)
*--------------------------------------------------
*-- ritorna una stringa coi mesi da usare come option html
local nnn, nMese, nFirst, nLast, aMesi, cTxt
declare aMesi[12]
   aMesi[1]  := "Gennaio"
   aMesi[2]  := "Febbraio"
   aMesi[3]  := "Marzo"
   aMesi[4]  := "Aprile"
   aMesi[5]  := "Maggio"
   aMesi[6]  := "Giugno"
   aMesi[7]  := "Luglio"
   aMesi[8]  := "Agosto"
   aMesi[9]  := "Settembre"
   aMesi[10] := "Ottobre"
   aMesi[11] := "Novembre"
   aMesi[12] := "Dicembre"

nFirst := month(dDate)
nLast  := nFirst + 6
cTxt :=""
for nnn = nFirst to nLast
    nMese := nnn
    if nMese > 12
       nMese := nMese-12
    endif
    cTxt += '<option>' + aMesi[nMese] + '</option>'
next
return cTxt

*-------------------------------------------------
function optDay(nDay)
*-------------------------------------------------
local cTxt,iii
cTxt := ""
if type(nDay)="C"
   nDay:=val(nDay)
endif
for iii = 1 to 31
   cTxt += "<option>" + str(iii,2,0,"0") + "</option>"
next

if pcount() = 0
   cTxt += "<option selected>" + str(day(date()),2,0,"0") + "</option>"
elseif pcount()=1
   cTxt += "<option selected>" + iif(nDay=0,"",str(nDay,2,0,"0")) + "</option>"
endif
return cTxt


*-------------------------------------------------
function optMonth(nMonth)
*-------------------------------------------------
local cTxt,iii
if type(nMonth)="C"
   nMonth :=val(nMonth)
endif
cTxt := ""
for iii = 1 to 12
   cTxt += "<option>" + str(iii,2,0,"0") + "</option>"
next
if pcount() = 0
   cTxt += "<option selected>" + str(month(date()),2,0,"0") + "</option>"
elseif pcount()=1
   cTxt += "<option selected>"+ iif(nMonth=0,"",str(nMonth,2,0,"0")) + "</option>"
endif
return cTxt

*-------------------------------------------------
function optYear(nYear, nDig)
*-------------------------------------------------
local cTxt, iii, nDigit, ccc, nnn
cTxt := ""
if type(nYear)="C"
   nYear:=val(nYear)
endif

if pcount() > 1
   nDigit := iif(nDig=2,2,4)
else
   nDigit := 2
endif
dStart := date()

if pcount() = 0
   nnn := year(dStart )
   cTxt += "<option selected>" + right(str(nnn),nDigit) + "</option>"
else
   cTxt += "<option selected>"+ iif(nYear=0,"",right(str(nYear),nDigit)) + "</option>"
endif

for iii = 2004 to year(date())+4
   cTxt += "<option>" + right(str(iii,4),2) + "</option>"
next
return cTxt

*-------------------------------------------------------------------------------
function chrDate(dDate)
*-------------------------------------------------------------------------------
return itDow(dDate) + " " + itDate(dDate)


//----------------------------------
function itDateStr(dDate)
//----------------------------------
return itDow(dDate) + " " + itDate(dDate)


****************************
function isLeapYear(dDate)
****************************
local lOk, nYear
lOk := .f.
nYear := year(dDate)
if mod(nYear,4)=0
   lOk :=.t.
endif
return lOk

****************************
function daysOfMonth(nMonth)
****************************
local cKey, nDays
cKey := str(nMonth,2,0,"0")
do case
case cKey $ "02 "
   nDays := 28
case cKey $ "11 04 06 09"
   nDays := 30 
otherwise
   nDays := 31
endcase
return nDays
*--eof




