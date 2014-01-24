var leftbar = {
    speed: 5, // velocità in px/frame
    x: 0,
    y: 0,
    width: 10,
    height: 20,
     
    draw: function(ctx) {
            // disegnamo la barra sinistra
            ctx.fillStyle = "#fff";
            ctx.fillRect(this.x, this.y, this.width , this.height);
          }
};
 
var ball = {
     
    speed: 5,
    x:0, y:0,
    radius:5,
     
    // direzione, inizialmente casuale
    angle: Math.random() * Math.PI * 2,
     
    draw: function(ctx) {
            // disegnamo la barra sinistra
            ctx.fillStyle = "#fff";
            ctx.beginPath();  
            ctx.arc(this.x, this.y, this.radius, 0, Math.PI*2, false);  
            ctx.closePath();  
            ctx.fill(); 
          },
           
    move: function(ctx) {
            this.x += Math.cos(this.angle) * this.speed;
            this.y += Math.sin(this.angle) * this.speed;
          }
};

// inizializzazione
document.addEventListener("DOMContentLoaded", function() {
    console.log("Documento caricato!"); // debugmsg
     
     
    // Recupero del contesto 2D dell'elemento canvas
    var canvas = document.getElementById("gamecanvas"),
        ctx = canvas.getContext("2d");
     
    console.log("contesto 2d acquisito: " + ctx);
     
    // altezza e larghezza della finestra
    var W = window.innerWidth, 
        H = window.innerHeight;
         
    canvas.width  = W;
    canvas.height = H;      
         
    // posizionamento delle barrette
    leftbar.x = Math.ceil(W/100*2);
    rightbar.x = Math.ceil(W/100*98);
    leftbar.y = rightbar.y = Math.ceil(H/2 - leftbar.height/2);
    leftbar.width = rightbar.width = Math.ceil(W/100*1); // barretta larga il 2% dello schermo
    leftbar.height = rightbar.height = Math.ceil(H/100*15); // barretta alta il 10% dello schermo
     
    // posizionamento iniziale della palla
    ball.x =  Math.ceil(W/2);
    ball.y =  Math.ceil(H/2);
    ball.radius = Math.ceil(W/100*1);
     
     
    function render() { 
     
        // puliamo lo sfondo
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, W, H);
        console.log("puliamo lo sfondo");
         
         
        // disegnamo gli oggetti
        leftbar.draw(ctx);
        rightbar.draw(ctx);
         
        // controlla le collisioni con i bordi
        if ((ball.y-ball.radius < 0) || (ball.y+ball.radius > H))
            ball.angle = 2*Math.PI - ball.angle; 
                 
        // aggiorna la posizione della palla
        ball.move(ctx);
         
        // if (ball.collide(leftbar)) console.log('collisione con leftbar');
        // if (ball.collide(rightbar)) console.log('collisione con rightbar');
         
        ball.draw(ctx);     
    }
     
    // primo disegno della scena
    render();
         
    // elaborazione degli eventi della tastiera
    window.onkeydown = function(event) {
         
        switch (event.which) {
        case 38:
            leftbar.y -= leftbar.speed;
            break;
        case 40:
            leftbar.y += leftbar.speed;
            break;
        default:
            return; // evita di restituire false
        }
        return false;
    };
     
     
     
    // impostazione del loop
    var then = Date.now(); // timestamp iniziale
    setInterval(mainLoop, 50); 
    // la scelta dei 50 ms è per non intasare troppo il processore nel test
    // si può anche mettere 1ms 
     
     
    function mainLoop()
    {
        // timestamp in ms (tempo passato da1l' 1/1/1970 alle 00:00)
        var now = Date.now();
        // differenza tra il momento attuale e il ciclo appena precedente
        var delta = now - then;
        render();
 
        then = now;
    }
     
});
