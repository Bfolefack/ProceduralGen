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
  noiseDetail(10);
    translate(-xPan, -yPan);
    translate(width/2, height/2);
    scale(scale);
    
    for(int i = 0; i < height; i++){
      for( int j = 0; j < width; j++){
         float x = noise(j * .01, i * .01);
         float r = map(x, 0, 1, 170, 255);
         float g = map(x, 0, 1, 145, 230);
         float b = map(x, 0, 1, 94, 184);
         fill(r, g, b);
         rect(j * 1, i * 1, 1, 1);
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
