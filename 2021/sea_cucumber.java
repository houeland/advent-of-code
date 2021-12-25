import java.io.*;
import java.util.*;

class SeaCucumber {
  char sc[][];
  char nsc[][];
  int width;
  int height;

  public SeaCucumber(ArrayList<String> input_map) {
    width = input_map.get(0).length();
    height = input_map.size();
    sc = new char[height][width];
    nsc = new char[height][width];
    for (int y = 0; y < height; y += 1) {
      for (int x = 0; x < width; x += 1) {
        sc[y][x] = input_map.get(y).charAt(x);
      }
    }
  }

  void print_map() {
    for (int y = 0; y < height; y += 1) {
      System.out.println(String.valueOf(sc[y]));
    }
  }

  void clone_to_nsc() {
    for (int y = 0; y < height; y += 1) {
      for (int x = 0; x < width; x += 1) {
        nsc[y][x] = sc[y][x];
      }
    }
  }

  boolean copy_back_from_nsc() {
    boolean changed = false;
    int count_changed = 0;
    for (int y = 0; y < height; y += 1) {
      for (int x = 0; x < width; x += 1) {
        if (sc[y][x] != nsc[y][x]) {
          changed = true;
          count_changed += 1;
        }
        sc[y][x] = nsc[y][x];
      }
    }
    //System.out.println("num_changes: " + count_changed);
    return changed;
  }

  void move_east() {
    for (int y = 0; y < height; y += 1) {
      for (int x = 0; x < width-1; x += 1) {
        if (sc[y][x] == '>' && sc[y][x+1] == '.') {
          nsc[y][x+1] = '>';
          nsc[y][x] = '.';
        }
      }
      if (sc[y][width-1] == '>' && sc[y][0] == '.') {
        nsc[y][0] = '>';
        nsc[y][width-1] = '.';
      }
    }
  }

  void move_south() {
    for (int x = 0; x < width; x += 1) {
      for (int y = 0; y < height-1; y += 1) {
        if (sc[y][x] == 'v' && sc[y+1][x] == '.') {
          nsc[y+1][x] = 'v';
          nsc[y][x] = '.';
        }
      }
      if (sc[height-1][x] == 'v' && sc[0][x] == '.') {
        nsc[0][x] = 'v';
        nsc[height-1][x] = '.';
      }
    }
  }

  public void solve_part_1() {
    //System.out.println("== before ==");
    //print_map();
    for (int n = 1; n < 1000; n += 1) {
      clone_to_nsc();
      move_east();
      boolean changed_east = copy_back_from_nsc();
      clone_to_nsc();
      move_south();
      boolean changed_south = copy_back_from_nsc();
      boolean changed = changed_east || changed_south;
      //System.out.println("== after == step=" + n + " changed=" + changed);
      //print_map();
      System.out.println("step " + n + ": " + changed);
    }
  }
}

public class Main {
  public static void main(String[] args) throws IOException {
    BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
    ArrayList<String> map = new ArrayList<String>();
    while (true) {
      String s = stdin.readLine();
      if (s == null) break;
      map.add(s);
    }
    new SeaCucumber(map).solve_part_1();
  }
}
