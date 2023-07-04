class Grid {
  float[][] cells;
  int gridWidth, gridHeight;
  float xPos, yPos;
  float[] div2 = {1};

  Grid(float x_, float y_, int gw_, int gh_) {
    cells = new float[gw_][gh_];
    gridWidth = gw_;
    gridHeight = gh_;
    xPos = x_;
    yPos = y_;
    //println(seed);
    //println(1 + (abs(seed) % 5)/10.f);
    float smallest = Integer.MAX_VALUE; 
    float biggest = Integer.MIN_VALUE;
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        
        float n = pow((getNoise(i, j, 2) + 1)/2, 1 + (abs(seed) % 5)/10.f) > 0.5? 1 : 0;
        cells[i][j] += n;
      }
    }
    
    OpenSimplexNoise mountainNoise = new OpenSimplexNoise(seed/10);
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) { 
        float n = abs(getNoise(i, j, 1, mountainNoise));
        cells[i][j] *= n < 0.206 ? (1-n) * (1-n)* (1-n): 0.5;
      }
    }
   
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j] > biggest)
          biggest = cells[i][j];
      }
    }

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        //cells[i][j]/=biggest;
      }
    }
    display();
    getImage();
    println("done!");
  }

  void getImage() {
    //save("Map_" + seed + ".png");
  }

  float getNoise(int xPos, int yPos, float r) {
    //float angle = (((((TWO_PI)/(gridWidth/gridHeight)))/(gridHeight)) * (index));
    //float angle2 = (((TWO_PI)/(gridWidth))) * (index2);
    //float cosAngle = (angle);
    //float sinAngle = (angle);
    //float cosAngle2 = cos(angle2);
    //float sinAngle2 = sin(angle2);
    float lon = ((float)xPos/gridWidth) * TWO_PI;
    float lat = ((float)yPos/gridHeight) * PI;

    float x = r*sin(lat)*cos(lon);
    float y = r*sin(lat)*sin(lon);
    float z = r*cos(lat);
    float n = (float)(noise.eval(x, y, z));
    return  n;
  }
  
    float getNoise(int xPos, int yPos, float r, OpenSimplexNoise noise) {
    //float angle = (((((TWO_PI)/(gridWidth/gridHeight)))/(gridHeight)) * (index));
    //float angle2 = (((TWO_PI)/(gridWidth))) * (index2);
    //float cosAngle = (angle);
    //float sinAngle = (angle);
    //float cosAngle2 = cos(angle2);
    //float sinAngle2 = sin(angle2);
    float lon = ((float)xPos/gridWidth) * TWO_PI;
    float lat = ((float)yPos/gridHeight) * PI;

    float x = r*sin(lat)*cos(lon);
    float y = r*sin(lat)*sin(lon);
    float z = r*cos(lat);
    float n = (float)(noise.eval(x, y, z));
    return  n;
  }


  void display() {

    loadPixels();

    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[0].length; j++) {


        pixels[j * width + i] = getColor(cells[i][j]);
      }
    }
    fill(0);
    updatePixels();
  }

  color getColor(float noise) {
    if (noise < .4) {
      return color(25, 40, 220);
    } else if (noise < .5) {
      return color(45, 85, 220);
    } else if (noise < .65) {
      return color(200, 230, 100);
    } else if (noise < .7) {
      return color(20, 225, 45);
    } else if (noise < .8) {
      return color(20, 150, 45);
    } else if (noise < .9) {
      return color(100, 50, 0);
    } else if (noise < .95) {
      return color(50, 25, 0);
    } else if (noise <= 1) {
      return color(255);
    } else {
    return color(noise * 255);
    }
  }
  void update() {
    //for (int i = 0; i < gridHeight; i++) {
    //  for (int j = 0; j < gridWidth; j++) {   
    //    Cells[i][j].update();
    //  }
    //}
  }
}
