class VoronoiPoint {
  int xPos;
  int yPos;
  int voronoiSize;
  boolean active;
  boolean plateFilled;
  Plate plate;
  float infectivity;
  color voCol = color(random(255), random(255), random(255));
  ArrayList<Cell> cells = new ArrayList<Cell>();
  ArrayList <VoronoiPoint> neighbors = new ArrayList <VoronoiPoint>();
  VoronoiPoint(int x_, int y_, int vS_) {
    xPos = x_;
    yPos = y_;
    voronoiSize = vS_;
  }
  void getPoints(Grid grid) {
    for (int i = -voronoiSize; i < voronoiSize; i++)
      for (int j = -voronoiSize; j < voronoiSize; j++) {
        Cell cel = grid.getCell(xPos + i, yPos + j);
        if (cel.size != 0) {
          if (dist(0, 0, i, j) <= cel.minVoronoiDist) {
            cel.minVoronoiDist = dist(0, 0, i, j);
            cel.voronoi = this;
          }
        }
      }
  }
  void getCells(Grid grid) {
    for (int i = -voronoiSize; i < voronoiSize; i++)
      for (int j = -voronoiSize; j < voronoiSize; j++) {
        Cell cel = grid.getCell(xPos + i, yPos + j);
        if (cel.voronoi == this) {
          cells.add(cel);
        }
      }
  }


  void activate(Plate p) {
    for (Cell c : cells) {
      c.plate = p;
      c.filled = true;
      p.cells.add(c);
      if (p.land) {
        c.elevation = 0.7;
      } else {
        c.elevation = 0.3;
      }
    }
    for(VoronoiPoint vp: neighbors){
      vp.neighbors.remove(this);
    }
    plate = p;
    active = true;
    plateFilled = true; 
    infectivity = p.infectivity;
  }
  
  void fillNeighbors(){
    for(int i = 0; i < neighbors.size(); i++){
        if(neighbors.get(i).plateFilled)
          neighbors.remove(i);
    }
    if(active && random(1) > infectivity)
     if(neighbors.size() > 0){
       neighbors.remove((int)random(neighbors.size())).activate(plate);
     } else {
       active = false;
     }
  }

  void getNeighbors(Grid grid) {
    for (Cell c : cells) {
      c.getVoronoiNeighbors(grid);
    }
  }
}
