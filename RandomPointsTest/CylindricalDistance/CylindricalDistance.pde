PVector[] p;


void setup(){
  size(1000, 500);
  p = new PVector[10000];
  for(int i = 0; i < p.length; i++){
    p[i] = new PVector(random(width), random(height));
  }
}

void draw(){
  noStroke();
  for(int i = 0; i < p.length; i++){
    float distance1 = sqrt(sq(p[i].x - mouseX) + sq(p[i].y - mouseY));
    float distance2 = sqrt(sq(width - abs(p[i].x - mouseX)) + sq(p[i].y - mouseY));
    fill(0);
    if(distance1 >= distance2){
      fill(255, 0, 0);
    }
    circle(p[i].x, p[i].y, 5);
  }
}
