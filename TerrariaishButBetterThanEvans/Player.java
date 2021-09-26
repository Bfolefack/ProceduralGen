class Player {
  float gravity;
  float jumpStrength;
  float floor;
  boolean onFloor;
  boolean prevOnFloor;
  char prevKeyPressed;
  PVector pos;
  PVector vel;
  PVector acc;
  Player() {
    floor = 200;
    gravity = 1.3;
    pos = new PVector(width/2, 50);
    acc = new PVector(0, 0);
    vel = new PVector(0, 0);
  }

  public void display() {
    rect(width/2, height/2 - 30, 10, 30);
  }
  public void update() {
    floor = pos.x/(;
    if (pos.y < floor) {
      acc.y = gravity;
      vel.mult(0.99);
      vel.x *= 0.8;
    } else {
      pos.y = floor;
      if (vel.y > 0) {
        vel.y = 0;
      }
      if (keys.contains('w') || keys.contains(' ')) {
          vel.y += -15;
          key = '0';
      }
      vel.x *= 0.8;
    }
    if (keyPressed) {
      if (keys.contains('a')) {
        acc.x += -2;
      }
      if (keys.contains('d')) {
        acc.x +=  2;
      }
    }
    prevKeyPressed = key;
    

    vel.add(acc);
    pos.add(vel);
    acc.set(0, 0);
  }
}
