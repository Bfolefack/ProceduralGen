int gridScale, chunkScale;
//Grid griddle;
float scale = 1;
float xPan;
float yPan;
float truMouseX;
float truMouseY;
float noiseScale;
float truScale = 1;
ChunkHandler ch;

void setup () {
  noiseDetail(60, 0.6);
  int x = int(random(100000000));
  println(x);
  noiseSeed(x);
  size(1300, 720);
  gridScale = 5;
  //noiseScale = .008;
  //noiseScale = .05;
  noiseScale = .01;
  chunkScale = 16;
  //griddle = new Grid(0, 0, grdWidth/gridScale, grdHeight/gridScale);
  noStroke();
  xPan = width/2;
  yPan = height/2;
  fill(0);
  ch = new ChunkHandler();
}

void draw () {
  truMouseX = (mouseX + xPan - width/2)/scale;
  truMouseY = (mouseY + yPan - height/2)/scale;


  if (mouseX > width - 75) {
    xPan += 20/scale;
  } else if (mouseX < 75) {
    xPan -= 20/scale;
  }

  if (mouseY > height - 75) {
    yPan += 20/scale;
  } else if (mouseY < 75) {
    yPan -= 20/scale;
  }

  background(150);
  pushMatrix();
  scale(scale);
  translate(-xPan, -yPan);

  //griddle.update();
  //griddle.display();

  ch.display();
  popMatrix();
  fill(0);
  textSize(30);
  text("Coords: " + xPan + width/2 + ", " + yPan + height/2, 10, 30);

  ellipse( width/2, height/2, 10, 10);
}
void mouseDragged() {
  xPan += (pmouseX - mouseX)/scale;
  yPan += (pmouseY - mouseY)/scale;
}
void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.1 * event.getCount());
  truScale *= scaleAmt;
  scale = truScale;
  scale *= gridScale;
  scale = (int)scale;
  scale /= gridScale;
  if (scale < .6) {
    scale = .6;
  }
}

void mousePressed() {
  if (mouseButton == CENTER) {
    scale = 1;
  }
}
