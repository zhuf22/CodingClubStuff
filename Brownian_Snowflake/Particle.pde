class Particle{
  PVector pos;
  float radius;
  
  Particle(float x, float y, float r){
    pos = new PVector(x, y);
    radius = r;
  }
  
  void walk(){
    pos.x -= 1;
    //pos.y += noise(frameCount) * (random(1)>0.5?-1:1);
    pos.y += random(-1,1);
    //pos.y += (random(1) > 0.5?-1:1);
    
    //constrain the position to between slice
    pos.y = constrain(pos.y, 0, pos.x*tan(PI/6));
    
    
  }
  
  boolean Intersects(){
    if(pos.x < 1) return true;
    float dist = 0;
    for(Particle p : particles){
      if(this.equals(p)) continue;
      dist = dist(p.pos.x, p.pos.y, pos.x, pos.y);
      if(dist < p.radius + radius) return true;
    }
    
    return false;
  }
  
  void draw(){
    push();
    circle(pos.x, pos.y, radius);
    pop();
  }
  
}
