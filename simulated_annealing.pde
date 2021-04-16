import java.util.*;
import java.io.*;

ArrayList<Float> path = new ArrayList<Float>();
float INITIAL_SYSTEM_TEMPERATURE = 1000;
float BOLTZMANN = .003;
float EPS = .1;
int ANIMATION_PTR = 0;

//for a simple example, we will consider optimizing some non convex function
//but we can optimize literally anything we want (doesn't even have to be a function, can even be Sudoku or TSP or any optimization problem)

float optimizing_function(float f){
  return ((sin(f) + cos(2*f) + sin(0.5*f) + cos(6*f)));
}
ArrayList<Float> generate_candidate_TSP(ArrayList<Float> current){
  int r1 = (int)(random(0,current.size()));
  int r2 = (int)(random(0,current.size()));
  ArrayList<Float> ret = new ArrayList<Float>(current);
  float cur = current.get(r2);
  current.set(r2,current.get(r1));
  current.set(r1,cur);
  return current;
}
void draw_function(){
  fill(0,0,0);
  for(float f = -50; f <= 50; f += 0.025){
    ellipse(f*20, (optimizing_function(f)*20) + 420, 5, 5);
  }
}


float generate_candidate_solution(float cur_x, float WINDOW_SIZE){
   ArrayList<Float> neighbor_heuristic = new ArrayList<Float>();
   for(float j = 0; j <= 1000; j+= 2){
     neighbor_heuristic.add(j);
   }
   for(float j = 1; j <= 999; j+= 2){
     neighbor_heuristic.add(j);
   }
   int rand = (int)(random(1,3));
   if(rand==1 || cur_x == 1001){
     return neighbor_heuristic.get( max(0,(int)(cur_x)-1) );
   } else {
     return neighbor_heuristic.get( min(1000,(int)(cur_x)+1) );
   }
}

ArrayList< ArrayList<Float> > simulated_annealing_TSP(){
    
  return new ArrayList< ArrayList<Float> >();
}


boolean energy_function(float energy_one, float energy_two){
  float r = random(0,1);
   if(INITIAL_SYSTEM_TEMPERATURE < 0.4){
        if(r > 0.2){
            return false;
        }
        return true;
   } else{
        if(r > 0.4){
            return false;
        }
        return true;
   }

}




//we will return an arraylist of movements that our annealing process makes so we can animate it later.
//this will MINIMIZE some given cost function.

ArrayList<Float> simulated_annealing(){
  float WINDOW_SIZE = 2000;
  ArrayList<Float> sol = new ArrayList<Float>();
  float init_solution = random(200,500);
  int numIter = 1;
  while(INITIAL_SYSTEM_TEMPERATURE > EPS){
    for(int i = 0; i < numIter; i++){
      float prev = optimizing_function(init_solution);
      float next_solution = generate_candidate_solution(init_solution, WINDOW_SIZE);
      println(prev + " " + optimizing_function(next_solution));
      if(optimizing_function(next_solution) < prev){
        init_solution = next_solution;
        sol.add(next_solution);
      } else {
        
        float diff = (optimizing_function(init_solution)-optimizing_function(next_solution));
        /*
        float power = (float)(diff)/(float)(INITIAL_SYSTEM_TEMPERATURE);
        float probability = exp( power );
        println("PROBABILITY: " + probability);
        */
        float aft = optimizing_function(next_solution);
        if(diff > 0 || energy_function(prev,aft)){
          init_solution = next_solution;
          sol.add(next_solution);
        } else {
          sol.add(init_solution);
        }
     }
    }
    INITIAL_SYSTEM_TEMPERATURE = INITIAL_SYSTEM_TEMPERATURE * (1-BOLTZMANN);
    //WINDOW_SIZE = WINDOW_SIZE * (float)(BOLTZMANN_CONSTANT + .0001);
  }
  return sol;
}

public void settings(){
   size(1000,1000);
}

void setup(){
  background(255);
  path = simulated_annealing();
  for(Float f : path){System.out.print(f + " " );}System.out.println();
}


void draw(){
  background(255);
  stroke(0,0,0);
  draw_function();
  stroke(0,255,255);
  line(path.get(path.size()-1),0,path.get(path.size()-1),1000);
  stroke(0,0,0);
  line(path.get(ANIMATION_PTR), 0, path.get(ANIMATION_PTR), 1000);
  println("POINTER : " + ANIMATION_PTR + " SIZE: " + path.size() );
  if(ANIMATION_PTR < path.size()-1){
    ANIMATION_PTR++;
  }

}
