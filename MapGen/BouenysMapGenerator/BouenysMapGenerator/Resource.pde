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
    sourcing = s;
    hue = c;
  }
  
  Resource(JSONObject jj) {
    name = jj.getString("Name");
    minMoisture = jj.getFloat("MinimumMoisture");
    maxMoisture = jj.getFloat("MaximumMoisture");
    minElevation = jj.getFloat("MinimumElevation");
    maxElevation = jj.getFloat("MaximumElevation");
    minTemperature = jj.getFloat("MinimumTemperature");
    maxTemperature = jj.getFloat("MaximumTemperature");
    blobSize = jj.getFloat("BlobSize");
    propogationDist = jj.getFloat("PropogationDistance");
    minResourceAbundance = jj.getInt("MinimumResourceAbundance");
    maxResourceAbundance = jj.getInt("MaximumResourceAbundance");
    minResourceSpread = jj.getInt("MinimumResourceSpread");
    maxResourceSpread = jj.getInt("MaximumResourceSpread");
    propogationMag = jj.getInt("PropogationMultiplier");
    resourceDecay = jj.getFloat("PropogationSizeDecay");
    waterResource = jj.getBoolean("WaterResource");
    landResource = jj.getBoolean("LandResource");
    sourcing = jj.getBoolean("Blocking");
    hue = jj.getInt("Color");
    blobSize = (blobSize * grdWidth)/750;
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

  String toString() {
    return name;
  }

  void saveJSON() {
    JSONObject resource = new JSONObject();
    resource.setString("Name", name);
    resource.setFloat("MinimumMoisture", minMoisture);
    resource.setFloat("MaximumMoisture", maxMoisture);
    resource.setFloat("MinimumElevation", minElevation);
    resource.setFloat("MaximumElevation", maxElevation);
    resource.setFloat("MinimumTemperature", minTemperature);
    resource.setFloat("MaximumTemperature", maxTemperature);
    resource.setFloat("BlobSize", blobSize);
    resource.setFloat("PropogationDistance", propogationDist);
    resource.setInt("MinimumResourceAbundance", minResourceAbundance);
    resource.setInt("MaximumResourceAbundance", maxResourceAbundance);
    resource.setInt("MinimumResourceSpread", minResourceSpread);
    resource.setInt("MaximumResourceSpread", maxResourceSpread);
    resource.setInt("PropogationMultiplier", propogationMag);
    resource.setFloat("PropogationSizeDecay", resourceDecay);
    resource.setBoolean("WaterResource", waterResource);
    resource.setBoolean("LandResource", landResource);
    resource.setBoolean("Blocking", sourcing);
    resource.setInt("Color", hue);
     saveJSONObject(resource, "Resources/" + name + ".resource");
   }
}
