ArrayList<Particle> particles;

void setup(){
  ellipseMode(RADIUS);
  size(600, 600);
  particles = new ArrayList<Particle>();
  particles.add(new Particle(width/2, random(0, (width/2)*tan(PI/6)), random(1,5)));
}
int maxSteps = 1000;
int maxParticles = round(random(200,500));
void draw(){
  background(0);
  noStroke();
  fill(255);
  
  if(particles.size() < maxParticles){
    Particle curr = particles.get(particles.size()-1);
    int count = 0;
    while(!curr.Intersects() && count < maxSteps){
      curr.walk();
      count++;
    }
    if(curr.Intersects() && particles.size() + 1 < maxParticles)
      particles.add(new Particle(width/2, random(0, (width/2)*tan(PI/6)), random(1,5)));
  }
  translate(width/2, height/2);
  
  for(int i = 0; i < 6; i++){
    rotate(PI/3);
    //draw particles
    for(Particle p : particles){
      p.draw();
    }
    pushMatrix();
    scale(1, -1);
    for(Particle p : particles){
      p.draw();
    }
    popMatrix();
  }
  
}
