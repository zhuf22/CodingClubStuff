class Protagonist extends Agent{
  
  public void flock(ArrayList<Agent> agents){
    PVector avoid = super.separation(agents);
    //println(avoid.mag());
    
    avoid.mult(1);
    
    applyForce(avoid);
  }
  
  void draw(){
    push();
    translate(pos.x, pos.y);
    rotate(vel.heading() + PI/2);
    stroke(0,100,100);
    fill(0,100,100);
    beginShape(TRIANGLES);
    vertex(0, -radius*2);
    vertex(-radius, radius*2);
    vertex(radius, radius*2);
    endShape();
    noFill();
    stroke(0,255,0);
    circle(0,0,localFlockDist*2);
    stroke(255,0,0);
    circle(0,0,avoidDist*2);
    pop();
  }
}
