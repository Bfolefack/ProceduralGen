class Point{
  PVector pos;
  color c;
  ArrayList<Cell> cells;
  
  Point(float x, float y){
    cells = new ArrayList<Cell>();
    pos = new PVector(x, y);
    //c = color(noise(x * .01, y * .01) * 255, 0, noise((x + 10000) * .01, (y + 10000) * .01) * 255 );
    c = color(random(255), random(255), random(255));
  }
  
  Point(PVector p){
    cells = new ArrayList<Cell>();
    pos = p;
     c = color(random(255), random(255), random(255));
  }
  
  void display(){
    ellipse(pos.x, pos.y, 5, 5);
  }
  
  Point getAvgPoint(){
    PVector total = new PVector(0, 0);
    for(Cell c : cells){
      total.add(c.truPos);
    }
    total.div(cells.size());
    return new Point(total);
  }
  
}
