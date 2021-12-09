Ball b1, b2;
Ball[] balls;

void setup(){
  size(400,400);
  ellipseMode(CENTER);
  ellipseMode(RADIUS);
  
  balls = new Ball[5];
  for(int i = 0; i < balls.length; i++){
    float r = random(10, 40);
    balls[i] = new Ball(r, r/10.0);
  }
}

void draw(){
  
  
  for(Ball b : balls){
    b.update();
  }
  
  background(200);
  
  for(int i = 0; i < balls.length; i++){
    Ball b1 = balls[i];
    for(int j = i+1; j < balls.length; j++){
      Ball b2 = balls[j];
      
      if(b1.IsColliding(b2)){
        //calculate the resulting velocities
        PVector v1new = collide(b1, b2);
        PVector v2new = collide(b2, b1);
        
        b1.v = v1new;
        b2.v = v2new;
        
      }
    }
  }
  
  
  for(Ball b : balls){
    b.draw();
  }
}

PVector collide(Ball b1, Ball b2){
  PVector v1 = b1.v;
  PVector v2 = b2.v;
  PVector x1 = b1.x;
  PVector x2 = b2.x;
  float m1 = b1.m;
  float m2 = b2.m;
  
  PVector out;
  float scalar;
  
  out = PVector.sub(x1, x2);
  
  scalar = PVector.dot(PVector.sub(v1, v2), PVector.sub(x1, x2));
  scalar /= out.magSq();
  
  scalar *= (2*m2)/(m1+m2);
  
  out = PVector.sub(v1, PVector.mult(out, scalar));
  
  return out;
}
