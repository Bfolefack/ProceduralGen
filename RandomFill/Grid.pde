import java.util.*;

class Grid {
  Cell[][] grid;
  Plate[] plates;
  int gridWidth;
  int gridHeight;
  boolean plateBuilding = true;
  boolean bordersChecked = false;

  Grid(int gw_, int gh_) {
    gridWidth = gw_;
    gridHeight = gh_;
    grid = new Cell[gw_][gh_];
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        grid[i][j] = new Cell(i, j, 1);
      }
    }

    plates = new Plate[20];
  }

  void buildPlates() {
    boolean b;

    if (random(1) < 0.7) {
      b = false;
    } else { 
      b = true;
    }
    println("a");
    plates[plates.length - 2] = new Plate(color(random(255), random(255), random(255)), b, random(0.4, 0.7), this);
    for (VoronoiPoint vp : vps) {
      if (vp.yPos <= voronoiSize) {
        vp.activate(plates[plates.length - 2]);
      }
    }

    if (random(1) < 0.7) {
      b = false;
    } else { 
      b = true;
    }
    println("b");
    plates[plates.length - 1] = new Plate(color(random(255), random(255), random(255)), b, random(0.4, 0.7), this);
    for (VoronoiPoint vp : vps) {
      if (vp.yPos >= gridHeight - voronoiSize) {
        vp.activate(plates[plates.length - 1]);
      }
    }
    println("c");
    ArrayList<VoronoiPoint> vps2 = (ArrayList) vps.clone();
    Collections.shuffle(vps2);
    for (int i = 0; i < plates.length - 2; i++) {
      if (i < 4) {
        plates[i] = new Plate(color(random(255), random(255), random(255)), false, random(-0.1, 0.2), this);
        VoronoiPoint vp;
        vp = vps2.get(i);
        if (!vp.plateFilled) {
          vp.activate(plates[i]);
        }
      } else if (i < 8) {
        plates[i] = new Plate(color(random(255), random(255), random(255)), true, random(0.1, 0.4), this);
        VoronoiPoint vp;
        vp = vps2.get(i);
        if (!vp.plateFilled) {
          vp.activate(plates[i]);
        }
      } else {
        if (random(1) < 0.7) {
          b = false;
        } else {
          b = true;
        }

        plates[i] = new Plate(color(random(255), random(255), random(255)), b, random(0.4, 0.7), this);
        VoronoiPoint vp;
        vp = vps2.get(i);
        if (!vp.plateFilled) {
          vp.activate(plates[i]);
        }
      }
    }
    println("d");
  }

  void display() {

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {   
        grid[i][j].display();
      }
    }
    if (bordersChecked) {
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridHeight; j++) {
          grid[i][j].showStroke();
        }
      }
    }
  }

  void update() {
    if (plateBuilding) {
      plateBuilding = false;
      for (int i = 0; i < vps.size(); i++) {
        VoronoiPoint vp = vps.get(i);
        float lat = abs((gridHeight/2) - vp.yPos) * 2;
        lat = map(lat, 0, gridHeight, 0, 1);
        lat = pow(lat, 8);
        lat = map(lat, 0, 1, 1, 5);
        for (int k = 0; k < (int) lat; k++) {
          if (vp.active) {
            plateBuilding = true;
            vp.fillNeighbors();
          }
        }
      }
    } else if (!bordersChecked) {
      println("checking borders");
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridHeight; j++) {
          grid[i][j].checkBorder(this);
        }
      }
      bordersChecked = true;
      for (int i = 0; i < plates.length; i++) {
        plates[i].getAvgPoint();
        plates[i].checkNeighbors();
      }
      for (int k = 0; k < 5; k++) {
        for (int i = 0; i < gridWidth; i++) {
          for (int j = 0; j < gridHeight; j++) {
            grid[i][j].smoothEdges(this);
          }
        }
      }
      
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridHeight; j++) {
          grid[i][j].checkBorder(this);
        }
      }
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridHeight; j++) {
          grid[i][j].calculateTectonics(this);
        }
      }
      for (int i = 0; i < 50; i++) {
        //println(i);
        for (Plate p : plates) {
          p.gradientBorders();
        }
      }   for (int i = 0; i < 10; i++) {
        //println(80 + i);
        for (Plate p : plates) {
          p.smoothBorders();
        }
      }
      println("done checking borders");
    }
  }


  Cell getCell(int x, int y) {
    if (x >= 0 && y >= 0 && x < gridWidth && y < gridHeight)
      return grid[x][y];
    if (y < grid[0].length - 1 && y >= 0) {
      if (x < 0) {
        return grid[gridWidth + x][y];
      }
      if (x >= gridWidth) {
        return grid[x - gridWidth][y];
      }
    }
    return new Cell();
  }
}
