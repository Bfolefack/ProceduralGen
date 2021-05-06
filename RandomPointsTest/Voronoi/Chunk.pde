class Chunk {
  Cell[][] cells;
  PVector pos;
  int size;
  ArrayList<Point> points = new ArrayList<Point>();
  Chunk(int x, int y, int s) {
    size = s;
    pos = new PVector(x, y);
    cells = new Cell[size][size];
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        cells[i][j] =  new Cell(i, j, this);
      }
    }
  }

  void display() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        cells[i][j].display();
      }
    }
  }
  
  void displayPoints(){
    for(Point p : points){
      p.display();
    }
  }
  
  void generateVoronoi(){
    for(int i = 0; i < size; i++){
      for(int j = 0; j < size; j++){
        cells[i][j].generateVoronoi();
      }
    }
  }
  
  void clearPoints(){
    points = new ArrayList<Point>();
    for(int i = 0; i < size; i++){
      for(int j = 0; j < size; j++){
        cells[i][j].points = new ArrayList<Point>();
      }
    }
  }
}
