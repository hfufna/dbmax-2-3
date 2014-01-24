
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  http=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  http=new ActiveXObject("Microsoft.XMLHTTP");
  }

function createObject() {
	var req_type;
	var browser = navigator.appName;
	if(browser == "Microsoft Internet Explorer"){
		req_type = new ActiveXObject("Microsoft.XMLHTTP");
	}else{
		req_type = new XMLHttpRequest();
	}
	return req_type;
}


function setCookie(name, value) {
	var exdate=new Date();
	exdate.setDate(exdate.getDate() + 360);
	var c_value=escape(value) +" ;     expires="+exdate.toUTCString()+";";
	document.cookie=name + "=" + c_value;
    //var cookieString = name + "=" +escape(value); 
    //document.cookie = cookieString;
}	

function getCookie( name ) {
   var start = document.cookie.indexOf(name+"=");
   var len = start+name.length+1;
   if ((!start) && (name != document.cookie.substring(0,name.length))) return(null);
   if (start == -1) return(null);
   var end = document.cookie.indexOf(";",len);
   if (end == -1) end = document.cookie.length;
   return(unescape(document.cookie.substring(len,end)) );
}
function deleteCookie(name) {
   if (getCookie(name)) document.cookie = name ;
}	