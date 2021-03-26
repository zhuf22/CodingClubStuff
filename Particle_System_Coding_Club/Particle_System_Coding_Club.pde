ArrayList<Particle> particles;
void setup(){
  size(600,400);
  //initialize the particles arraylist
  particles = new ArrayList<Particle>();
  particles.add(new Particle(300,300));
}

void draw(){
  background(0);
  //add 5 particles each frame
  for(int i = 0; i < 5; i++){
    particles.add(new Particle(300,300));
  }
  
  //update and draw each particle
  for(int i = particles.size()-1; i >= 0; i--){
    Particle p = particles.get(i);
    
    //reset acceleration
    p.accelX = 0; p.accelY = 0;
    
    //check if mouse is pressed
    if(mousePressed){
      //add acceleration away from mouse
      //using exponential so it's stronger force when closer to mouse 
      float dist = dist(p.x, p.y, mouseX, mouseY);
      float xForce = (p.x - mouseX) * pow(2, -dist/5);
      float yForce = (p.y - mouseY) * pow(2, -dist/5);
      p.accelX += xForce;
      p.accelY += yForce;
    }
    
    //update and draw the particles
    p.update();
    p.show();
    
    //remove the particle if it has disappeared
    if(p.transparency <= 0){
      particles.remove(i);
    }
  }
}

//int particleSize = 10;
int disappearingSpeed = 1;
color yellow = color(255, 255, 0);
color red = color(255,0,0);
class Particle{
  float particleSize;
  float x, y;
  float velX, velY;
  float accelX, accelY;
  int transparency;
  Particle(int x, int y){
    //choose a random particle size
    particleSize = random(5, 20);
    transparency = 255;
    this.x = x;
    this.y = y;
    
    //choose a random direction to move
    velX = random(-1,1);
    velY = random(-1, 0);
    
    //start with zero acceleration
    accelX = 0;
    accelY = 0;
  }
  
  void update(){
    
    //decrease the transparency
    transparency -= disappearingSpeed;
    
    //add some upwards buoyant acceleration
    accelY -= 0.05;
    
    //update velocity and position
    velX += accelX;
    velY += accelY;
    x += velX;
    y += velY;
  }
  
  void show(){
    //draw the particles with no outline and a color in between yellow and red
    noStroke();
    fill(lerpColor(yellow, red, ((255-transparency)/255.0)), transparency);
    circle(x, y, particleSize);
  }
  
}
