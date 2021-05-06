class Word {
  String characters;
  double fitness = 0;
  float truFitness = 0;
  float  score;

  Word(String s_) {
    characters = s_;
  }

  void calcFitness() {
    fitness = pronounce(characters);
    fitness *= fitness;
  }
  
  void calcFitness(String _o) {
    fitness = pronounce(characters);
    fitness *= fitness;
  }
  
  //******************************************************************************************************************

  double pronounce(String word) {

    String[] vowels =
      {
      "a", 
      "e", 
      "i", 
      "o", 
      "u", 
      "y"
    };

    String[] composites =
      {
      "mm", 
      "ll", 
      "th", 
      "ss", 
      "ee", 
      "tt", 
      "ff", 
      "oo", 
      "ing", 
      "cc", 
      "er", 
      "ck", 
      "ch", 
      "sk", 
      "le", 
      "ph", 
      "fr",
      "ia",
      "sh"
    };

    word = simplify(word);
    // Special case
    if (word.equals("a")) return 1;
    if (word.equals("i")) return 1;

    int len = word.length();

    // Let"s not parse an empty string
    if (len == 0) return 0;

    float score = 0;
    int pos = 0;

  outer: 
    while (pos < len) {

      // Check if is allowed composites
      for (String comp : composites) {
        int complen = comp.length();

        if ((pos + complen) <= len) {
          String check = word.substring(pos, pos + complen);
          if (check.equals(comp)) {
            score += complen;
            pos += complen;
            continue outer;
          }
        }
      }
      // Is it a ? If so, check if previous wasn't a vowel too.
      if (contains(vowels, Character.toString(word.charAt(pos)))) {
        if ((pos - 1) >= 0) {
          if (!contains(vowels, Character.toString(word.charAt(pos - 1)))) {
            score += 1;
            pos += 1;
            continue outer;
          }
        } else {
          score += 1;
          pos += 1;
          continue outer;
        }
      } else { // Not a vowel, check if next one is, or if is end of word
        if ((pos + 1) < len && word.charAt(pos + 1) != ' ') {
          if (contains(vowels, Character.toString(word.charAt(pos + 1)))) {
            score += 2;
            pos += 2;
            continue outer;
          }
        } else if (pos + 1 == len || word.charAt(pos + 1) == ' ') {
          score += 1;
          break outer;
        }
      }

      pos += 1;
    }

    return score / len;
  }

//******************************************************************************************************************


  String simplify(String word) {
    String alphabet = "abcdefghijklmnopqrstuvwxyz";
    word = word.toLowerCase();
    // Remove non letters and put in lowercase
    for (int i = word.length() - 1; i >= 0; i--) {
      if (alphabet.indexOf(word.charAt(i)) < 0) {
        word = word.substring(0, i) + word.substring(i + 1, word.length());
      }
    }
    return word;
  }

//******************************************************************************************************************

  boolean contains(String[] s, String t) {
    for (int i = 0; i < s.length; i++) {
      if (t.equals(s[i])) {
        return true;
      }
    }
    return false;
  }
  
  
}                                                    
