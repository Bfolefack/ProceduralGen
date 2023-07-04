ellipseMode(CENTER);
size(600, 600);
fill(0);
noStroke();
for(int i = -5; i < 5; i++){
  for(int j = -5; j < 5; j++){
    ellipse(i * 50 + 300, j * 50 + 300, 5, 5);
  }
}
fill(255, 0, 0);
fill(0);
for(int i = -5; i < 5; i++){
  for(int j = -5; j < 5; j++){
    float q = (2.0/3 * i);
    float r = (-1.0/3 * i + 0.57735026919 * j);
    ellipse(i * 50 + 300, j * 50 + 300, 5, 5);
  }
}
