void setup(){
  size(800,800);
}
float initLen = 200;
void draw(){
  background(0);
  stroke(255);
  
  rotAngle = (mouseX - width/2)/100.0;
  scale = (float) mouseY/height;
  
  
  translate(width/2, height);
  branch(initLen, 0);
}

int limit = 10;
float minSize = 30;
float rotAngle = PI/4;
float scale = 0.667;
void branch(float len, int layer){
  if(len < minSize || layer > limit) return;
  line(0, 0, 0, -len);
  translate(0, -len);
  
  push();
  rotate(rotAngle);
  branch(len * scale, layer+1);
  pop();
  
  push();
  rotate(-rotAngle*.2);
  branch(len * scale, layer+1);
  pop();
}
