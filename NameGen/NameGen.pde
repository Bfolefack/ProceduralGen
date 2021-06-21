String display;
String[][] consonemes = {
  {"b"}, // B
  {"d", "ed"}, // D
  {"f", "ph", "lf", "gh"}, // F
  {"g", "gh", "gu", "gue"}, // G
  {"h", "wh"}, // H
  {"j", "ge", "g", "dge", "di"}, // J
  {"k", "c", "ck", "ch", "q", "x", "lk"}, // K
  {"l", "ll"}, // L
  {"m", "mn", "lm", "mb"}, // M
  {"n", "kn", "gn", "pn", "mn"}, // N
  {"p"}, // P 
  {"r", "wr", "rh"}, // R
  {"s", "c", "sc", "ce", "se", "ps", "st"}, // S
  {"t", "th"}, //  T
  {"v", "ve", "f", "ph"}, // V
  {"w"}, // W
  {"z", "zw", "s"}, // Z
  {"s", "si", "z"}, // TREASURE, DIVISION, AZURE
  {"ch", "tch"}, // CHIP, WATCH
  {"sh", "ch", "ci", "ti"}, // SH
  {"th"}, // TH
  {"th"}, // TH
  {"ng"}, // RING
  {"y", "i"} // YOU, ONION
};
String[][] vowelnemes = {
  {"a", "ai", "au"}, // SHORT A
  {"a", "ai", "ay", "au", "aigh"}, // LONG A
  {"e", "ea", "ie", "ai", "a", "eo"}, //SHORT E
  {"e", "ee", "y", "ey", "ea"}, // LONG E
  {"i", "y", "e", "o", "u", "ui"}, // SHORT I
  {"i", "y", "igh", "ai", "eigh", "ie"}, 
  {"a", "au", "aw", "ho", "ough"}, //AWW SOUND
  {"o", "oa", "oe", "ow", "ough", "eau", "oo", "ew"}, // SHORT O
  {"o", "oo", "u", "ou"}, // LONG O
  {"u", "o", "oo", "ou"}, // UH SOUND
  {"o", "oo", "ew", "ue", "ou", "oe", "ough", "ui", "oew"}, // EW SOUND
  {"oi", "oy", "uoy"}, // OI SOUND
  {"ow", "ou", "ough"}, // OW SOUND
  {"a", "er", "ar", "our", "ur"}, // UH SOUND
  {"air", "are", "ear", "ere", "eir", "ayer"}, // AIR SOUND
  {"a"}, // HONESTLY IDK
  {"ir", "er", "ur", "ear", "or", "our", "yr"}, // ERR SOUND
  {"aw", "a", "or", "oor", "ore", "oar", "our", "augh", "ar", "ough", "au"}, //SOME SCOTTISH BS
  {"ear", "eer", "ere", "ier"}, //EAR SOUND
  {"ure", "our"}, 
};
void setup() {
  size(800, 500);
  textAlign(CENTER);
  textSize(100);
  fill(0);
  frameRate(120);
  //String[] yee = new String [1000000];
  //for (int i = 0; i < 1000000; i++) {
  //  yee[i] = generateWord((int) random(2, 6));
  //}
  //saveStrings("AMillionLinesOfCompleteNonsense.txt", yee);
  //exit();
  display = generateWord((int)random(2, 4));
}
String generateWord(int len) {
  int offset = (int)random(2);
  String conglomerate = "";
  for (int i = 0; i < len; i++) {
    if ( (i + offset)  % 2 == 0) {
      String[] nemes = vowelnemes[(int)random(20)];
      int count = 0;
      while (true) {
        if (random(1) < 0.5 || count == nemes.length - 1) {
          conglomerate += nemes[count];
          break;
        }
        count++;
      }
    } else {
      String[] nemes = consonemes[(int)random(24)];
      int count = 0;
      while (true) {
        if (random(1) < 0.5 || count == nemes.length - 1) {
          conglomerate += nemes[count];
          break;
        }
        count++;
      }
    }
  }
  return conglomerate;
}

void draw() {
  background(255);
  text(display, width/2, height/2);
}

void mousePressed() { 
  display = generateWord((int)random(2, 6));
}
