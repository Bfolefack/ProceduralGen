import java.io.*;
class Chunk implements Serializable{
  int chunkSize;
  Block[][] blocks;
  ArrayList alteredBlocks;
  Chunk(int s){
    chunkSize = s;
    blocks = new Block[chunkSize][chunkSize];
    for(int i = 0; i < chunkSize; i++){
      for(int j = 0; j < chunkSize; j++){
        blocks[i][j] = new Block();
      }
    }
  }
}
