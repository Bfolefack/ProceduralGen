class Cell {
  PVector gridPos;
  int borders;
  float noise;
  color currColor;

  Cell(int x_, int y_) {
    gridPos = new PVector(x_, y_);
    noise = 0;
    currColor = color(0);
  }
  void addNoise(float n_) {
    if (noise < .2) {
      currColor = color(25, 40, 150);
    }else  if (noise < .5) {
      currColor = color(25, 40, 220);
    }else if (noise < .6) {
      currColor = color(45, 85, 220);
    } else if (noise < .65) {
      currColor = color(200, 230, 100);
    } else if (noise < .7) {
      currColor = color(20, 225, 45);
    } else if (noise < .87) {
      currColor = color(20, 150, 45);
    } else if (noise < .9) {
      currColor = color(100, 50, 0);
    } else if (noise < .95) {
      currColor = color(50, 25, 0);
    } else if (noise < 1) {
      currColor = color(255);
    } else {
      currColor = color(25, 40, 220);
    }
    noise += n_;
  }

  void updateColor() {
    if (noise < .6) {
      currColor = color(25, 40, 220);
    } else if (noise < .63) {
      currColor = color(45, 85, 220);
    } else if (noise < .65) {
      currColor = color(200, 230, 100);
    } else if (noise < .7) {
      currColor = color(20, 225, 45);
    } else if (noise < .8) {
      currColor = color(20, 150, 45);
    } else if (noise < .9) {
      currColor = color(100, 50, 0);
    } else if (noise < .95) {
      currColor = color(50, 25, 0);
    } else if (noise <= 1) {
      currColor = color(255);
    } else {
      currColor = color(noise * 255);
    }
  }

  void display() {
    fill(currColor);
    rect(gridPos.x * gridScale, gridPos.y * gridScale, gridScale, gridScale);
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
      if (x + gridPos.x < 0) {
        ifx = false;
      }
    }
    if (x > 0) {
      println(x + gridPos.x);
      println(cells[0].length);
      println(x + gridPos.x > cells[0].length);
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
}
