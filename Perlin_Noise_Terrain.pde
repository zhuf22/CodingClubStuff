int gridScale = 20; //size of each grid square

//grid of points - each point has a height - looks like its moving but in reality we just change height
int rows = 50;
int cols = 50;

float[][] heights; //store the heights of each gridspace
float heightScale = 250; //increases size of noise for each grid space

float noiseScale = 0.1; //smoothign noise

float yOffset = 0;
float xOffset = 0;

float theta = 0;




void setup() {
  size(600, 600, P3D);//P3D = rendering in 3D

  heights = new float[cols][rows]; //need a function now to give it values - perlin
}

void draw() {
  background(0);
  noFill();
  stroke(255);

  //put it within the screen
  translate(width/2, height/2); //puts top left square at width/2
  //rotate the terrain
  rotateX(PI/3);

  //theta += 0.01;
  //yOffset = sin(theta);
  //xOffset = cos(theta);
  
  yOffset -= 0.01;
  
  
  perlin();
  drawMesh();
}


void perlin() {
  
  //iterate through and add heights to each location
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      heights[x][y] = noise(x * noiseScale + xOffset, y * noiseScale + yOffset) * heightScale; //gives you a number between 0 and 1
      heights[x][y] -= heightScale/2; //gives you negatives - bounds (heightScale/2, -heightScale/2)
      
    }
  }

  
}


void drawMesh() {
  push(); //only translates within the push
    
                                                   //moves grid at the speed of offset
  translate(-cols * gridScale / 2 + gridScale/2 /* + (xOffset/noiseScale * gridScale) */, -rows * gridScale/2 + gridScale/2  /* + (yOffset/noiseScale * gridScale) */); //center it


  //iterate through and draw the triangles
  for (int y = 0; y < rows - 1; y++) {
    
    stroke(255, ((float) y)/rows * 255); //change transparency
    fill(10, 20, 50, ((float) y)/rows * 255); //fades out as row index is smaller - some number between 0 and 1
    
    //dumb syntax stuff for drawing traingles
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) { //c is x, r is y
      vertex(x * gridScale, y * gridScale, heights[x][y]); //draw a vertex at every point (gridScale being the width of one space
      vertex(x * gridScale, (y+1) * gridScale, heights[x][y+1]); //x, y, z
    }
    endShape(); //close it
  }

  pop();
}
