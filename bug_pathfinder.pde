
//bug pathfinding algorithm presentation:
//https://spacecraft.ssl.umd.edu/academics/788XF14/788XF14L14/788XF14L14.pathbugsmapsx.pdf

class BezierProfile{
  float init_x, init_y;
  float ref1_x, ref1_y;
  float ref2_x, ref2_y;
  float final_x, final_y;
  public BezierProfile(float init_x, float init_y, float ref1_x,float ref1_y, float ref2_x, float ref2_y, float final_x, float final_y){
    this.init_x = init_x;
    this.init_y = init_y;
    this.ref1_x = ref1_x;
    this.ref1_y = ref1_y;
    this.ref2_x = ref2_x;
    this.ref2_y = ref2_y;
    this.final_x = final_x;
    this.final_y = final_y;
  }
  
  //takes some input [0,1]
  float return_x(float x){
  double v = (init_x * Math.pow( (1-x), 3)) +(3*x * (1-x) * (1-x) * ref1_x) + (3*x*x * (1-x) * ref2_x)+ (Math.pow(x,3) * final_x);
  return (float)(v);
}
float return_y(float x){
   double v = (init_y * Math.pow( (1-x), 3)) +(3*x * (1-x)*(1-x) * ref1_y) + (3*x*x * (1-x) * ref2_y)+ (Math.pow(x,3) * final_y);
  return (float)(v);
}
}



class Bug{
  float sensing_radius;
  ArrayList<Location> past_places = new ArrayList<Location>();
  Location current_loc;
  Location goal_loc;
  public Bug(float sensing_radius, ArrayList<Location> past_places, Location current_loc, Location goal_loc){
    this.sensing_radius = sensing_radius;
    this.past_places = past_places;
    this.current_loc = current_loc;
    this.goal_loc = goal_loc;
  }
}

class Location{
  public float x;
  public float y;
  Location(float x, float y){
    this.x=x;
    this.y=y;
  }
}

//we will simply draw shapes into the map to give us the obstacles in the space.
Bug bg;
ArrayList<Location> bad_places = new ArrayList<Location>();
boolean draw_obstacle = true;
public void setup(){
  size(1400,1400);
  frameRate(20);
  Location current_loc = new Location(200,300);
  Location goal_loc = new Location(800,400);
  bg = new Bug(5, new ArrayList<Location>(), current_loc, goal_loc);
}



public float[] change_x = {1.5,0,-1.5,0};
public float[] change_y = {0,-1.5,0,1.5};

public float intersect_circles(Location one, Location two){
  return dist(one.x,one.y,two.x,two.y);
}

public boolean intersect_obstacle(){
  for(Location l : bad_places){
    if(intersect_circles(l,bg.current_loc) < 22){
      return true;
    }
  }
  return false;
}

// the first bug algorithm we have is based on the following idea:

//1. we want to take the motion which will let us get close to our goal
//2. if we find an obstacle, we want to navigate around the obstacle while we still get close to the goal
//3. straight line paths are always faster than curved paths




void path_planning_one(){
}

void path_planning_two(){
  
}

boolean is_reversed(float OPT_X, float OPT_Y, float PREV_OPT_X, float PREV_OPT_Y){
  if(OPT_X != 0){
    if(OPT_X==PREV_OPT_X*-1){
      return true;
    }
  }
  if(OPT_Y != 0){
    if(OPT_Y==PREV_OPT_Y*-1){
      return true;
    }
  }
  return false;
}

public void draw(){
  background(0);
  for(Location l : bad_places){
    ellipse(l.x,l.y,2,2);
  }
  fill(255,0,0);
  noStroke();
  ellipse(bg.current_loc.x, bg.current_loc.y, 8, 8);
  fill(0,255,0);
  ellipse(bg.goal_loc.x,bg.goal_loc.y,8,8);
  fill(255);
  boolean condition=bg.current_loc.x == bg.goal_loc.x && bg.current_loc.y == bg.goal_loc.y;
  if(!condition && !draw_obstacle){
    println(bg.current_loc.x + " " + bg.current_loc.y);
    float glob_min = 1000000000;
    float OPT_X=-1,OPT_Y=-1;
    float PREV_OPT_X=-1,PREV_OPT_Y=-1;
    for(int i = 0; i < 4; i++){
      float tot_dist = dist(bg.current_loc.x+change_x[i], bg.current_loc.y+change_y[i], bg.goal_loc.x, bg.goal_loc.y);
      if(!intersect_obstacle()){
          glob_min=min(glob_min,tot_dist);
          if(glob_min==tot_dist){

            OPT_X=change_x[i];
            OPT_Y=change_y[i];
          }
      }
    }
    
    
    if(OPT_X==-1 && OPT_Y==-1){
      float dist_max = 0;
      for(Location l : bad_places){
        for(int i = 0; i < 4; i++){
          Location loc = new Location(bg.current_loc.x+change_x[i],bg.current_loc.y+change_y[i]);
          float sav = intersect_circles(l,loc);
          if(sav <= bg.sensing_radius){
            dist_max= max(dist_max,sav);
            float goal_dist = dist(bg.current_loc.x+change_x[i],bg.current_loc.y+change_y[i],bg.goal_loc.x,bg.goal_loc.y);
            glob_min = min(glob_min, goal_dist);
            if(dist_max==sav && glob_min==goal_dist){
              if(bg.past_places.contains(new Location(bg.current_loc.x+change_x[i],bg.current_loc.y+change_y[i]))){
                continue;
              }
              if(is_reversed(OPT_X,OPT_Y,PREV_OPT_X,PREV_OPT_Y)){
                continue;
              }
              OPT_X = change_x[i];
              OPT_Y = change_y[i];
           }
         }
        }
      }
    }
    if(OPT_X == -1 && OPT_Y == -1){
      OPT_X=PREV_OPT_X;
      OPT_Y=PREV_OPT_Y;
    }
    bg.current_loc.x += OPT_X;
    bg.current_loc.y += OPT_Y;
    bg.past_places.add(bg.current_loc);
    PREV_OPT_X = OPT_X;
    PREV_OPT_Y = OPT_Y;
  }
}

public void mouseDragged(){
  if(draw_obstacle){
    println(mouseX + " " + mouseY);
    bad_places.add(new Location( (int)(mouseX), (int)(mouseY)));
    
  }
}

public void keyPressed(){
  if(key==BACKSPACE){
    println("Pressed!");
    draw_obstacle=false;
    //path_planning_one();
  }
}
