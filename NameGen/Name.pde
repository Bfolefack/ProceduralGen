class Name {

  int popSize;
  float mutRate;
  boolean answerFound = false;
  int target;
  String orig = "";
  Word[] genePool;

  Name(int p_, float m_, int t_){
    popSize = p_;
    mutRate = m_;
    target = t_;
    mutRate *= 10000;
    System.out.println(mutRate);
    
    genePool = new Word[popSize];
    
    for ( int i = 0; i < popSize; i++){
      genePool[i] = new Word(generateString());
    }
  }
  
  Name(int p_, float m_, String t_){
    popSize = p_;
    mutRate = m_;
    target = t_.length();
    t_ = t_.toLowerCase();
    System.out.println(mutRate);
    
    genePool = new Word[popSize];
    
    for ( int i = 0; i < popSize; i++){
      genePool[i] = new Word(t_);
    }
  }
  
  String generateString(){
    String temp = "";
              
    for(int i = 0; i < target; i++){
      temp += alphabet.charAt((int)random(alphabet.length()));
    }
    return temp;
  }
  
   void calcFitness(){
    for ( int i = 0; i < popSize; i++ ){
      genePool[i].calcFitness();
    }
  }
  
  void newGeneration() {
    calcFitness();
    Word temp = new Word(" ");
    temp.fitness = 0;
    for (int i = 0; i < popSize; i++){
      if(genePool[i].fitness >= temp.fitness){
        temp = genePool[i];
      }
    }
    
    double tempFitness = temp.fitness;
    System.out.println("Max Fitness: " + temp.fitness * 100);
    System.out.println("Best Candidate: " + temp.characters);
    answerFound = temp.fitness * 100 == 100;
    
    for (int i = 0; i < popSize; i++){
      
        map(genePool[i].fitness, 0, tempFitness, 0, 1);
        genePool[i].fitness *= 100;
        genePool[i].fitness++;
      
    }
    
    
    int matingPoolLength = 0;
    for (int i = 0; i < popSize; i++){
        matingPoolLength  += Math.floor(genePool[i].fitness);
    }
    Word[] matingPool = new Word[matingPoolLength];
    int counter = 0;
    for (int i = 0; i < popSize; i++){
      for(int j = 0; j < Math.floor(genePool[i].fitness); j++){
        matingPool[counter] = genePool[i];
        counter++;
      }
    }
    
    
    
    Word[] nextGen = new Word[popSize];
    
    for (int i = 0; i < popSize; i++){
      nextGen[i] = mate(matingPool[(int)random((matingPool.length))], matingPool[(int)random((matingPool.length))]);
    }
    genePool = nextGen;
  }
  
  Word mate(Word a, Word b){
    String child;
    child = "";
    
    for(int i = 0; i < target; i++){
      int coinToss = (int)random(2);
      if(coinToss == 0){    
        child += a.characters.charAt(i);
      } else {
        child += b.characters.charAt(i);
      }
    }
    
    child = mutate(child);
    return new Word(child);
  }
  
  String mutate(String child){
    for(int i = 0; i < child.length(); i++){
      if(random(1) < mutRate){
        char[] childChars = child.toCharArray();
        childChars[i] = alphabet.charAt((int)random(alphabet.length()));
        child = String.valueOf(childChars);
      }
    }
    
    return child;
  }
  
  double map (double s, double a1, double a2, double b1, double b2){
      return b1 + (s-a1)*(b2-b1)/(a2-a1);
  }
}
