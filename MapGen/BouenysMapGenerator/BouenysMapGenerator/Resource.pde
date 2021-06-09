class Resource {
  String name;
  color hue;
  float minMoisture;
  float maxMoisture;
  float minElevation;
  float maxElevation;
  float minTemperature;
  float maxTemperature;
  float resourceAbundance;
  float blobSize;
  float propogationDist;
  float resourceDecay;
  int minResourceSpread;
  int maxResourceSpread;
  int propogationMag;
  boolean waterResource;
  boolean landResource;
  Resource() {
    name = "None";
    waterResource = false;
    landResource = false;
  }
  Resource(String n, float nM, float xM, float nE, float xE, float nT, float xT, float bS, float pD, float rA, int nRS, int mRS, int pM, float rD, boolean w, boolean l, color c) {
    name = n;
    minMoisture = nM;
    maxMoisture = xM;
    minElevation = nE;
    maxElevation = xE;
    minTemperature = nT;
    maxTemperature = xT;
    blobSize = bS;
    propogationDist = pD;
    resourceAbundance = rA;
    minResourceSpread = nRS;
    maxResourceSpread = mRS;
    propogationMag = pM;
    resourceDecay = rD;
    waterResource = w;
    landResource = l;
    hue = c;
  }
}
