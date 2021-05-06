class Generator {
  int monstTypeNum, elementNum, aspectNum, attackNum;
  boolean sizeTrue;
  
  Generator(int eN_, int asN_, int atN_, boolean s_){
    elementNum = eN_;
    aspectNum = asN_;
    attackNum = atN_;
    sizeTrue = s_;
  }
  
  String generateMonsterType(){
    int monstType = int(random(0, MonsterTypes.length));
    if (monstType == MonsterTypes.length - 1){
      return (MonsterTypes[MonsterTypes.length - 1] + "-" + MonsterTypes[int(random(0, MonsterTypes.length - 1))]);
    } else {
      return (MonsterTypes[monstType]);
    }
  }
  
  String generateElement(){
    int element = int(random(0, Elements.length));
    if (element == Elements.length - 1){
      return (Elements[int(random(0, 14))] + "-" + Elements[int(random(0, 14))]);
    } else {
      return (Elements[element]);
    }
  }
  
  String generateAspect(){
    int aspect = int(random(0, RandomAspects.length));
      return (RandomAspects[aspect]);
  }
  
  String generateAttack(){
    int attack = int(random(0, Attacks.length));
      return (Attacks[attack]);
  }
  
  String generateSize(){
    int size = int(random(0, Sizes.length));
      return (Sizes[size]);
  }
  
  void generateMonster(){
    println("Monster Type:");
    if (sizeTrue){
      println("    " + generateSize() + " " + generateMonsterType());
    } else {
      println("    " + generateMonsterType());
    }
    println();
    println("Elements:");
    for(int i = 0; i < elementNum; i++){
      println("    " + generateElement());
    }
    println();
    println("Aspects:");
    for(int i = 0; i < aspectNum; i++){
      println("    " + generateAspect());
    }
    println();
    println("Attacks:");
    for(int i = 0; i < attackNum; i++){
      println("    " + generateAttack());
    }
    println();
    println();
    println();
    println();
  }
}
