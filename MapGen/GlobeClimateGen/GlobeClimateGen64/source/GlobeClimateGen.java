import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.util.*; 
import java.io.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GlobeClimateGen extends PApplet {

//Created by Boueny Folefack
//Last Updated: 4/24/21
//Whether or not you want to save the map to a text file 
//Default: true
boolean saveToFile = false;
boolean saving = false;
Cell focusCell = new Cell();
//Filepath if you would like to load a map from a file. Leave blank to generate a new map.
//Default: ""
//Template: "Maps/16.0/1000x500/seed/Map_1000x500.map";
//final String loadFile = "Maps/16.0/1500x750/-1362801152/Map_1500x750.map";
String loadFile = "";
//How many maps you want to generate
//Default: 0
int autoGen = 0;
//Dimensions of your grid
//Default: 1000
int grdWidth = 1500;
//Default: 500
int grdHeight = 750;
//Size of the pixels on your grid
//Default: 1
int gridScale = 1;
//Controls how jagged your coastlines are
//Default: 2
float noiseDetail = 2.2f;
//Controls the size of all structures on your map(this one's a bit wonky)
//Default: -0.5
float noiseScale = -0.5f;
//Controls what power your noise funtion is raised to (How big the oceans are relative to the land)
//Default: 2
float noisePower = 1.1f;
//The seed of your noise funtion. Set to 0 for a random seed;
//NOTE: This will do nothing if autogen is on.
int seed = 0;
//Number of Continental Plates you want
int contPlates = 3;
//Number of Oceanic Plates you want
int oceanPlates = 2;
//Number of randomly scattered plates you want
int randPlates = 6;
//Odds of a random plate being ocean or land. 1 = Ocean. 0 = Land.
float randPlateChance = 0.4f;
//Odds of the polar plates being ocean or land. 1 = Ocean. 0 = Land.
float polPlateChance = 0.8f;

JSONObject json;

//List of cool seeds:
//832653312 1000x500
//-838727424
//2051667968
//1870626560 750x375
//1977817088 750 x 375
//-132052992 750 x 375
//This modifies how much the nois is stretched towards the poles
int warpL = 16;
Grid grid;

//Camera Functions
//Controls:
//Move mouse near edge of screen to pan
//Use scroll wheel to zoom
float scale = 1;
float xPan;
float yPan;
float truMouseX;
float truMouseY;
//Noise
OpenSimplexNoise noise;
OpenSimplexNoise bigNoise;

public void settings(){
  size(displayWidth - 100, displayHeight - 100);
}

public void setup () {
  background(0);
  textSize(200);
  fill(255);
  text("Loading...", width/2 - 500, height/2);
  delay(15);
  json = loadJSONObject("Parameters.txt");
  grdWidth = json.getInt("GridWidth");
  grdHeight = json.getInt("GridHeight");
  contPlates = json.getInt("ContinentalPlates");
  oceanPlates = json.getInt("OceanicPlates");
  randPlates = json.getInt("RandomPlates");
  seed = json.getInt("Seed");
  autoGen = json.getInt("AutoGen");
  randPlateChance = json.getFloat("RandomPlateChance");
  polPlateChance = json.getFloat("RandomPolarPlateChance");
  if (loadFile == "") {
    if (seed == 0) {
      seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
    }
    randomSeed(seed);
    if (autoGen > 0) {
      surface.setVisible(false);
    }

    for (int i = 0; i < autoGen; i++) {    
      seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
      println(seed);
      noise = new OpenSimplexNoise(seed);
      bigNoise = noise;
      new Grid(0, 0, grdWidth, grdHeight, warpL, seed, noiseDetail, noiseScale, noisePower, oceanPlates, contPlates, randPlates, randPlateChance, polPlateChance).getImages();
      println("Map #" + (i + 1) + " done");
    }

    if (autoGen > 0) {
      exit();
    }
    noise = new OpenSimplexNoise(seed);
    bigNoise = noise;
    grid = new Grid(0, 0, grdWidth, grdHeight, warpL, seed, noiseDetail, noiseScale, noisePower, oceanPlates, contPlates, randPlates, randPlateChance, polPlateChance);
  } else {
    println("Loading Grid File");
    grid = new Grid(loadFile);
    bigNoise = noise;
    seed = grid.localSeed;
    noise = new OpenSimplexNoise(seed);
    bigNoise = noise;
  }
  println(seed);
  println("All Done!");
  noStroke();
  xPan = width/2;
  yPan = height/2;
  fill(0);
}

public void draw () {
  if(saving){
    grid.getImages();
    exit();
  }
  truMouseX = (mouseX + xPan - width/2)/scale;
  truMouseY = (mouseY + yPan - height/2)/scale;


  if (mouseX > width - 75) {
    xPan += 10;
  } else if (mouseX < 75) {
    xPan -= 10;
  }

  if (mouseY > height - 75) {
    yPan += 10;
  } else if (mouseY < 75) {
    yPan -= 10;
  }

  if (keyPressed && key == 'r') {
    xPan = width/2;
    yPan = height/2;
    scale = 1;
  }


  background(150);
  pushMatrix();
  translate(-xPan, -yPan);
  translate(width/2, height/2);
  scale(scale);
  grid.display();
  popMatrix();
  fill(0);
  textSize(25);
  text("Temperature: " + map(focusCell.temperature, 0, 1, -10, 30) + " C", 10, 25);
  //println("Temperature: " + temperature);
  text("Moisture: " + map(focusCell.moisture, 0, 1, 0, 100) + "%", 10, 50);
  text("River Flow: " + (focusCell.flow * 100) + "%", 10, 75);
  if (focusCell.water == false) {
    if (focusCell.finalElevation > 0.5f) {
      text("Elevation: " + map(sq((focusCell.finalElevation - 0.5f) * 2), 0, 1, 0, 8000) + " ft", 10, 100);
    } else {
      text("Elevation: " + (-map(sq((focusCell.finalElevation - 0.5f) * 2), 0, 1, 0, 8000) + " ft"), 10, 100);
    }
  } else {
    text("Elevation: " + 0 + " ft", 10, 100);
  }
  text("Climate: " + focusCell.climate, 10, 125);
  text("Color: " + red(focusCell.currColor) + ", " + green(focusCell.currColor) + ", " + blue(focusCell.currColor), 10, 150);
  
  if (keyPressed && key == 's') {
    saving = true;
    background(0);
    textSize(200);
    fill(255);
    text("Saving...", width/2 - 500, height/2);
  }
}

public void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.1f * event.getCount());

  scale *= scaleAmt;
  xPan *= scaleAmt;
  yPan *= scaleAmt;
}


class Cell implements Comparable<Cell> {
  int xPos;
  int yPos;
  int plateID;
  PVector windDir;
  int size;
  int borders;

  int currColor;
  int watershedColor;

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

  float noise;
  float elevation;
  float infectivity;
  float finalElevation;
  float moisture;
  float temperature;
  float ice;
  float divotedFinalElevation;
  float flow;

  String climate;
  ArrayList<String> flowIDs = new ArrayList<String>();

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

  public void updateColor(String map) {
    if (ocean)
      water = true;
    if (map.equals("Final")) {
      float num = finalElevation;
      if (climate.equals("Water")) {
        if (num < .01f) {
          currColor = color(15, 50, 100);
        } else if (num < .03f) {
          currColor = color(15, 50, 150);
        } else  if (num < .20f) {
          currColor = color(25, 40, 200);
        } else if (num < .3f) {
          currColor = color(25, 60, 220);
        } else if (num < .43f) {
          currColor = color(25, 80, 220);
        } else if (num < .5f) {
          currColor = color(60, 130, 250);
        } else {
          currColor = color(100, 190, 255);
        }
      } else if (climate.equals("Hot Desert")) {
        if (num < .45f) {
          currColor = color(255, 210, 150);
        } else if (num < .5f) {
          currColor = color(250, 200, 120);
        } else if (num < .55f) {
          currColor = color(250, 190, 100);
        } else if (num < .65f) {
          currColor = color(230, 170, 85);
        } else if (num < .75f) {
          currColor = color(220, 160, 60);
        } else if (num < .8f) {
          currColor = color(210, 140, 45);
        } else if (num < .9f) {
          currColor = color(190, 110, 25);
        } else if (num <= 1) {
          currColor = color(160, 85, 15);
        } else {
          currColor = color(num * 255);
        }
      } else if (climate.equals("Semi-Arid")) {
        if (num < .45f) {
          currColor = color(255, 190, 140);
        } else if (num < .5f) {
          currColor = color(250, 180, 110);
        } else if (num < .55f) {
          currColor = color(250, 170, 90);
        } else if (num < .65f) {
          currColor = color(230, 150, 75);
        } else if (num < .75f) {
          currColor = color(220, 140, 50);
        } else if (num < .8f) {
          currColor = color(210, 135, 35);
        } else if (num < .9f) {
          currColor = color(190, 80, 15);
        } else if (num <= 1) {
          currColor = color(160, 60, 10);
        } else {
          currColor = color(num * 255);
        }
      } else if (climate.equals("Tropical Savannah")) {
        if (num < .45f) {
          currColor = color(240, 245, 120);
        } else if (num < .5f) {
          currColor = color(225, 235, 120);
        } else if (num < .55f) {
          currColor = color(190, 195, 100);
        } else if (num < .65f) {
          currColor = color(185, 190, 80);
        } else if (num < .75f) {
          currColor = color(170, 185, 60);
        } else if (num < .8f) {
          currColor = color(165, 175, 50);
        } else if (num < .9f) {
          currColor = color(145, 155, 40);
        } else if (num <= 1) {
          currColor = color(130, 140, 30);
        } else {
          currColor = color(num * 255);
        }
      } else if (climate.equals("Tropical Rainforest")) {
        if (num < .45f) {
          currColor = color(150, 225, 120);
        } else if (num < .5f) {
          currColor = color(135, 215, 120);
        } else if (num < .55f) {
          currColor = color(115, 200, 100);
        } else if (num < .65f) {
          currColor = color(95, 185, 80);
        } else if (num < .75f) {
          currColor = color(80, 165, 60);
        } else if (num < .8f) {
          currColor = color(70, 150, 50);
        } else if (num < .9f) {
          currColor = color(55, 135, 40);
        } else if (num <= 1) {
          currColor = color(45, 115, 30);
        } else {
          currColor = color(num * 255);
        }
      } else if (climate.equals("Tropical Monsoon")) {
        if (num < .45f) {
          currColor = color(180, 225, 120);
        } else if (num < .5f) {
          currColor = color(165, 215, 120);
        } else if (num < .55f) {
          currColor = color(150, 200, 100);
        } else if (num < .65f) {
          currColor = color(140, 185, 80);
        } else if (num < .75f) {
          currColor = color(125, 165, 60);
        } else if (num < .8f) {
          currColor = color(95, 150, 50);
        } else if (num < .9f) {
          currColor = color(80, 135, 40);
        } else if (num <= 1) {
          currColor = color(65, 115, 30);
        } else {
          currColor = color(num * 255);
        }
      } else if (climate.equals("Humid Subtropical")) {
        if (num < .45f) {
          currColor = color(220, 255, 120);
        } else if (num < .5f) {
          currColor = color(210, 255, 120);
        } else if (num < .55f) {
          currColor = color(170, 235, 100);
        } else if (num < .65f) {
          currColor = color(155, 215, 80);
        } else if (num < .75f) {
          currColor = color(140, 200, 60);
        } else if (num < .8f) {
          currColor = color(125, 185, 50);
        } else if (num < .9f) {
          currColor = color(100, 175, 40);
        } else if (num <= 1) {
          currColor = color(90, 155, 30);
        } else {
          currColor = color(num * 255);
        }
      } else if (climate.equals("Steppe")) {
        if (num < .45f) {
          currColor = color(255, 250, 120);
        } else if (num < .5f) {
          currColor = color(235, 230, 110);
        } else if (num < .55f) {
          currColor = color(225, 220, 100);
        } else if (num < .65f) {
          currColor = color(210, 205, 80);
        } else if (num < .75f) {
          currColor = color(200, 195, 60);
        } else if (num < .8f) {
          currColor = color(185, 180, 50);
        } else if (num < .9f) {
          currColor = color(175, 170, 40);
        } else if (num <= 1) {
          currColor = color(160, 155, 30);
        } else {
          currColor = color(num * 255);
        }
      } else if (climate.equals("Tundra")) {
        if (num < .45f) {
          currColor = color(170, 140, 70);
        } else if (num < .5f) {
          currColor = color(160, 130, 60);
        } else if (num < .55f) {
          currColor = color(150, 120, 50);
        } else if (num < .65f) {
          currColor = color(140, 110, 40);
        } else if (num < .75f) {
          currColor = color(130, 100, 30);
        } else if (num < .8f) {
          currColor = color(120, 90, 20);
        } else if (num < .9f) {
          currColor = color(110, 80, 10);
        } else if (num <= 1) {
          currColor = color(100, 70, 0);
        } else {
          currColor = color(num * 255);
        }
      } else if (climate.equals("Ice Cap")) {
        if (num < .45f) {
          currColor = color(235);
        } else if (num < .5f) {
          currColor = color(220);
        } else if (num < .55f) {
          currColor = color(205);
        } else if (num < .65f) {
          currColor = color(190);
        } else if (num < .75f) {
          currColor = color(175);
        } else if (num < .8f) {
          currColor = color(160);
        } else if (num < .9f) {
          currColor = color(145);
        } else if (num <= 1) {
          currColor = color(130);
        } else {
          currColor = color(num * 255);
        }
      }
    } else if (map.equals("Elevation")) {
      float num = finalElevation;
      if (water) {
        if (num < .01f) {
          currColor = color(15, 50, 100);
        } else if (num < .03f) {
          currColor = color(15, 50, 150);
        } else  if (num < .20f) {
          currColor = color(25, 40, 200);
        } else if (num < .3f) {
          currColor = color(25, 60, 220);
        } else if (num < .43f) {
          currColor = color(25, 80, 220);
        } else if (num < .5f) {
          currColor = color(60, 130, 250);
        } else {
          currColor = color(100, 190, 255);
        }
      } else { 
        if (num < .45f) {
          currColor = color(255, 190, 40);
        } else if (num < .5f) {
          currColor = color(255, 220, 90);
        } else if (num < .55f) {
          currColor = color(250, 230, 150);
        } else if (num < .65f) {
          currColor = color(130, 220, 80);
        } else if (num < .75f) {
          currColor = color(100, 180, 60);
        } else if (num < .8f) {
          currColor = color(180, 120, 0);
        } else if (num < .9f) {
          currColor = color(120, 70, 0);
        } else if (num <= 1) {
          currColor = color(255);
        } else {
          currColor = color(num * 255);
        }
      }
      if (ice == 0.5f) {
        currColor = color(225, 245, 255);
      } else if (ice == 1) {
        currColor = color(180, 200, 205);
      }
    } else if (map.equals("Divoted")) {
      float num = divotedFinalElevation;
      if (water) {
        if (num < .01f) {
          currColor = color(15, 50, 100);
        } else if (num < .03f) {
          currColor = color(15, 50, 150);
        } else  if (num < .20f) {
          currColor = color(25, 40, 200);
        } else if (num < .3f) {
          currColor = color(25, 60, 220);
        } else if (num < .43f) {
          currColor = color(25, 80, 220);
        } else if (num < .5f) {
          currColor = color(60, 130, 250);
        } else {
          currColor = color(100, 190, 255);
        }
      } else { 
        if (num < .45f) {
          currColor = color(255, 190, 40);
        } else if (num < .5f) {
          currColor = color(255, 220, 90);
        } else if (num < .55f) {
          currColor = color(250, 230, 150);
        } else if (num < .65f) {
          currColor = color(130, 220, 80);
        } else if (num < .75f) {
          currColor = color(100, 180, 60);
        } else if (num < .8f) {
          currColor = color(180, 120, 0);
        } else if (num < .9f) {
          currColor = color(120, 70, 0);
        } else if (num <= 1) {
          currColor = color(255);
        } else {
          currColor = color(num * 255);
        }
      }
      if (ice == 0.5f) {
        currColor = color(225, 245, 255);
      } else if (ice == 1) {
        currColor = color(180, 200, 205);
      }
    } else if (map.equals("Plates")) {
      float num = elevation;
      if (num < .01f) {
        currColor = color(15, 50, 100);
      } else if (num < .03f) {
        currColor = color(15, 50, 150);
      } else  if (num < .20f) {
        currColor = color(25, 40, 200);
      } else if (num < .3f) {
        currColor = color(25, 60, 220);
      } else if (num < .43f) {
        currColor = color(25, 80, 220);
      } else if (num < .5f) {
        currColor = color(60, 130, 250);
      } else if (num < .55f) {
        currColor = color(250, 230, 150);
      } else if (num < .65f) {
        currColor = color(130, 220, 80);
      } else if (num < .75f) {
        currColor = color(100, 180, 60);
      } else if (num < .8f) {
        currColor = color(180, 120, 0);
      } else if (num < .9f) {
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
      if (num < .01f) {
        currColor = color(15, 50, 100);
      } else if (num < .03f) {
        currColor = color(15, 50, 150);
      } else  if (num < .20f) {
        currColor = color(25, 40, 200);
      } else if (num < .3f) {
        currColor = color(25, 60, 220);
      } else if (num < .43f) {
        currColor = color(25, 80, 220);
      } else if (num < .5f) {
        currColor = color(60, 130, 250);
      } else if (num < .55f) {
        currColor = color(250, 230, 150);
      } else if (num < .65f) {
        currColor = color(130, 220, 80);
      } else if (num < .75f) {
        currColor = color(100, 180, 60);
      } else if (num < .8f) {
        currColor = color(180, 120, 0);
      } else if (num < .9f) {
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
      if (!ocean)
        currColor = color(255 - flow * 255, 255 - flow * 255, 255);
      else
        currColor = color(0, 0, 255);
    } else if (map.equals("Heightmap")) {
      currColor = color(finalElevation * 255);
    } else if (map.equals("DivotedHeightmap")) {
      currColor = color(divotedFinalElevation * 255);
    } else if (map.equals("Watershed")) {
      currColor = watershedColor;
    } else if (map.equals("Climate")) {
      String str = climate;
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
      } else {
        currColor = color(255);
      }
    }
  }

  public void display() {
    if (keyPressed) {
      if (key == 'p') {
        updateColor("Plates");
      }
      if (key == 'n') {
        updateColor("Noise");
      }
      if (key == 'e') {
        updateColor("Elevation");
      }
      if (key == 'c') {
        updateColor("Climate");
      }
      if (key == 't') {
        updateColor("Temperature");
      }
      if (key == 'm') {
        updateColor("Moisture");
      }
      if (key == 'h') {
        updateColor("Heightmap");
      }
      if (key == 'd') {
        updateColor("Divoted");
      }
      if (key == 'v') {
        updateColor("DivotedHeightmap");
      }
      if (key == 'y') {
        updateColor("River");
      } 
      if (key == 'f') {
        //updateColor("Final");
      }
      if (key == 'h') {
        updateColor("Watershed");
      }
    }

    fill(currColor);
    if (key == 'l') {
      if (laked) {
        fill(lake.col);
        //println("yee");
      }
      if (ocean) {
        fill(0, 0, 255);
        //println("yee");
      }
    } 
    if (key == 't') {
      fill(255, 255 - temperature * 255, 255 - temperature * 255);
    }
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
  public void flowRiver(Grid grid) {
    if (!ocean && !lowestNeighbor.ocean) {
      watershedColor = lowestNeighbor.flowRiver(grid, sq(moisture) * pow((finalElevation - 0.5f) * 2, 4), 1);
    } else if (ocean) {
      watershedColor = color(255);
    }
  }

  public int flowRiver(Grid grid, float propogation, int count) {   
    if (!ocean && !lowestNeighbor.ocean) {
      flow += propogation;
      return lowestNeighbor.flowRiver(grid, propogation, count + 1);
    } else if (!ocean) {
      flow += propogation;
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

  public void slopeNeighbors(float target, PriorityQueue<Cell> active, Grid grid) {
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

  public void calculateTemperature(Grid grid) {
    float temp = 0;
    if (water == false) {
      temp += pow(map(abs((grdHeight/2) - yPos) * 2, 0, grdHeight, 0.9f, 0.1f), 1);
    } else {
      temp += pow(map(abs((grdHeight/2) - yPos) * 2, 0, grdHeight, 1, 0), 1);
    }
    float tempElev = 0;
    float oceanAvg = 0;
    int oceanTotal = 0;
    int posCount = 0;
    int diameter = grid.gridWidth/40;
    int radius = diameter/2;
    if (water == false) {
      tempElev = (finalElevation - 0.5f) * 2;
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
        temperature += (abs(oceanTotal)/(PI*sq(radius))) * (((posCount)/((PI*sq(radius))) + 0.5f)+0.5f) * 0.1f;
      }
    }
    //temperature += () * (1 - (oceanTotal/( PI*sq(radius)))) * 0.2;
    //if(temperature > 1 || temperature <= 0){
    //  println(temperature);
    //}
  }

  public void smoothTemp(Grid grid) {
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

  public void setEarthlikeWindDirection() {
    float jitter = (float) bigNoise.eval(xPos * 5.0f/grdWidth, yPos * 5.0f/grdWidth) * grdHeight/16.0f;
    if (yPos < grdHeight/6 + jitter) {
      windDir = new PVector(1, -1);
    } else if (yPos < grdHeight/6 + jitter + grdHeight/40) {
      windDir = new PVector(0, 4);
    } else if (yPos < grdHeight/3 + jitter) {
      windDir = new PVector(-1, 1);
    } else if (yPos < grdHeight/3 + jitter + grdHeight/40) {
      windDir = new PVector(0, 3);
    } else if (yPos < grdHeight/2 + jitter) {
      windDir = new PVector(1, -1);
    } else if (yPos < grdHeight/2 + jitter + grdHeight/40) {
      windDir = new PVector(0, 2);
    } else if (yPos < (2 * grdHeight)/3.0f + jitter) {
      windDir = new PVector(1, 1);
    } else if (yPos < (2 * grdHeight)/3.0f + jitter + grdHeight/40) {
      windDir = new PVector(0, 3);
    } else if (yPos < (5.0f * grdHeight)/6.0f + jitter) {
      windDir = new PVector(-1, -1);
    } else if (yPos < (5.0f * grdHeight)/6.0f + jitter + grdHeight/40) {
      windDir = new PVector(0, 4);
    } else {
      windDir = new PVector(1, 1);
    }
  }

  public void calcFinalElevation() {
    elevation = pow(elevation, 1.2f);
    if (noise >= 0 && noise <= 1 && elevation >= 0 && elevation <= 1) {
      finalElevation = noise * 0.5f + elevation * 0.5f;
    } else {
      int e = 1/0;
    }
  }

  public void checkElevation() {
    if (finalElevation < 0.5f)
      water = true;
    divotedFinalElevation = finalElevation;
  }

  public PVector getMouseGridspace() {
    int x, y;
    x = PApplet.parseInt(truMouseX/gridScale);
    y = PApplet.parseInt(truMouseY/gridScale);
    return new PVector(x, y);
  }

  public void setBoundaryMoisture(Grid grid) {
    if (water) {
      moistened = true;
    }
    if (water) {
      map(sqrt(temperature), 0, 1, 0.3f, 1);
      //println(moisture);
    } else {
      //moisture = 0;
    }
  }

  public void getMoisture(Grid grid) {
    float lat = abs((grid.gridHeight/2) - yPos) * 2;
    lat = map(lat, 0, grid.gridHeight, 0, 0.8f);
    lat += 0.2f;
    if (water == true) {
      moisture = sqrt(temperature);
      //println(moisture);
    }
    if (!water)
    if (abs(windDir.x) != 0) {
      float avgElevation = 0;
      float avgExtremeElevation = 0;
      float extremeCount = 0;
      float waterPercentage = 0;
      float avgTemperature = 0;
      int count = 0;
      int landCount = 0;
      float addedMoisture = 0;
      for (int i = 0; i < grid.gridWidth * lat; i++) {
        Cell cel = grid.getCell(xPos + (i * (int) windDir.x), yPos + ((int)(bigNoise.eval((xPos + (i * (int) windDir.x)) * 0.05f, yPos * 0.05f) * grid.gridHeight/20)));
        if (cel.size > 0) {
          if (water)
            if (cel.water && addedMoisture < sqrt(temperature)/4)
              //addedMoisture += 0.05;
              print();
            else
              waterPercentage += cel.moisture * 2;
          else
            if (cel.water) 
              waterPercentage += 1;
            else 
            waterPercentage += cel.moisture * 2;

          avgTemperature += cel.temperature;
          if (cel.water == false) {
            float landElevation = (cel.finalElevation - 0.5f) * 2;
            if (landElevation < 0) {
              landElevation = 0;
            }
            avgElevation += sq((landElevation));
            landCount++;
            if (sq(landElevation) > 0.6f) {
              avgExtremeElevation += sq(landElevation);
              extremeCount++;
            }
            if (sq(landElevation) > 0.9f) {
              break;
            }
          }
          count++;
        }
      }
      if (count > 0) {
        waterPercentage /= count;
        avgTemperature /= count;
      }
      if (landCount > 0)
        avgElevation /= landCount;

      if (extremeCount != 0)
        avgExtremeElevation /= extremeCount;
      avgElevation *= (1 - avgExtremeElevation);
      if (avgElevation > 0.2f) {
        map(avgElevation, 0, 1, 0.4f, 1);
      }
      moisture += waterPercentage * map(avgTemperature, 0, 1, 0.4f, 0.8f) * (1 - avgElevation) + addedMoisture;
      //if (water == true) {
      //  moisture += 25.0/grid.gridWidth;
      //  if (moisture > sqrt(temperature)) {
      //    moisture = sqrt(temperature);
      //  }
      //}

      lat = abs((grid.gridHeight/2) - yPos) * 2;
      lat = map(lat, 0, grid.gridHeight, 0, 90);
      if (lat <= 15) {
        lat = map(lat, 0, 10, 1, 0);
        moisture += (moisture + 0.05f) * 0.4f * lat;
      }
      if (lat >= 20 && lat <= 40) {
        if (lat >= 30) {
          lat = map(lat, 30, 40, 1, 0);
        } else {
          lat = map(lat, 20, 30, 0, 1);
        }
        moisture -=  (moisture + 0.05f) * 0.4f * lat;
      }
      if (lat >= 60) {
        if (lat >= 75) {
          lat = map(lat, 75, 90, 1, 0);
        } else {
          lat = map(lat, 60, 75, 0, 1);
        }
        moisture += (moisture + 0.05f) * 0.2f * lat;
      }
      if (moisture > 1)
        moisture = 1;
      else if (moisture < 0)
        moisture = 0;
      moistened = true;
      moisture = pow(abs(moisture), 1.2f);
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
    if (water)
      moisture += 0.05f;
  }

  public void smoothMoisture(Grid grid) {
    float total = 0;
    int count = 0;
    for (int i = -1; i < 2; i++) {
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

  public void setClimate() {
    if (water == false) {
      if (moisture > 0.7f) {
        if (temperature > 0.6f) {
          climate = "Tropical Rainforest";
        } else if (temperature > 0.4f) {
          climate = "Tropical Monsoon";
        } else if (temperature > 0.3f) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.2f) {
          climate = "Humid Subtropical";
        } else {
          climate = "Subarctic";
        }
      } else if (moisture > 0.6f) {
        if (temperature > 0.8f) {
          climate = "Tropical Rainforest";
        } else if (temperature > 0.6f) {
          climate = "Tropical Monsoon";
        } else if (temperature > 0.5f) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.3f) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.2f) {
          climate = "Continental";
        } else {
          climate = "Subarctic";
        }
      } else if (moisture > 0.4f) {
        if (temperature > 0.8f) {
          climate = "Tropical Monsoon";
        } else if (temperature > 0.6f) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.3f) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.2f) {
          climate = "Continental";
        } else {
          climate = "Subarctic";
        }
      } else if (moisture > 0.3f) {
        if (temperature > 0.7f) {
          climate = "Tropical Savannah";
        } else if (temperature > 0.4f) {
          climate = "Humid Subtropical";
        } else if (temperature > 0.3f) {
          climate = "Continental";
        } else if (temperature > 0.15f) {
          climate = "Subarctic";
        } else if (temperature > 0.1f) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.2f) {
        if (temperature > 0.7f) {
          climate = "Semi-Arid";
        } else if (temperature > 0.5f) {
          climate = "Steppe";
        } else if (temperature > 0.25f) {
          climate = "Continental";
        } else if (temperature > 0.15f) {
          climate = "Subarctic";
        } else if (temperature > 0.1f) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.1f) {
        if (temperature > 0.6f) {
          climate = "Hot Desert";
        } else if (temperature > 0.5f) {
          climate = "Semi-Arid";
        } else if (temperature > 0.4f) {
          climate = "Steppe";
        } else if (temperature > 0.3f) {
          climate = "Continental";
        } else if (temperature > 0.15f) {
          climate = "Subarctic";
        } else if (temperature > 0.1f) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else if (moisture > 0.05f) {
        if (temperature > 0.6f) {
          climate = "Hot Desert";
        } else if (temperature > 0.5f) {
          climate = "Semi-Arid";
        } else if (temperature > 0.4f) {
          climate = "Steppe";
        } else if (temperature > 0.3f) {
          climate = "Continental";
        } else if (temperature > 0.2f) {
          climate = "Subarctic";
        } else if (temperature > 0.1f) {
          climate = "Tundra";
        } else {
          climate = "Ice Cap";
        }
      } else {
        if (temperature > 0.5f) {
          climate = "Hot Desert";
        } else if (temperature > 0.4f) {
          climate = "Semi-Arid";
        } else if (temperature > 0.2f) {
          climate = "Tundra";
        } else { 
          climate = "Ice Cap";
        }
      }
    } else {
      climate = "Water";
    }
  }

  public void freezeOceans(Grid grid) {
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
      if ((temperature * (1 - landPercentage) * 0.98f) + bigNoise.eval(xPos * 0.05f, yPos * 0.05f) * 0.01f < 0.1f) {
        ice = 1;
      } else if ((temperature * (1 - landPercentage) * 0.98f) + bigNoise.eval(xPos * 0.05f, yPos * 0.05f) * 0.01f  < 0.2f) {
        ice = 0.5f;
      }
    }
  }





  //NOISE FUNCTIONS
  public void addNoise(float n_) { 
    noise += n_; 
    updateColor("Noise");
  }

  //PLATE FUNCTIONS
  public void fillNeighbors(Grid grid) {
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

  public void checkBorder (Grid grid) {
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

  public void smoothEdges(Grid grid) {
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

  public void calculateTectonics (Grid grid) {
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
            elevation += totalCollision * -0.07f;
          } else {
            elevation += 0;
          }
        } else {
          //Continental-Oceanic
          if (totalCollision > 0) {
            elevation += totalCollision * 0.3f;
          } else {
            elevation += abs(totalCollision) * 0.1f;
          }
        }
      } else if (!plate.land) {
        //Oceanic-Oceanic
        if (totalCollision > 0) {
          elevation += totalCollision * 0.2f;
        } else {
          elevation += abs(totalCollision) * 0.02f;
        }
      } else {
        //Continental-Continental
        if (totalCollision > 0) {
          elevation += totalCollision * 0.3f;
        } else {
          elevation += totalCollision * 0.1f;
        }
      }

      if (elevation > 1)
        elevation = 1; 
      if (elevation < 0)
        elevation = 0;
    }
  }

  public void activate(Plate p) {
    plate = p;
    plateID = p.plateID;
    active = true; 
    filled = true; 
    infectivity = p.infectivity; 
    p.cells.add(this); 
    if (p.land) {
      elevation = 0.7f;
    } else {
      elevation = 0.3f;
    }
  }

  public void changePlate(Plate p) {
    plate = p; 
    infectivity = p.infectivity; 
    p.cells.add(this); 
    if (p.land) {
      elevation = p.landElevation;
    } else {
      elevation = p.seaElevation;
    }
  }

  public void getAvgBrothers(Grid grid) {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    int rad = (grid.gridWidth/1000) + 1;
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

  public void getAvgEverybody(Grid grid) {
    //boolean b = true;
    //while(b){
    //  int x = (int)random(-2, 10);
    //  int y = (int)random(-2, 10);
    //  //println((xPos + x) + "," + (yPos + y));
    //  Cell cel = grid.getCell(xPos + x, yPos + y);
    //  if(cel.size > 0){
    //    elevation = cel.elevation;
    //    b = false;
    //  }
    //}
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
    if (elevation > 1)
      elevation = 1; 
    if (elevation < 0)
      elevation = 0;
  }

  public void fillLake(Lake l, Grid grid) {
    if (!laked) {
      lake = l; 
      laked = true; 
      l.lake.add(this); 
      for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
          if (!(i == 0 && j == 0)) {
            //println(xPos + i, yPos + j);
            Cell cel = grid.getCell(xPos + i, yPos + j); 
            if (cel.size > 0 && !cel.laked && cel.finalElevation <= 0.5f) {
              l.nextActive.add(cel);
            }
          }
        }
      }
    }
  }
}


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

  PVector possibR;

  boolean plateBuilding = true;
  boolean bordersChecked = false;

  Plate[] plates;

  ArrayList<Lake> lakes;
  ArrayList<PVector> shuffledCells;

  float[] octaves = {50, 25, 12.5f, 6.25f, 3.125f, 2, 1, 0.5f};

  JSONObject gridJson = new JSONObject();

  Random randy;

  Grid(String file) {
    JSONObject jj = loadJSONObject(file);
    loadJSON(jj);
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
    Collections.shuffle(shuffledCells, new Random(localSeed));
    println("Getting Noise");
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        for (int k = 0; k < 8; k++) {
          cells[i][j].addNoise(getNoise(i, j, pow(noiseDet, k + 1 + noiseSca)) * octaves[k]);
        }
      }
    }
    println("Building Plates");


    ArrayList<Integer> yValues = new ArrayList<Integer>();
    for (int i = 0; i < gridHeight; i++) {
      float lat = abs((gridHeight/2) - i) * 2;
      lat = map(lat, 0, gridHeight, 0, 1);
      lat = pow(lat, 16);
      lat = map(lat, 0, 1, 20, 1);
      //println(lat);
      for (int j = 0; j < lat; j++) {
        yValues.add(i);
      }
    }

    plates = new Plate[continentalPlates + oceanicPlates + randomPlates + 2];

    for (int i = 0; i < plates.length - 2; i++) {
      if (i < oceanicPlates) {
        int x = (int)random(gridWidth);
        int y = yValues.get((int)random(yValues.size()));
        plates[i] = new Plate(color(random(255), random(255), random(255)), false, random(-0.3f, 0.2f), this);
        cells[x][y].activate(plates[i]);
      } else if (i < continentalPlates + oceanicPlates) {
        int x = (int)random(gridWidth);
        int y = yValues.get((int)random(yValues.size()));
        plates[i] = new Plate(color(random(255), random(255), random(255)), true, random(-0.1f, 0.4f), this);
        cells[x][y].activate(plates[i]);
      } else {
        int x = (int)random(gridWidth);
        int y = yValues.get((int)random(yValues.size()));
        boolean b;
        if (random(1) < randomPlateChance) {
          b = false;
        } else {
          b = true;
        }

        plates[i] = new Plate(color(random(255), random(255), random(255)), b, random(0.5f, 0.7f), this);
        cells[x][y].activate(plates[i]);
      }
    }

    boolean b;
    if (random(1) < polarPlateChance) {
      b = false;
    } else { 
      b = true;
    }

    plates[plates.length - 2] = new Plate(color(random(255), random(255), random(255)), b, random(0.4f, 0.7f), this);
    for (int i = 0; i < gridWidth; i++) {
      cells[i][0].activate(plates[plates.length - 2]);
    }

    if (random(1) < polarPlateChance) {
      b = false;
    } else { 
      b = true;
    }

    plates[plates.length - 1] = new Plate(color(random(255), random(255), random(255)), b, random(0.4f, 0.7f), this);
    for (int i = 0; i < gridWidth; i++) {
      cells[i][gridHeight - 1].activate(plates[plates.length - 1]);
    }

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
      if (lakes.get(i) != biggestLake) {
        lakes.remove(i).drain();
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

    for (int k = 0; k < 1; k++) {
      for (int i = 0; i < gridHeight; i++) {
        for (int j = 0; j < gridWidth; j++) {
          if (cells[j][i].windDir.x == 1) {
            cells[j][i].getMoisture(this);
          }
          if (cells[gridWidth - j - 1][i].windDir.x == -1) {
            cells[gridWidth - j - 1][i].getMoisture(this);
          }
        }
      }
      //for (int i = gridHeight - 1; i >= 0; i--) {
      //  for (int j = 0; j < gridWidth; j++) {

      //  }
      //}
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

    int count = 0;
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
        if (cells[i][j].flow > biggest) {
          biggest = cells[i][j].flow;
        }
        if (cells[i][j].flow < smallest) {
          smallest = cells[i][j].flow;
        }
      }
    }
    println(smallest + ", " + biggest);

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].flow = map(cells[i][j].flow, smallest, biggest, 0, 1);
        cells[i][j].flow = sqrt(cells[i][j].flow);
      }
    }

    //smallest = Integer.MAX_VALUE; 
    //biggest = Integer.MIN_VALUE; 

    //for (int i = 0; i < gridWidth; i++) {
    //  for (int j = 0; j < gridHeight; j++) {
    //    if (cells[i][j].flow > biggest) {
    //      biggest = cells[i][j].flow;
    //    }
    //    if (cells[i][j].flow < smallest) {
    //      smallest = cells[i][j].flow;
    //    }
    //  }
    //}

    //println(smallest + ", " + biggest);

    //for (int i = 0; i < gridWidth; i++) {
    //  for (int j = 0; j < gridHeight; j++) {
    //    cells[i][j].flow = map(cells[i][j].flow, smallest, biggest, 0, 1);
    //    //cells[i][j].flow = sqrt(cells[i][j].flow);
    //  }
    //}

    //if (saveToFile) {
    //  println("Creating Images");
    //  getImages();
    //}

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        cells[i][j].updateColor("Elevation");
      }
    }
    println("done!");
  }

  public Cell getNextWater() {
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        Cell cel = cells[i][j];
        if (cel.size != 0 && cel.laked == false && cel.finalElevation <= 0.5f) {
          return cel;
        }
      }
    }
    return new Cell();
  }

  public void getImages() {
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
    //getImage("Final");
    if (saveToFile) {
      println("Creating JSON");
      saveJSON();
    }
  }

  public PImage getImage(String tag) {
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

  public void saveJSON() {
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

  public void loadJSON(JSONObject json) {
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

  public Cell loadJSONCell(JSONObject cell) {
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

  public float getNoise(int index2, int index, float nD) {
    float lat = abs((gridHeight/2) - index) * 2;
    float r =pow(sqrt((float)gridHeight * 2 * (float)lat - pow((float)lat, 2.0f))/PApplet.parseFloat(gridHeight), warpLevel);
    r = 1.0f - r;
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





  public void display() {

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

    for (int i = 0; i < gridWidth; i++) {
      line(xPos + gridScale * i, yPos, xPos + gridScale * i, yPos + gridHeight * gridScale);
    }

    for (int i = 0; i < gridHeight; i++) {
      line(xPos, yPos + gridScale * i, xPos + gridWidth * gridScale, yPos + gridScale * i);
    }

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

  public void update() {
    if (plateBuilding) {
      plateBuilding = false;
      //println("Shuffling");
      //Collections.shuffle(shuffledCells, new Random(localSeed + (int) random(30)));
      //println("Done Shuffling");
      for (PVector p : shuffledCells) {
        Cell cel = getCell((int) p.x, (int) p.y);
        cel.fillNeighbors(this);
        if (!cel.filled) {
          plateBuilding = true;
        }
      }
    } else if (!bordersChecked) {
      println("Checking Plate borders");
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

  public Cell getCell(int x, int y) {
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
class Lake {
  ArrayList<Cell> lake = new ArrayList<Cell>();
  ArrayList<Cell> active = new ArrayList<Cell>();
  ArrayList<Cell> nextActive = new ArrayList<Cell>();
  int col;

  Lake() {
  }

  Lake(Cell seed) {
    active.add(seed);
    col = color(random(255), random(255), random(255));
  }

  public void fillBody(Grid grid) {
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

  public void ocean() {
    for (Cell c : lake) {
      c.ocean = true;
    }
  }

  public void drain() {
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
class Plate {
  Grid grid;
  int col;
  boolean land;
  boolean active;
  boolean ocean;
  float infectivity;
  float angle;
  float seaElevation = 0.3f;
  float landElevation = 0.5f;
  int xPos;
  int yPos;
  int plateID = (int) random(Integer.MIN_VALUE, Integer.MAX_VALUE);
  ArrayList<Cell> cells = new ArrayList<Cell>();
  ArrayList<Plate> neighbors = new ArrayList<Plate>();
  Plate(int c_, boolean l_, float i_, Grid g_) {
    col = c_;
    land = l_;
    infectivity = i_;
    grid = g_;
    active = true;
    //angle = (int)random(8) * 45;
    //println(angle);
    //angle = radians(angle);
    angle = random(TWO_PI);
  }

  public void getAvgPoint() {
    int xTotal = 0;
    int yTotal = 0;
    for (Cell c : cells) {
      xTotal += c.xPos;
      yTotal += c.yPos;
    }
    xPos = (int) (xTotal/ (float) cells.size());
    yPos = (int) (yTotal/ (float) cells.size());
  }

  public void checkNeighbors() {
    if (neighbors.size() < 2 && neighbors.size() > 0) {
      for (Cell cel : cells) {
        cel.changePlate(neighbors.get(0));
      }
      active = false;
    } else {
      if (!land) {
        boolean allLand = true;
        for (Plate p : neighbors) {
          if (!p.land)
            allLand = false;
        }
        if (allLand) {
          for (Cell c : cells) {
            c.elevation = landElevation;
          }
        }
      }
    }
  }

  public void gradientBorders() {
    for (Cell c : cells) {
      if (!c.border) {
        c.getAvgBrothers(grid);
      }
    }
  }

  public void smoothBorders() {
    for (Cell c : cells) {
      c.getAvgEverybody(grid);
    }
  }
}

static class Serializer {
  public static void serialization(String file, Object object) throws IOException {
    FileOutputStream fileOutputStream = new FileOutputStream(file);
    BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(fileOutputStream);
    ObjectOutputStream objectOutputStream = new ObjectOutputStream(bufferedOutputStream);
    objectOutputStream.writeObject(object);
    objectOutputStream.close();
  }

  public static Object deSerialization(String file) throws IOException, ClassNotFoundException {
    FileInputStream fileInputStream = new FileInputStream(file);
    BufferedInputStream bufferedInputStream = new BufferedInputStream(fileInputStream);
    ObjectInputStream objectInputStream = new ObjectInputStream(bufferedInputStream);
    Object object = objectInputStream.readObject();
    objectInputStream.close();
    return object;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GlobeClimateGen" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
