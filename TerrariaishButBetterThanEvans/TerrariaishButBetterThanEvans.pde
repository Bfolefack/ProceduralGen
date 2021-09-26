Player p1 = new Player();
Set<Character> keys;
World w;
import java.util.*;

public void setup(){
  keys = new TreeSet<Character>();
  size(1280, 720);
  w = new World();
  try{
    openSave("temp.tws");
  } catch (Exception e){
    println(e);
    println("ur dum");
  }
}

public void draw(){
  background(125);
  //println(keys);
  p1.display();
  p1.update();
  translate(-p1.pos.x, -p1.pos.y);
  line(0, 0, width, height);
  
}

void keyPressed(){
  keys.add(key);
  if(key == '\\'){
    try{
      createSave(w);
    } catch (Exception e){
      println(e);
      println("ur even more dum");
    }
  }
}

void keyReleased(){
  keys.remove(key);
}

void openSave(String s) throws IOException, ClassNotFoundException{
  File f = new File("data/temp.tws");
  FileInputStream fileInputStream = new FileInputStream(f);
  ObjectInputStream objectInputStream = new ObjectInputStream(fileInputStream);
  w = (World) objectInputStream.readObject();
  objectInputStream.close(); 
}

public void createSave(World world) throws IOException, ClassNotFoundException {
    File f;
    try {
      f = new File("temp.tws");
    } 
    catch (Exception e) {
      createWriter("temp.tws");
      f = new File("temp.tws");
    }

    FileOutputStream fileOutputStream = new FileOutputStream(f);
    ObjectOutputStream objectOutputStream = new ObjectOutputStream(fileOutputStream);
    objectOutputStream.writeObject(world);
    objectOutputStream.flush();
    objectOutputStream.close();
  }
