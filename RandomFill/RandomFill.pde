float truMouseX;
float truMouseY;
Zoom zoomer;
Grid grid = new Grid(1000, 500);

void setup() {
  //noStroke();
  size(1000, 500);
  zoomer = new Zoom(1);
}

void draw() {
  background(200);
  zoomer.edgePan();
  zoomer.keyScale();
  zoomer.pushZoom();
  
  grid.update();
  grid.display();

  zoomer.popZoom();
  if (keyPressed && key == 'e') {
    //grid.getImage().save("RandoFill/" + random(1) + ".png");
    exit();
  }
}
