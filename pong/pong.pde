import processing.sound.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

// Entrada de audio
AudioIn in;
// Variavel para receber a amplitude do som
Amplitude amp;

float escala; //escala do som

int E_rectY = 200; //posição inicial retângulo esquerdo
int D_rectY = 200; //posição inicial retângulo direito

int ellX = 350,ellY = 250; //posição inicial do círculo

boolean moveDireita = true, moveBaixo = true; //variáveis booleanas para decidir direções do eixo x e y do círculo 

int velocidadeX = 3, velocidadeY = 3; //variáveis para velocidade do círculo no eixo X e Y.

int pontosD=0, pontosE=0; //variaveis para guardar placar

PFont font,font2; //fonte das letras do placar

PImage img;

int sen = 140, nivel_s = 4; //variaveis para sensibilidade
boolean troca_s = false; //variavel booleana para troca de sensisbilidade

boolean rstr_rosto = false; //variavel booleana para tela de rastreamento do rosto
boolean comeca_jogo = false; //variavel booleana para tela tela do jogo
boolean inicio = false; //variavel booleana para o menu

int intervalo = 5; //tempo para o jogo começar deposi que detectou o rosto;
int tempo; //tempo passado;
boolean recomecar = false;
int tempocomeca=0;

int pontosGanhar = 15;

float threshold;
color trackColor;
boolean poder = false;
boolean inicio_poder = false;
boolean jogar_poder = true;

int tempo_poder;
int intervalo_poder = 10;
boolean recomecar_poder = false;

int posicaoX = 60; //poder jogador
int posicaoY;

boolean congelar_adv = false;
int duracao_poder = 4;
int tempo_descongelar;
int tempo_inicial;

int advX = 640;
int advY;

boolean poder_comp = false;
int temp_inicial_adv;
int cooldown_adv = 15;
int tempo_adv;
boolean recomeca_adv;
boolean pos_inicial_adv = true;

boolean congelar_jogador = false;
int temp_ini_congela_jog; 
int tempo_descongela_jog;
int temp_jog_congelado = 4;

void setup(){

  size(700,500);
  //background(20,20,20);
  font = loadFont("AgencyFB-Bold-120.vlw"); //fonte para inicio
  font2 = loadFont("AgencyFB-Bold-38.vlw"); //fonte para jogo
  img = loadImage("falar.png");
  //recebendo a entrada de audio
  in = new AudioIn(this, 0);
  in.play();
  amp = new Amplitude(this);
  amp.input(in);  
  
  //recebendo o video
  //size(640, 480);
  video = new Capture(this, 700, 500);
  opencv = new OpenCV(this, 700, 500);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  trackColor = color(255, 0, 0);
  
  video.start();
}



void draw () {

  if(rstr_rosto==false){ //tela do rastreamento do rosto

    opencv.loadImage(video);
    //image(video, 0, 0 );
  
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    Rectangle[] faces = opencv.detect();

    if(faces.length >= 1){
      if(recomecar == false){
        tempocomeca = int(millis()/1000);
        recomecar = true;
      }
      tempo= (intervalo + tempocomeca) - int(millis()/1000);
      println(tempo);
      if(tempo == 0){
        rstr_rosto = true;
        inicio = true;
      } 
    }
    if(faces.length == 0){
      recomecar = false;
    }
    
    background(26,26,26);
    textFont(font2);
    fill(255);
    textAlign(CENTER);
    text("Posicione seu rosto na frente da câmera para acessar o menu", 100,height/2-80,500,200);
    if(faces.length >= 1){
      fill(255,227,84);
      noStroke();
      ellipse(width/2,300,70,70);
      fill(26,26,26);
      text(tempo,width/2,315);
    }

    scale(2);
  }
  
if(inicio == true){ //tela do menu
  textAlign(LEFT);
  textFont(font);
  background(26,26,26);
  
  fill(255,227,84);
  textSize(120);
  text("Voice Pong", 127,185);
  
  textFont(font2);
  fill(255);
  text("Faça um som para começar", 171,235);
  
  textSize(20);
  fill(255,227,84);
  text("Instruções:", 50,387);
  fill(255);
  String instrucoes = "faça algum barulho para sua peça se mover para cima, quanto mais alto o barulho mais rápido a peça se mexe.";
  text(instrucoes,50,395,300,102);
  
  fill(255,227,84);
  text("Sensibilidade:", 380,387);
  fill(255);
  String sensibilidade = "Aperte 'S' para mudar a sensibilidade. Valores possíveis: 30, 60, 90, 120.";
  text(sensibilidade,380,395,282,80);
  
  
  image(img,327,260);
  
  
  
  escala = amp.analyze()*sen;
  if(escala >= 1){
    inicio = false;
    comeca_jogo = true;
  }

}

if(comeca_jogo == true){ //tela do jogo
  video.loadPixels();
  textFont(font2);
  background(26,26,26);
  //text("teste",310,50);
  
  escala = amp.analyze()*sen;
  
  //println(escala);
  threshold = 150;

  int count = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      //color corPoder = color(255,0,0);
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 
      //println(d);

      if (d < threshold*threshold) {
        stroke(255);
        strokeWeight(1);
        point(x, y);
        count++;
      }
    }
  }
  
  if (count > 100 && jogar_poder == true) { 
    poder = true;
    if (inicio_poder == false){
      posicaoY = E_rectY;
      inicio_poder = true;
    }
  }
  //println(poder);
  
  //poder jogador
  if(poder == true){
    fill(102,174,233);
    ellipse(posicaoX, posicaoY, 20,20);
    posicaoX = posicaoX + 5;
    if(posicaoX > 650){
    poder = false;
    inicio_poder = false;
    posicaoX = 60;
    }
  }
  //println(poder);
  
  //poder computador
    if(poder_comp == true){
    if(pos_inicial_adv == true){
      advY = D_rectY;
      pos_inicial_adv = false;
    }
    fill(102,174,233);
    ellipse(advX, advY, 20,20);
    advX = advX - 5;
    if(advX < 60){
    poder_comp = false;
    pos_inicial_adv = true;
    advX = 640;
    }
  }
  
  //congelar adversario
  if(posicaoX >= 630 && posicaoY > D_rectY && posicaoY < (D_rectY +100)){
    congelar_adv = true;
    tempo_inicial = int(millis()/1000);
  }
  if(congelar_adv == true){
    tempo_descongelar = (duracao_poder + tempo_inicial) - int(millis()/1000);
    if(tempo_descongelar == 0){
    congelar_adv = false;
    }
  }
  
  
  //congelar jogador
  if(advX <= 60 && advY > E_rectY && advY < (E_rectY +100)){
    congelar_jogador = true;
    temp_ini_congela_jog = int(millis()/1000);
  }
  if(congelar_jogador == true){
    tempo_descongela_jog = (temp_ini_congela_jog + temp_jog_congelado) - int(millis()/1000);
    if(tempo_descongela_jog == 0){
    congelar_jogador = false;
    }
  }
  
  
  //cooldown adversario
  if(poder_comp == false){
    if(recomeca_adv == true){
      temp_inicial_adv = int(millis()/1000);
      recomeca_adv = false;
    }
    tempo_adv = (temp_inicial_adv + cooldown_adv) - int(millis()/1000);
    if(tempo_adv == 0){
    poder_comp = true;
    recomeca_adv = true;
    }
  }
  println(poder_comp);
  /////////////////////////////////////////////////////////////////////////////
  
  
  if(jogar_poder == true && poder==true){
    if(recomecar_poder == false){
      tempo_poder = int(millis()/1000);
      recomecar_poder = true;
      jogar_poder = false;
    }
   //println(jogar_poder);
   }
   tempo= (intervalo_poder + tempo_poder) - int(millis()/1000);
   //println(tempo);
   if(tempo == 0){
     recomecar_poder = false;
     jogar_poder=true;
   } 
   if(jogar_poder == true){
   fill(102,174,233);
   ellipse(40,40,20,20);
   }
  
  
  for(int i=15;i<height;i=i+25){
    //fill(170,170,170);
    fill(255);
    ellipse(width/2,i,10,10);
  }
  
  fill(255,227,84);
  noStroke();
  ellipse(ellX,ellY,25,25); //círculo
  
   
  if(congelar_jogador == true){
    fill(102,174,233);
  }else{
    fill(255);
  }  
  rect(30,E_rectY,25,100,5); //retângulo esquerdo
  fill(255);
  text(pontosE,(width/2)-50,50);
  
  if(congelar_adv == true){
    fill(102,174,233);
  }else{
    fill(255);
  } 
  rect(645,D_rectY,25,100,5); //retângulo direito
  fill(255);
  text(pontosD,(width/2)+34,50);
  
  fill(255,227,84);//retângulo da sensisbilidade
  rect(width-50,480,50,20,5,0,0,0);
  fill(26,26,26);
  textSize(20);
  text("S: "+sen, width-40,height-2);
  
  //regular sensibildade
  if(keyPressed == true && (key == 's' || key == 'S') && troca_s == false){
    if(nivel_s == 1){
      sen = 60;
      nivel_s++;
    }else if(nivel_s == 2){
      sen = 90;
      nivel_s++;
    }else if(nivel_s == 3){
      sen = 120;
      nivel_s = 4;
    }else{
      sen = 30;
      nivel_s = 1;
    }
    troca_s = true;
  }
  
  
 //println(sen);
  
  //controles jogador
  if(congelar_jogador == false){
    if(escala >= 1){
      if(E_rectY <= 20){
        E_rectY = 20;
      }
      if(escala > 1 && escala < 3){
        E_rectY = E_rectY - 6;
      }else if(escala > 3 && escala < 6){  
        E_rectY = E_rectY - 10; 
      }else if(escala > 6){
        E_rectY = E_rectY - 14;
      }  
    }else{
      if(E_rectY >= 380){
        E_rectY = 380;
      }else{
        E_rectY = E_rectY + 6;
      }
    }
  }

  
  //controles computador
  if(congelar_adv == false){
    if(D_rectY > ellY){
      if(D_rectY <= 20){
        D_rectY = 20;
      }
      D_rectY = D_rectY - 4;
    }else if(D_rectY < ellY){
      if(D_rectY >= 380){
        D_rectY = 380;
      } 
      D_rectY = D_rectY + 4;
    }  
  }

  
  
  //movimento da bola
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
  
  
  if(ellY <= 15){
    moveBaixo = true; //move para baixo
  }
  if(ellY >= height - 15){
    moveBaixo = false; //move para cima
  }
  if(ellX >= width){
    moveDireita = false; //move para esquerda
    pontosE++;
    ellX = width/2;
    ellY = height/2;
    velocidadeX=3;
    velocidadeY=3;
  }
  if(ellX <= 0){
    moveDireita = true; ////move para direita
    pontosD++;
    ellX = width/2;
    ellY = height/2;
    velocidadeX=3;
    velocidadeY=3;
  }
  
  if(pontosD==pontosGanhar){
    fill(255,227,84,200);
    rect(0,0,700,500);
    fill(0);
    textSize(38);
    text("O LADO DIREITO VENCEU!", width/2-150,height/2+10);
    textSize(25);
    text("clique para jogar de novo",width/2-105,height/2+40);
  
    noLoop();
  }
  
  if(pontosE==pontosGanhar){
    fill(255,227,84,200);
    rect(0,0,700,500);
    fill(0);
    textSize(38);
    text("O LADO ESQUERDO VENCEU!", width/2-166,height/2+10);
    textSize(25);
    text("clique para jogar de novo",width/2-105,height/2+40);
  
    noLoop();
  }
  
  
  
  //interação com retângulo
  if(ellX >= 630 && ellY > D_rectY && ellY < (D_rectY +100)){
    moveDireita = false;
    velocidadeX = int(random(4,16));
    velocidadeY = int(random(2,6));
  }
  if(ellX <= 60 && ellY > E_rectY && ellY < (E_rectY +100)){
    moveDireita = true;
    velocidadeX = int(random(4,16));
    velocidadeY = int(random(2,6));
  }

}
  
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void mouseClicked() { //função para retornar o loop da função draw e voltar ao jogo
  if(pontosD == pontosGanhar || pontosE == pontosGanhar){
    loop();
    pontosD=0;
    pontosE=0;
    poder = false;
    inicio_poder = false;
    jogar_poder = true;
    recomecar_poder = false;
    congelar_adv = false;
    pos_inicial_adv = true;
  }

}

void keyReleased() { //função para habilitar novamente a troca de sensibilidade
  if(key == 's' || key == 'S'){
    troca_s = false;
  }
}

void captureEvent(Capture c) {
  c.read();
}
