import java.util.*;
import java.io.*;


class Pair{
	int x, y;
	public Pair(int x, int y){
		this.x = x;
		this.y = y;
	}
}


public class ChessboardAndQueens{

	public static char[][] inp = new char[8][8];
	public static ArrayList<Pair> OCCUPIED_CELLS = new ArrayList<Pair>();
	static int LIM_ITER_ONE = 20;
	static int CUR_LIM = 0;
	static int GLOBAL_ANSWER = 0;

	
	//this function returns a new arraylist of the cells we can place on.
	public static ArrayList<Pair> new_open_cells(Pair cur_place, ArrayList<Pair> aq){
		ArrayList<Pair> ret = new ArrayList<Pair>();
		for( Pair p : aq){
			if(OCCUPIED_CELLS.contains(p)){
				continue;
			}
			boolean should_we_add = true;
			if(p.x == cur_place.x){
				should_we_add=false;
			}
			if(p.y==cur_place.y){
				should_we_add=false;
			}
			//makes sure we arent dividing by zero
			if(cur_place.x != p.x){
				double slp = (double)(cur_place.y-p.y)/(double)(cur_place.x-p.x);
				if(slp<0){slp *= -1;}
				if(slp == 1.0){
					should_we_add = false;
				}
			}
			if(should_we_add){
				ret.add(p);
			}
		}
		return ret;
	}
	//solve() is returning the number of VALID boards where queens dont hit each other
	public static int solve(int n, ArrayList< Pair> aq){
		//if(CUR_LIM == LIM_ITER_ONE){
		//	return;
		//}
		//System.out.println("ITERATION: " + n);
		//System.out.println("OPEN CELLS: ");
		++CUR_LIM;
		if(n == 8){
			return 1;
		}
		//System.out.println("ITERATION LEVELS: " + n + " NUMBER OF OPEN CELLS: " + aq.size() );
		//for(Pair p : aq){
			//System.out.println(p.x + " " + p.y);
		//}
		int ans = 0;
		for(Pair valid_placing : aq){
			ArrayList<Pair> p = new_open_cells(valid_placing,aq);
			ans += solve(n+1,p);
		}
		return ans;
	}

	public static void main(String[] args) throws IOException{
		BufferedReader r = new BufferedReader( new InputStreamReader(System.in) );
		String t=null; 
		int idx = 0;
		while(idx < 8){
			t = r.readLine();
			inp[idx] = t.toCharArray();
			idx += 1;
		}
		ArrayList<Pair> open_cells = new ArrayList<Pair>();

		for(int i = 0; i < 8; i++){
			for(int j = 0; j < 8; j++){
				//System.out.println("CHAR: " + inp[i][j]);
				if(inp[i][j] == '.'){
					open_cells.add(new Pair(i+1,j+1));
				} else {
					OCCUPIED_CELLS.add(new Pair(i+1,j+1));
				}
			}
		}
		System.out.println("NUMBER OF OCCUPIED CELLS: " + OCCUPIED_CELLS.size());
		
		int ans = (solve(0,open_cells));
		System.out.println(ans/40320);

	}
}
