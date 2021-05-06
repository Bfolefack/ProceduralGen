class Cell {
  PVector gridPos;
  int borders;
  float noise, dTC;
  
  Cell(int x_, int y_, float n_){
    gridPos = new PVector(x_, y_);
    noise = n_;
    if (gridPos.y < gridPos.x && gridPos.x < -gridPos.y + grdHeight/gridScale){
        //Top
        dTC = dist(gridPos.x, gridPos.y, gridPos.x, 0);
      } else if (gridPos.y < gridPos.x && gridPos.x >= -gridPos.y + grdHeight/gridScale){
        //Right
        dTC = dist(gridPos.x, gridPos.y, grdWidth/gridScale, gridPos.y);
      } else if (gridPos.y >= gridPos.x && gridPos.x < -gridPos.y + grdHeight/gridScale){
        //Left
        dTC = dist(gridPos.x, gridPos.y, 0, gridPos.y);
      } else if (gridPos.y >= gridPos.x && gridPos.x >= -gridPos.y + grdHeight/gridScale){
        //Bottom
        dTC = dist(gridPos.x, gridPos.y, gridPos.x, grdHeight/gridScale);
      }
      dTC = map(dTC, 0, 400, 0, 1);
      dTC = 1 - dTC;
      //dTC -= .2;
      if(dTC < 0){
        dTC = 0; 
      }
      noise = (noise + dTC)/2;
  }
  
  void display(){
      
      if(noise < .5){
        fill(25, 40, 220);
      } else if (noise < .54){
        fill(45, 85, 220);
      } else if (noise < .6){
        fill(200, 230, 100);
      } else if (noise < .65){
        fill(20, 225, 45);
      } else if (noise < .75){
        fill(20, 150, 45);
      } else if (noise < .8){
        fill(100, 50, 0);
      } else if (noise < .9){
        fill(50, 25, 0);
      } else if (noise < 1){
        fill(255);
      } else {
        fill(noise * 255);
      }
      //fill(dTC * 255);
      
      rect(gridPos.x * gridScale - .02, gridPos.y * gridScale - .02, gridScale + .04, gridScale + .04);
    
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
    
    if(x < 0){
      if(x + gridPos.x < 0){
        ifx = false;
      }
    }
    if(x > 0){
      if(x + gridPos.x > cells[0].length - 1){
        ifx = false;
      }
    }
    
    if(y < 0){
      if(y + gridPos.y < 0){
        ify = false;
      }
    }
    if(y > 0){
      if(y + gridPos.y > cells.length - 1){
        ify = false;
      }
    }
    return ifx && ify;
  }
   
  void update(){
     PVector maus = getMouseGridspace();
     
   }
}
