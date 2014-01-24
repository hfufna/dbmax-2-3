////////////////////////////////////////////
function myWW() {
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
function myHH() {
var hh;
if( window.innerHeight ) 
   {    hh = window.innerHeight;    } 
else if (document.documentElement && document.documentElement.clientHeight != 0) 
    {    hh = document.documentElement.clientHeight ;     } 
else if (document.body) 
    {    hh = document.body.clientHeight;    }
return hh;
}


////////////////////////////////////////
function loadModal(cURL,cMsg) {
var ww = myWW() ;
var hh = myHH() ;

document.getElementById('div_modal-body').style.height=''+(hh)+'px';
document.getElementById('div_modal-content').style.width=ww+'px';

document.getElementById('div_modal-title').innerHTML=cURL;
document.getElementById('div_modal-body').src=cURL; 
}

//////////////////////////////////////////////////
function popupFile(cFile,cMsg) {

document.getElementById('div_modal-title').innerHTML=unescape(cMsg);
document.getElementById('div_modal-body').src=cFile; 
}
