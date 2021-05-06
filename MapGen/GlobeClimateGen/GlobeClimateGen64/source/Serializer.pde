import java.io.*;
static class Serializer {
  public static void serialization(String file, Object object) throws IOException {
    FileOutputStream fileOutputStream = new FileOutputStream(file);
    BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(fileOutputStream);
    ObjectOutputStream objectOutputStream = new ObjectOutputStream(bufferedOutputStream);
    objectOutputStream.writeObject(object);
    objectOutputStream.close();
  }

  public static Object deSerialization(String file) throws IOException, ClassNotFoundException {
    FileInputStream fileInputStream = new FileInputStream(file);
    BufferedInputStream bufferedInputStream = new BufferedInputStream(fileInputStream);
    ObjectInputStream objectInputStream = new ObjectInputStream(bufferedInputStream);
    Object object = objectInputStream.readObject();
    objectInputStream.close();
    return object;
  }
}
