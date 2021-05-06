int gridScale, grdWidth, grdHeight;
Grid griddle;
float scale = 0.5;
float xPan;
float yPan;
float truMouseX;
float truMouseY;
float noiseScale;
float lowerBound;
float upperBound;
OpenSimplexNoise noise;

void setup () {
  long x = (long)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
  noise = new OpenSimplexNoise(x);
  noiseDetail(8,0.55);
  println(x);
  noiseSeed(x);
  size(1300, 720);
  gridScale = 1;
  grdWidth = 500;
  grdHeight = 500;
  noiseScale = 2;
  griddle = new Grid(0, 0, grdWidth/gridScale, grdHeight/gridScale);
  noStroke();
  xPan = width/2;
  yPan = height/2;
  fill(0);
}

void draw () {
  truMouseX = (mouseX + xPan - width/2)/scale;
  truMouseY = (mouseY + yPan - height/2)/scale;
  
  
  if(mouseX > width - 75){
    xPan += 10; 
  } else if (mouseX < 75){
    xPan -= 10; 
  }
  
  if(mouseY > height - 75){
    yPan += 10; 
  } else if (mouseY < 75){
    yPan -= 10; 
  }
  
  
  background(150);
  pushMatrix();
  translate(-xPan, -yPan);
  translate(width/2, height/2);
  scale(scale);
  griddle.update();
  griddle.display();
  popMatrix();
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.1 * event.getCount());
  
  scale *= scaleAmt;
  xPan *= scaleAmt;
  yPan *= scaleAmt;
}
