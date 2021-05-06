class Grid {
  Chunk[][] grid;
  int chunkSize;
  Point[] points;

  Grid(int c, int p) {
    chunkSize = c;
    grid = new Chunk[width/chunkSize][height/chunkSize];
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        grid[i][j] = new Chunk(i, j, chunkSize);
      }
    }
    
    points = new Point[p];
    for (int i = 0; i < points.length; i++) {
      points[i] = new Point(random(width), random(height));
      grid[(int)points[i].pos.x/chunkSize][(int)points[i].pos.y/chunkSize].points.add(points[i]);
    }   
  }

  void display() {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        grid[i][j].display();
      }
    }
  }
  
  void generateVoronoi(){
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        grid[i][j].generateVoronoi();
      }
    }
  }
  
  void relax(){
    Point[] temp = new Point[points.length];
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        grid[i][j].clearPoints();
      }
    }
    for(int i = 0; i < points.length; i++){
      temp[i] = points[i].getAvgPoint();
      grid[(int)temp[i].pos.x/chunkSize][(int)temp[i].pos.y/chunkSize].points.add(temp[i]);
    }
    points = temp;
    generateVoronoi();
  }
}
