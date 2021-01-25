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

class BSP_Pair{
  BSP_Node one;
  BSP_Node two;
  public BSP_Pair(BSP_Node one, BSP_Node two){
    this.one=one;
    this.two=two;
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
  //requires some knowledge in recursive methods
  ArrayList<BSP_Node> traverse(BSP_Node cur){
    if(cur==null){
      return new ArrayList<BSP_Node>();
    }
    if(cur.left == null && cur.right == null){
      ArrayList<BSP_Node> ret = new ArrayList<BSP_Node>();
      ret.add(cur);
      return ret;
    }
    if(cur.left != null){
      println("LEFT: " + cur.left.bottom_x + " " + cur.left.bottom_y + " " + cur.left.top_x + " " + cur.left.top_y);
    }
    if(cur.right != null){
      println("RIGHT: " + cur.right.bottom_x + " " + cur.right.bottom_y + " " + cur.right.top_x + " " + cur.right.top_y);
    }
    ArrayList<BSP_Node> one = traverse(cur.left);
    ArrayList<BSP_Node> two = traverse(cur.right);
    ArrayList<BSP_Node> net = new ArrayList<BSP_Node>();
    for(BSP_Node b : one){
      net.add(b);
    }
    for(BSP_Node b : two){
      net.add(b);
    }
    return net;
  }
}


//these are the two main methods that you will use to split your space:

//split_space_horizontally() takes the parameters of 5 floats: (top_x,top_y), which corresponds to upper right corner of rectangle, and (bottom_x,bottom_y), which is lower left corner
//and a DIV_Y parameter, which specifies a Y position to divide the space

//split_space_vertically should function similarly, except divides the space vertically given a DIV_X parameter
//these methods should be pretty short, since they are acting as helper methods in other tasks

public ArrayList<BSP_Node> split_space_horizontally(float top_x, float top_y, float bottom_x, float bottom_y, float DIV_Y){
    ArrayList<BSP_Node> ret = new ArrayList<BSP_Node>();
    ret.add(new BSP_Node(bottom_x,bottom_y,top_x,DIV_Y));
    ret.add(new BSP_Node(bottom_x,DIV_Y,top_x,top_y));
    return ret;
}
public ArrayList<BSP_Node> split_space_vertically(float top_x, float top_y, float bottom_x, float bottom_y, float DIV_X){
    ArrayList<BSP_Node> ret = new ArrayList<BSP_Node>();
    ret.add(new BSP_Node(bottom_x,bottom_y,DIV_X,top_y));
    ret.add(new BSP_Node(DIV_X,bottom_y,top_x,top_y));
    return ret;
}
public boolean is_in(ArrayList<BSP_Node> vis, BSP_Node target){
  for(BSP_Node b : vis){
    if(b.top_x==target.top_x && b.top_y==target.top_y && b.bottom_x==target.bottom_x && b.bottom_y==target.bottom_y){
      return true;
    }
  }
  return false;
}


//remember to note that the way of limiting iterations will lead to map designs that are kind of uniform

//augment_dungeon() is objectively the hardest part of this, since it is where you actually build your BSP tree. For the time being, the augment_dungeon() function takes
//the parameter of LIMIT_ITERATIONS, which is just a limit to the number of times your loop should run before it terminates.
//make sure to be able to have a way to be able to randomly select if you want to cut horizontally or vertically in your BSP Tree

//Building the BSP tree requires knowledge of BFS traversal
public BSP_Node augment_dungeon(float LIMIT_ITERATIONS){
  float CUR_ITERATIONS = 0;
  BSP_Node root = new BSP_Node(10.0, 10.0, 600.0, 600.0);
  Queue<BSP_Node> q = new LinkedList<BSP_Node>();
  q.add(root);
  ArrayList<BSP_Node> seen = new ArrayList<BSP_Node>();
  while(!q.isEmpty() && CUR_ITERATIONS < LIMIT_ITERATIONS){
    ++CUR_ITERATIONS;
    BSP_Node root_one = q.poll();
    
    float select = (int)(random(1,3));
    if(is_in(seen,root_one)){
      println("CONTINUE!");
      continue;
    }
    seen.add(root_one);
    //println(select);
    if(select==1){
      float ran_div = (int)(random(2,5));
      float split_point = (root_one.top_y + root_one.bottom_y)/2;
      //println("SPLIT PARAM HORIZ: " + root_one.top_x + " " + root_one.bottom_x);
      ArrayList<BSP_Node> one = split_space_horizontally(root_one.top_x,root_one.top_y,root_one.bottom_x,root_one.bottom_y,split_point);
      println("PARENT: "  + ": "  + root_one.bottom_x + " " + root_one.bottom_y + " " + root_one.top_x + " " + root_one.top_y);
      root_one.left = one.get(0);
      root_one.right = one.get(1);
      println("LEFT: "  + ": "  + root_one.left.bottom_x + " " + root_one.left.bottom_y + " " + root_one.left.top_x + " " + root_one.left.top_y);
      println("RIGHT: "  + ": "  + root_one.right.bottom_x + " " + root_one.right.bottom_y + " " + root_one.right.top_x + " " + root_one.right.top_y);
      if(!is_in(seen,root_one.left)){
        q.add(root_one.left);
      }
      //seen.add(one.get(0));
      if(!is_in(seen,root_one.right)){
        q.add(root_one.right);
      }
      //seen.add(one.get(1));
    } else if(select==2){
      float ran_div = (int)(random(2,5));
      float split_point = (root_one.top_x + root_one.bottom_x)/3;
      //println("SPLIT PARAM VERT: " + root_one.top_y + " " + root_one.bottom_y);
      ArrayList<BSP_Node> two = split_space_vertically(root_one.top_x,root_one.top_y,root_one.bottom_x,root_one.bottom_y,split_point);
       println("PARENT: "  + ": "  + root_one.bottom_x + " " + root_one.bottom_y + " " + root_one.top_x + " " + root_one.top_y);
      root_one.left = two.get(0);
      root_one.right = two.get(1);
      println("LEFT: "  + ": "  + root_one.left.bottom_x + " " + root_one.left.bottom_y + " " + root_one.left.top_x + " " + root_one.left.top_y);
      println("RIGHT: "  + ": "  + root_one.right.bottom_x + " " + root_one.right.bottom_y + " " + root_one.right.top_x + " " + root_one.right.top_y);
      if(!is_in(seen,root_one.left)){
        q.add(root_one.left);
      }
      if(!is_in(seen,root_one.right)){
        q.add(root_one.right);
      }
    }
  }
  DUNGEON_CONSTRUCTION_ORDER = root.traverse(root);
  return root;
}


//this methods assumes that DUNGEON_CONSTRUCTION_ORDER is already initialized and not null.
//the goal of this method is to create map connections between two nodes if they are adjacent regions and if we decide to connect them(use random() to determine if they should be connected)
//tiny hint: two regions are directly adjacent to each other if they both share the same parent in the BSP Tree, this should make implementation a lot easier.

public void create_map_connections(){
}

void setup(){
    size(700,700);
    DUNGEON_CONSTRUCTION_ORDER = new ArrayList<BSP_Node>();
    MAP_CONNECTIONS = new ArrayList<BSP_Pair>();
    BSP_Node ret = augment_dungeon(25);
    region_colors = new color[DUNGEON_CONSTRUCTION_ORDER.size()];
    int idx = 0;
    for(BSP_Node b : DUNGEON_CONSTRUCTION_ORDER){
     println("LEAF: " + b.bottom_x + " " + b.bottom_y + " " + b.top_x + " " + b.top_y);
     region_colors[idx++] = color(random(0,255),random(0,255),random(0,255));
   }
}

void draw(){
   background(255);
   int idx = 0;
   for(BSP_Node b : DUNGEON_CONSTRUCTION_ORDER){
     //fill(region_colors[idx++]);
     rect(b.bottom_x,b.bottom_y,b.top_x-b.bottom_x,b.top_y-b.bottom_y);
     //delay(10);
   }
   println("SIZE: " + DUNGEON_CONSTRUCTION_ORDER.size());
   
}
