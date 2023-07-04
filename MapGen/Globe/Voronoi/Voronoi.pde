size(1000, 500);
ellipseMode(CENTER);
float[][]  points = new float[50][6];
fill(0);
for (int i = 0; i < points.length; i++) {
  float x = random(-1, 1);
  float y = random(-1, 1);
  float z = random(-1, 1);
  float stretch = asin(z)/PI * 2;
  float lat = (asin(z) + PI/2)/PI * 500;
  float lon = (atan2(y, x) + PI)/PI * 500;
  points[i] = new float[]{lat, lon, 2/(1-abs(stretch)), random(255), random(255), random(255)};
}

//int count = 0;
//for (int i = 0; i <= height; i+= 25){
//  float z = cos(((i/500.f) * PI) - PI/2);
//  for (int j = 0; j < z * 20; j++){
//    ellipse((j * width)/(int(z * 20) + 1) ,i,2/z, 2);
//    float lat = i;
//    float lon = (j * width)/(int(z * 20) + 1);
//    float stretch = 2/z;
    
//    points[count] = new float[]{lat, lon, stretch, random(255), random(255), random(255)};
//    count++;
//  }
//}
//print(count);

loadPixels();

for (int lon1 = 0; lon1 < width; lon1++) {
  for (int lat1 = 0; lat1 < height; lat1++) {
    float min_dist = 100000000;
    int nearest_point = 0;
    for (int k = 0; k < points.length; k++) {
      float lon2 = points[k][1];
      float lat2 = points[k][0];
      float dist = acos(sin(map(lat1, 500, 0, -PI/2, PI/2)*sin(map(lat2, 500, 0, -PI/2, PI/2))+cos(map(lat1, 500, 0, -PI/2, PI/2))*cos(map(lat2, 500, 0, -PI/2, PI/2))*cos(map(lon2, 0, 1000, -PI, PI)-map(lon1, 0, 1000, -PI, PI))));
      if (dist < min_dist) {
        min_dist = dist;
        nearest_point = k;
      }
    }

    pixels[lat1 * width + lon1] = color(points[nearest_point][3], points[nearest_point][4], points[nearest_point][5]);
  }
}
fill(0);
updatePixels();
for (int i = 0; i < points.length; i++) {
  ellipse(points[i][1], points[i][0], points[i][2], 2);
}


save("image_" +int(random(10000))+ ".png");
