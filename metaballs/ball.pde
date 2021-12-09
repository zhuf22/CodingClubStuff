class Ball{
  PVector pos;
  PVector vel;
  float r;
  boolean positive = true;
  
  Ball(float radius){
    this.r = radius;
    pos = new PVector(random(r,width-r), random(r,height-r));
    vel = new PVector(random(-4,4), random(-4,4));
  }
  
  int polarity(){
    return ((positive)?1:(-1));
  }
  
  void update(){
    pos.add(vel);
    
    //bounce off walls
    if(pos.x < r || pos.x > width-r){
      pos.x = max(r, min(pos.x, width-r));
      vel.x *= -1;
    }
    if(pos.y < r || pos.y > height-r){
      pos.y = max(r, min(pos.y, height-r));
      vel.y *= -1;
    }
  }
  
}
