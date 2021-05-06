//Establish Scaling Variables
float scale = 1;
float xPan;
float yPan;



void setup (){
  size(1300, 700);
  noStroke();
  yPan = height/2;
  xPan  = width/2;
}

void draw (){
  background(255);
  pushMatrix();
    translate(-xPan, -yPan);
    translate(width/2, height/2);
    scale(scale);
    
    for(int i = 0; i < 1000; i++){
      for( int j = 0; j < 1000; j++){
         float x = noise(j * .005, i * .005);
         x *= 255;
         fill(x);
         rect(j * 5 , i * 5, 5, 5);
      }
    }
  popMatrix();
}

void keyPressed() {
  if(key == 'w'){
    scale *= 1.02;
  }
  if(key == 's'){
    scale *= .98;
  }
}

void mouseDragged ()  {
  xPan += (pmouseX - mouseX)/scale;
  yPan += (pmouseY - mouseY)/scale;
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.05 * event.getCount());
  println(scale);
  scale *= scaleAmt;
}
