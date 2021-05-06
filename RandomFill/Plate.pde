class Plate {
  Grid grid;
  color col;
  boolean land;
  boolean active;
  float infectivity;
  float angle;
  int xPos;
  int yPos;
  ArrayList<Cell> cells = new ArrayList<Cell>();
  ArrayList<Plate> neighbors = new ArrayList<Plate>();
  Plate(color c_, boolean l_, float i_, Grid g_) {
    col = c_;
    land = l_;
    infectivity = i_;
    grid = g_;
    active = true;
    //angle = (int)random(8) * 45;
    //println(angle);
    //angle = radians(angle);
    angle = random(TWO_PI);
  }

  void getAvgPoint() {
    int xTotal = 0;
    int yTotal = 0;
    for (Cell c : cells) {
      xTotal += c.xPos;
      yTotal += c.yPos;
    }
    xPos = (int) (xTotal/ (float) cells.size());
    yPos = (int) (yTotal/ (float) cells.size());
  }

  void checkNeighbors() {
    if (neighbors.size() < 2) {
      for (Cell cel : cells) {
        cel.changePlate(neighbors.get(0));
      }
      active = false;
    }
  }

  void gradientBorders() {
    for (Cell c : cells) {
      if (!c.border) {
        c.getAvgBrothers(grid);
      }
    }
  }

  void smoothBorders() {
    for (Cell c : cells) {
      c.getAvgEverybody(grid);
    }
  }
}
