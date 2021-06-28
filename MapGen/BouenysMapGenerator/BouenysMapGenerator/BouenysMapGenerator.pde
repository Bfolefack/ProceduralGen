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
int grdWidth;
//Default: 500
int grdHeight;
//Size of the pixels on your grid
//Default: 1
int gridScale = 1;
//Controls how jagged your coastlines are
//Default: 2
float noiseDetail = 2.25;
//Controls the size of all structures on your map(this one's a bit wonky)
//Default: -0.5
float noiseScale = -0.2;
//Controls what power your noise funtion is raised to (How big the oceans are relative to the land)
//Default: 2
float noisePower = 1;
//The seed of your noise funtion. Set to 0 for a random seed;
//NOTE: This will do nothing if autogen is on.
int seed;
//Number of Continental Plates you want
int contPlates;
//Number of Oceanic Plates you want
int oceanPlates;
//Number of randomly scattered plates you want
int randPlates;
//Odds of a random plate being ocean or land. 1 = Ocean. 0 = Land.
float randPlateChance;
//Odds of the polar plates being ocean or land. 1 = Ocean. 0 = Land.
float polPlateChance;
int globalCount = 0;
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
Resource whales = new Resource("Whales", color(130, 180, 250));

Resource[] resources = {
  //  name,minMoisture,maxMoisture,minElevation,maxElevation,minTemperature,maxTemperature,blobSize,
  //  propogationDist,minResourceAbundance,maxResourceAbundance,minResourceSpread,maxResourceSpread,propogationMag,
  //  resourceDecay,waterResource,landResource,hue)
  new Resource("Oil", 0.0, 1.0, 0.00, 1.0, 0.0, 1.0, 10, 6, 10, 20, 5, 15, 4, 1.4, true, true, false, color(60)), 
  new Resource("Salt", 0.0, 0.2, 0.00, 0.6, 0.5, 1.0, 10, 15, 4, 8, 5, 10, 4, 1.5, false, true, false, color(255)), 
  new Resource("Coal", 0.0, 1.0, 0.65, 0.8, 0.0, 1.0, 9, 20, 7, 12, 4, 6, 4, 1.45, false, true, false, color(100)), 
  new Resource("Iron", 0.0, 1.0, 0.65, 0.9, 0.0, 1.0, 8, 16, 6, 9, 4, 6, 4, 1.5, false, true, true, color(170, 35, 5)), 
  new Resource("Copper", 0.0, 1.0, 0.7, 0.9, 0.0, 1.0, 6, 12, 4, 6, 3, 5, 4, 1.7, false, true, true, color(200, 100, 0)), 
  new Resource("Tin", 0.0, 1.0, 0.7, 0.9, 0.0, 1.0, 6, 12, 3, 5, 3, 5, 4, 1.7, false, true, true, color(140)), 
  new Resource("Silver", 0.0, 1.0, 0.75, 0.95, 0.0, 1.0, 5, 10, 2, 4, 2, 5, 4, 1.7, false, true, true, color(230)), 
  new Resource("Jade", 0.0, 1.0, 0.75, 0.95, 0.0, 1.0, 5, 10, 2, 3, 2, 5, 4, 1.7, false, true, true, color(0, 160, 100)), 
  new Resource("Uranium", 0.0, 1.0, 0.85, 1.0, 0.0, 1.0, 4, 8, 2, 3, 2, 4, 4, 1.7, false, true, true, color(0, 255, 0)), 
  new Resource("Gold", 0.0, 1.0, 0.85, 1.0, 0.0, 1.0, 4, 8, 2, 3, 2, 4, 4, 1.7, false, true, true, color(255, 215, 0)), 
  new Resource("Platinum", 0.0, 1.0, 0.85, 1.0, 0.0, 1.0, 3, 6, 1, 2, 2, 3, 4, 1.7, false, true, true, color(150, 215, 235)), 
  new Resource("Diamond", 0.0, 1.0, 0.9, 1.0, 0.0, 1.0, 3, 6, 1, 2, 2, 3, 4, 1.7, false, true, true, color(0, 255, 255)), 
};

void settings() {
  size(displayWidth - 100, displayHeight - 100);
}

void setup () {
  background(0);
  textSize(200);
  textAlign(CENTER, CENTER);
  fill(255);
  text("Loading...", width/2, height/2);
  loadJsons();
  delay(5);
}

void draw () {

  if (frameCount == 1 && autoGen == 0) {
    createMaps();
  } else if (autoGen > 0) {
    if (frameCount <= autoGen) {
      background(0);
      text("Getting Map #" + (frameCount), width/2, height/2);
      seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
      println(seed);
      noise = new OpenSimplexNoise(seed);
      bigNoise = noise;
      new Grid(0, 0, grdWidth, grdHeight, warpL, seed, noiseDetail, noiseScale, noisePower, oceanPlates, contPlates, randPlates, randPlateChance, polPlateChance).getImages();
    } else {
      exit();
    }
  } else {
    textAlign(LEFT);
    background(155);

    if (saving) {
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

    pushMatrix();
    translate(-xPan, -yPan);
    translate(width/2, height/2);
    scale(scale);
    grid.display();
    popMatrix();
    fill(0);
    textSize(25);
    text("Temperature: " + map(focusCell.temperature, 0, 1, -10, 30) + " C", 10, 25);
    //text("Temperature: " + focusCell.temperature, 10, 25);    
    text("Moisture: " + map(focusCell.moisture, 0, 1, 0, 100) + "%", 10, 50);
    text("River Flow: " + (focusCell.flow * 100) + "%", 10, 75);
    if (focusCell.water == false) {
      if (focusCell.finalElevation > 0.5) {
        text("Elevation: " + map(sq((focusCell.finalElevation - 0.5) * 2), 0, 1, 0, 8000) + " ft", 10, 100);
      } else {
        text("Elevation: " + (-map(sq((focusCell.finalElevation - 0.5) * 2), 0, 1, 0, 8000) + " ft"), 10, 100);
      }
    } else {
      text("Elevation: " + 0 + " ft", 10, 100);
    }
    text("Climate: " + focusCell.climate, 10, 125);
    text("Resources: " + focusCell.getResources(), 10, 150);

    if (keyPressed && key == 's') {
      saving = true;
      background(0);
      textSize(200);
      fill(255);
      text("Saving...", width/2 - 500, height/2);
    }
  }
}

void loadJsons() {
  json = loadJSONObject("Parameters.txt");
  grdWidth = json.getInt("GridSize");
  grdHeight = json.getInt("GridSize")/2;
  contPlates = json.getInt("ContinentalPlates");
  oceanPlates = json.getInt("OceanicPlates");
  randPlates = json.getInt("RandomPlates");
  seed = json.getInt("Seed");
  autoGen = json.getInt("AutoGen");
  randPlateChance = json.getFloat("RandomPlateChance");
  polPlateChance = json.getFloat("RandomPolarPlateChance");
}

void createMaps() {
  if (seed == 0) {
    seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
  }
  randomSeed(seed);
  if (autoGen > 0) {
    surface.setVisible(false);
  }

  if (autoGen > 0) {
    exit();
  }
  noise = new OpenSimplexNoise(seed);
  bigNoise = noise;
  //grid = new Grid();
  grid = new Grid(0, 0, grdWidth, grdHeight, warpL, seed, noiseDetail, noiseScale, noisePower, oceanPlates, contPlates, randPlates, randPlateChance, polPlateChance);
  //grid = new Grid(loadImage("Earth.png"));
  println(seed);
  println("All Done!");
  noStroke();
  xPan = width/2;
  yPan = height/2;
  fill(0);
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.1 * event.getCount());

  scale *= scaleAmt;
  xPan *= scaleAmt;
  yPan *= scaleAmt;
}
