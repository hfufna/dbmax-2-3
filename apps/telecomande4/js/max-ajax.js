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
