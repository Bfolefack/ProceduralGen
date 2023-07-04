int gridScale, grdWidth, grdHeight;
Grid griddle;
float scale = 0.5;
float xPan;
float yPan;
float truMouseX;
float truMouseY;
float noiseDetail;
float noiseScale;
float lowerBound;
float upperBound;
OpenSimplexNoise noise;
int seed;
void setup () {
  seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
  //seed = 10000;
  noise = new OpenSimplexNoise(seed);
  
  gridScale = 5;
  size(1000, 500);
  grdWidth = width;
  grdHeight = height;
  griddle = new Grid(0, 0, grdWidth, grdHeight);
  //for (int i = 0; i < 100; i++) {
  //  seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
  //  println(seed);
  //  noise = new OpenSimplexNoise(seed);
  //  new Grid(0, 0, grdWidth, grdHeight);
  //}
  //println("Truly Done!");
  noStroke();
  xPan = width/2;
  yPan = height/2;
  fill(0);
}

void draw () {
  truMouseX = (mouseX + xPan - width/2)/scale;
  truMouseY = (mouseY + yPan - height/2)/scale;


  if (mouseX > width - 75) {
    xPan += 10;
  } else if (mouseX < 75) {
    xPan -= 10;
  }

  if (mouseY > height - 75) {
    yPan += 10;
  } else if (mouseY < 75) {
    yPan -= 10;
  }


  background(150);
  pushMatrix();
  translate(-xPan, -yPan);
  translate(width/2, height/2);
  scale(scale);
  //griddle.update();
  griddle.display();
  popMatrix();
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.1 * event.getCount());

  scale *= scaleAmt;
  xPan *= scaleAmt;
  yPan *= scaleAmt;
}
