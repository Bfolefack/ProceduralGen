int gridScale, grdWidth, grdHeight;
Grid griddle;
int noiseCount;

void setup () {
  size(1300, 700);
  gridScale = 10;
  griddle = new Grid(0, 0, width/gridScale, height/gridScale);
  frameRate(2000);
  noStroke();
  fill(0);
}

void draw () {
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.update();
  griddle.display();
}
