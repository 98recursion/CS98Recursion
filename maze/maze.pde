// 2D Array of objects
Cell[][] grid;

int len; //Length of grid

//2D Maze -- MUST BE SQUARE
int[][] maze = {
  {0, 0, 0, 0},
  {0, 1, 0, 1},
  {0, 1, 0, 0},
  {1, 0, 0, 1}  };
  
int[] start;
int[] goal;
  
void setup() {
  
  //Define the start and goal nodes.
  start = new int[2];
  start[0] = 0;
  start[1] = 2;
  goal = new int[2];
  goal[0] = 3;
  goal[1] = 1;
  
  int cellWidth = 50;
  len = maze.length;
  size( cellWidth*len, cellWidth*len);
  grid = new Cell[len][len];
  for( int i = 0; i < len; i++ ){
    for( int j = 0; j < len; j++ ){
      grid[j][i] = new Cell( j, i, j*cellWidth, i*cellWidth, cellWidth, cellWidth, maze[i][j]);
    }
  }
}

void draw() {
  background(0);
  // The counter variables i and j are also the column and row numbers and 
  // are used as arguments to the constructor for each object in the grid.  
  for (int i = 0; i < len; i++) {
    for (int j = 0; j < len; j++) {
      // Display each object
      grid[i][j].display();
    }
  }
}

// A Cell object
class Cell {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  int locX, locY;
  float x,y;   // x,y location
  float w,h;   // width and height
  float angle; // angle for oscillating brightness
  int wall;  // wall or open square


  // Cell Constructor
  Cell(int tlocX, int tlocY, float tempX, float tempY, float tempW, float tempH, int tempWall) {
    locX = tlocX;
    locY = tlocY;
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    wall = tempWall;
  } 
  

  void display() {
    stroke(100);
    //Color appropriately
    //if goal
    if( locX==goal[0] && locY==goal[1] ) {
      fill( 255, 0, 0 );
    } else if ( locX==start[0] && locY==start[1] ) {
      fill( 0, 255, 0 );
    } else if( wall == 1 ) {
      fill( 0 );
    } else {
      fill( 255 );
    }
    rect(x,y,w,h); 
  }
}
