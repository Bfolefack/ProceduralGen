class Cell {
  String status = "wall";
  PVector gridPos;
  int borders;

  Cell(int x_, int y_) {
    gridPos = new PVector(x_, y_);
  }

  void display() {

    if (status == "wall") {
      fill(0);
      rect(gridPos.x * gridScale - .01, gridPos.y * gridScale - .01, gridScale + .03, gridScale + .03);
    } else if (status == "path") {
      fill(255);
      rect(gridPos.x * gridScale - .01, gridPos.y * gridScale - .01, gridScale + .03, gridScale + .03);
    } else if (status == "open") {
      fill(0, 0, 255);
      rect(gridPos.x * gridScale - .01, gridPos.y * gridScale - .01, gridScale + .03, gridScale + .03);
    } else {
      fill(255, 0, 0);
      rect(gridPos.x * gridScale - .01, gridPos.y * gridScale - .01, gridScale + .03, gridScale + .03);
    }
  }

  PVector getMouseGridspace() {
    int x, y;
    x = int(mouseX/gridScale);
    y = int(mouseY/gridScale);
    return new PVector(x, y);
  }

  boolean exists(int x, int y, Cell[][] cells) {
    boolean ifx, ify;
    ifx = true;
    ify = true;

    if (x < 0) {
      if (x + gridPos.x < 0) {
        ifx = false;
      }
    }
    if (x > 0) {
      if (x + gridPos.x > cells[0].length - 1) {
        ifx = false;
      }
    }

    if (y < 0) {
      if (y + gridPos.y < 0) {
        ify = false;
      }
    }
    if (y > 0) {
      if (y + gridPos.y > cells.length - 1) {
        ify = false;
      }
    }
    return ifx && ify;
  }

  void update() {
    PVector maus = getMouseGridspace();
  }

  void setPath(Cell[][] cells) {
    if (status == "open") {
      ArrayList<PVector> pathCells = new ArrayList<PVector>();
      if (exists(0, -2, cells)) {
        if ( cells[int(gridPos.y) - 2][int(gridPos.x)].status == "path") {
          pathCells.add(new PVector(-1, 0));
        }
      }

      if (exists(0, 2, cells)) {
        if ( cells[int(gridPos.y) + 2][int(gridPos.x)].status == "path") {
          pathCells.add(new PVector(1, 0));
        }
      }

      if (exists(2, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) + 2].status == "path") {
          pathCells.add(new PVector(0, 1));
        }
      }

      if (exists(-2, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) - 2].status == "path") {
          pathCells.add(new PVector(0, -1));
        }
      }

      int pickedVector = int(random(pathCells.size()));
      PVector vector = pathCells.get(pickedVector);
      cells[int(gridPos.y + vector.x)][int(gridPos.x + vector.y)].status = "path";
    }
    status = "path";
    if (exists(0, -2, cells)) {
      if ( cells[int(gridPos.y) - 2][int(gridPos.x)].status == "wall") {
        cells[int(gridPos.y) - 2][int(gridPos.x)].status = "open";
      }
    }

    if (exists(0, 2, cells)) {
      if ( cells[int(gridPos.y) + 2][int(gridPos.x)].status == "wall") {
        cells[int(gridPos.y) + 2][int(gridPos.x)].status = "open";
      }
    }

    if (exists(2, 0, cells)) {
      if ( cells[int(gridPos.y)][int(gridPos.x) + 2].status == "wall") {
        cells[int(gridPos.y)][int(gridPos.x) + 2].status = "open";
      }
    }

    if (exists(-2, 0, cells)) {
      if ( cells[int(gridPos.y)][int(gridPos.x) - 2].status == "wall") {
        cells[int(gridPos.y)][int(gridPos.x) - 2].status = "open";
      }
    }
  }
  void clipEnds(Cell[][] cells) {
    int wallNum = 0;
    if (status == "path") {
      ArrayList<PVector> pathCells = new ArrayList<PVector>();
      if (exists(0, -1, cells)) {
        if ( cells[int(gridPos.y) - 1][int(gridPos.x)].status == "wall") {
          pathCells.add(new PVector(-1, 0));
          wallNum++;
        }
      }

      if (exists(0, 1, cells)) {
        if ( cells[int(gridPos.y) + 1][int(gridPos.x)].status == "wall") {
          pathCells.add(new PVector(1, 0));
          wallNum++;
        }
      }

      if (exists(1, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) + 1].status == "wall") {
          pathCells.add(new PVector(0, 1));
          wallNum++;
        }
      }

      if (exists(-1, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) - 1].status == "wall") {
          pathCells.add(new PVector(0, -1));
          wallNum++;
        }
      }
      if (wallNum == 3) {
        int pickedVector = int(random(pathCells.size()));
        PVector vector = pathCells.get(pickedVector);
        cells[int(gridPos.y + vector.x)][int(gridPos.x + vector.y)].status = "path";
      }
    } else {
      if (exists(0, -1, cells)) {
        if ( cells[int(gridPos.y) - 1][int(gridPos.x)].status == "path") {
          wallNum++;
        }
      }

      if (exists(0, 1, cells)) {
        if ( cells[int(gridPos.y) + 1][int(gridPos.x)].status == "path") {
          wallNum++;
        }
      }

      if (exists(1, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) + 1].status == "path") {
          wallNum++;
        }
      }

      if (exists(-1, 0, cells)) {
        if ( cells[int(gridPos.y)][int(gridPos.x) - 1].status == "path") {
          wallNum++;
        }
      }
      if (wallNum == 4) {
        status = "path";
      } else if (random(1) <.01){
        status = "path";
      }
    }
  }

  void setWall() {
    status = "wall";
  }
}
