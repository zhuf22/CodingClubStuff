Flock flock;
Protagonist p;
void setup(){
  size(800,600);
  flock = new Flock(50);
  p = new Protagonist();
  flock.agents.add(p);
}

void draw(){
  background(150);
  flock.updateBoids();
  if(mousePressed) p.applyForce(PVector.mult(p.steer(new PVector(mouseX, mouseY)), 2));
  flock.draw();
}


class Flock{
  ArrayList<Agent> agents;
  
  Flock(int n){
    agents = new ArrayList<Agent>(n);
    for(int i = 0; i < n; i++){
      agents.add(new Agent());
    }
  }
  
  public void steer(PVector dest, float strength){
    for(Agent a : agents){
      a.applyForce(a.steer(dest).mult(strength));
    }
  }
  
  public void draw(){
    for(Agent a : agents){
      a.draw();
    }
  }
  
  public void updateBoids(){
    for(Agent a : agents){
      a.flock(agents);
    }
    for(Agent a : agents){
      a.move();
    }
  }
  
}
