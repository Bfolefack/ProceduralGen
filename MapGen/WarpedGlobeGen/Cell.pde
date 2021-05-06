class Cell {
  int xPos;
  int yPos;
  float noise;
  color currColor;

  Cell(int x_, int y_) {
    xPos = x_;
    yPos = y_;
    noise = 0;
    currColor = color(0);
  }
  
  Cell() {}

  void updateColor() {
    //finalElevation = (noise + elevation)/2.0;
    if (noise < .01) {
      currColor = color(15, 50, 100);
    }else if (noise < .03) {
      currColor = color(15, 50, 150);
    }else  if (noise < .20) {
      currColor = color(25, 40, 200);
    }else if (noise < .3) {
      currColor = color(25, 60, 220);
    }else if (noise < .43) {
      currColor = color(25, 80, 220);
    }else if (noise < .5) {
      currColor = color(60, 130, 250);
    }else if (noise < .55) {
      currColor = color(250, 230, 150);
    }else if (noise < .65) {
      currColor = color(130, 220, 80);
    }else if (noise < .75) {
      currColor = color(100, 180, 60);
    }else if (noise < .8) {
      currColor = color(180, 120, 0);
    }else if (noise < .9) {
      currColor = color(120, 70, 0);
    }else if (noise <= 1) {
      currColor = color(255);
    }else {
      currColor = color(noise * 255);
    }
  }

  void display() {
    fill(currColor);
    rect(xPos * gridScale, yPos * gridScale, gridScale, gridScale);
  }

  PVector getMouseGridspace() {
    int x, y;
    x = int(truMouseX/gridScale);
    y = int(truMouseY/gridScale);
    return new PVector(x, y);
  }

  boolean exists(int x, int y, Cell[][] cells) {
    boolean ifx, ify;
    ifx = true;
    ify = true;

    if (x < 0) {
      if (x + xPos < 0) {
        ifx = false;
      }
    }
    if (x > 0) {
      println(x + xPos);
      println(cells[0].length);
      println(x + xPos > cells[0].length);
      if (x + xPos > cells[0].length - 1) {
        ifx = false;
      }
    }

    if (y < 0) {
      if (y + yPos < 0) {
        ify = false;
      }
    }
    if (y > 0) {
      if (y + yPos > cells.length - 1) {
        ify = false;
      }
    }
    return ifx && ify;
  }
  
  //NOISE FUNCTIONS
  void addNoise(float n_) {
    noise += n_;
    updateColor();
  }
}
