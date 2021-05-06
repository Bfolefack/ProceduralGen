//Created by Boueny Folefack
//Last Updated: 4/24/21
//Whether or not you want to save the map to a text file 
//Default: true
boolean saveToFile = false;
int wahCount = 0;
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
int grdWidth = 750;
//Default: 500
int grdHeight = 375;
//Size of the pixels on your grid
//Default: 1
int gridScale = 1;
//Controls how jagged your coastlines are
//Default: 2
float noiseDetail = 2.4;
//Controls the size of all structures on your map(this one's a bit wonky)
//Default: -0.5
float noiseScale = -0.5;
//Controls what power your noise funtion is raised to (How big the oceans are relative to the land)
//Default: 2
float noisePower = 1.1;
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
float randPlateChance = 0.4;
//Odds of the polar plates being ocean or land. 1 = Ocean. 0 = Land.
float polPlateChance = 0.8;

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

void setup () {
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
  size(1500, 750);
  println("All Done!");
  noStroke();
  xPan = width/2;
  yPan = height/2;
  fill(0);
}

void draw () {
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
  }
  if (keyPressed && key == 's') {
    println("Saving...");
    grid.getImages();
    //try {
    //  Serializer.serialization("test.txt", grid);
    //} 
    //catch (Exception e) {
    //  println(e);
    //  println("FAILED TO SERIALIZE");
    //}
    exit();
  }


  background(150);
  pushMatrix();
  translate(-xPan, -yPan);
  translate(width/2, height/2);
  scale(scale);
  grid.display();
  popMatrix();
}

void mouseWheel (MouseEvent event) {
  float scaleAmt = 1 + (.1 * event.getCount());

  scale *= scaleAmt;
  xPan *= scaleAmt;
  yPan *= scaleAmt;
}
