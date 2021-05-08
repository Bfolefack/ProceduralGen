class Cell {
  boolean filled;
  String state = "none";
  String erosionState = "none";
  PVector gridPos, fillColor;
  int borders;
  boolean erode;

  Cell(int x_, int y_, boolean f_) {
    gridPos = new PVector(x_, y_);
    filled = f_;
  }

  Cell(int x_, int y_) {
    gridPos = new PVector(x_, y_);
    if (random(0, 1) < .43) {
      filled = true;
    } else {
      filled = false;
    }
  }

  void display() {
    noStroke();
    //noStroke();
    //if (filled) {
    //} else if (state == "open") {
    //  fill(0, 255, 0);
    //  rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
    //} else if (state == "closed") {
    //  fill(fillColor.x, fillColor.y, fillColor.z);
    //  rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
    //}
    switch(state) {
    case "open":
      fill(0, 255, 0);
      rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
      break;
    case "closed":
      fill(fillColor.x, fillColor.y, fillColor.z);
      rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
      break;
    default:
      if (filled) {
        fill(0);
        rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
        break;
      }
    }
    fill(0, 255, 0);
    //textSize(10);
    //text(borders, gridPos.x * gridScale + gridScale/2, gridPos.y * gridScale + gridScale/2);
  }

  PVector getMouseGridspace() {
    int x, y;
    x = int(mouseX/gridScale);
    y = int(mouseY/gridScale);
    return new PVector(x, y);
  }

  void fillUp() {
    filled = true;
  }

  boolean exists(int x, int y, Cell[][] cells) {
    boolean ifx = true, ify = true;
    if (gridPos.x + x < 0 || gridPos.x + x > cells[0].length - 1) {
      ifx = false;
    }
    if (gridPos.y + y < 0 || gridPos.y + y > cells.length - 1) {
      ify = false;
    }
    return ifx && ify;
  }

  void update(Cell[][] cells) {
    PVector maus = getMouseGridspace();
    if (int(maus.x) == gridPos.x && int(maus.y) == gridPos.y && mousePressed && !filled) {
      if (state == "none") {
        //state = "open";
      }
    }
  }

  void smoothCavern(Cell[][] cells) {
    borders = 0;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!( i ==0 && j == 0)) {

          if (exists(i, j, cells)) {
            if (cells[int(gridPos.y + j)][int(gridPos.x + i)].filled) {
              borders++;
            }
          } else {
            borders++;
          }
        }
      }
    }
    if (borders < 3) {
      filled = false;
    } else if (borders > 4) {
      filled = true;
    }
  }

  void nipBuds(Cell[][] cells) {
    borders = 0;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!( i ==0 && j == 0)) {

          if (exists(i, j, cells)) {
            if (cells[int(gridPos.y + j)][int(gridPos.x + i)].filled) {
              borders++;
            }
          } else {
            borders++;
          }
        }
      }
    }

    if ( borders < 4) {
      filled = false;
    }
  }

  void floodFill(Cell[][] cells, ArrayList<Cell> cellss) {
    if (state == "open") {
      for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
          if ((abs(i) + abs(j) < 2) && !( i ==0 && j == 0)) {

            if (exists(i, j, cells)) {
              if (!cells[int(gridPos.y + j)][int(gridPos.x + i)].filled && cells[int(gridPos.y + j)][int(gridPos.x + i)].state == "none") {
                cells[int(gridPos.y + j)][int(gridPos.x + i)].state = "open";
                cells[int(gridPos.y + j)][int(gridPos.x + i)].fillColor = fillColor;
                cellss.add(cells[int(gridPos.y + j)][int(gridPos.x + i)]);
              }
            }
          }
        }
      }
      state = "closed";
    }
  }

  void erode(float erosionFactor, Cell[][] cells, ArrayList<Cell> cells2) {
    if (erosionFactor > 1) {
      filled = false;
    } else if (random(0, 1) <= erosionFactor) {
      filled = false;
    } else {
      filled = true;
    }

    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if ((abs(i) + abs(j) < 2) && !( i ==0 && j == 0)) {

          if (exists(i, j, cells)) {
            if (cells[int(gridPos.y + j)][int(gridPos.x + i)].erosionState == "none" && cells[int(gridPos.y + j)][int(gridPos.x + i)].filled) {
              cells2.add(cells[int(gridPos.y + j)][int(gridPos.x + i)]);
            }
          }
        }
      }
    }
    erosionState = "done";
  }
}
