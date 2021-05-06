class ChunkHandler {

  ChunkHandler() {
  }

  void display() {
    for (int i = 0; i < (ceil((((float)width) / (chunkScale * gridScale)))/(scale)); i++) {
      for (int j = 0; j < (ceil((((float)height) / (chunkScale * gridScale)))/(scale)); j++) {
        Chunk c = new Chunk(i + (xPan/ (chunkScale * gridScale)), j + (yPan/ (chunkScale * gridScale)));
        c.display();
      }
    }
  }
}
