class Lake {
  ArrayList<Cell> lake = new ArrayList<Cell>();
  ArrayList<Cell> active = new ArrayList<Cell>();
  ArrayList<Cell> nextActive = new ArrayList<Cell>();
  color col;

  Lake() {
  }

  Lake(Cell seed) {
    active.add(seed);
    col = color(random(255), random(255), random(255));
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

  void ocean() {
    for (Cell c : lake) {
      c.ocean = true;
    }
  }

  void drain() {
    for (Cell c : lake) {
      c.water = false;
      c.laked = false;
    }

    //for (Cell c : lake) {
    //  c.finalElevation = 0.5 + (float) (noise.eval(c.xPos * 0.05, c.yPos * 0.05) + 1) * 0.02;
    //  c.laked = false;
    //}
  }

  //Lake(Cell seed, Grid grid, River river) {
  //  active.add(seed);
  //  col = color(random(255), random(255), random(255));
  //  while (active.size() > 0) {
  //    nextActive.clear();
  //    Cell lowest = getLowest(active);
  //    Cell highest = getHighest(lake);
  //    if(lowest.finalElevation > highest.finalElevation){
  //      river = new River(lowest);
  //    } else {

  //    }
  //    active.clear();
  //    for (Cell c : nextActive) {
  //      if (c.laked == false) {
  //        active.add(c);
  //      }
  //    }
  //  }
  //}

  //Cell getLowest(ArrayList<Cell> cs) {
  //  Cell lowest = new Cell();
  //  lowest.finalElevation = 1;
  //  for (Cell c : cs) {
  //    if (c.finalElevation < lowest.finalElevation) {
  //      lowest = c;
  //    }
  //  }
  //  return lowest;
  //}
  //Cell getHighest(ArrayList<Cell> cs) {
  //  Cell highest = new Cell();
  //  highest.finalElevation = 0;
  //  for (Cell c : cs) {
  //    if (c.finalElevation > highest.finalElevation) {
  //      highest = c;
  //    }
  //  }
  //  return highest;
  //}
}
