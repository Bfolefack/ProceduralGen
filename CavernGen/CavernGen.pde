float gridScale;
Grid griddle;
void setup () {
  size(800, 600);
  gridScale = 5;
  background(0);
  textSize(200);
  text("Loading...", width/2 - 400, height/2);
  noStroke();
}

void draw () {
  if(frameCount == 1){
    griddle = new Grid(0, 0, int(width/gridScale), int(height/gridScale));
  }
  background(150);
  griddle.update();
  griddle.display();
}
