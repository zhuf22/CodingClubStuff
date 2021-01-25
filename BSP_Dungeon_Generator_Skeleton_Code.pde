import java.util.*;

//RELEVANT LINKS:
//http://www.roguebasin.com/index.php?title=Articles#Combat_2
//https://www.redblobgames.com/

//Implementing a BSP Tree for Map Gen: http://www.roguebasin.com/index.php?title=Basic_BSP_Dungeon_generation

//BSP(or Binary Space Partitioning) Tree, is a structure which allows you to divide regions up and consider them as nodes in a binary tree, 
//where a node is considered to be a child of another node if its space is enclosed within its parent's space. The link above provides a nice summary of it for our purposes.


//the BSP_Node class has 6 fields, (top_x,top_y), which is the top right corner of some rectangle, (bottom_x,bottom_y), which is the bottom left corner of some rectangle,
//and left and right, which act as pointers to other BSP_Node objects for building your BSP tree.

ArrayList<BSP_Node> DUNGEON_CONSTRUCTION_ORDER; //this will store the BSP_Nodes which represent our map
ArrayList<BSP_Pair> MAP_CONNECTIONS; //this will store the pair of BSP_Nodes which indicate a connection between two regions (i.e. some player can move between them)
color[] region_colors; //colors mutually reachable locations with the same color, that can be chosen by the programmer

//BSP_Pair is used for connecting two BSP_Nodes to create sort of like bridges between different regions
class BSP_Pair{
  BSP_Node one;
  BSP_Node two;
  public BSP_Pair(BSP_Node one, BSP_Node two){
    this.one=one;
    this.two=two;
  }
  public BSP_Node getOne(){
    return one;
  }
  public BSP_Node getTwo(){
    return two;
  }
  public void setOne(BSP_Node set){
    one = set;
  }
  public void setTwo(BSP_Node set){
    two = set;
  }
}

class BSP_Node{
  float top_x, bottom_x, top_y, bottom_y;
  BSP_Node left;
  BSP_Node right;
  
  public void setLeftNode(BSP_Node set){
    left = set;
  }
  public void setRightNode(BSP_Node set){
    right = set;
  }
  public BSP_Node getLeftNode(){
    return left;
  }
  public BSP_Node getRightNode(){
    return right;
  }
  //this constructor assumes the left child and right child are null, of course
  public BSP_Node(float bottom_x, float bottom_y, float top_x, float top_y){
   this.top_x=top_x;
   this.top_y=top_y;
   this.bottom_x=bottom_x;
   this.bottom_y=bottom_y;
   this.left=null;
   this.right=null;
  }
  //this function will traverse your BSP tree and return an arraylist of BSP_Node objects which are the leaves of your BSP Tree:
  //the reason why we care for the leaves of the BSP tree is because the spaces that they correspond to are the partitions that we actually care about.
  //requires some knowledge in recursion
  public ArrayList<BSP_Node> traverse(BSP_Node cur){
      //WRITE CODE HERE
      traverse(cur.left);
      traverse(cur.right)
  }
}
//this method is given to you: basically takes in an arraylist of bsp_nodes and a target bsp_node and sees if it exists in it.
public boolean is_in(ArrayList<BSP_Node> vis, BSP_Node target){
  for(BSP_Node b : vis){
    if(b.top_x==target.top_x && b.top_y==target.top_y && b.bottom_x==target.bottom_x && b.bottom_y==target.bottom_y){
      return true;
    }
  }
  return false;
}

//these are the two main methods that you will use to split your space:

//split_space_horizontally() takes the parameters of 5 floats: (top_x,top_y), which corresponds to upper right corner of rectangle, and (bottom_x,bottom_y), which is lower left corner
//and a DIV_Y parameter, which specifies a Y position to divide the space

//split_space_vertically should function similarly, except divides the space vertically given a DIV_X parameter
//these methods should be pretty short, since they are acting as helper methods in other tasks
//you are technically returning an arraylist of length 2, but it could also take a return type of BSP_Pair if you wish (I implemented before BSP_Pair existed, so that is why I used ArrayList)

public ArrayList<BSP_Node> split_space_horizontally(float top_x, float top_y, float bottom_x, float bottom_y, float DIV_Y){
    ArrayList<BSP_Node> ret = new ArrayList<BSP_Node>();
    //write code here
    return ret;
}
public ArrayList<BSP_Node> split_space_vertically(float top_x, float top_y, float bottom_x, float bottom_y, float DIV_X){
    ArrayList<BSP_Node> ret = new ArrayList<BSP_Node>();
    //write code here
    return ret;
}
public void augment_dungeon(float LIMIT_ITERATIONS){
  float CUR_ITERATIONS = 0;
  BSP_Node root = new BSP_Node(10.0, 10.0, 700.0, 700.0);
  Queue<BSP_Node> q = new LinkedList<BSP_Node>();
  q.add(root);
  float EP_X = 5;
  float EP_Y = 5;
  ArrayList<BSP_Node> seen = new ArrayList<BSP_Node>();
  while(!q.isEmpty() && CUR_ITERATIONS < LIMIT_ITERATIONS){
    ++CUR_ITERATIONS;
    BSP_Node root_one = q.poll();
    //write code here
  }
  
  
  DUNGEON_CONSTRUCTION_ORDER = root.traverse(root);
  create_map_connections(root);
}

//this method assumes that your BSP Tree is already built( i.e. augment_dungeon() is functional )
//the goal of this method is to create map connections between two nodes if they are adjacent regions
//tiny hint: two regions are directly adjacent to each other if they both share the same parent in the BSP Tree, this should make implementation a lot easier (only worry about doing this for connecting leaf nodes right now).
//another hint: you will also have to traverse the tree, as you had to do for traverse() (code should be similar overall)
public void create_map_connections(BSP_Node cur){
    //WRITE CODE HERE
    
    //recursive calls to left node and right node provided
    create_map_connections(cur.left);
    create_map_connections(cur.right);
 }
 
 //BOTH SETUP() AND DRAW() will be provided as I have made them, but you can change them as you wish for cooler visualizations and colors
 
 void setup(){
    size(800,800);
    DUNGEON_CONSTRUCTION_ORDER = new ArrayList<BSP_Node>();
    MAP_CONNECTIONS = new ArrayList<BSP_Pair>();
    augment_dungeon(24);
    region_colors = new color[DUNGEON_CONSTRUCTION_ORDER.size()];
    int idx = 0;
    for(BSP_Node b : DUNGEON_CONSTRUCTION_ORDER){
     println("LEAF: " + b.bottom_x + " " + b.bottom_y + " " + b.top_x + " " + b.top_y);
     region_colors[idx++] = color(random(0,255),random(0,255),random(0,255));
   }
}

void draw(){
   background(0);
   int idx = 0;
   stroke(0);
   fill(255);
   for(BSP_Node b : DUNGEON_CONSTRUCTION_ORDER){
     //fill(region_colors[idx++]);
     rect(b.bottom_x,b.bottom_y,b.top_x-b.bottom_x,b.top_y-b.bottom_y);
     //delay(10);
   }
   
   for(BSP_Pair pr : MAP_CONNECTIONS){
     BSP_Node one = pr.getOne();
     BSP_Node two = pr.getTwo();
     float avg_one_x = (one.top_x + one.bottom_x)/2;
     float avg_one_y = (one.top_y + one.bottom_y)/2;
     float avg_two_x = (two.top_x + two.bottom_x)/2;
     float avg_two_y = (two.top_y + two.bottom_y)/2;
     stroke(color(255,125,0));
     line(avg_one_x,avg_one_y,avg_two_x,avg_two_y);
     fill(color(255,0,0));
     ellipse(avg_one_x,avg_one_y,8,8);
     ellipse(avg_two_x,avg_two_y,8,8);
   }
   
   //println("SIZE: " + DUNGEON_CONSTRUCTION_ORDER.size());
   //println("NUMBER OF BRIDGES: " + MAP_CONNECTIONS.size());
   
}

//if you are able to get the BSP Tree functional, think about different improvements that you could apply in order to make it more effective,
//namely: consider implementing it such that you aren't just connecting regions that are leaf nodes, but connecting ANY two nodes in the BSP Tree which share the same parent
//also, consider for augment_dungeon() to do it so that you arent stopping based on number of iterations, but rather by depth in your BSP Tree.

//this is not necessary in order to get a decent map for game dev, but it is good to think about and is a fun implementation




