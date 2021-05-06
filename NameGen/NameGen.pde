String alphabet = "abcdefghijklmnopqrstuvwxyz";

void setup() {
  surface.setVisible(false);
  int count = 0;
  //Name n = new Name(100, .01, (int)random(3, 12));
  Name n = new Name(100, .01, "Orbis");
  while(true){
    println("\nGeneration: " + count);
    n.newGeneration();
    if (n.answerFound){
      break;
    }
    count++;
  }
}
