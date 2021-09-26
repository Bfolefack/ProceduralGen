import java.util.*; //<>//

public class Grid {

  Cell[][] cells;

  float warpLevel;
  float noiseDet;
  float noiseSca;
  float noisePow;
  float xPos, yPos;
  float randomPlateChance;
  float polarPlateChance;

  int gridWidth, gridHeight;
  int localSeed;
  int continentalPlates;
  int oceanicPlates;
  int randomPlates;
  int voronoiSize = 5;
  PVector possibR;

  boolean plateBuilding = true;
  boolean bordersChecked = false;

  Plate[] plates;

  ArrayList<Lake> lakes;
  ArrayList<PVector> shuffledCells;
  ArrayList<VoronoiPoint> vps = new ArrayList<VoronoiPoint>();

  float[] octaves = {50, 25, 12.5, 6.25, 3.125, 2, 1, 0.5};

  JSONObject gridJson = new JSONObject();

  Random randy = new Random(localSeed + 12345);
  Grid() {
    gridWidth = 500;
    gridHeight = 500;
    grdWidth = gridWidth;
    grdHeight = gridHeight;
    cells = new Cell[gridWidth][gridHeight];
    for (int i = 0; i < gridWidth; i++) {
      Cell[] tempCells = new Cell[gridHeight];
      for (int j = 0; j < gridHeight; j++) {
        tempCells[j] = new Cell(i, j);
        tempCells[j].moisture = i/500.0;
        tempCells[j].temperature = j/500.0;
        tempCells[j].finalElevation = i/500.0;
        tempCells[j].setClimate();
        tempCells[j].updateColor("Climate");
      }
      cells[i] = tempCells;
    }
    ArrayList<Cell> newShuffledCells = new ArrayList<Cell>();
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        newShuffledCells.add(cells[i][j]);
      }
    }
    println(resources);
    for (Resource r : resources) {
      int limit = (int) random(r.minResourceAbundance, r.maxResourceAbundance + 1);
      int lcount = 0;
      //println(randy);
      Collections.shuffle(newShuffledCells, randy);
      for (Cell c : newShuffledCells) {
        if (lcount < limit) {
          if (c.propogateResource(r, this)) {
            lcount++;
          }
        } else {
          break;
        }
      }
    }
  }


  Grid(String file) {
    JSONObject jj = loadJSONObject(file);
    loadJSON(jj);
  }

  Grid(PImage img) {
    gridWidth = img.width;
    gridHeight = img.height;
    grdWidth = gridWidth;
    grdHeight = gridHeight;
    int count = 0;
    cells = new Cell[gridWidth][gridHeight];
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {
        cells[j][i] = new Cell(j, i);
        float b = brightness(img.pixels[count]);

        if (b > 0) {
          b = map(pow(map(b, 0, 255, 0, 1), 0.5), 0, 1, 0.5001, 1);
        } else {
          b = 0;
        }

        cells[j][i].finalElevation = b;
        count++;
      }
    }

    println("Equalizing Elevation");    
    float smallest = Integer.MAX_VALUE; 
    float biggest = Integer.MIN_VALUE; 

    smallest = Integer.MAX_VALUE; 
    biggest = Integer.MIN_VALUE; 

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j].finalElevation > biggest) {
          biggest = cells[i][j].finalElevation;
        }
        if (cells[i][j].finalElevation < smallest) {
          smallest = cells[i][j].finalElevation;
        }
      }
    }
    println(biggest);
    println(smallest);
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].finalElevation = map(cells[i][j].finalElevation, smallest, biggest, 0, 1);
        cells[i][j].checkElevation();
      }
    }
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].updateColor("Elevation");
      }
    }
    println("Filling Basins");
    lakes = new ArrayList<Lake>();
    while (true) {
      Cell source = getNextWater();
      if (source.size != 0) {
        Lake l = new Lake(source);
        l.fillBody(this);
        lakes.add(l);
      } else {
        break;
      }
    }
    ArrayList<Lake> garbage = new ArrayList<Lake>();
    Lake biggestLake = new Lake(new Cell());
    for (Lake l : lakes) {
      if (l.lake.size() > biggestLake.lake.size()) {
        biggestLake = l;
      }
    }
    biggestLake.ocean();
    //for (int i = lakes.size() - 1; i >= 0; i--) {
    //  if (lakes.get(i).lake.size() < biggestLake.lake.size()/4) {
    //    //lakes.remove(i).drain();
    //  }
    //}
    for (Lake l : lakes) {
      l.ocean();
    }

    println("Getting Temperature");

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].calculateTemperature(this);
      }
    }

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].smoothTemp(this);
      }
    }

    println("Getting Moisture");
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {
        cells[j][i].setBoundaryMoisture(this);
      }
    }
    ArrayList<Cell> blah = new ArrayList<Cell>();
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {
        if (cells[j][i].windDir.x != 0)
          blah.add(cells[j][i]);
      }
    }
    Collections.shuffle(blah, randy);

    for (Cell c : blah) {
      if (c.water)
        c.getMoisture(this);
    }
    for (Cell c : blah) {
      if (!c.water)
        c.getMoisture(this);
    }

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j].windDir.x == 0) {
          cells[i][j].getMoisture(this);
        }
        if (cells[i][j].moisture < 0) {
          println(cells[i][j].moisture);
        }
      }
    }

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].smoothMoisture(this);
      }
    }


    println("Setting Climate");
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].setClimate();
      }
    }

    //for (int i = 0; i < gridWidth; i++) {
    //  for (int j = 0; j < gridHeight; j++) {
    //      cells[i][j].freezeOceans(this);
    //  }
    //}

    println("Forming Rivers");
    PriorityQueue<Cell> open = new PriorityQueue<Cell>();
    //for (int i = 0; i < gridWidth; i++) {
    //  open.add(cells[i][0]);
    //  cells[i][0].slopeClosed = true;
    //  open.add(cells[i][gridHeight - 1]);
    //  cells[i][gridHeight - 1].slopeClosed = true;
    //}
    //for (int i = 0; i < gridHeight; i++) {
    //  open.add(cells[0][i]);
    //  cells[0][i].slopeClosed = true;
    //  open.add(cells[gridWidth - 1][i]);
    //  cells[gridWidth - 1][i].slopeClosed = true;
    //}

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j].ocean) {
          open.add(cells[i][j]);
          cells[i][j].slopeClosed = true;
        }
      }
    }

    count = 0;
    while (open.size() > 0) {
      Cell c = open.remove();
      c.slopeNeighbors(c.divotedFinalElevation, open, this);
      count++;
    }
    println(count);

    //for (int i = 0; i < gridWidth; i++) {
    //  for (int j = 0; j < gridHeight; j++) {
    //    cells[i][j].getLowestNeighbor(this);
    //  }
    //}

    //ArrayList<Cell> highCells = new ArrayList<Cell>();
    //for (int i = 0; i < gridWidth; i++) {
    //  for (int j = 0; j < gridHeight; j++) {
    //    if (cells[i][j].finalElevation >= 0.7 && cells[i][j].finalElevation < 0.9) {
    //      highCells.add(cells[i][j]);
    //    }
    //  }
    //}

    //for (int i = 0; i < 50; i++) {
    //  highCells.remove((int) random(50)).flowRiver(this);
    //}

    PriorityQueue<Cell> riverCells = new PriorityQueue<Cell>(Collections.reverseOrder());
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        riverCells.add(cells[i][j]);
      }
    }
    count = 0;
    while (riverCells.size() > 0) {
      riverCells.remove().flowRiver(this);
      count++;
      //println(count);
    }
    //for (int i = 0; i < gridWidth; i++) {
    //  for (int j = 0; j < gridHeight; j++) {
    //    cells[i][j].flowRiver(this, new PVector(0, 0), 0, 0);
    //  }
    //}

    smallest = Integer.MAX_VALUE; 
    biggest = Integer.MIN_VALUE; 

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j].rawFlow > biggest) {
          biggest = cells[i][j].rawFlow;
        }
        if (cells[i][j].flow < smallest) {
          smallest = cells[i][j].rawFlow;
        }
      }
    }
    println(smallest + ", " + biggest);

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].flow = map(cells[i][j].rawFlow, smallest, biggest, 0, 1);
        cells[i][j].flow = sqrt(cells[i][j].flow);
      }
    }

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].updateColor("Elevation");
      }
    }
    println("done!");
  }

  Grid(float x_, float y_, int gw_, int gh_, float wL_, int s_, float nD_, float nS_, float nP_, int oP_, int coP_, int rdP_, float rdPC_, float pPC_) {
    cells = new Cell[gw_][gh_];
    gridWidth = gw_;
    gridHeight = gh_;
    xPos = x_;
    yPos = y_;
    warpLevel = wL_;
    noiseDet = nD_;
    noiseSca = nS_;
    noisePow = nP_;
    localSeed = s_;

    oceanicPlates = oP_;
    continentalPlates = coP_;
    randomPlates = rdP_;
    randomPlateChance = rdPC_;
    polarPlateChance = pPC_;

    possibR = new PVector(Integer.MAX_VALUE, Integer.MIN_VALUE);
    println("Initializing");
    for (int i = 0; i < gridWidth; i++) {
      Cell[] tempCells = new Cell[gridHeight];
      for (int j = 0; j < gridHeight; j++) {
        tempCells[j] = new Cell(i, j);
      }
      cells[i] = tempCells;
    }
    shuffledCells = new ArrayList<PVector>();
    for (int i = 0; i < gridHeight; i++) {
      float lat = abs((gridHeight/2) - i) * 2;
      lat = map(lat, 0, gridHeight, 0, 1);
      lat = pow(lat, 16);
      lat = map(lat, 0, 1, 1, 20);
      for (int k = 0; k < (int) lat; k++) {
        for (int j = 0; j < gridWidth; j++) {
          shuffledCells.add(new PVector(j, i));
        }
      }
    }
    Collections.shuffle(shuffledCells, new Random(seed));
    println("Getting Noise");
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        for (int k = 0; k < 8; k++) {
          cells[i][j].addNoise(getNoise(i, j, pow(noiseDet, k + 1 + noiseSca)) * octaves[k]);
        }
      }
    }
    println("Generating Voronoi");
    for (int i = 0; i < gridWidth/voronoiSize; i++)
      for (int j = 0; j < gridWidth/voronoiSize; j++) {
        vps.add(new VoronoiPoint(i * voronoiSize + (int)random(voronoiSize), j * voronoiSize + (int)random(voronoiSize), voronoiSize));
      }
    for (VoronoiPoint vp : vps) {
      vp.getPoints(this);
    }
    for (VoronoiPoint vp : vps) {
      vp.getCells(this);
    }
    for (VoronoiPoint vp : vps) {
      vp.getNeighbors(this);
    }

    plates = new Plate[continentalPlates + oceanicPlates + randomPlates + 2];
    ArrayList<VoronoiPoint> vps2 = (ArrayList) vps.clone();
    Collections.shuffle(vps2, new Random(seed + 1000));
    int oc  = 0;
    int lnd = 0;
    int rnd = 0;
    for (int i = 0; oc + lnd + rnd < plates.length - 2; ) {
      if (oc < oceanicPlates) {
        VoronoiPoint vp;
        vp = vps2.get(i);
        if (!vp.plateFilled) {
          plates[i] = new Plate(color(random(255), random(255), random(255)), false, random(-0.3, 0.2), this);
          vp.activate(plates[i]);
          oc++;
          i++;
        }
      } 
      if (lnd < continentalPlates) {
        VoronoiPoint vp;
        vp = vps2.get(i);
        if (!vp.plateFilled) {
          plates[i] = new Plate(color(random(255), random(255), random(255)), true, random(-0.1, 0.4), this);
          vp.activate(plates[i]);
          lnd++;
          i++;
        }
      } 
      if (rnd < randomPlates) {
        boolean b;
        if (random(1) < randomPlateChance) {
          b = false;
        } else {
          b = true;
        }
        VoronoiPoint vp;
        vp = vps2.get(i);
        if (!vp.plateFilled) {
          plates[i] = new Plate(color(random(255), random(255), random(255)), b, random(0.5, 0.7), this);
          vp.activate(plates[i]);
          rnd++;
          i++;
        }
      }
    }

    boolean b;
    if (random(1) < polarPlateChance) {
      b = false;
    } else { 
      b = true;
    }

    plates[plates.length - 2] = new Plate(color(random(255), random(255), random(255)), b, random(0.4, 0.7), this);
    for (VoronoiPoint vp : vps) {
      if (vp.yPos <= voronoiSize) {
        vp.activate(plates[plates.length - 2]);
      }
    }

    if (random(1) < polarPlateChance) {
      b = false;
    } else { 
      b = true;
    }

    plates[plates.length - 1] = new Plate(color(random(255), random(255), random(255)), b, random(0.4, 0.7), this);
    for (VoronoiPoint vp : vps) {
      if (vp.yPos >= gridHeight - voronoiSize) {
        vp.activate(plates[plates.length - 1]);
      }
    }
    println("Building Plates");

    while (!bordersChecked) {
      update();
    }

    println("Equalizing Elevation");    
    float smallest = Integer.MAX_VALUE; 
    float biggest = Integer.MIN_VALUE; 

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j].noise > biggest) {
          biggest = cells[i][j].noise;
        }
        if (cells[i][j].noise < smallest) {
          smallest = cells[i][j].noise;
        }
      }
    }
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].noise = pow(map(cells[i][j].noise, smallest, biggest, 0, 1), noisePow);
        cells[i][j].calcFinalElevation();
      }
    }

    smallest = Integer.MAX_VALUE; 
    biggest = Integer.MIN_VALUE; 

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j].finalElevation > biggest) {
          biggest = cells[i][j].finalElevation;
        }
        if (cells[i][j].finalElevation < smallest) {
          smallest = cells[i][j].finalElevation;
        }
      }
    }
    println(biggest);
    println(smallest);
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].finalElevation = map(cells[i][j].finalElevation, smallest, biggest, 0, 1);
        cells[i][j].checkElevation();
      }
    }
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].updateColor("Elevation");
      }
    }
    println("Filling Basins");
    lakes = new ArrayList<Lake>();
    while (true) {
      Cell source = getNextWater();
      if (source.size != 0) {
        Lake l = new Lake(source);
        l.fillBody(this);
        lakes.add(l);
      } else {
        break;
      }
    }
    ArrayList<Lake> garbage = new ArrayList<Lake>();
    Lake biggestLake = new Lake(new Cell());
    for (Lake l : lakes) {
      if (l.lake.size() > biggestLake.lake.size()) {
        biggestLake = l;
      }
    }
    biggestLake.ocean();
    for (int i = lakes.size() - 1; i >= 0; i--) {
      if (lakes.get(i).lake.size() < biggestLake.lake.size()/4) {
        lakes.get(i).drain();
      }
    }
    println("Getting Temperature");

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].calculateTemperature(this);
      }
    }

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].smoothTemp(this);
      }
    }

    println("Getting Moisture");
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {
        cells[j][i].setBoundaryMoisture(this);
      }
    }
    ArrayList<Cell> blah = new ArrayList<Cell>();
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {
        if (cells[j][i].windDir.x != 0)
          blah.add(cells[j][i]);
      }
    }
    Collections.shuffle(blah, randy);
    for (Cell c : blah) {
      if (c.water)
        c.getMoisture(this);
    }
    for (Cell c : blah) {
      if (!c.water)
        c.getMoisture(this);
    }

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j].windDir.x == 0) {
          cells[i][j].getMoisture(this);
        }
        if (cells[i][j].moisture < 0) {
          println(cells[i][j].moisture);
        }
      }
    }

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].smoothMoisture(this);
      }
    }


    println("Setting Climate");
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].setClimate();
      }
    }

    //for (int i = 0; i < gridWidth; i++) {
    //  for (int j = 0; j < gridHeight; j++) {
    //      cells[i][j].freezeOceans(this);
    //  }
    //}

    println("Forming Rivers");
    PriorityQueue<Cell> open = new PriorityQueue<Cell>();

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j].ocean) {
          open.add(cells[i][j]);
          cells[i][j].slopeClosed = true;
        }
      }
    }

    int count = 0;
    Lake activeLake = new Lake();
    while (open.size() > 0) {
      Cell c = open.remove();
      c.slopeNeighbors(c.divotedFinalElevation, open, this);
      if (c.finalElevation < c.divotedFinalElevation) {
        activeLake.add(c);
      } else {
        if (activeLake.lake.size() > 0) {
          lakes.add(activeLake);
          activeLake = new Lake();
        }
      }
      count++;
    }
    println(count);
    for (int i = lakes.size() - 1; i >= 0; i--) {
      if (lakes.get(i).lake.size() < 1) {
        lakes.remove(i);
      }
    }

    PriorityQueue<Cell> riverCells = new PriorityQueue<Cell>(Collections.reverseOrder());
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        riverCells.add(cells[i][j]);
      }
    }
    count = 0;
    while (riverCells.size() > 0) {
      riverCells.remove().flowRiver(this);
      count++;
      //println(count);
    }
    //for (int i = 0; i < gridWidth; i++) {
    //  for (int j = 0; j < gridHeight; j++) {
    //    cells[i][j].flowRiver(this, new PVector(0, 0), 0, 0);
    //  }
    //}

    smallest = Integer.MAX_VALUE; 
    biggest = Integer.MIN_VALUE; 

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        if (cells[i][j].rawFlow > biggest) {
          biggest = cells[i][j].rawFlow;
        }
        if (cells[i][j].rawFlow < smallest) {
          smallest = cells[i][j].rawFlow;
        }
      }
    }
    println(smallest + ", " + biggest);

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].flow = map(cells[i][j].rawFlow, 0, biggest, 0, 1);
        cells[i][j].flow = pow(cells[i][j].flow, 0.5);
      }
    }

    println("Filling Lakes");
    for (Lake l : lakes) {
      l.calculateLakeFill();
    }
    for (Lake l : lakes) {
      l.flood();
    }
    for (int i = 0; i < 10; i++) {
      for (Lake l : lakes) {
        l.smoothLake(this);
      }
    }
    println("Depositing Resources");
    ArrayList<Cell> newShuffledCells = new ArrayList<Cell>();
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        newShuffledCells.add(cells[i][j]);
      }
    }
    println(resources);
    for (Resource r : resources) {
      int limit = (int) random(r.minResourceAbundance, r.maxResourceAbundance + 1);
      int lcount = 0;
      //println(randy);
      Collections.shuffle(newShuffledCells, randy);
      for (Cell c : newShuffledCells) {
        if (lcount < limit) {
          if (c.propogateResource(r, this)) {
            lcount++;
          }
        } else {
          break;
        }
      }
    }

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].updateColor("Elevation");
      }
    }
    println("done!");
  }

  Cell getNextWater() {
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        Cell cel = cells[i][j];
        if (cel.size != 0 && cel.laked == false && cel.finalElevation <= 0.5) {
          return cel;
        }
      }
    }
    return new Cell();
  }

  void getImages() {
    println("Creating Images");
    getImage("Noise");
    getImage("Plates");
    getImage("Temperature");
    getImage("Moisture");
    getImage("Climate");
    getImage("River");
    getImage("Heightmap");
    getImage("Elevation");
    getImage("Watershed");
    getImage("Resource");
    //getImage("Final");
    if (saveToFile) {
      println("Creating JSON");
      saveJSON();
    }
  }

  PImage getImage(String tag) {
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].updateColor(tag);
      }
    }
    PImage p = createImage(gridWidth, gridHeight, RGB);
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        //println((i * gridHeight) + j);
        p.pixels[(j * gridWidth) + i] = cells[i][j].currColor;
      }
    }
    p.save("Maps/" + warpLevel + "/"+ gridWidth + "x" + gridHeight + "/" + seed +"/Map_"+ gridWidth + "x" + gridHeight + "_" + tag + ".png");
    return p;
  }

  void saveJSON() {
    JSONObject gridJSON = new JSONObject();
    gridJSON.setFloat("warpLevel", warpLevel);
    gridJSON.setInt("gridWidth", gridWidth);
    gridJSON.setInt("gridHeight", gridHeight);
    gridJSON.setInt("localSeed", localSeed);
    gridJSON.setFloat("noiseDet", noiseDet);
    gridJSON.setFloat("noiseSca", noiseSca);
    gridJSON.setFloat("noisePow", noisePow);
    JSONArray JCells = new JSONArray();
    int count = 0;
    for (int i = 0; i < gridWidth; i++) {
      JSONArray tempJCells = new JSONArray();
      for (int j = 0; j < gridHeight; j++) {
        JSONObject cell = new JSONObject();
        cell.setInt("xPos", cells[i][j].xPos);
        cell.setInt("yPos", cells[i][j].yPos);
        cell.setInt("plateID", cells[i][j].plateID);
        cell.setInt("windDir", (int) cells[i][j].windDir.x);
        cell.setInt("watershed", cells[i][j].watershedColor);
        cell.setBoolean("filled", cells[i][j].filled);
        cell.setBoolean("active", cells[i][j].active);
        cell.setBoolean("border", cells[i][j].border);
        cell.setBoolean("ocean", cells[i][j].ocean);
        cell.setBoolean("laked", cells[i][j].laked);
        cell.setBoolean("river", cells[i][j].river);
        cell.setFloat("noise", cells[i][j].noise);
        cell.setFloat("elevation", cells[i][j].elevation);
        cell.setFloat("infectivity", cells[i][j].infectivity);
        cell.setFloat("finalElevation", cells[i][j].finalElevation);
        cell.setFloat("temperature", cells[i][j].temperature);
        cell.setFloat("ice", cells[i][j].ice);
        cell.setFloat("moisture", cells[i][j].moisture);
        cell.setString("climate", cells[i][j].climate);
        cell.setFloat("flow", cells[i][j].flow);
        tempJCells.setJSONObject(j, cell);
      }
      JSONObject tempJSON = new JSONObject();
      tempJSON.setJSONArray("temp", tempJCells);
      JCells.setJSONObject(i, tempJSON);
    }
    gridJSON.setJSONArray("Cells", JCells);
    saveJSONObject(gridJSON, "Maps/" + warpLevel + "/"+ gridWidth + "x" + gridHeight + "/" + seed +"/Map_"+ gridWidth + "x" + gridHeight + ".map");
  }

  void loadJSON(JSONObject json) {
    warpLevel = json.getFloat("warpLevel");
    gridWidth = json.getInt("gridWidth");
    gridHeight = json.getInt("gridHeight");
    localSeed = json.getInt("localSeed");
    noiseDet = json.getFloat("noiseDet");
    noiseSca = json.getFloat("noiseSca");
    noisePow = json.getFloat("noisePow");
    cells = new Cell[gridWidth][gridHeight];
    JSONArray JCells = json.getJSONArray("Cells");
    for (int i = 0; i < gridWidth; i++) {
      println("Loading Row" + (i + 1));
      JSONArray tempJCells = JCells.getJSONObject(i).getJSONArray("temp");
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j] = loadJSONCell(tempJCells.getJSONObject(j));
        cells[i][j].updateColor("Final");
      }
      JSONObject tempJSON = new JSONObject();
      tempJSON.setJSONArray("temp", tempJCells);
      JCells.setJSONObject(i, tempJSON);
    }
  }

  Cell loadJSONCell(JSONObject cell) {
    Cell c = new Cell();
    c.size = 1;
    c.xPos = cell.getInt("xPos");
    c.yPos = cell.getInt("yPos");
    c.plateID = cell.getInt("plateID");
    c.windDir.x = cell.getInt("windDir");
    c.watershedColor = cell.getInt("watershed");
    c.filled = cell.getBoolean("filled");
    c.active = cell.getBoolean("active");
    c.border = cell.getBoolean("border");
    c.ocean = cell.getBoolean("ocean");
    c.laked = cell.getBoolean("laked");
    c.river = cell.getBoolean("river");
    c.noise = cell.getFloat("noise");
    c.elevation = cell.getFloat("elevation");
    c.infectivity = cell.getFloat("infectivity");
    c.finalElevation = cell.getFloat("finalElevation");
    c.temperature = cell.getFloat("temperature");
    c.ice = cell.getFloat("ice");
    c.climate = cell.getString("climate");
    c.moisture = cell.getFloat("moisture");
    c.flow = cell.getFloat("flow");
    return c;
  }

  float getNoise(int index2, int index, float nD) {
    float lat = abs((gridHeight/2) - index) * 2;
    float r =pow(sqrt((float)gridHeight * 2 * (float)lat - pow((float)lat, 2.0))/float(gridHeight), warpLevel);
    r = 1.0 - r;
    float angle = ((TWO_PI/(gridWidth/gridHeight))/gridHeight) * index;
    float angle2 = (TWO_PI)/(gridWidth) * index2;
    float cosAngle2 = cos(angle2);
    float sinAngle2 = sin(angle2);
    if (r < possibR.x) {
      possibR.x = r;
    }
    if (r > possibR.y) {
      possibR.y = r;
    }
    return map((float) noise.eval(angle * nD, (cosAngle2) * nD * r, (sinAngle2) * nD * r), -1, 1, 0, 1);
  }





  void display() {

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {   
        cells[i][j].display();
      }
    }
    //if(bordersChecked){
    //  for (int i = 0; i < gridWidth; i++) {
    //    for (int j = 0; j < gridHeight; j++) {
    //      cells[i][j].showStroke();
    //    }
    //  }
    //}

    //stroke(0);
    for (Plate p : plates) {
      p.display();
    }
    if (keyPressed & key == 'p') {
      for (Plate p : plates) {
        p.showDirectionLine = true;
      }
    } else if (keyPressed & key != 'p') {
      for (Plate p : plates) {
        p.showDirectionLine = false;
      }
    }

    //for (int i = 0; i < gridWidth; i++) {
    //  line(xPos + gridScale * i, yPos, xPos + gridScale * i, yPos + gridHeight * gridScale);
    //}

    //for (int i = 0; i < gridHeight; i++) {
    //  line(xPos, yPos + gridScale * i, xPos + gridWidth * gridScale, yPos + gridScale * i);
    //}

    //rectMode(CORNERS);
    //fill(0);
    //rect(-5, -5, 5, gridHeight * gridScale);
    //rect(-5, -5, gridWidth * gridScale, 5);
    //rect(- 5, gridHeight * gridScale - 5, gridWidth * gridScale, gridHeight * gridScale + 5);
    //rect(gridWidth * gridScale - 5, -5, gridWidth * gridScale + 5, gridHeight * gridScale);
    //Created by Boueny  Folefack
    //rectMode(CORNER);
  }





  //PLATE FUNCTIONS

  void update() {
    if (plateBuilding) {
      plateBuilding = false;
      for (int i = 0; i < vps.size(); i++) {
        VoronoiPoint vp = vps.get(i);
        float lat = abs((gridHeight/2) - vp.yPos) * 2;
        lat = map(lat, 0, gridHeight, 0, 1);
        lat = pow(lat, 8);
        lat = map(lat, 0, 1, 1, 1);
        for (int k = 0; k < (int) lat; k++) {
          if (vp.active) {
            plateBuilding = true;
            vp.fillNeighbors();
          }
        }
      }
    } else if (!bordersChecked) {
      println("checking borders");
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridHeight; j++) {
          cells[i][j].checkBorder(this);
        }
      }
      bordersChecked = true;
      for (int i = 0; i < plates.length; i++) {
        plates[i].checkNeighbors();
        plates[i].getAvgPoint();
      }
      for (int k = 0; k < 5; k++) {
        for (int i = 0; i < gridWidth; i++) {
          for (int j = 0; j < gridHeight; j++) {
            cells[i][j].smoothEdges(this);
          }
        }
      }
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridHeight; j++) {
          cells[i][j].checkBorder(this);
        }
      }
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridHeight; j++) {
          cells[i][j].calculateTectonics(this);
        }
      }
      for (int i = 0; i < 50; i++) {
        //println(i);
        for (Plate p : plates) {
          p.gradientBorders();
        }
      }
      for (int i = 0; i < 10; i++) {
        //println(80 + i);
        for (Plate p : plates) {
          p.smoothBorders();
        }
      }
      println("Done Checking Plate Borders");
    }
  }

  Cell getCell(int x, int y) {
    if (x >= 0 && y >= 0 && x < gridWidth && y < gridHeight)
      return cells[x][y];
    if (y < cells[0].length - 1 && y >= 0) {
      if (x < 0) {
        return cells[gridWidth + x][y];
      }
      if (x >= gridWidth) {
        return cells[x - gridWidth][y];
      }
    }
    return new Cell();
  }
}
