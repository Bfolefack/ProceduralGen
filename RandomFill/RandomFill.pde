float truMouseX;
float truMouseY;
Zoom zoomer;
Grid grid = new Grid(750, 375);
int voronoiSize = 10;
ArrayList<VoronoiPoint> vps;

void setup() {
    //noStroke();
    vps = new ArrayList<VoronoiPoint>();
    size(1000, 500);
    zoomer = new Zoom(1);
    for (int i = 0; i < grid.gridWidth/voronoiSize; i++)
      for (int j = 0; j < grid.gridWidth/voronoiSize; j++) {
        vps.add(new VoronoiPoint(i * voronoiSize + (int)random(voronoiSize), j * voronoiSize + (int)random(voronoiSize), voronoiSize));
      }
    for (VoronoiPoint vp : vps) {
      vp.getPoints(grid);
    }
    for (VoronoiPoint vp : vps) {
      vp.getCells(grid);
    }
     for (VoronoiPoint vp : vps) {
      vp.getNeighbors(grid);
    }
    grid.buildPlates();
}

void draw() {
  background(200);
  zoomer.edgePan();
  zoomer.keyScale();
  zoomer.pushZoom();

  grid.update();
  grid.display();

  zoomer.popZoom();
  //if (keyPressed && key == 'e') {
  //  //grid.getImage().save("RandoFill/" + random(1) + ".png");
  //  exit();
  //}
}
