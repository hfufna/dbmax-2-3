**************************************************************
**  
**************************************************************
**  DBMAX 2.5 - LIBRARY MODULE (derived from DBFree 3.0.1)
**  (c) by G.Napolitano
**
**  Project start: Prato 4 ott 2013
**  vers. 0.0.1 - Prato 05 ott 2013
**  vers. 0.0.2 - Prato  
**
**************************************************************
#define CR_LF chr(13)+chr(10)



****************************
function firstDoM(NumOrDate)
****************************
local nMM,nYY
//-- return a calendar date data type with first day of month
local nMM, nYY
if pcount()=0
   NumOrDate := month(date())
endif
if type(NumOrDate)="D"
   nMM := month(NumOrDate)
   nYY := year(NumOrDate)
else
   nMM := NumOrDate
   nYY := year(date())
endif
return  ctod("01/" + zz(nMM) + "/" + zz(nYY))

****************************
function lastDoM(NumOrDate)
****************************
local nDD,nMM,nYY, cTyp, cOut
//-- return a calendar date data type with last day of month
if pcount()=0
   NumOrDate := month(date())
endif
cTyp := type(NumOrDate)

if cTyp = "C"
   NumOrDate := ctod(NumOrDate)
endif
do case
case cTyp = "D"
   nMM := month(NumOrDate)
   nYY := year(NumOrDate)
case cTyp = "N"
   nMM := NumOrDate
   nYY := year(date())
endcase

declare aMd[12]
aMd[1]:=31
aMd[2]:=28
aMd[3]:=31
aMd[4]:=30
aMd[5]:=31
aMd[6]:=30
aMd[7]:=31
aMd[8]:=31
aMd[9]:=30
aMd[10]:=31
aMd[11]:=30
aMd[12]:=31
nDD := aMd[nMM]
cOut := nDD | "/" | nMM | "/" | nYY
return ctod(cOut)


*******************************
function lastDayOfM(NumOrDate)
*******************************
local nMM
//-- return the number of last day of month
if pcount()=0
   nMM:= month(date())
endif
if type(NumOrDate)="D"
   nMM:= month(NumOrDate)
else
   nMM:=NumOrDate
endif
declare aMd[12]
aMd[1]:=31
aMd[2]:=28
aMd[3]:=31
aMd[4]:=30
aMd[5]:=31
aMd[6]:=30
aMd[7]:=31
aMd[8]:=31
aMd[9]:=30
aMd[10]:=31
aMd[11]:=30
aMd[12]:=31
return aMd[nMM]

*************************
function lastDoY(nYear)
*************************
//-- return a calendar date data type with the last day of the year
return ctod("31/12/" + zz(year(date())))

*************************
function firstDoY(nYear)
*************************
//-- return a calendar date data type with the last day of the year
return ctod("01/01/" + zz(year(date())))

*************************
function monthName(nnn)
*************************
declare aMo[12]
aMo[1] := "January"
aMo[2] := "February"
aMo[3] := "March"
aMo[4] := "April"
aMo[5] := "May"
aMo[6] := "June"
aMo[7] := "July"
aMo[8] := "August"
aMo[9] := "September"
aMo[10] := "October"
aMo[11] := "November"
aMo[12] := "December"
return aMo[nnn]

********************************
function daysFrom( date1,date2)
********************************
//-- days past from
local nDD, cDD
if pcount()=0
   cDD := "01/01/" | year(date())
   nDD := date()-ctod(cDD)
   return nDD
endif
if type(date2)="U"
   date2 := date()
endif
nDD := date1-date2
return nDD

**********************
function daysOfM(date1)
**********************
//-- days of month
local cMM, lLap
if pcount()=0
   date1 := date()
endif
cMM := str(month(date1),2,0,"0")
do case
 case cMM  $ "04 06 09 11"
    return 30
 case cMM = "02"
    ** if lapYear()
    **    return 29
    ** endif
    return 28
 otherwise
    return 31
endcase
return

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
//-- cParam defines the output type:
//   H=time, M=month, 
//
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

*******************************
function dayStr(dDate, cLang)
*******************************
local cDD, nDD, nMM, nYY, cOut
ainit("aXXDS","Sunday","Monday","Thursday","Wednesday","Tuesday","Friday","Saturday")
ainit("aXXMS","January ","February","March","April","May","June","July","August","September","October","November","December")
nDD := dow(dDate)
nMM := month(dDate)
nYY := year(dDate)
cDD :=  aXXDS[nDD]
cMM := aXXMS[nMM]
cOut := cDD + " " + zz(nDD) + " " + cMM + " " + zz(nYY)
return cOut

****************************
function dayOfW(dDate)
****************************
local aXXDS, nDD
nDD := dow(dDate)
ainit("aXXDS","Sunday","Monday","Thursday","Wednesday","Tuesday","Friday","Saturday")
cDD := aXXDS[nDD]
return cDD

******************************
function timeDiff(cStr1,cStr2)
******************************
local nHour,cVal1,cVal2
if not left(upper(cStr1),2) $ "AMPM"
   nHour := val(left(cStr1,2)) 
   cStr1 := cStr1 +" "+iif(nHour>=12,"pm","am")
endif

if not left(upper(cStr2),2) $ "AMPM"
   nHour := val(left(cStr2,2)) 
   cStr2 := cStr2 +" "+iif(nHour>=12,"pm","am")
endif
return elaptime(cStr1,cStr2)

**************************************************
function CtimeDiff(cTime1,cTime2)
**************************************************
local c1,c2,h1,h2,m1,m2
c1 := zz(cTime1)
c2 := zz(cTime2)
h1 := val(left(c1,2))
h2 := val(left(c2,2))
m1 := val(subs(c1,4,2))
m2 := val(subs(c2,4,2))
if h2<h1
   h2 += 24
endif
nnn := (h2*60+m2)-(h1*60+m1)
return zz(int(nnn/60))+":"+zz(mod(nnn,60))


*-------------------------------------------------------------------------------
function itMonth(dDate, lFullname)
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
   cOut := cMese
endif
return cOut

*******************************
function week(dThis)
*******************************
//-- returns the number of the week based on the date
//   passed as parameter: weeks go from 1 to 53
//   starting from january 1
//   nMode=1 week starts from sunday (default no)
//
local dFirst, nNum
dFirst := ctod("01/01/" + zz(year(dThis)))
nNum := daysFrom( dThis,dFirst)
nNum := int(nNum/7)+1
return nNum

*--eof




