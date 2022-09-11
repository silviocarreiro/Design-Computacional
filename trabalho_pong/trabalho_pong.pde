//projeto pong

int E_rectY = 200; //posição inicial retângulo esquerdo
int D_rectY = 200; //posição inicial retângulo direito

int ellX = 350,ellY = 250; //posição inicial do círculo

boolean moveDireita = true, moveBaixo = true; //variáveis booleanas para decidir direções do eixo x e y do círculo 

int velocidadeX = 3, velocidadeY = 3; //variáveis para velocidade do círculo no eixo X e Y.

int pontosD=0, pontosE=0; //variaveis para guardar placar

PFont font; //fonte das letras do placar

void setup(){
size(700,500);
//background(20,20,20);
font = loadFont("AgencyFB-Bold-38.vlw"); //fonte para placar
  
  
}

void draw () {
textFont(font);
background(26,26,26);
//text("teste",310,50);

for(int i=15;i<height;i=i+25){
  fill(170,170,170);
  ellipse(width/2,i,10,10);
}

fill(255,227,84);
noStroke();
ellipse(ellX,ellY,25,25); //círculo
  
fill(255);
rect(30,E_rectY,25,100,5); //retângulo esquerdo
text(pontosE,(width/2)-50,50);

fill(255);
rect(645,D_rectY,25,100,5); //retângulo direito
text(pontosD,(width/2)+34,50);




//parte dos controles que precisa ser alterada
if(keyPressed == true && key == 'w') {
  E_rectY = E_rectY - 6; 
}

if(keyPressed == true && key == 's') {
  E_rectY = E_rectY + 6; 
}

if(keyPressed == true && key == 'i') {
  D_rectY = D_rectY - 6; 
}

if(keyPressed == true && key == 'k') {
  D_rectY = D_rectY + 6; 
}

if (moveDireita == true){
  ellX = ellX + velocidadeX; //círculo se move para a direita
}else{
  ellX = ellX - velocidadeX; //círculo se move para a esquerda
}

if (moveBaixo == true){
  ellY = ellY + velocidadeY; //círculo se move para baixo
}else{
  ellY = ellY - velocidadeY; //círculo se move para cima
}

if(ellY <= 0){
  moveBaixo = true; //move para baixo
}
if(ellY >= height){
  moveBaixo = false; //move para cima
}
if(ellX >= width){
  moveDireita = false; //move para esquerda
  pontosE++;
  ellX = width/2;
  ellY = height/2;
  
}
if(ellX <= 0){
  moveDireita = true; ////move para direita
  pontosD++;
  ellX = width/2;
  ellY = height/2;
}


//interação com retângulo
if(ellX >= 630 && ellY > D_rectY && ellY < (D_rectY +100)){
  moveDireita = false;
  velocidadeX = int(random(2,10));
}
if(ellX <= 60 && ellY > E_rectY && ellY < (E_rectY +100)){
  moveDireita = true;
  velocidadeX = int(random(2,10));

} 


}
