import java.io.*;
class World implements Serializable {
  Chunk[][] chunks;
  Set<Chunk> modifiedChunks;
  int chunkX;
  int chunkY;
  Player player;
  World() {
    chunks = new Chunk[width/64 + 1][height/64 + 1];
    Chunk temp = new Chunk(64);
    modifiedChunks = new TreeSet<Chunk>();
  }


  private void writeObject(java.io.ObjectOutputStream out) throws IOException {
    println("1");
    out.defaultWriteObject();
    println("2");
    out.writeObject(modifiedChunks);
    println("3");
    out.writeObject(player);
  }
  private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
    in.defaultReadObject();
    modifiedChunks = (Set) in.readObject();
    player = (Player) in.readObject();
  }
}
