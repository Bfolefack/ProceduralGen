import java.util.*;

class Lake {
  PriorityQueue<Cell> lake = new PriorityQueue<Cell>();
  ArrayList<Cell> active = new ArrayList<Cell>();
  ArrayList<Cell> nextActive = new ArrayList<Cell>();
  float waterLevel;
  float trueGreatestFlow;
  color col;

  Lake() {
    col = color(random(255), random(255), random(255));
  }

  Lake(Cell seed) {
    active.add(seed);
    col = color(random(255), random(255), random(255));
  }

  void add(Cell c) {
    c.lake = this; 
    c.laked = true; 
    lake.add(c);
  }

  void fillBody(Grid grid) {
    while (active.size() > 0) {
      nextActive.clear();
      for (Cell c : active) {
        c.fillLake(this, grid);
      }
      active.clear();
      for (Cell c : nextActive) {
        if (c.laked == false) {
          active.add(c);
        }
      }
    }
  }

  void calculateLakeFill() {
    //println(lake);
    float greatestFlow = -1;
    for (Cell c : lake) {
      if (c.rawFlow > greatestFlow) {
        greatestFlow = c.rawFlow;
        trueGreatestFlow = c.flow;
      }
    }
    waterLevel += sq(greatestFlow/16);
    //println(waterLevel);
    for (Cell c : lake) {
      if (c.finalElevation > 0.5) {
        waterLevel += sq((c.finalElevation - 0.5) * 2);
      }
      waterLevel += c.moisture - 0.2;
    }
  }

  void smoothLake(Grid grid) { 
    //if (lake.size() > 5)
      for (Cell c : lake) {
        c.smoothLake(grid);
      }
  }

  void flood() {
    Object[] tempLake = lake.toArray();
    if (waterLevel > tempLake.length) {
      for (int i = 0; i < tempLake.length; i++) {
        ((Cell)tempLake[i]).water = true;
      }
    } else {
      for (int i = 1; i < waterLevel; i++) {
        ((Cell)tempLake[i]).water = true;
      }
    }
  }

  void ocean() {
    for (Cell c : lake) {
      c.ocean = true;
    }
  }

  void drain() {
    for (Cell c : lake) {
      c.water = false;
    }
  }
}
