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
    
    for(int i = 0; i < 400; i++){
      for( int j = 0; j <1000; j++){
         float x = noise(j * .03, i * .03);
         float offset = (100.0 - i)/100.0;
         //println(offset);
         if(offset> 1){
           offset = 1;
         } else if(offset < 0){
           offset = 0;
         }
         if(i <= 100){
           if(noise(j * 0.05) * 25 > i){
             x = 0.5;
           }
         }
         if(x < 0.55 && x > 0.45){
           fill(255);
         } else {
           fill(0);
         }
         //fill(offset * 255);
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
  //println(scale);
  scale *= scaleAmt;
}
