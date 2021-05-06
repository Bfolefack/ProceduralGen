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

    ArrayList<Integer> yValues = new ArrayList<Integer>();
    for (int i = 0; i < gridHeight; i++) {
      float lat = abs((gridHeight/2) - i) * 2;
      lat = map(lat, 0, gridHeight, 0, 1);
      lat = pow(lat, 16);
      lat = map(lat, 0, 1, 20, 0);
      //println(lat);
      for (int j = 0; j < lat; j++) {
        yValues.add(i);
      }
    }

    plates = new Plate[20];

    boolean b;
    if (random(1) < 0.7) {
      b = false;
    } else { 
      b = true;
    }

    plates[plates.length - 2] = new Plate(color(random(255), random(255), random(255)), b, random(0.4, 0.7), this);
    for (int i = 0; i < gridWidth; i++) {
      grid[i][0].activate(plates[plates.length - 2]);
    }

    if (random(1) < 0.7) {
      b = false;
    } else { 
      b = true;
    }

    plates[plates.length - 1] = new Plate(color(random(255), random(255), random(255)), b, random(0.4, 0.7), this);
    for (int i = 0; i < gridWidth; i++) {
      grid[i][gridHeight - 1].activate(plates[plates.length - 1]);
    }

    for (int i = 0; i < plates.length - 2; i++) {
      if (i < 4) {
        int x = (int)random(gridWidth);
        int y = yValues.get((int)random(yValues.size()));
        plates[i] = new Plate(color(random(255), random(255), random(255)), false, random(-0.3, 0.2), this);
        grid[x][y].activate(plates[i]);
      } else if (i < 8) {
        int x = (int)random(gridWidth);
        int y = yValues.get((int)random(yValues.size()));
        plates[i] = new Plate(color(random(255), random(255), random(255)), true, random(-0.1, 0.4), this);
        grid[x][y].activate(plates[i]);
      } else {
        int x = (int)random(gridWidth);
        int y = yValues.get((int)random(yValues.size()));
        boolean c;
        if (random(1) < 0.5) {
          c = false;
        } else {
          c = true;
        }

        plates[i] = new Plate(color(random(255), random(255), random(255)), b, random(0.5, 0.7), this);
        grid[x][y].activate(plates[i]);
      }
    }

    //while (!bordersChecked) {
    //  update();
    //}
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
      int j = 0; 
      for (int i = 0; i < gridHeight; i++) {
        float lat = abs((gridHeight/2) - i) * 2;
        lat = map(lat, 0, gridHeight, 0, 1);
        lat = pow(lat, 16);
        lat = map(lat, 0, 1, 1, 20);
        for (int k = 0; k < (int) lat; k++) {
          for (j = 0; j < gridWidth; j++) {
            grid[j][i].fillNeighbors(this);
          }
        }
      }
      for (int i = gridHeight - 1; i >= 0; i--) {
        float lat = abs((gridHeight/2) - i) * 2;
        lat = map(lat, 0, gridHeight, 0, 1);
        lat = pow(lat, 16);
        lat = map(lat, 0, 1, 1, 20);
        for (int k = 0; k < (int) lat; k++) {
          for (j = gridWidth - 1; j >= 0; j--) {
            grid[j][i].fillNeighbors(this);
            if (!grid[j][i].filled) {
              plateBuilding = true;
              //println("unfullfilled [" + j + "," + i + "]");
            }
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
      }
      for (int i = 0; i < 10; i++) {
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
