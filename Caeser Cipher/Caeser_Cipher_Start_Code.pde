//variables that can be used anywhere (AKA Global Variables)
String word = "";
String ciph = "";
//Change this to change the key of the cipher
int k = 5;
void setup() {
  //this is so we can work with a decent amount of letters and numbers
  size(500, 500);
}

void draw() {
  //you can change the background and text colors to your own desire
  background(0, 0, 0);
  stroke(255, 255, 255);
  text(word, 10, 100);
  text(ciph, 10, 150);
}
//This checks what was pressed and either makes the cipher or adds to word
void keyPressed() {
  if (keyCode == ENTER ) {
    // so ciph can return to word
    if (k < 0) {
      ciph = wordToCipher(word, k);
    }else{
      ciph = wordToCipher(ciph, k);
    }
    k *= -1;
  } else {
    //so it doesn't look weird if you delete or use these keys
    if (key != CODED && key != BACKSPACE && key != TAB && key != ENTER && key != RETURN && key != ESC && key != DELETE) {
      word += key;
    }
  }
}

//changes the text you put down into letters
String wordToCipher(String word, int k) {
  String ret = "";
  char[] wordArr = word.toCharArray();
  for(int i = 0; i < wordArr.length; i++){
    wordArr[i] -= k;
    print(wordArr[i]);
    ret += wordArr[i];
    
  }
  return ret;
 
}
