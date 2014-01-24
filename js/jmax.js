/*
       DBMax 2.5
       JMAX javascript Library

       To embed the code into a page use this code:       
       <script type="javascript"><%=include("/js/jmax.js")%></script>

*/

///////////////////////////////////////////


function ajaxRun( cMaxPage, cParam, cTarget) {
var aa=cTarget;
var bb=cMaxPage+cParam;

if (cParam.length==0)
  { 
  document.getElementById(cTarget).innerHTML="";
  return;
  }
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    document.getElementById(cTarget).innerHTML=xmlhttp.responseText;
    //document.all[cTarget].innerHTML=xmlhttp.responseText;
    }
  }
xmlhttp.open("GET", bb, true);
xmlhttp.send();
}



///////////////////////////////////////
function showDiv(cDiv,nVisib){
var aa = cDiv;
var bb = document.getElementById(aa);
if (nVisib == 1)
   {
    bb.style.display='block';
   }
else if (nVisib == 0)
   { 
    bb.style.display='none';
   }
}

////////////////////////////////////////
function toggleDiv(cDiv){
var aa = cDiv;
var bb=document.getElementById(aa);
if (bb.style.display == 'block')
   {
   bb.style.display='none';
   }
else if (bb.style.display == 'none')
   { 
   bb.style.display='block';
   }
}

//////////////////////////////////////////
function toggleSelDivs(nstart,nend)
//-- toggles all divs matching the mask DIV_nnn from nstart to nend (default ALL divs)
{
nstart = (nstart===undefined) ? 0 : nstart;
nend = (nend===undefined) ? 99999 : nend ;
var div;
while( ((div = document.getElementById('div_' + nstart)) !== false) && (nstart<nend) )
{
div.style.display = (div.style.display == 'none') ? '' : 'none';
nstart++;
}
}

//////////////////////////////////////////
function hideDivs(cmask,nstart,nend)
//-- hide all divs matching the mask from nstart to nend (default ALL divs)
{
cmask = (cmask===undefined) ? 'div_' : cmask;
nstart = (nstart===undefined) ? 0 : nstart;
nend = (nend===undefined) ? 99999 : nend ;
var div;
while( ((div = document.getElementById(cmask + nstart)) !== false) && (nstart<nend) )
{
div.style.display = 'none';
nstart++;
}
}

////////////////////////////////////////////
function curWidth() {
var ww;
if( window.innerWidth ) 
   {    ww = window.innerWidth;    } 
else if (document.documentElement && document.documentElement.clientWidth != 0) 
    {    ww = document.documentElement.clientWidth ;     } 
else if (document.body) 
    {    ww = document.body.clientWidth;    }
return ww;
}

////////////////////////////////////////////
function curHeight() {
var hh;
if( window.innerHeight ) 
   {    hh = window.innerHeight;    } 
else if (document.documentElement && document.documentElement.clientHeight != 0) 
    {    hh = document.documentElement.clientHeight ;     } 
else if (document.body) 
    {    hh = document.body.clientHeight;    }
return hh;
}

/////////////////////////////
function showAllDivs(argc) {
var divs = document.getElementsByTagName("div");
for (var i = 0; i < divs.length; i++) {
ccc = divs[i].id;
if ( ccc.indexOf(argc)!==-1 ) {
//document.writeln(divs[i].id);
divs[i].style.display = 'block';
}
}
}
/////////////////////////////
function hideAllDivs(argc) {
var divs = document.getElementsByTagName("div");
for (var i = 0; i < divs.length; i++) {
ccc = divs[i].id;
if ( ccc.indexOf(argc)!==-1 ) {
//document.writeln(divs[i].id);
divs[i].style.display = 'none';
}
}
}
/////////////////////////////
function toggleAllDivs(argc) {
var divs = document.getElementsByTagName("div");
for (var i = 0; i < divs.length; i++) {
ccc = divs[i].id;
if ( ccc.indexOf(argc)!==-1 ) {
if (divs[i].style.display == 'none') {divs[i].style.display = 'block';}
else
{divs[i].style.display = 'none';}
}
}
}


