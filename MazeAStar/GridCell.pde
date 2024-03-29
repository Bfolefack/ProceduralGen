class GridCell {


  int xCoord, yCoord;
  int displayMode = 1;
  String gridType = "empty";
  PVector col = new PVector(0, 0, 0);
  boolean touchingMouse, start;
  boolean startRun = true;
  int g, h;
  GridCell gSource;
  GridCell[][] cells;




  GridCell(int x_, int y_) {
    xCoord = x_;
    yCoord = y_;
  }


  //***************************************************************************************************************************************************  


  void setArray(GridCell[][] c_) {
    cells = c_;
  }


  //***************************************************************************************************************************************************


  void display() {
    if (gridType == "start" ) {
      start = true;
    }
    if (start) {
      gridType = "start";
    }
    if (gridType == "start" || gridType == "end") {
      col = new PVector(0, 100, 255); 
      displayMode = 2;
    }

    if (gridType == "path") {
      col = new PVector(0, 200, 255);
      displayMode = 2;
    }

    if (gridType == "open") {
      col = new PVector(0, 255, 50); 
      displayMode = 2;
    }

    if (gridType == "closed") {
      col = new PVector(255, 50, 0); 
      displayMode = 2;
    }

    if (gridType == "blocked") {
      col = new PVector(0, 0, 0); 
      displayMode = 2;
    }

    if (touchingMouse == true) {
      col = new PVector(0, 0, 0);
    }

    if (displayMode == 2) {

      fill(col.x, col.y, col.z);
      rectMode(CORNERS);
      rect(xCoord * gridScale, yCoord * gridScale, xCoord * gridScale + gridScale, yCoord * gridScale + gridScale);
    }

    //ellipseMode(CENTER);
    //fill(0);
    //if (gridScale/3 >= 1) {
    //  circle(xCoord * gridScale + gridScale/2, yCoord * gridScale + gridScale/2, gridScale/3);
    //} else {
    //  circle(xCoord * gridScale + gridScale/2, yCoord * gridScale + gridScale/2, 1);
    //}



    if (gridType == "open" || gridType == "closed" || gridType == "path") {
      /*
        textSize(15);
        text(g, xCoord * gridScale + gridScale/5, yCoord * gridScale + gridScale/4);
        text(h, xCoord * gridScale + gridScale/1.5, yCoord * gridScale + gridScale/4);
        */
      
      
    }



    touchingMouse = false;
    displayMode = 1;
  }


  //***************************************************************************************************************************************************


  boolean exists(int y, int x) {
    boolean ifx, ify;
    ifx = true;
    ify = true;

    if (x < 0) {
      if (x + xCoord < 0) {
        ifx = false;
      }
    }
    if (x > 0) {

      if (x + xCoord > cells[0].length - 1) {
        ifx = false;
      }
    }

    if (y < 0) {
      if (y + yCoord < 0) {
        ify = false;
      }
    }
    if (y > 0) {
      if (y + yCoord > cells.length - 1) {
        ify = false;
      }
    }

    return ifx && ify;
  }


  //***************************************************************************************************************************************************


  void setGnH(int g_, GridCell cell) {
    g = g_;
    h = int(dist(xCoord * gridScale + gridScale/2, yCoord * gridScale + gridScale/2, cell.xCoord * gridScale + gridScale/2, cell.yCoord * gridScale + gridScale/2)/(gridScale/10));
  }


  //***************************************************************************************************************************************************


  void startRun(GridCell start, GridCell end) {
    if (gridType == "start") {
      if (startRun) {
        g = 0;
        h = int(dist(xCoord * gridScale + gridScale/2, yCoord * gridScale + gridScale/2, end.xCoord * gridScale + gridScale/2, end.yCoord * gridScale + gridScale/2)/(gridScale/10));
        if (exists(1, 0)) {
          if (cells[yCoord + 1][xCoord].gridType == "empty") {
            cells[yCoord + 1][xCoord].gridType = "open";
            cells[yCoord + 1][xCoord].setGnH(g + 10, end);
            cells[yCoord + 1][xCoord].gSource = this;
          }
        }

        if (exists(-1, 0)) {
          if (cells[yCoord - 1][xCoord].gridType == "empty") {
            cells[yCoord - 1][xCoord].gridType = "open";
            cells[yCoord - 1][xCoord].setGnH(g + 10, end);
            cells[yCoord - 1][xCoord].gSource = this;
          }
        }

        if (exists(0, 1)) {
          if (cells[yCoord][xCoord + 1].gridType == "empty") {
            cells[yCoord][xCoord + 1].gridType = "open";
            cells[yCoord][xCoord + 1].setGnH(g + 10, end);
            cells[yCoord][xCoord + 1].gSource = this;
          }
        }

        if (exists(0, -1)) {
          if (cells[yCoord][xCoord - 1].gridType == "empty") {
            cells[yCoord][xCoord - 1].gridType = "open";
            cells[yCoord][xCoord - 1].setGnH(g + 10, end);
            cells[yCoord][xCoord - 1].gSource = this;
          }
        }
    //if (exists(1, 1)) {
    //  if (cells[yCoord + 1][xCoord + 1].gridType == "empty") {
    //    cells[yCoord + 1][xCoord + 1].gridType = "open";
    //    cells[yCoord + 1][xCoord + 1].setGnH(g + 14, end);
    //    cells[yCoord + 1][xCoord + 1].gSource = this;
    //  }
    //}

    //if (exists(-1, 1)) {
    //  if (cells[yCoord - 1][xCoord + 1].gridType == "empty") {
    //    cells[yCoord - 1][xCoord + 1].gridType = "open";
    //    cells[yCoord - 1][xCoord + 1].setGnH(g + 14, end);
    //    cells[yCoord - 1][xCoord + 1].gSource = this;
    //  }
    //}

    //if (exists(1, -1)) {
    //  if (cells[yCoord + 1][xCoord - 1].gridType == "empty") {
    //    cells[yCoord + 1][xCoord - 1].gridType = "open";
    //    cells[yCoord + 1][xCoord - 1].setGnH(g + 14, end);
    //    cells[yCoord + 1][xCoord - 1].gSource = this;
    //  }
    //}

    //if (exists(-1, -1)) {
    //  if (cells[yCoord - 1][xCoord - 1].gridType == "empty") {
    //    cells[yCoord - 1][xCoord - 1].gridType = "open";
    //    cells[yCoord - 1][xCoord - 1].setGnH(g + 14, end);
    //    cells[yCoord - 1][xCoord - 1].gSource = this;
    //  }
    //}
        startRun = false;
      }
    }
  }


  //***************************************************************************************************************************************************


  void infectBorders(GridCell start, GridCell end) {
    if (exists(1, 0)) {
      if (cells[yCoord + 1][xCoord].gridType == "empty") {
        cells[yCoord + 1][xCoord].gridType = "open";
        cells[yCoord + 1][xCoord].setGnH(g + 10, end);
        cells[yCoord + 1][xCoord].gSource = this;
      }
      if (cells[yCoord + 1][xCoord].gridType == "open" || cells[yCoord + 1][xCoord].gridType == "closed") {
        if (g + 10 < cells[yCoord + 1][xCoord].g) {
          cells[yCoord + 1][xCoord].g = g + 10;
          cells[yCoord + 1][xCoord].gSource = this;
        }
      }
      if (cells[yCoord + 1][xCoord].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }

    if (exists(-1, 0)) {
      if (cells[yCoord - 1][xCoord].gridType == "empty") {
        cells[yCoord - 1][xCoord].gridType = "open";
        cells[yCoord - 1][xCoord].setGnH(g + 10, end);
        cells[yCoord - 1][xCoord].gSource = this;
      }
      if (cells[yCoord - 1][xCoord].gridType == "open" || cells[yCoord - 1][xCoord].gridType == "closed") {
        if (g + 10 < cells[yCoord - 1][xCoord].g) {
          cells[yCoord - 1][xCoord].g = g + 10;
          cells[yCoord - 1][xCoord].gSource = this;
        }
      }
      if (cells[yCoord - 1][xCoord].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }

    if (exists(0, 1)) {
      if (cells[yCoord][xCoord + 1].gridType == "empty") {
        cells[yCoord][xCoord + 1].gridType = "open";
        cells[yCoord][xCoord + 1].setGnH(g + 10, end);
        cells[yCoord][xCoord + 1].gSource = this;
      }
      if (cells[yCoord][xCoord + 1].gridType == "open" || cells[yCoord][xCoord + 1].gridType == "closed") {
        if (g + 10 < cells[yCoord][xCoord + 1].g) {
          cells[yCoord][xCoord + 1].g = g + 10;
          cells[yCoord][xCoord + 1].gSource = this;
        }
      }
      if (cells[yCoord][xCoord + 1].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }

    if (exists(0, -1)) {
      if (cells[yCoord][xCoord - 1].gridType == "empty") {
        cells[yCoord][xCoord - 1].gridType = "open";
        cells[yCoord][xCoord - 1].setGnH(g + 10, end);
        cells[yCoord][xCoord - 1].gSource = this;
      }
      if (cells[yCoord][xCoord - 1].gridType == "open" || cells[yCoord][xCoord - 1].gridType == "closed") {
        if (g + 10 < cells[yCoord][xCoord - 1].g) {
          cells[yCoord][xCoord - 1].g = g + 10;
          cells[yCoord][xCoord - 1].gSource = this;
        }
      }
      if (cells[yCoord][xCoord - 1].gridType == "end") {
        gridType = "path";
        pathFound = true;
      }
    }
    
    
    //if (exists(1, 1)) {
    //  if (cells[yCoord + 1][xCoord + 1].gridType == "empty") {
    //    cells[yCoord + 1][xCoord + 1].gridType = "open";
    //    cells[yCoord + 1][xCoord + 1].setGnH(g + 14, end);
    //    cells[yCoord + 1][xCoord + 1].gSource = this;
    //  }
    //  if (cells[yCoord + 1][xCoord + 1].gridType == "open" || cells[yCoord + 1][xCoord + 1].gridType == "closed") {
    //    if (g + 14 < cells[yCoord + 1][xCoord + 1].g) {
    //      cells[yCoord + 1][xCoord + 1].g = g + 14;
    //      cells[yCoord + 1][xCoord + 1].gSource = this;
    //    }
    //  }
    //  if (cells[yCoord + 1][xCoord + 1].gridType == "end") {
    //    gridType = "path";
    //    pathFound = true;
    //  }
    //}

    //if (exists(-1, 1)) {
    //  if (cells[yCoord - 1][xCoord + 1].gridType == "empty") {
    //    cells[yCoord - 1][xCoord + 1].gridType = "open";
    //    cells[yCoord - 1][xCoord + 1].setGnH(g + 14, end);
    //    cells[yCoord - 1][xCoord + 1].gSource = this;
    //  }
    //  if (cells[yCoord - 1][xCoord + 1].gridType == "open" || cells[yCoord - 1][xCoord + 1].gridType == "closed") {
    //    if (g + 14 < cells[yCoord - 1][xCoord + 1].g) {
    //      cells[yCoord - 1][xCoord + 1].g = g + 14;
    //      cells[yCoord - 1][xCoord + 1].gSource = this;
    //    }
    //  }
    //  if (cells[yCoord - 1][xCoord + 1].gridType == "end") {
    //    gridType = "path";
    //    pathFound = true;
    //  }
    //}

    //if (exists(1, -1)) {
    //  if (cells[yCoord + 1][xCoord - 1].gridType == "empty") {
    //    cells[yCoord + 1][xCoord - 1].gridType = "open";
    //    cells[yCoord + 1][xCoord - 1].setGnH(g + 14, end);
    //    cells[yCoord + 1][xCoord - 1].gSource = this;
    //  }
    //  if (cells[yCoord + 1][xCoord - 1].gridType == "open" || cells[yCoord + 1][xCoord - 1].gridType == "closed") {
    //    if (g + 14 < cells[yCoord + 1][xCoord - 1].g) {
    //      cells[yCoord + 1][xCoord - 1].g = g + 14;
    //      cells[yCoord + 1][xCoord - 1].gSource = this;
    //    }
    //  }
    //  if (cells[yCoord + 1][xCoord - 1].gridType == "end") {
    //    gridType = "path";
    //    pathFound = true;
    //  }
    //}

    //if (exists(-1, -1)) {
    //  if (cells[yCoord - 1][xCoord - 1].gridType == "empty") {
    //    cells[yCoord - 1][xCoord - 1].gridType = "open";
    //    cells[yCoord - 1][xCoord - 1].setGnH(g + 14, end);
    //    cells[yCoord - 1][xCoord - 1].gSource = this;
    //  }
    //  if (cells[yCoord - 1][xCoord - 1].gridType == "open" || cells[yCoord - 1][xCoord - 1].gridType == "closed") {
    //    if (g + 14 < cells[yCoord - 1][xCoord - 1].g) {
    //      cells[yCoord - 1][xCoord - 1].g = g + 14;
    //      cells[yCoord - 1][xCoord - 1].gSource = this;
    //    }
    //  }
    //  if (cells[yCoord - 1][xCoord - 1].gridType == "end") {
    //    gridType = "path";
    //    pathFound = true;
    //  }
    //}

    if (gridType == "open") {
      gridType = "closed";
    }
  }
}
