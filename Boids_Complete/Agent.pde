class Agent{
  //http://www.kfish.org/boids/pseudocode.html
  //https://processing.org/examples/flocking.html
  static final float maxSpeed = 3;
  static final float maxForce = 0.1;
  PVector vel;
  PVector pos;
  PVector accel;
  float angle;
  float radius = 3;
  float mass = 1;
  
  Agent(){
    pos = new PVector(random(width), random(height));
    angle = random(2*PI);
    vel = new PVector(cos(angle), sin(angle));
    accel = new PVector(0,0);
  }
  
  public void move(){
    vel.add(accel);
    
    pos.add(vel);
    accel.mult(0); //reset accelaration
    
    //looping borders
    if(pos.x < -radius) pos.x = width + radius;
    else if(pos.x > width + radius) pos.x = -radius;
    
    if(pos.y < -radius) pos.y = height + radius;
    else if(pos.y > height + radius) pos.y = -radius;
  }
  
  public void flock(ArrayList<Agent> agents){
    PVector v1 = cohesion(agents);
    PVector v2 = separation(agents);
    PVector v3 = alignment(agents);
    
    v1.mult(1);
    v2.mult(1.5); //arbitrary weight
    v3.mult(1);
    
    applyForce(v1);
    applyForce(v2);
    applyForce(v3);
  }
  
  public void applyForce(PVector force){
    accel.add(force.div(mass));
  }
  
  public PVector steer(PVector dest){
    //try to go towards destination
    PVector dir = PVector.sub(dest, pos);
    dir.setMag(maxSpeed);
    
    PVector steerAccel = PVector.sub(dir, vel);
    steerAccel.limit(maxForce);
    return steerAccel;
  }
  
  float localFlockDist = 25;
  private PVector cohesion(ArrayList<Agent> agents){
    //fly to the center of nearby boids
    PVector centerPos = new PVector(0,0);
    int count = 0;
    //loop through every boid
    for(int i = 0; i < agents.size(); i++){
      Agent curr = agents.get(i);
      
      //don't consider curr if this boid is curr
      if(curr == this)
        continue;
        
      //sum up nearby boids
      float distance = PVector.dist(pos, curr.pos);
      if(distance <= localFlockDist){
        centerPos.add(curr.pos);
        count++;
      }
    }
    
    //if no nearby boids, return a force of 0
    if(count == 0) return new PVector(0,0);
    
    //average the positions to get the center
    centerPos.div(count);
    
    //return a force moving towards the center of nearby boids
    return steer(centerPos);
  }
  
  float avoidDist = 15;
  private PVector separation(ArrayList<Agent> agents){
    //avoid collision with nearby boids
    
    PVector avoidForce = new PVector(0,0);
    int count = 0;
    //loop through every boid
    for(int i = 0; i < agents.size(); i++){
      Agent curr = agents.get(i);
      if(curr == this)
        continue;
      
      
      float distance = PVector.dist(curr.pos, pos);
      //if the boid is within a certain radius of consideration
      if(distance <= avoidDist){
        //get the vector in the direction away from the other boid
        PVector avoidDir = PVector.sub(pos, curr.pos);
        //scale the vector by how close you are (closer = stronger force)
        avoidDir.setMag(1/distance);
        //add to the total force
        avoidForce.add(avoidDir);
        count++;
      }
    }
    
    //make sure there is a force
    if(avoidForce.mag() > 0){
      //scale the force so it's not too strong
      avoidForce.div((float) count);
      
      /* somewhat lengthy explanation of the following code
      avoidForce at this moment is actually a velocity. If you look at the previous calculations,
      you'll see that it's subtracting positions. The difference in positions is velocity. In this
      portion, we are scaling the resultant velocity to the maximum speed, then getting the accelaration
      by subtracting the current velocity from the desired velocity (avoidForce).
      Since force = mass * accelaration, and mass here is 1, we now have the force. We limit the force
      so that we don't end up overshooting.
      */
      avoidForce.setMag(maxSpeed);
      avoidForce.sub(vel);
      avoidForce.limit(maxForce);
    }
    
    //since we calculated a force, we don't need to use steer()
    //steer(PVector p) is used to convert a position into a force towards that position
    return avoidForce;
  }
  private PVector alignment(ArrayList<Agent> agents){
    //try to match velocity of nearby boids
    PVector avgVel = new PVector(0,0);
    int count = 0;
    for(int i = 0; i < agents.size(); i++){
      Agent a = agents.get(i);
      if(a == this) continue;
      if(PVector.dist(this.pos, a.pos) > localFlockDist){
        continue;
      }
      
      avgVel.add(a.vel);
      count++;
    }
    avgVel.div(count);
    
    if(count == 0){
      return new PVector(0,0);
    }
    
    avgVel.setMag(maxSpeed);
    PVector accel = PVector.sub(avgVel, vel);
    PVector force = accel.mult(1);
    
    force.limit(maxForce);
    
    return force;
  }
  
  public void draw(){
    push();
    translate(pos.x, pos.y);
    rotate(vel.heading() + PI/2);
    stroke(255);
    beginShape(TRIANGLES);
    vertex(0, -radius*2);
    vertex(-radius, radius*2);
    vertex(radius, radius*2);
    endShape();
    pop();
  }
}
