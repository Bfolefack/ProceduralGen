class Grid {
  Cell[][] Cells;
  int gridWidth, gridHeight;
  float xPos, yPos;
  float[] div2 = {0.6, 0.2, 0.1, 0.05, 0.025, 0.0125, 0.00625, 0.003125};

  Grid(float x_, float y_, int gw_, int gh_) {
    Cells = new Cell[gh_][gw_];
    gridWidth = gw_;
    gridHeight = gh_;
    xPos = x_;
    yPos = y_;
    for (int i = 0; i < gridHeight; i++) {
      Cell[] tempCells = new Cell[gridWidth];
      for (int j = 0; j < gridWidth; j++) {
        tempCells[j] = new Cell(j, i);
      }
      Cells[i] = tempCells;
    }
    for (int k = 0; k < 6; k++){
      for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {
          Cells[i][j].addNoise(getNoise(i, j, pow(noiseDetail, k) + noiseScale) * div2[k]);
        }
      }
    }
    
    float smallest = Integer.MAX_VALUE; 
    float biggest = Integer.MIN_VALUE; 
    
    for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {
          if(Cells[i][j].noise > biggest){
            biggest = Cells[i][j].noise;
          }
          if(Cells[i][j].noise < smallest){
            smallest = Cells[i][j].noise;
          }
        }
      }
      
      for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {
          Cells[i][j].noise = map(Cells[i][j].noise, smallest, biggest, 0, 1);
          Cells[i][j].updateColor();
        }
      }
      getImage();
      println("done!");
  }
  
  PImage getImage(){
    PImage p = createImage(gridWidth, gridHeight, RGB);
    for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {
          //println((i * gridHeight) + j);
          p.pixels[(i * gridWidth) + j] = Cells[i][j].currColor;
        }
      }
    p.save("Map_" + seed + ".png");
    return p;
  }

  float getNoise(int index, int index2, float nD) {
    float angle = (((((TWO_PI)/(gridWidth/gridHeight)))/(gridHeight)) * (index));
    float angle2 = (((TWO_PI)/(gridWidth))) * (index2);
    float cosAngle = (angle);
    float sinAngle = (angle);
    float cosAngle2 = cos(angle2);
    float sinAngle2 = sin(angle2);
    return map((float) noise.eval((cosAngle) * nD, (sinAngle) * nD, (cosAngle2) * nD, (sinAngle2) * nD), -1, 1, 0, 1);
  }


  void display() {

    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        Cells[i][j].display();
      }
    }

    //stroke(0);

    for (int i = 0; i < gridWidth; i++) {
      line(xPos + gridScale * i, yPos, xPos + gridScale * i, yPos + gridHeight * gridScale);
    }

    for (int i = 0; i < gridHeight; i++) {
      line(xPos, yPos + gridScale * i, xPos + gridWidth * gridScale, yPos + gridScale * i);
    }

    //rectMode(CORNERS);
    //fill(0);
    //rect(-5, -5, 5, gridHeight * gridScale);
    //rect(-5, -5, gridWidth * gridScale, 5);
    //rect(- 5, gridHeight * gridScale - 5, gridWidth * gridScale, gridHeight * gridScale + 5);
    //rect(gridWidth * gridScale - 5, -5, gridWidth * gridScale + 5, gridHeight * gridScale);
    //rectMode(CORNER);
  }

  void update() {
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        Cells[i][j].update();
      }
    }
  }
}
