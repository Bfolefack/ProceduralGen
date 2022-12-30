int gridScale, grdWidth, grdHeight;
MazeGrid griddle;
int noiseCount;
int INF = 999999999;
boolean begin = false;
boolean pathFound = false;
PVector start;
PVector end;
Grid grid;
int speed = 50;

void setup () {
  fullScreen(P2D);
  gridScale = 10;
  griddle = new MazeGrid(0, 0, width/gridScale, height/gridScale);
  frameRate(2000);
  noStroke();
  fill(0);
    
}

void draw () {
  background(255);
  if(griddle.clippedEnds){
    if(grid != null){
      grid.highlightGridspace();
      if (begin) {
        for(int i = 0; i < speed; i++)
          grid.update();
      }
       grid.display();
    } else {
      griddle.display();
    }
  } else {
   griddle.display();
   for(int i = 0; i < speed; i++)
     griddle.update();
  }
  //if(frameRate < 30 && speed > 20){
  //  speed--;
  //} else if (speed < 75) {
  //  speed++;
  //}
  println(frameRate);
  println(speed);
}

void mouseClicked() {
  if (mouseButton == RIGHT) {
    if (begin) {
      begin = false;
    } else {
      begin = true;
    }
  } else if (start == null){
    start = new PVector(mouseX/gridScale, mouseY/gridScale);
  } else if(end == null){
    end = new PVector(mouseX/gridScale, mouseY/gridScale);
    grid = new Grid(gridScale, (int)start.x, (int)start.y, (int)end.x, (int)end.y);
    for (int i = 0; i < griddle.Cells.length; i++){
      for (int j = 0; j < griddle.Cells[0].length; j++){
        if(griddle.Cells[i][j].status == "wall"){
          grid.gridCells[i][j].gridType = "blocked";
        }
      }
    }
  }
}

void keyPressed() {
  if(key == 's'){
    saveFrame("data/####.png");
  }
}
