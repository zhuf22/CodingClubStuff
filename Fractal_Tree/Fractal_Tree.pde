void setup(){
  size(800,800);
}
float initLen = 200;
void draw(){
  background(150);
  stroke(255);
  
  rotAngle = (mouseX - width/2)/100.0;
  scale = (float) mouseY/height;
  
  
  translate(width/2, height);
  branch(initLen);
}

float minSize = 30;
float rotAngle = PI/4;
float scale = 0.667;
void branch(float len){
  if(len < minSize) return;
  line(0, 0, 0, -len);
  translate(0, -len);
  
  push();
  rotate(rotAngle);
  branch(len * scale);
  pop();
  
  push();
  rotate(-rotAngle);
  branch(len * scale);
  pop();
}