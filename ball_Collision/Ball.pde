class Ball{
  float m;
  PVector v;
  PVector x;
  float r;
  
  Ball(float r, float m){
    this.r = r;
    this.m = m;
    x = new PVector(random(r, width-r), random(r, height-r));
    v = new PVector(random(-5, 5), random(-5, 5));
  }
  
  void update(){
    x.add(v);
    
    if(x.x < r || x.x > width-r){
      x.x = max(r, min(x.x, width-r));
      v.x *= -1;
    }
    if(x.y < r || x.y > height-r){
      x.y = max(r, min(x.y, height-r));
      v.y *= -1;
    }
  }
  
  boolean IsColliding(Ball o){
    return (PVector.dist(this.x, o.x) < this.r + o.r);
  }
  
  
  
  void draw(){
    push();
    noStroke();
    fill(200,0,0);
    circle(x.x, x.y, r);
    stroke(0);
    strokeWeight(5);
    point(x.x, x.y);
    pop();
  }
}
