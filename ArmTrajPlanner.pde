import java.io.*;
import java.util.*;
import java.nio.*;
/*

The basic question of this project is: given some linkage of arms, how can we manipulate it to do what we want? (In this case,
what we want is for it to reach some point in space). The answer is two-fold: Forward Kinematics and Inverse Kinematics.

Forward Kinematics for a 2D kinematic chain can be figured out using some trigonometry stuff although in order to generalise to a 3D space
we can also use the denavit hartenberg matrices in order to solve the FK problem (although this is decidedly harder)

For those more interested in Denavit-Hartenberg matrices, here is a nice source: https://users.cs.duke.edu/~brd/Teaching/Bio/asmb/current/Papers/chap3-forward-kinematics.pdf

Inverse Kinematics in 2D, though, is comparably difficult to in 3D space, and for this we will implement an IK algorithm called cyclic coordinate descent
https://www.ryanjuckett.com/cyclic-coordinate-descent-in-2d/
The idea is that you try to optimize each individual arm of your chain by attempting to move it closer to the target position and iteratively
attempt to move closer and closer to the goal state

If you are familiar with machine learning, the forward and inverse kinematics processes can be thought of similar to the feedforward and backpropagation procedures in a 
neural network, since we can theoretically optimize a chain with any amount of arms in it.

The main issues that are prevalent with CCD is that it tends to make the arm move in unreasonable ways, and in some cases can lead to NaN in some values
due to weird numerical errors (although I think this can be resolved easily).


*/

/*

PROJECT STRUCTURE: 

You'll probably notice that we have two important classes here: ForwardKinematics, InverseKinematics, and ArmSegment

The way that we will do this is that we will have the InverseKinematics class extend the ForwardKinematics class, because we need to use FK
to find out where our end effector is after changing some angle.

ArmSegment is a class for storing the information about each arm in our kinematic chain.

Both classes take the parameters:
   1. ArrayList<ArmSegment> kinematicChain: encodes the structure of the chain for us
   2. PVector seed_position: the position at which the arm is rooted
   3. ArrayList<Float> arm_lengths: this stores the length of each arm for us, but it is technically redundant since none of our arms extend, only rotate
   4. ArrayList<Float> angles: this stores the angle information for the chain for us
   
The only caveat is that since InverseKinematics extends ForwardKinematics, we can all APPLY_FK() from InverseKinematics to find out where our end effector is
and we do this after each call of cyclic_coordinate_descent() as well
*/

InverseKinematics IK; //this will be our main InverseKinematics object to hold info about our kinematic chain.

ArrayList<ArmParameters> armStateMachine = new ArrayList<ArmParameters>();
int IK_PTR = 1;
//these will be the parameters for one 2D kinematic chain (we can add more later and generalise this)
PVector cur = new PVector(350,350);
ArrayList<ArmSegment> robotArm = new ArrayList<ArmSegment>();
ArrayList<Float> arm_lengths = new ArrayList<Float>();
ArrayList<Float> angles = new ArrayList<Float>();
PVector target_point = new PVector(350,400);

//We can make an arraylist of target points we want the arm to hit and iterate on this later
ArrayList<PVector> target_points = new ArrayList<PVector>();


//THIS CLASS IS EXTRA FOR IF YOU FINISH:

//If you wish, it could be cool to make a way to create multiple chains onscreen and have each of them running their own IK procedures
//This ArmParameters class can be used in order to streamline that process.
//Also, you could change the arm generation method and maybe try to find ways to generate "better" chains.

public class ArmParameters{
  PVector cur;
  ArrayList<ArmSegment> robotArm;
  ArrayList<Float> arm_lengths;
  ArrayList<Float> angles;
  PVector target_point;
  public ArmParameters(PVector cur, ArrayList<ArmSegment> robotArm, ArrayList<Float> arm_lengths, ArrayList<Float> angles, PVector target_point){
    this.cur = cur;
    this.robotArm = robotArm;
    this.arm_lengths = arm_lengths;
    this.angles = angles;
    this.target_point = target_point;
  }
}




//TODO: this method should generate an arm with "LENGTH" amount of arms in it, and to make the arms reasonable,
//we will keep each arm length a fixed length (indicated by len), and randomize the angle at which we should turn the arm
//and then move "len" units in that direction. This may be a bit of a confusing description, but I will likely clarify.

public void GENERATE_CUSTOM_ARM(int LENGTH){
    
   PVector init = new PVector(cur.x,cur.y);
   float len = 60;
   for(int i = 0; i < LENGTH; i++){
     //WRITE CODE HERE
    
    }
}

//TODO: This method takes an InverseKinematics object and draws the kinematic chain stored in it.
public void DRAW_ROBOT_ARM(InverseKinematics IK){
     PVector start = new PVector(IK.seed_position.x, IK.seed_position.y);
     for(int i = 0; i < IK.arm_lengths.size(); i++){
       //WRITE CODE HERE
     }
}

//This is a utility class for encoding information about arms in the chain. This class is provided.
class ArmSegment{
  PVector start;
  PVector end;
  public ArmSegment(PVector one, PVector two){
    this.start = one;
    this.end = two;
  }
}

class ForwardKinematics{
  PVector seed_position;
  ArrayList<ArmSegment> kinematic_chain;
  ArrayList<Float> angles, arm_lengths;
  public ForwardKinematics(ArrayList<ArmSegment> kinematic_chain, PVector seed_position, ArrayList<Float> angles, ArrayList<Float> arm_lengths){
    this.kinematic_chain = kinematic_chain;
    this.seed_position = seed_position;
    this.angles = angles;
    this.arm_lengths = arm_lengths;
  }
  //TODO: This method returns a PVector which is the position of the end of our chain. We have to use the angle information as well as the length of each
  //arm to find out where the end of our chain is in space. There is also some prerequisite understanding of trigonometry that is assumed.
  
  //This method is also pretty short, so don't overthink it.
  public PVector APPLY_FK(){
    float angSum = this.angles.get(0);
    PVector ret = new PVector(seed_position.x,seed_position.y);
    for(int i = 0; i < kinematic_chain.size(); i++){
        //WRITE CODE HERE
    }
    return ret;
  }
  //TODO: Given a new ArrayList<Float> of angles for our arm, we need to update the ArrayList<ArmSegment> structure that is actually storing 
  //info about the points in our chain. This method is also pretty short.
  public ArrayList<ArmSegment> UPDATE_KINEMATIC_CHAIN(ArrayList<Float> newAngles){
    PVector start = new PVector(seed_position.x,seed_position.y);
    ArrayList<ArmSegment> updatedArm = new ArrayList<ArmSegment>();
    for(int i = 0; i < newAngles.size(); i++){
      //WRITE CODE HERE
    }
    return updatedArm;
  }
}


//This is where a lot of the hard stuff begins to rear its head, and I'll probably talk on this the most, but the guide for the
//inverse kinematics stuff is really good, and provides some nice visuals. This also assumes some understanding of vectors and basic vector subtraction
//(at least in order to understand some of the mathematics)

class InverseKinematics extends ForwardKinematics{
  
  //these parameters eps_x and eps_y set an error bound for our CCD function (since we don't necessarily want to be right on the point, just close enough)
  public static final float eps_x = 8;
  public static final float eps_y = 8;
  PVector end_effector_position;
  public InverseKinematics(ArrayList<ArmSegment> kinematic_chain, PVector seed_position, ArrayList<Float> angles, ArrayList<Float> arm_lengths){
    super(kinematic_chain,seed_position,angles,arm_lengths);
    this.end_effector_position = this.APPLY_FK();
  }
  
  //TODO: this method will run iteratively in draw(), but we will have the method return TRUE if a solution has been found, and FALSE otherwise.
  //It takes the parameter of some position in 2D space (for the moment, we will assume that the arm will always be able to reach desired_position, so we don't get weird cases)
  public boolean cyclic_coordinate_descent(PVector desired_position){
    println("POSITION: " + end_effector_position.x + " " + end_effector_position.y + " " + desired_position.x + " " + desired_position.y);
    println(abs(end_effector_position.x-desired_position.x));
    println(abs(end_effector_position.y-desired_position.y));
    boolean run =  abs(end_effector_position.x-desired_position.x)>eps_x || abs(end_effector_position.y-desired_position.y) > eps_y;
    if(run){
      for(int i = this.kinematic_chain.size()-1; i >= 0; i--){
        //In terms of the CCD article, efp represents e, dp returns t, and j represents j
        PVector j = new PVector( this.kinematic_chain.get(i).start.x, this.kinematic_chain.get(i).start.y);
        PVector efp = new PVector(end_effector_position.x, end_effector_position.y);
        PVector dp = new PVector(desired_position.x, desired_position.y);
        //WRITE CODE HERE:

      }
      return false;
    }
    return true;
  }
}


void setup(){
  size(1400,900);
  //In order to get a sample of points to try out, we'll just make a circle of points around our arm.
  int RAD = 300;
  for(float f = 0; f <= 2*PI; f+= 0.1){
    target_points.add(new PVector(350 + (RAD*cos(f)),350 + (RAD*sin(f)) ) );
  }
  armStateMachine.add(new ArmParameters(cur,new ArrayList<ArmSegment>(),new ArrayList<Float>(), new ArrayList<Float>(), target_point));
  GENERATE_CUSTOM_ARM(6);//will modify this to generate "better" kinematic chains
  IK = new InverseKinematics(robotArm, cur, angles, arm_lengths);
}

void draw(){
  //Now, we actually run all of the code we have written.
  background(0);
  DRAW_ROBOT_ARM(IK);
  println("KINEMATIC CHAIN ANGLES: ");
  //some debugging information (notice some of the values here, it can be interesting in some cases)
  for(Float f : IK.angles){
    print(f + " ");
  }
  println();
  PVector ret = IK.APPLY_FK();
  noStroke();
  ellipse(ret.x, ret.y, 10, 10);
  fill(0,255,0);
  for(PVector p : target_points){noStroke(); fill(0,255,0); ellipse(p.x, p.y, 8, 8);}
  
  PVector target_point = target_points.get(10);
  IK.cyclic_coordinate_descent(target_point);
}
