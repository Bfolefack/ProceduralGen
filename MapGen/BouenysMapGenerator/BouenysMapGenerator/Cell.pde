import java.util.*;

class Cell implements Comparable<Cell> {
  int xPos;
  int yPos;
  int plateID;
  PVector windDir;
  int size;
  int borders;

  color currColor;
  color watershedColor;

  Cell lowestNeighbor;
  Plate plate;
  Plate neighbor;
  Lake lake;

  boolean filled = false;
  boolean active = false;
  boolean border = false;
  boolean ocean = false;
  boolean water = false;
  boolean laked = false;
  boolean river = false;
  boolean slopeClosed = false;
  boolean moistened = false;
  boolean moistShlapped = false;
  boolean sourced = false;

  float noise;
  float elevation;
  float infectivity;
  float finalElevation;
  float moisture;
  float temperature;
  float ice;
  float divotedFinalElevation;
  float rawFlow;
  float flow;
  float jitter;
  float minVoronoiDist = Integer.MAX_VALUE;
  VoronoiPoint voronoi;

  Resource resource = new Resource();
  TreeSet<Resource> localResources = new TreeSet<Resource>();

  String climate;

  Cell(int x_, int y_) {
    xPos = x_;
    yPos = y_;
    noise = 0;
    size = 1;
    currColor = color(0);
    setEarthlikeWindDirection();
    watershedColor = color(random(255), random(255), random(255));
  }

  Cell() {
    size = 0;
    filled = true;
    windDir = new PVector(0, 0);
  }

  void updateColor(String map) {
    if (ocean)
      water = true;
    if (map.equals("Elevation")) {
      float num = finalElevation;
      if (water) {
        if (num < .01) {
          currColor = color(15, 50, 100);
        } else if (num < .03) {
          currColor = color(15, 50, 150);
        } else  if (num < .20) {
          currColor = color(25, 40, 200);
        } else if (num < .3) {
          currColor = color(25, 60, 220);
        } else if (num < .43) {
          currColor = color(25, 80, 220);
        } else if (num < .5) {
          currColor = color(60, 130, 250);
        } else if (num < .6) {
          currColor = color(100, 190, 255);
        } else {
          currColor = color(170, 230, 255);
        }
      } else { 
        if (num < .45) {
          currColor = color(255, 190, 40);
        } else if (num < .5) {
          currColor = color(255, 220, 90);
        } else if (num < .55) {
          currColor = color(250, 230, 150);
        } else if (num < .65) {
          currColor = color(130, 220, 80);
        } else if (num < .75) {
          currColor = color(100, 180, 60);
        } else if (num < .8) {
          currColor = color(180, 120, 0);
        } else if (num < .9) {
          currColor = color(120, 70, 0);
        } else if (num <= 1) {
          currColor = color(255);
        } else {
          currColor = color(num * 255);
        }
      }
      if (ice == 0.5) {
        currColor = color(225, 245, 255);
      } else if (ice == 1) {
        currColor = color(180, 200, 205);
      }
    } else if (map.equals("Divoted")) {
      float num = divotedFinalElevation;
      if (ocean) {
        if (num < .01) {
          currColor = color(15, 50, 100);
        } else if (num < .03) {
          currColor = color(15, 50, 150);
        } else  if (num < .20) {
          currColor = color(25, 40, 200);
        } else if (num < .3) {
          currColor = color(25, 60, 220);
        } else if (num < .43) {
          currColor = color(25, 80, 220);
        } else if (num < .5) {
          currColor = color(60, 130, 250);
        } else {
          currColor = color(100, 190, 255);
        }
      } else { 
        if (num < .45) {
          currColor = color(255, 190, 40);
        } else if (num < .5) {
          currColor = color(255, 220, 90);
        } else if (num < .55) {
          currColor = color(250, 230, 150);
        } else if (num < .65) {
          currColor = color(130, 220, 80);
        } else if (num < .75) {
          currColor = color(100, 180, 60);
        } else if (num < .8) {
          currColor = color(180, 120, 0);
        } else if (num < .9) {
          currColor = color(120, 70, 0);
        } else if (num <= 1) {
          currColor = color(255);
        } else {
          currColor = color(num * 255);
        }
      }
      if (ice == 0.5) {
        currColor = color(225, 245, 255);
      } else if (ice == 1) {
        currColor = color(180, 200, 205);
      }
    } else if (map.equals("Plates")) {
      float num = elevation;
      if (num < .01) {
        currColor = color(15, 50, 100);
      } else if (num < .03) {
        currColor = color(15, 50, 150);
      } else  if (num < .20) {
        currColor = color(25, 40, 200);
      } else if (num < .3) {
        currColor = color(25, 60, 220);
      } else if (num < .43) {
        currColor = color(25, 80, 220);
      } else if (num < .5) {
        currColor = color(60, 130, 250);
      } else if (num < .55) {
        currColor = color(250, 230, 150);
      } else if (num < .65) {
        currColor = color(130, 220, 80);
      } else if (num < .75) {
        currColor = color(100, 180, 60);
      } else if (num < .8) {
        currColor = color(180, 120, 0);
      } else if (num < .9) {
        currColor = color(120, 70, 0);
      } else if (num <= 1) {
        currColor = color(255);
      } else {
        currColor = color(num * 255);
      }
      if (border) {
        currColor = color(0, 255, 0);
      }
    } else if (map.equals("Noise")) {
      float num = noise;
      if (num < .01) {
        currColor = color(15, 50, 100);
      } else if (num < .03) {
        currColor = color(15, 50, 150);
      } else  if (num < .20) {
        currColor = color(25, 40, 200);
      } else if (num < .3) {
        currColor = color(25, 60, 220);
      } else if (num < .43) {
        currColor = color(25, 80, 220);
      } else if (num < .5) {
        currColor = color(60, 130, 250);
      } else if (num < .55) {
        currColor = color(250, 230, 150);
      } else if (num < .65) {
        currColor = color(130, 220, 80);
      } else if (num < .75) {
        currColor = color(100, 180, 60);
      } else if (num < .8) {
        currColor = color(180, 120, 0);
      } else if (num < .9) {
        currColor = color(120, 70, 0);
      } else if (num <= 1) {
        currColor = color(255);
      } else {
        currColor = color(num * 255);
      }
    } else if (map.equals("Temperature")) {
      currColor = color(255, 255 - temperature * 255, 255 - temperature * 255);
    } else if (map.equals("Moisture")) {
      currColor = color(255 - moisture * 255, 255 - moisture * 255, 255);
    } else if (map.equals("River")) {
      if (!water)
        currColor = color(255 - flow * 255, 255 - flow * 255, 255);
      else if (!ocean)
        currColor = color(255 - lake.trueGreatestFlow * 255, 255 - lake.trueGreatestFlow * 255, 255);
      else
        currColor = color(0, 0, 255);
    } else if (map.equals("Heightmap")) {
      currColor = color(finalElevation * 255);
    } else if (map.equals("DivotedHeightmap")) {
      currColor = color(divotedFinalElevation * 255);
    } else if (map.equals("Watershed")) {
      currColor = watershedColor;
    } else if (map.equals("Voronoi")) {
      currColor = voronoi.voCol;
    } else if (map.equals("Resource")) {
      currColor = resource.hue;
      if (resource.name.equals("None")) {
        if (ocean) { 
          currColor = color(230);
        } else {
          currColor = color(190);
        }
      }
    } else if (map.equals("Lake")) {
      updateColor("Elevation");
      if (laked)
        currColor = lake.col;
      if (ocean) 
        currColor = color(0, 0, 255);
    } else if (map.equals("Climate")) {
      String str = climate;
      if (!water) {
        if (str.equals("Tropical Rainforest")) {
          currColor = color(0, 0, 255);
        } else if (str.equals("Tropical Monsoon")) {
          currColor = color(60, 125, 255);
        } else if (str.equals("Tropical Savannah")) {
          currColor = color(120, 150, 255);
        } else if (str.equals("Hot Desert")) {
          currColor = color(255, 0, 0);
        } else if (str.equals("Semi-Arid")) {
          currColor = color(255, 175, 0);
        } else if (str.equals("Cool Desert")) {
          currColor = color(255, 145, 145);
        } else if (str.equals("Steppe")) {
          currColor = color(255, 225, 85);
        } else if (str.equals("Humid Subtropical")) {
          currColor = color(165, 255, 25);
        } else if (str.equals("Subtropical Monsoon")) {
          currColor = color(65, 255, 125);
        } else if (str.equals("Mediterranean")) {
          currColor = color(225, 255, 0);
        } else if (str.equals("Mediterranean")) {
          currColor = color(225, 255, 0);
        } else if (str.equals("Oceanic")) {
          currColor = color(0, 255, 0);
        } else if (str.equals("Continental")) {
          currColor = color(125, 200, 255);
        } else if (str.equals("Subarctic")) {
          currColor = color(0, 125, 150);
        } else if (str.equals("Tundra")) {
          currColor = color(200);
        } else if (str.equals("Ice Cap")) {
          currColor = color(125);
        }
      } else {
        currColor = color(255);
      }
      if (finalElevation >0.8) {
        currColor = color(0);
      }
    }
  }

  void display() {
    if (keyPressed) {
      switch (key) {
      case 'p':
        updateColor("Plates");
        break;
      case 'e':
        updateColor("Elevation");
        break;
      case 'n':
        updateColor("Noise");
        break;
      case 'c':
        updateColor("Climate");
        break;
      case 't':
        updateColor("Temperature");
        break;
      case 'm':
        updateColor("Moisture");
        break;
      case 'h':
        updateColor("Heightmap");
        break;
      case 'd':
        updateColor("Divoted");
        break;
      case 'v':
        updateColor("DivotedHeightmap");
        break;
      case 'y':
        updateColor("River");
        break;
      case 'u':
        updateColor("Watershed");
        break;
      case 'b':
        updateColor("Resource");
        break;
      case 'o':
        updateColor("Voronoi");
        break;
      case 'l':
        updateColor("Lake");
        break;
      }
    }

    fill(currColor);
    if (key == 'w') {
      if (windDir.x == -1) {
        fill(color(0, 0, 255));
      }

      if (windDir.x == 1) {
        fill(color(255, 0, 0));
      }

      if (windDir.x == 0) {
        fill(color(0, 255, 0));
      }
    }

    if (getMouseGridspace().x == xPos && getMouseGridspace().y == yPos && mousePressed) {
      focusCell = this;
      fill(255, 0, 0);
    }

    rect(xPos * gridScale, yPos * gridScale, gridScale, gridScale);
  }
  void flowRiver(Grid grid) {
    if (!ocean && !lowestNeighbor.ocean) {
      watershedColor = lowestNeighbor.flowRiver(grid, sq(moisture) * pow((finalElevation - 0.5) * 2, 2), 1);
    } else if (ocean) {
      watershedColor = color(255);
    }
  }

  color flowRiver(Grid grid, float propogation, int count) {   
    if (!ocean && !lowestNeighbor.ocean) {
      rawFlow += propogation;
      return lowestNeighbor.flowRiver(grid, propogation, count + 1);
    } else if (!ocean) {
      rawFlow += propogation;
      return watershedColor;
    }
    return 0;
  }

  public int compareTo(Cell cel) {
    if (finalElevation >= cel.finalElevation)
      return 1;
    else
      return -1;
  }

  void slopeNeighbors(float target, PriorityQueue<Cell> active, Grid grid) {
    for (int i = -1; i < 2; i++)
      for (int j = -1; j < 2; j++) {
        Cell cel = grid.getCell(xPos + i, yPos + j);
        if (cel.size > 0 && !cel.slopeClosed) {
          active.add(cel);
          cel.slopeClosed = true;
          cel.lowestNeighbor = this;
          if (cel.finalElevation < target)
            cel.divotedFinalElevation = target;
        }
      }
  }
  int coinFlip() {
    if (random(1) < 0.5) {
      return -1;
    } else {
      return 1;
    }
  }

  void smoothLake(Grid grid) {
    int total = 0;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!(i == 0 && j == 0)) {
          Cell cel = grid.getCell(xPos + i, yPos + j);
          if (cel.size != 0) {
            if (cel.water) {
              total++;
            }
          }
        }
      }
    }
    if (total < 3) {
      water = false;
    } else if (total > 5) {
      water = true;
    }
  }

  String getResources() {
    String s = "";
    if (localResources.size() == 0) {
      return "None";
    }
    for (Resource r : localResources) {
      s += r.name + ", ";
    }
    s = s.substring(0, s.length() - 2);
    return s;
  }

  boolean propogateResource (Resource r, Grid grid) {
    float blobSize = r.blobSize;
    if (moisture >= r.minMoisture && moisture <= r.maxMoisture)
      if (finalElevation >= r.minElevation && finalElevation <= r.maxElevation)
        if (temperature >= r.minTemperature && temperature <= r.maxTemperature)
          if (!sourced)
            if ((water && r.waterResource) || (!water && r.landResource)) {
              for (int i = (int) -blobSize; i < blobSize; i++) {
                for (int j = (int) -blobSize; j < blobSize; j++) {
                  localResources.add(r);
                  resource = r;
                  sourced = r.sourcing;
                  Cell cel = grid.getCell(xPos + i, yPos + j);
                  if (cel != null) {
                    if (dist(xPos, yPos, xPos + i, yPos + j) < blobSize) {
                      if ((cel.water && r.waterResource) || (!cel.water && r.landResource)) {
                        cel.resource = r;
                        cel.localResources.add(r);
                        cel.sourced = r.sourcing;
                      }
                    }
                  }
                }
              }
              int big = (int) random(r.minResourceSpread, r.maxResourceSpread);
              for (int i = 0; i < big; i++) {
                Cell cel = grid.getCell(xPos + (int) (random(-1, 1) * r.propogationDist), yPos + (int) (random(-1, 1) * r.propogationDist));
                if (cel != null) {
                  cel.propogateResource(r, 1, grid);
                }
              }
              return true;
            }
    return false;
  }

  void propogateResource (Resource r, int stage, Grid grid) {
    if (stage < r.propogationMag) {
      float blobSize = r.blobSize/pow(r.resourceDecay, stage) + 1;
      if (moisture >= r.minMoisture && moisture <= r.maxMoisture)
        if (finalElevation >= r.minElevation && finalElevation <= r.maxElevation)
          if (temperature >= r.minTemperature && temperature <= r.maxTemperature)
            if (!sourced || resource == r)
              if ((water && r.waterResource) || (!water && r.landResource)) {
                for (int i = (int) -blobSize; i < blobSize; i++) {
                  for (int j = (int) -blobSize; j < blobSize; j++) {
                    resource = r;
                    localResources.add(r);
                    sourced = r.sourcing;
                    Cell cel = grid.getCell(xPos + i, yPos + j);
                    if (cel != null) {
                      if (dist(xPos, yPos, xPos + i, yPos + j) < blobSize) {
                        if ((cel.water && r.waterResource) || (!cel.water && r.landResource)) {
                          cel.resource = r;
                          cel.localResources.add(r);
                          cel.sourced = r.sourcing;
                        }
                      }
                    }
                  }
                }
                int big = (int) random(r.minResourceSpread, r.maxResourceSpread);
                for (int i = 0; i < big; i = i) {
                  Cell cel = grid.getCell(xPos + (int) (random(-1, 1) * r.propogationDist), yPos + (int) (random(-1, 1) * r.propogationDist));
                  if (cel != null) {
                    cel.propogateResource(r, stage + 1, grid);
                    i++;
                  }
                }
              }
    }
  }

  void smoothTemp(Grid grid) {
    float total = 0;
    float count = 0;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!(i == 0 && j == 0)) {
          Cell cel = grid.getCell(xPos + i, yPos + j);
          if (cel.size != 0) {
            total += cel.temperature;
            count++;
          }
        }
      }
    }
    total /= count;
    temperature = total;
  }

  void setEarthlikeWindDirection() {
    jitter = (float) bigNoise.eval(xPos * 5.0/grdWidth, yPos * 5.0/grdWidth) * grdHeight/32.0;
    if (yPos < grdHeight/6 + jitter) {
      windDir = new PVector(1, -1);
    } else if (yPos < grdHeight/6 + jitter + grdHeight/40) {
      windDir = new PVector(0, 0);
    } else if (yPos < grdHeight/3 + jitter) {
      windDir = new PVector(-1, 1);
    } else if (yPos < grdHeight/3 + jitter + grdHeight/40) {
      windDir = new PVector(0, 0);
    } else if (yPos < grdHeight/2 + jitter) {
      windDir = new PVector(1, -1);
    } else if (yPos < grdHeight/2 + jitter + grdHeight/40) {
      windDir = new PVector(0, 0);
    } else if (yPos < (2 * grdHeight)/3.0 + jitter) {
      windDir = new PVector(1, 1);
    } else if (yPos < (2 * grdHeight)/3.0 + jitter + grdHeight/40) {
      windDir = new PVector(0, 0);
    } else if (yPos < (5.0 * grdHeight)/6.0 + jitter) {
      windDir = new PVector(-1, -1);
    } else if (yPos < (5.0 * grdHeight)/6.0 + jitter + grdHeight/40) {
      windDir = new PVector(0, 0);
    } else {
      windDir = new PVector(1, 1);
    }
  }

  void calcFinalElevation() {
    if (noise >= 0 && noise <= 1) {
      finalElevation = (noise + elevation + (0.33 * pow(elevation, 2)))/2.0;
    } else {
      int e = 1/0;
    }
    //finalElevation = pow(noise, 1.5);
  }

  void checkElevation() {
    if (finalElevation < 0.5)
      water = true;
    divotedFinalElevation = finalElevation;
  }

  PVector getMouseGridspace() {
    int x, y;
    x = int(truMouseX/gridScale);
    y = int(truMouseY/gridScale);
    return new PVector(x, y);
  }

  void setBoundaryMoisture(Grid grid) {
  }

  void calculateTemperature(Grid grid) {
    float temp = 0;
    if (water == false) {
      temp += pow(map(abs((grdHeight/2) - yPos) * 2, 0, grdHeight, 0.9, 0.1), 1.5);
    } else {
      temp += pow(map(abs((grdHeight/2) - yPos) * 2, 0, grdHeight, 1, 0), 1.5);
    }
    float tempElev = 0;
    float oceanAvg = 0;
    int oceanTotal = 0;
    int posCount = 0;
    int diameter = grid.gridWidth/40;
    int radius = diameter/2;
    if (water == false) {
      tempElev = (finalElevation - 0.5) * 2;
      tempElev = pow(tempElev, 3);
      for (int i = -radius; i < radius; i++) {
        for (int j = -radius; j < radius; j++) {
          if (sqrt(sq(i) + sq(j)) <= diameter) {
            if (grid.getCell(xPos + i, yPos + j).ocean) {
              if (i < 0) {
                posCount--;
              }
              if (i > 0) {
                posCount++;
              }
              oceanAvg += i;   
              oceanTotal++;
            }
          }
        }
      }
    }
    temperature = temp - tempElev;
    //println(windDir);
    if ((oceanAvg/abs(oceanAvg)) == -windDir.x) {
      if (!water) {
        //println((posCount)/((PI*sq(radius))) + 0.5);
        temperature += (abs(oceanTotal)/(PI*sq(radius))) * (((posCount)/((PI*sq(radius))) + 0.5)+0.5) * 0.1;
      }
    }
    if (water) {
      moisture = pow(temperature, 0.75);
    }
    //temperature += () * (1 - (oceanTotal/( PI*sq(radius)))) * 0.2;
    //if(temperature > 1 || temperature <= 0){
    //  println(temperature);
    //}
  }

  void getMoisture(Grid grid) {
    float lat = abs((grid.gridHeight/2) - yPos) * 2;
    lat = map(lat, 0, grid.gridHeight, 0, 0.9);
    if (water == true) {
      moisture = (temperature);
      //println(moisture);
    }
    if (!water)
      if (abs(windDir.x) != 0) {
        float avgElevation = 0;
        float avgExtremeElevation = 0;
        float extremeCount = 0;
        float waterPercentage = 0;
        float avgTemperature = 0;
        int count = 1;
        int landCount = 1;
        for (int i = 0; i <  grid.gridWidth * ((lat) + 0.1); i++) {
          Cell cel = grid.getCell(xPos + (int)(i * windDir.x), yPos + (int)(i * (windDir.y/2)) + ((int)(bigNoise.eval((xPos + (int)(i * windDir.x)) * 0.05, yPos * 0.05) * grid.gridHeight/32)));
          if (cel.size > 0) {
            if (cel.water) {
              waterPercentage += sqrt(cel.moisture);
            } else {
              waterPercentage += (cel.moisture);
            }
            if (cel.finalElevation >= 0.5) {
              float landElevation = (cel.finalElevation - 0.5) * 0.5;
              waterPercentage -= sq(landElevation) * 10;
              i += landElevation * 10;
            }
            count++;
          } else {
            break;
          }
        }
        waterPercentage /= count;
        moisture = waterPercentage;
      } else {
        float moistTotal = 0;
        int count = 0;
        for (int i = -grid.gridHeight/25; i < grid.gridHeight/25; i++) {
          for (int j = -grid.gridHeight/25; j < grid.gridHeight/25; j++) {
            if (!(i == 0 && j == 0)) {
              Cell cel = grid.getCell(xPos + i, yPos + j);
              if (cel.size > 0) {
                moistTotal += cel.moisture;
                count++;
              }
            }
          }
        }
        moisture = moistTotal/count;
      }
    lat = abs((grid.gridHeight/2) - yPos + jitter) * 2;
    lat = map(lat, 0, grid.gridHeight, 0, 90);
    if (lat <= 15) {
      lat = map(lat, 0, 15, 1, 0);
      moisture += (moisture + 0.1) * 0.2 * lat;
    }
    if (lat >= 15 && lat <= 30) {
      if (lat >= 22.50) {
        lat = map(lat, 22.5, 30, 1, 0);
      } else {
        lat = map(lat, 15, 22.5, 0, 1);
      }
      moisture -=  (moisture + 0.1) * 0.2 * lat;
    }
    if (lat >= 60) {
      if (lat >= 75) {
        lat = map(lat, 75, 90, 1, 0);
      } else {
        lat = map(lat, 60, 75, 0, 1);
      }
      moisture += (moisture + 0.1) * 0.1 * lat;
    }
    if (moisture > 1)
      moisture = 1;
    else if (moisture < 0)
      moisture = 0;
    moistened = true;
    moisture = abs(moisture);
    if (water)
      moisture += 0.05;
  }

  void smoothMoisture(Grid grid) {
    float total = 0;
    int count = 0;
    for (int i = -2; i < 3; i++) {
      for (int j = -2; j < 3; j++) {
        if (!(i == 0 && j == 0)) {
          Cell cel = grid.getCell(xPos + i, yPos + j);
          if (cel.size != 0) {
            total += cel.moisture;
            count++;
          }
        }
      }
    }
    moisture = total/count;
  }

  void setClimate() {
    if (water == false) {
      if (moisture > 0.9) {
        if (temperature > 0.6) {
          climate = "Tropical Rainforest";
        } else if (temperature > 0.525) {
          climate = "Tropical Monsoon";
        } else if (temperature > 0.5) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.3) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.1) {
          climate = "Subarctic";
        } else if (temperature > 0.05) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.8) {
        if (temperature > 0.75) {
          climate = "Tropical Rainforest";
        } else if (temperature > 0.5) {
          climate = "Tropical Monsoon";
        } else if (temperature > 0.5) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.3) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.1) {
          climate = "Subarctic";
        } else if (temperature > 0.05) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.775) {
        if (temperature > 0.8) {
          climate = "Tropical Rainforest";
        } else if (temperature > 0.65) {
          climate = "Tropical Monsoon";
        } else if (temperature > 0.4) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.35) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.3) {
          climate = "Continental";
        } else if (temperature > 0.1) {
          climate = "Subarctic";
        } else if (temperature > 0.05) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.7) {
        if (temperature > 0.8) {
          climate = "Tropical Rainforest";
        } else if (temperature > 0.65) {
          climate = "Tropical Monsoon";
        } else if (temperature > 0.5) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.35) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.3) {
          climate = "Continental";
        } else if (temperature > 0.1) {
          climate = "Subarctic";
        } else if (temperature > 0.05) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.6) {
        if (temperature > 0.65) {
          climate = "Tropical Monsoon";
        } else if (temperature > 0.55) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.4) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.3) {
          climate = "Continental";
        } else if (temperature > 0.1) {
          climate = "Subarctic";
        } else if (temperature > 0.05) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.55) {
        if (temperature > 0.8) {
          climate = "Tropical Monsoon";
        } else if (temperature > 0.6) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.4) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.3) {
          climate = "Continental";
        } else if (temperature > 0.15) {
          climate = "Subarctic";
        } else if (temperature > 0.05) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.5) {
        if (temperature > 0.6) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.4) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.3) {
          climate = "Continental";
        } else if (temperature > 0.15) {
          climate = "Subarctic";
        } else if (temperature > 0.05) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.45) {
        if (temperature > 0.85) {
          climate = "Semi-Arid";
        } else if (temperature > 0.6) {
          climate = "Steppe";
        } else if (temperature > 0.45) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.3) {
          climate = "Continental";
        } else if (temperature > 0.2) {
          climate = "Subarctic";
        } else if (temperature > 0.1) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.4) {
        if (temperature > 0.9) {
          climate = "Hot Desert";
        } else if (temperature > 0.77) {
          climate = "Semi-Arid";
        } else if (temperature > 0.6) {
          climate = "Steppe";
        } else if (temperature > 0.45) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.3) {
          climate = "Continental";
        } else if (temperature > 0.2) {
          climate = "Subarctic";
        } else if (temperature > 0.1) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.35) {
        if (temperature > 0.8) {
          climate = "Hot Desert";
        } else if (temperature > 0.75) {
          climate = "Semi-Arid";
        } else if (temperature > 0.6) {
          climate = "Steppe";
        } else if (temperature > 0.5) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.3) {
          climate = "Continental";
        } else if (temperature > 0.2) {
          climate = "Subarctic";
        } else if (temperature > 0.1) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.3) {
        if (temperature > 0.8) {
          climate = "Hot Desert";
        } else if (temperature > 0.65) {
          climate = "Semi-Arid";
        } else if (temperature > 0.55) {
          climate = "Steppe";
        } else if (temperature > 0.5) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.3) {
          climate = "Continental";
        } else if (temperature > 0.2) {
          climate = "Subarctic";
        } else if (temperature > 0.1) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.2) {
        if (temperature > 0.7) {
          climate = "Hot Desert";
        } else if (temperature > 0.65) {
          climate = "Semi-Arid";
        } else if (temperature > 0.5) {
          climate = "Steppe";
        } else if (temperature > 0.3) {
          climate = "Continental";
        } else if (temperature > 0.25) {
          climate = "Subarctic";
        } else if (temperature > 0.15) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.1) {
        if (temperature > 0.7) {
          climate = "Hot Desert";
        } else if (temperature > 0.6) {
          climate = "Semi-Arid";
        } else if (temperature > 0.5) {
          climate = "Steppe";
        } else if (temperature > 0.35) {
          climate = "Continental";
        } else if (temperature > 0.2) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.05) {
        if (temperature > 0.7) {
          climate = "Hot Desert";
        } else if (temperature > 0.5) {
          climate = "Semi-Arid";
        } else if (temperature > 0.35) {
          climate = "Continental";
        } else if (temperature > 0.2) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else {
        if (temperature > 0.55) {
          climate = "Hot Desert";
        } else if (temperature > 0.5) {
          climate = "Semi-Arid";
        } else if (temperature > 0.3) {
          climate = "Tundra";
        } else { 
          climate = "Ice Cap";
        }
      }
    } else {
      climate = "Water";
    }
    if (water && temperature > 0.1 && temperature < 0.4) {
      localResources.add(whales);
      resource = whales;
    }
  }

  void freezeOceans(Grid grid) {
    float landPercentage = 0;
    int count = 0;
    if (water == true) {
      for (int i = -grid.gridHeight/25; i < grid.gridHeight/25; i++) {
        for (int j = -grid.gridHeight/25; j < grid.gridHeight/25; j++) {
          Cell cel = grid.getCell(xPos + i, yPos + j);
          if (cel.size > 0 && cel.water == false) {
            landPercentage++;
          }
          count++;
        }
      }
      if (count > 0)
        landPercentage /= count;
      if ((temperature * (1 - landPercentage) * 0.98) + bigNoise.eval(xPos * 0.05, yPos * 0.05) * 0.01 < 0.1) {
        ice = 1;
      } else if ((temperature * (1 - landPercentage) * 0.98) + bigNoise.eval(xPos * 0.05, yPos * 0.05) * 0.01  < 0.2) {
        ice = 0.5;
      }
    }
  }





  //NOISE FUNCTIONS
  void addNoise(float n_) { 
    noise += n_; 
    updateColor("Noise");
  }

  //PLATE FUNCTIONS
  void fillNeighbors(Grid grid) {
    if (active && infectivity < random(1)) {
      ArrayList<Cell> buds = new ArrayList<Cell>();
      for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
          if (abs(i) + abs(j) < 2) {
            Cell cel = grid.getCell(xPos + i, yPos + j);
            if (!cel.filled && cel.size > 0) {
              buds.add(cel);
            }
          }
        }
      }
      if (buds.size() > 0) {
        buds.get((int)random(buds.size())).activate(plate);
      } else {
        active = false;
      }
      //int choice = (int) random(4) + 1; 
      //if (choice == 1) {
      //} else if (choice == 2) {
      //  Cell cel = grid.getCell(xPos + 1, yPos); 
      //  if (!cel.filled) {
      //    cel.activate(plate); 
      //    if (random(1) < infectivity) {
      //      //cel.fillNeighbors(grid);
      //    }
      //  }
      //} else if (choice == 3) {
      //  Cell cel = grid.getCell(xPos, yPos + 1); 
      //  if (!cel.filled) {
      //    cel.activate(plate); 
      //    if (random(1) < infectivity) {
      //      //cel.fillNeighbors(grid);
      //    }
      //  }
      //} else if (choice == 4) {
      //  Cell cel = grid.getCell(xPos - 1, yPos); 
      //  if (!cel.filled) {
      //    cel.activate(plate); 
      //    if (random(1) < infectivity) {
      //      //cel.fillNeighbors(grid);
      //    }
      //  }
      //}
      //if (grid.getCell(xPos, yPos - 1).filled && grid.getCell(xPos + 1, yPos).filled && grid.getCell(xPos, yPos + 1).filled && grid.getCell(xPos - 1, yPos).filled) {
      //  active = false;
      //}
    }
  }

  void checkBorder (Grid grid) {
    border = false; 
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!(i == 0 && j == 0)) {
          Cell cel = grid.getCell(xPos + i, yPos + j); 
          if (cel.size != 0) {
            if (cel.plate != plate) {
              border = true; 
              neighbor = cel.plate; 
              if (!plate.neighbors.contains(cel.plate)) {
                plate.neighbors.add(cel.plate);
              }
            }
          }
        }
      }
    }
  }

  void smoothEdges(Grid grid) {
    ArrayList<Cell> neighbors = new ArrayList<Cell>(); 
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!(i == 0 && j == 0)) {
          Cell cel = grid.getCell(xPos + i, yPos + j); 
          if (cel.size != 0) {
            if (cel.plate != plate) {
              neighbors.add(cel);
            }
          }
        }
      }
    }

    if (neighbors.size() > 4) {
      changePlate(neighbors.get(0).plate);
    }
  }

  void getVoronoiNeighbors(Grid grid) {
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        Cell cel = grid.getCell(xPos + i, yPos + j);
        if (cel.size != 0) {
          if (cel.voronoi.voCol != voronoi.voCol) {
            if (!voronoi.neighbors.contains(cel.voronoi)) {
              voronoi.neighbors.add(cel.voronoi);
            }
          }
        }
      }
    }
  }

  void calculateTectonics (Grid grid) {
    if (border) {
      ArrayList<Cell> neighbors = new ArrayList<Cell>(); 
      for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
          if (!(i == 0 && j == 0)) {
            Cell cel = grid.getCell(xPos + i, yPos + j); 
            if (cel.size != 0) {
              if (cel.plate != plate) {
                neighbors.add(cel);
              }
            }
          }
        }
      }

      float totalCollision = 0; 
      for (Cell n : neighbors) {
        PVector v = new PVector(cos(plate.angle) - cos(n.plate.angle), sin(plate.angle) - sin(n.plate.angle)); 
        PVector p = new PVector(xPos - n.xPos, yPos - n.yPos); 

        float collision = PVector.dot(v, p); 
        collision += -map(collision, -2, 2, -1, 1); 
        totalCollision += collision; 
        //println(collision);
      }

      if (plate.land != neighbor.land) {

        if (!plate.land) {
          //Oceanic-Continental
          if (totalCollision > 0) {
            elevation += totalCollision * 0.07;
          } else {
            elevation += 0;
          }
        } else {
          //Continental-Oceanic
          if (totalCollision > 0) {
            elevation += totalCollision * 0.3;
          } else {
            elevation += totalCollision * 0.1;
          }
        }
      } else if (!plate.land) {
        //Oceanic-Oceanic
        if (totalCollision > 0) {
          elevation += totalCollision * 0.175;
        } else {
          elevation += abs(totalCollision) * 0.05;
        }
      } else {
        //Continental-Continental
        if (totalCollision > 0) {
          elevation += totalCollision * 0.4;
        } else {
          elevation += totalCollision * 0.15;
        }
      }
      //if (elevation > 1)
      //  elevation = 1; 
      //if (elevation < 0)
      //  elevation = 0;
    }
  }

  void activate(Plate p) {
    plate = p;
    plateID = p.plateID;
    active = true; 
    filled = true; 
    infectivity = p.infectivity; 
    p.cells.add(this); 
    if (p.land) {
      elevation = plate.landElevation;
    } else {
      elevation = plate.seaElevation;
    }
  }

  void changePlate(Plate p) {
    plate = p; 
    infectivity = p.infectivity; 
    p.cells.add(this); 
    if (p.land) {
      elevation = p.landElevation;
    } else {
      elevation = p.seaElevation;
    }
  }

  void getAvgBrothers(Grid grid) {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    int rad = (grid.gridWidth/500) + 1;
    for (int i = -rad; i < rad + 1; i++) {
      for (int j = -rad; j < rad + 1; j++) {
        if (!(i == 0 && j == 0)) {
          Cell cel = grid.getCell(xPos + i, yPos + j); 
          if (cel.size != 0) {
            if (cel.plate == plate) {
              neighbors.add(cel);
            }
          }
        }
      }
    }
    float total = 0; 
    for (Cell c : neighbors) {
      total += c.elevation;
    }
    elevation = total/neighbors.size(); 
    if (elevation > 1)
      elevation = 1; 
    if (elevation < 0)
      elevation = 0;
  }

  void getAvgEverybody(Grid grid) {
    ArrayList<Cell> neighbors = new ArrayList<Cell>(); 
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (!(i == 0 && j == 0)) {
          //println(xPos + i, yPos + j);
          Cell cel = grid.getCell(xPos + i, yPos + j); 
          if (cel.size != 0) {
            neighbors.add(cel);
          }
        }
      }
    }
    float total = 0; 
    for (Cell c : neighbors) {
      total += c.elevation;
    }
    elevation = total/neighbors.size();
    elevation += (bigNoise.eval(xPos * 0.5, yPos * 0.5) + bigNoise.eval(xPos, yPos))/2 * 0.01;
    if (elevation > 1)
      elevation = 1; 
    if (elevation < 0)
      elevation = 0;
  }

  void fillLake(Lake l, Grid grid) {
    if (!laked) {
      lake = l; 
      laked = true; 
      l.lake.add(this); 
      for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
          if (!(i == 0 && j == 0)) {
            //println(xPos + i, yPos + j);
            Cell cel = grid.getCell(xPos + i, yPos + j); 
            if (cel.size > 0 && !cel.laked && cel.finalElevation <= 0.5) {
              l.nextActive.add(cel);
            }
          }
        }
      }
    }
  }
}
