void setup(){
  size(600,600);
}

float x1(float t){
  //return 100 + 50*cos(t);
  return 100 + 300*noise(0.25*t);
}

float y1(float t){
  //return 300 + 50*sin(t);
  return 300 + 300*noise(0.25*t);
}

float x2(float t){
  return 500 + 50*cos(t);
  //return 500 + 100*noise(500 + 0.25*t);
}

float y2(float t){
  return 300 + 50*sin(t);
  //return 300 + 100*noise(483 + 0.25*t);
}

float x3(float t){
  return 300 + 100*noise(1385 + 0.25*t);
}
float y3(float t){
  return 100 + 100*noise(5928 + 0.25*t);
}


float t = 0.0;
float num_points = 200;
float delay = 10.0;
void draw(){
  background(0);
  
  t += 0.03;
  strokeWeight(6);
  stroke(255);
  
  point(x1(t), y1(t));
  point(x2(t), y2(t));
  point(x3(t), y3(t));
  
  strokeWeight(2);
  for(int i = 0; i < num_points; i++){
    float lerp_t = i/num_points;
    
    //connection from 1-2
    float x = lerp(x1(t - delay*lerp_t), x2(t - delay*(1-lerp_t)), lerp_t);
    float y = lerp(y1(t - delay*lerp_t), y2(t - delay*(1-lerp_t)), lerp_t);
    point(x,y);
    
    //connection 1-3
    x = lerp(x1(t - delay*lerp_t), x3(t), lerp_t);
    y = lerp(y1(t - delay*lerp_t), y3(t), lerp_t);
    point(x,y);
    
    //connection 2-3
    x = lerp(x2(t- delay*lerp_t), x3(t - delay*(1-lerp_t)), lerp_t);
    y = lerp(y2(t- delay*lerp_t), y3(t - delay*(1-lerp_t)), lerp_t);
    point(x,y);
    
    
  }
}
