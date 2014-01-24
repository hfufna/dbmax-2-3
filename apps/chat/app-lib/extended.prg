**************************************************************
**
**  DBMAX->DBFREE 2.0 - DBF EXTEND FUNCTIONS LIBRARY
**
**  Progetto iniziato a Prato il 10 ago 2010
**
**  vers. 0.0.3 - Prato 02 ott 2010
**
**************************************************************

#define CR_LF chr(13)+chr(10)
$extended

*-------------------------------------------------------------------------------
function fieldNum(cStr)
*-------------------------------------------------------------------------------
//-- ritorna la posizione di un campo fornendo il nome
//   Uso: nPos := fieldNum(cFldName)
//
local ttt,mmm,aaa
ttt := aFields(aaa)
mmm := ascan(aaa,cStr)
return mmm

*-------------------------------------------------------------------------------
function fieldList(xVal)
*-------------------------------------------------------------------------------
//-- se si passa un array come parametro lo riempie con i nomi dei campi
//   e restituisce il numero di campi esistenti
//   altrimenti restituisce una stringa con i nomi separati da virgole
//   Uso: 
//   ainit("myArray","")
//   fieldlist(myArray)
//
local xFldLst,iii
if type(xVal)="A"
   nnn := aFields(xVal)
   return nnn
else
   cOut :=""
   nnn := aFields(xFldLst)
   for iii=1 to nnn
       cOut += zz(xFldLst[iii]) +","
   next
   if right(cOut,1)=","
      cOut := trimRight(cOut,1)
   endif
endif
return cOut
