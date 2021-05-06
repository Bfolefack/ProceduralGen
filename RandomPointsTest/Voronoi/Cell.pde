import java.util.*;

class Cell {
  color voronoiID;
  PVector pos;
  PVector truPos;
  ArrayList<Point> points = new ArrayList<Point>();
  Chunk chunk;
  Cell(int x, int y, Chunk c) {
    pos = new PVector(x, y);
    truPos = new PVector(c.pos.x * c.size + pos.x, c.pos.y * c.size + pos.y);
    voronoiID = color(0);
    chunk = c;
  }

  void display() {
    stroke(voronoiID);
    point(truPos.x, truPos.y);
  }

  void generateVoronoi() {
    ArrayList<Chunk> chunkTree = new ArrayList<Chunk>(); 
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        chunkTree.add(getChunk((int)chunk.pos.x + i, (int)chunk.pos.y + j, grid.grid));
      }
    }
    for (Chunk c : chunkTree) {
      for (Point p : c.points) {
        points.add(p);
      }
    }
    float smallestDist = 10000000000.0;
    Point smallest = new Point(0, 0);
    smallest.c = 0;
    for (Point p: points) {        
      float distance = sqrt(sq((p.pos.x - truPos.x)) +  sq(p.pos.y -truPos.y));
      float distance1 = sqrt(sq((p.pos.x + width) - truPos.x) + sq(p.pos.y -truPos.y));
      float distance2 = sqrt(sq((p.pos.x - width) - truPos.x) + sq(p.pos.y -truPos.y));
      //if(distance1 < distance)
      //  distance = distance1;
      //if(distance2 < distance)
      //  distance = distance2;
      if (distance < smallestDist) {
        smallestDist = distance;
        smallest = p;
      }
    }
    if(smallestDist > width/2){
      println("wah");
    }
    voronoiID = smallest.c;
    smallest.cells.add(this);
    
  }

  Chunk getChunk(int x, int y, Chunk[][] chunks) {
    if (x < 0) {
      x = chunks.length - 1;
    }
    if (y < 0) {
      y = 0;
    }
    if (x > chunks.length - 1) {
      x = 0;
    }
    if (y > chunks[0].length - 1) {
      y = chunks[0].length - 1;
    }
    return chunks[x][y];
  }
}
