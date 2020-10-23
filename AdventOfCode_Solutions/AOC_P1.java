import java.util.*;
import java.io.*;


public class AOC_P1{
	public static void main(String[] args){
		try{
			BufferedReader buf = new BufferedReader(new FileReader("AOC_1.txt"));
			String line;
			long ans = 0;
			while( (line=buf.readLine()) != null){
				int v = Integer.parseInt(line);
				int t_v = 0;
				while(v>0){
					if( (v/3) - 2 < 0){break;}
					t_v += (v/3)-2;
					v = (v/3)-2;
					//System.out.println(v);
				}
				ans += t_v;
			}
			System.out.println(ans);
		} catch(Exception e){
			e.printStackTrace();
		}
	}
}
