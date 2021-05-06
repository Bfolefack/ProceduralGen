public class Grid {
  Cell[][] cells;
  float warpLevel;
  int gridWidth, gridHeight;
  PVector possibR;
  float xPos, yPos;
  float[] octaves = {50, 25, 12.5, 6.25, 3.125, 1.0625, 0.5, 0.25};

  Grid(float x_, float y_, int gw_, int gh_, float wL_) {
    cells = new Cell[gw_][gh_];
    gridWidth = gw_;
    gridHeight = gh_;
    xPos = x_;
    yPos = y_;
    warpLevel = wL_;
    possibR = new PVector(Integer.MAX_VALUE, Integer.MIN_VALUE);
    println("stepOne");
    for (int i = 0; i < gridWidth; i++) {
      Cell[] tempCells = new Cell[gridHeight];
      for (int j = 0; j < gridHeight; j++) {
        tempCells[j] = new Cell(i, j);
      }
      cells[i] = tempCells;
    }
    println("stepTwo");
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        for (int k = 0; k < 6; k++) {
          cells[i][j].addNoise(getNoise(i, j, pow(noiseDetail, k + 0.3) + noiseScale) * octaves[k]);
        }
      }
    }
    println("stepThree");
    
    float smallest = Integer.MAX_VALUE; 
    float biggest = Integer.MIN_VALUE; 

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j].noise > biggest) {
          biggest = cells[i][j].noise;
        }
        if (cells[i][j].noise < smallest) {
          smallest = cells[i][j].noise;
        }
      }
    }
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].noise = pow(map(cells[i][j].noise, smallest, biggest, 0, 1), noisePower);
        cells[i][j].updateColor();
      }
    }
    
    getImage(); //<>//
    //println(possibR);
    println("done!");
  }

  PImage getImage() {
    PImage p = createImage(gridWidth, gridHeight, RGB);
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        //println((i * gridHeight) + j);
        p.pixels[(i * gridHeight) + j] = cells[i][j].currColor;
      }
    }
    p.save("Maps/" + warpLevel + "/"+ gridWidth + "x" + gridHeight + "/Map_"+ gridWidth + "x" + gridHeight + "_" + seed + ".png");
    return p;
  }




  float getNoise(int index2, int index, float nD) {
    float lat = abs((gridHeight/2) - index) * 2;
    float r =pow(sqrt((float)gridHeight * 2 * (float)lat - pow((float)lat, 2.0))/float(gridHeight), warpLevel);
    r = 1.0 - r;
    float angle = ((TWO_PI/(gridWidth/gridHeight))/gridHeight) * index;
    float angle2 = (TWO_PI)/(gridWidth) * index2;
    float cosAngle2 = cos(angle2);
    float sinAngle2 = sin(angle2);
    if(r < possibR.x){
      possibR.x = r;
    }
    if(r > possibR.y){
      possibR.y = r;
    }
    return map((float) noise.eval(angle * nD, (cosAngle2) * nD * r, (sinAngle2) * nD * r), -1, 1, 0, 1);
  }





  void display() {

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {   
        cells[i][j].display();
      }
    }
    //if(bordersChecked){
    //  for (int i = 0; i < gridWidth; i++) {
    //    for (int j = 0; j < gridHeight; j++) {
    //      cells[i][j].showStroke();
    //    }
    //  }
    //}

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
    //Created by Boueny  Folefack
    //rectMode(CORNER);
  }

  Cell getCell(int x, int y) {
    if (x >= 0 && y >= 0 && x < gridWidth && y < gridHeight)
      return cells[x][y];
    if (y < cells[0].length && y >= 0) {
      if (x < 0) {
        return cells[gridWidth + x][y];
      }
      if (x > 0) {
        return cells[x - gridWidth][y];
      }
    }
    return new Cell();
  }
}
