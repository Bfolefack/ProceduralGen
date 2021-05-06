//Created by Boueny Folefack
//Last Updated: 4/5/21

//Whether or not you want to save the map to a file 
//Default: true
final boolean saveToFile = true;
//Dimensions of your grid
//Default: 1000
final int grdWidth = 8000;
//Default: 500
final int grdHeight = 4000;
//Size of the pixels on your grid
//Default: 1
final int gridScale = 1;
//Controls how jagged your coastlines are
//Default: 2
final float noiseDetail = 2.2;
//Controls the size of all structures on your map(this one's a bit wonky)
//Default: -0.5
final float noiseScale = -0.5;
//Controls what power your noise funtion is raised to (How big the oceans are relative to the land)
//Default: 2
final float noisePower = 2;
//The seed of your noise funtion. Set to 0 for a random seed;
int seed = -0;

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

void setup () {
  if(seed == 0){
    seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
  }
  println(seed);
  noise = new OpenSimplexNoise(seed);
  size(1300, 720);
  grid = new Grid(0, 0, grdWidth, grdHeight, 4);
  for (int i = 0; i < 100; i++) {
    seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
    println(seed);
    noise = new OpenSimplexNoise(seed);
    new Grid(0, 0, grdWidth, grdHeight, 4);
  }
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
