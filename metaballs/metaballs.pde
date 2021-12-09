Ball[] balls;
void setup(){
  size(600,600);
  ellipseMode(CENTER);
  ellipseMode(RADIUS);
  
  balls = new Ball[3];
  for(int i = 0; i < balls.length; i++){
    balls[i] = new Ball(random(50, 70));
  }
  //balls[0].positive = false;
}

void draw(){
  loadPixels();
  
  for(int x = 0; x < width; x++){
    for(int y = 0; y < height; y++){
      int index = x + y*width;
      
      //calculate color for each pixel
      float sum = 0;
      for(Ball b : balls){
        float d = dist(x, y, b.pos.x, b.pos.y);
        sum += sq(b.r / d) * b.polarity();
      }
      //sum is from 0-1, map to color from 0-255
      //pixels[index] = color(255*sum);
      
      //threshold essentially is "line thickness"
      float threshold = 0.02;
      float col = sq(threshold)/sq(sum-1);
      
      /*
      float falloff = 0.4; //how much "glow" is on the line
      float col = pow(sq(threshold)/sq(sum - 1), falloff);
      */
      pixels[index] = color(255*constrain(col,0,1));
      
    }
  }
  
  updatePixels();
  
  stroke(255,0,0);
  noFill();
  for(Ball b : balls){
    //circle(b.pos.x, b.pos.y, b.r);
    b.update();
  }
}
