//Establish Scaling Variables
float scale = 1;
float xPan;
float yPan;



void setup (){
  size(1300, 700);
  noStroke();
  yPan = height/2;
  xPan  = width/2;
  noiseDetail(10);
}

void draw (){
  background(255);
  pushMatrix();
    translate(-xPan, -yPan);
    translate(width/2, height/2);
    scale(scale);
    
    for(int i = 0; i < height/5; i++){
      for( int j = 0; j < width/5; j++){
         fill(noise(j * .025, i * .025, frameCount * .025) * 255, noise(i * .025, j * .025, frameCount * .025) * 255, noise(frameCount * .025) * 255);
         rect(j * 5 , i * 5, 5.01, 5.01);
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
  scale *= scaleAmt;
}
