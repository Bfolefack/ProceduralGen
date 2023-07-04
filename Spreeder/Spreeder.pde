int count;
int letterCountDown = 20;
String[] words;
boolean paused = true;
boolean reversed = false;

void setup(){
  size(1000, 600);
  int wpm = 400;
  String text = "";
  for(String s : loadStrings("ATLWCS.txt")){
    text += s + " ";
  }
  
  words = text.split(" ");
  frameRate(wpm/12.f);

}


void draw(){
  fill(0);
  if(frameCount == 1){
     background(255);
    textAlign(CENTER, CENTER);
    textSize(height/8);
    text(words[count], width/2, height/2);
    textSize(height/32);
    text((count + 1) + "/" + words.length, width/2, height - height/16);
    fill(25, 25, 255);
    rect(0, height - height/32, ((float)count/words.length) * width, height/32); 
  }
  
  if(!paused){
   
    if(letterCountDown == 0){
      count += reversed ? -1 : 1;
      letterCountDown = words[count].length() > 5 ? words[count].length() : 5;
    }
    if(count < 0)
        count = 0;
      if (count >= words.length)
        count = words.length - 1;
    letterCountDown--;
    background(255);
    textAlign(CENTER, CENTER);
    textSize(height/8);
    text(words[count], width/2, height/2);
    textSize(height/32);
    text((count + 1) + "/" + words.length, width/2, height - height/16);
    fill(25, 25, 255);
    rect(0, height - height/32, ((float)count/words.length) * width, height/32);
  }
}

void keyPressed(){
 if(key == 'p'){
   paused = !paused;
 }
 if(key == 'r'){
   reversed = !reversed;
   count += reversed ? -1 : 1;
 }
 
 if(key == 'd'){
   count += 100;
 }
 if(key == 'a'){
   count -= 100;
 }
}
