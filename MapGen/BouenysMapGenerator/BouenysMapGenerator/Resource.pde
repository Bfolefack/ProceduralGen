class Resource implements Comparable {
  String name;
  color hue;
  float minMoisture;
  float maxMoisture;
  float minElevation;
  float maxElevation;
  float minTemperature;
  float maxTemperature;
  int minResourceAbundance;
  int maxResourceAbundance;
  float blobSize;
  float propogationDist;
  float resourceDecay;
  int minResourceSpread;
  int maxResourceSpread;
  int propogationMag;
  boolean waterResource;
  boolean landResource;
  boolean sourcing;
  Resource() {
    name = "None";
    waterResource = false;
    landResource = false;
  }
  Resource(String n, float nM, float xM, float nE, float xE, float nT, float xT, float bS, float pD, int nRA, int mRA, int nRS, int mRS, int pM, float rD, boolean w, boolean l, boolean s, color c) {
    name = n;
    minMoisture = nM;
    maxMoisture = xM;
    minElevation = nE;
    maxElevation = xE;
    minTemperature = nT;
    maxTemperature = xT;
    blobSize = bS;
    propogationDist = pD;
    minResourceAbundance = nRA;
    maxResourceAbundance = mRA;
    minResourceSpread = nRS;
    maxResourceSpread = mRS;
    propogationMag = pM;
    resourceDecay = rD;
    waterResource = w;
    landResource = l;
    hue = c;
    sourcing = s;
  }
  
  Resource(String n, color c) {
    name = n;
    hue = c;
  }
  
  int compareTo(Object r) {
    Resource re = (Resource) r;
    if (!name.equals(re.name))
      return 1;
    return 0;
  }
  
  String toString(){
    return name;
  }
}
