class Grid {
  Cell[][] Cells;
  int gridWidth, gridHeight;
  float xPos, yPos;
  ArrayList<Cavern> caverns = new ArrayList<Cavern>();

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
    
    smoothCavern();
    
    int count = 0;
    while(true){
      caverns();
      count++;
      println(count);
      if(caverns.size() <= 1 || count > 100){
        break;
      }
      resetGrid();
    }
    
    
  }

  void display() {
    for (int i = 0; i < gridWidth; i++) {
      line(xPos + gridScale * i, yPos, xPos + gridScale * i, yPos + gridHeight * gridScale);
    }

    for (int i = 0; i < gridHeight; i++) {
      line(xPos, yPos + gridScale * i, xPos + gridWidth * gridScale, yPos + gridScale * i);
    }

    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {   
        Cells[i][j].display();
      }
    }
    
    for(Cavern c: caverns){
      c.display();
    }
  }

  void update() {
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {
      }
    }
  }

  void smoothCavern() {
    for (int k = 0; k < 40; k++) {
      for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {   
          Cells[i][j].smoothCavern(Cells);
        }
      }
    }
    
    for (int k = 0; k < 25; k++) {
      for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {   
          Cells[i][j].nipBuds(Cells);
        }
      }
    }
    
  }
  
  boolean createCaverns() {
    Cavern c = new Cavern(Cells);
    if(c.cavernAvailible){
        caverns.add(c);
    }
    return c.cavernAvailible;
  }
  
  void caverns(){
    int count = 0;
     while(true){
        count++;
        if(!createCaverns()){
          break;
        }
    }
    
    if(caverns.size() <= 1){
      return;
    }
    
    ArrayList<Cavern> cavernsToBeRemoved = new ArrayList<Cavern>();
    
    for(Cavern c: caverns){
      if(c.myCells.size() < 10){
        c.fillIn();
        cavernsToBeRemoved.add(c);
      }
    }
    
    for(Cavern c: cavernsToBeRemoved){
       caverns.remove(c); 
    }
    cavernsToBeRemoved.clear();
    
    for(Cavern c: caverns){
      c.getNearestLine(Cells);
    } 
    
    ArrayList<Cell> erodingCells = new ArrayList<Cell>();
    for(Cavern c: caverns){
      ArrayList<Cell> tempCells = c.getErosionCells(Cells);
      for(Cell cl: tempCells){
        erodingCells.add(cl);
      }
    }
    float erosionFactor = 1;
    for(int i = 0; i < 15; i++){
      
      ArrayList<Cell> tempCells = new ArrayList<Cell>();
      for(Cell c: erodingCells){
         c.erode(erosionFactor, Cells, tempCells);
      }
      erodingCells.clear();
      for(Cell c: tempCells){
        erodingCells.add(c);
      }
      if(i < 1){
       erosionFactor = 1;
      } else {
        erosionFactor *= .75;
      }
    }
    
    smoothCavern();
    
  }
  
  void resetGrid(){
    for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {   
          Cells[i][j] = new Cell(int(Cells[i][j].gridPos.x), int(Cells[i][j].gridPos.y), Cells[i][j].filled);
        }
      }
      caverns = new ArrayList<Cavern>();
  }
   
}
