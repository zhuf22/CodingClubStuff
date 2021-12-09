void setup(){
  size(800,800);
}
float initLen = 200;
void draw(){
  background(0);
  stroke(255);
  
  rotAngle = (mouseX - width/2)/100.0;
  scale = constrain((float) mouseY/height, 0.01,1);
  
  
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
  rotate(-rotAngle*.2);
  branch(len * scale);
  pop();
}
