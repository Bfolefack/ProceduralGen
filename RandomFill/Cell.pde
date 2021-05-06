class Cell {
  Plate plate;
  Plate neighbor;
  color col;
  boolean filled;
  boolean active;
  boolean border;
  int xPos;
  int yPos;
  int size;
  float elevation;
  float infectivity;

  Cell(int x_, int y_, int s_) {
    xPos = x_;
    yPos = y_;
    size = s_;
    col = color(0);
  }

  Cell() {
    size = 0;
    filled = true;
  }

  void display() {
    noStroke();
    if (filled) {
      fill(plate.col);
      rect(xPos * size, yPos * size, size, size);
    }
  }

  void showStroke() {
    if (xPos % 30 == 0 && yPos % 30 == 0) {
      stroke(0, 255, 0);
      line(xPos + size/2, yPos + size/2, (xPos + size/2) + cos(plate.angle) * 10, (yPos + size/2) + sin(plate.angle) * 10);
      fill(0, 255, 0);
      ellipse(xPos, yPos, 5, 5);
    }
  }

  void fillNeighbors(Grid grid) {
    if (active && infectivity < random(1)) {
      int choice = (int) random(4) + 1;
      if (choice == 1) {
        Cell cel = grid.getCell(xPos, yPos - 1);
        if (!cel.filled) {
          cel.activate(plate);
          if (random(1) < infectivity) {
            //cel.fillNeighbors(grid);
          }
        }
      } else if (choice == 2) {
        Cell cel = grid.getCell(xPos + 1, yPos);
        if (!cel.filled) {
          cel.activate(plate);
          if (random(1) < infectivity) {
            //cel.fillNeighbors(grid);
          }
        }
      } else if (choice == 3) {
        Cell cel = grid.getCell(xPos, yPos + 1);
        if (!cel.filled) {
          cel.activate(plate);
          if (random(1) < infectivity) {
            //cel.fillNeighbors(grid);
          }
        }
      } else if (choice == 4) {
        Cell cel = grid.getCell(xPos - 1, yPos);
        if (!cel.filled) {
          cel.activate(plate);
          if (random(1) < infectivity) {
            //cel.fillNeighbors(grid);
          }
        }
      }
      if (grid.getCell(xPos, yPos - 1).filled && grid.getCell(xPos + 1, yPos).filled && grid.getCell(xPos, yPos + 1).filled && grid.getCell(xPos - 1, yPos).filled) {
        active = false;
      }
    }
  }

  void checkBorder (Grid grid) {
    border = false;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!(i == 0 && j == 0)) {
          Cell cel = grid.getCell(xPos + i, yPos + j);
          if (cel.size != 0) {
            if (cel.plate != plate) {
              border = true;
              neighbor = cel.plate;
              if (!plate.neighbors.contains(cel.plate)) {
                plate.neighbors.add(cel.plate);
              }
            }
          }
        }
      }
    }
  }

  void smoothEdges(Grid grid) {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!(i == 0 && j == 0)) {
          Cell cel = grid.getCell(xPos + i, yPos + j);
          if (cel.size != 0) {
            if (cel.plate != plate) {
              neighbors.add(cel);
            }
          }
        }
      }
    }

    if (neighbors.size() > 4) {
      changePlate(neighbors.get(0).plate);
    }
  }

  void calculateTectonics (Grid grid) {
    if (border) {
      ArrayList<Cell> neighbors = new ArrayList<Cell>();
      for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
          if (!(i == 0 && j == 0)) {
            Cell cel = grid.getCell(xPos + i, yPos + j);
            if (cel.size != 0) {
              if (cel.plate != plate) {
                neighbors.add(cel);
              }
            }
          }
        }
      }

      float totalCollision = 0;
      for (Cell n : neighbors) {
        PVector v = new PVector(cos(plate.angle) - cos(n.plate.angle), sin(plate.angle) - sin(n.plate.angle));
        PVector p = new PVector(xPos - n.xPos, yPos - n.yPos);

        float collision = PVector.dot(v, p);
        collision += -map(collision, -2, 2, -1, 1);
        totalCollision += collision;
        //println(collision);
      }

      if (plate.land != neighbor.land) {

        if (!plate.land) {
          //Oceanic-Continental
          if (totalCollision > 0) {
            elevation += totalCollision * -0.07;
          } else {
            elevation += 0;
          }
        } else {
          //Continental-Oceanic
          if (totalCollision > 0) {
            elevation += totalCollision * 0.3;
          } else {
            elevation += abs(totalCollision) * 0.1;
          }
        }
      }
      if (!plate.land) {
        //Oceanic-Oceanic
        if (totalCollision > 0) {
          elevation += totalCollision * 0.2;
        } else {
          elevation += abs(totalCollision) * 0.02;
        }
      } else {
        //Continental-Continental
        if (totalCollision > 0) {
          elevation += totalCollision * 0.3;
        } else {
          elevation += totalCollision * 0.1;
        }
      }

      if (elevation > 1)
        elevation = 1;
      if (elevation < 0) {
        elevation = 0;
      }
    }
  }

  void activate(Plate p) {
    plate = p;
    active = true;
    filled = true; 
    infectivity = p.infectivity;
    p.cells.add(this);
    if (p.land) {
      elevation = 0.7;
    } else {
      elevation = 0.3;
    }
  }

  void changePlate(Plate p) {
    plate = p;
    infectivity = p.infectivity;
    p.cells.add(this);
    if (p.land) {
      elevation = 0.6;
    } else {
      elevation = 0.3;
    }
  }

  void getAvgBrothers(Grid grid) {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!(i == 0 && j == 0)) {
          Cell cel = grid.getCell(xPos + i, yPos + j);
          if (cel.size != 0) {
            if (cel.plate == plate) {
              neighbors.add(cel);
            }
          }
        }
      }
    }
    float total = 0;
    for (Cell c : neighbors) {
      total += c.elevation;
    }
    elevation = total/neighbors.size();
    if (elevation > 1)
      elevation = 1;
    if (elevation < 0)
      elevation = 0;
  }

  void getAvgEverybody(Grid grid) {
    //boolean b = true;
    //while(b){
    //  int x = (int)random(-2, 10);
    //  int y = (int)random(-2, 10);
    //  //println((xPos + x) + "," + (yPos + y));
    //  Cell cel = grid.getCell(xPos + x, yPos + y);
    //  if(cel.size > 0){
    //    elevation = cel.elevation;
    //    b = false;
    //  }
    //}
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    for (int i = -1; i < 1; i++) {
      for (int j = -1; j < 1; j++) {
        if (!(i == 0 && j == 0)) {
          //println(xPos + i, yPos + j);
          Cell cel = grid.getCell(xPos + i, yPos + j);
          if (cel.size != 0) {
            neighbors.add(cel);
          }
        }
      }
    }
    float total = 0;
    for (Cell c : neighbors) {
      total += c.elevation;
    }
    elevation = total/neighbors.size();
    if (elevation > 1)
      elevation = 1;
    if (elevation < 0)
      elevation = 0;
  }
}
