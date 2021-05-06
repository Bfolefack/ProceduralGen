Grid grid;

void setup() {
  size(1000, 500);
  grid = new Grid(500, 50);
  grid.generateVoronoi();
}

void draw() {
  grid.display();
  if (keyPressed) {
    if (key == 'e') {
      save("img_" + random(1) + ".png");
      exit();
    }
    if (key == 'r') {
      println("relaxing");
      grid.relax();
    }
  }
}
