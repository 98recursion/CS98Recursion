// 2D Array of objects
Cell[][] grid;

int len; //Length of grid
int cellWidth;

PFont f; //Font for text strings

//2D Maze -- MUST BE SQUARE
int[][] maze = {
  {
    0, 0, 0, 0
  }
  , 
  {
    0, 1, 0, 1
  }
  , 
  {
    0, 1, 0, 0
  }
  , 
  {
    1, 0, 0, 1
  }
};

//2D distance from goal information.  This is TEMPORARY...
int[][] distance = {
  {
    1, 2, 3, 1
  }
  , 
  {
    0, 5, -1, 6
  }
  , 
  {
    -1, -1, 4, 1
  }
  , 
  {
    0, 2, 1, 5
  }
};

int[] start;
int[] goal;

void setup() {

  f = createFont("Arial", 16, true);


  //Define the start and goal nodes.
  start = new int[2];
  start[0] = 0;
  start[1] = 2;
  goal = new int[2];
  goal[0] = 3;
  goal[1] = 1;
  
  int[][] swap = new int[maze.length][maze.length];
  for( int i=0; i < swap.length; i++){
    for( int j=0; j< swap.length; j++){
      swap[i][j] = distance[j][i];
    }
  }

  distance = lableGraph( maze, start, goal );

  cellWidth = 50;
  len = maze.length;
  size( cellWidth*len, cellWidth*len);
  grid = new Cell[len][len];
  for ( int i = 0; i < len; i++ ) {
    for ( int j = 0; j < len; j++ ) {
      grid[j][i] = new Cell( j, i, j*cellWidth, i*cellWidth, cellWidth, cellWidth, maze[i][j], distance[i][j]);
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

void mouseClicked() {
  //Get cell which is clicked
  int row = mouseX / cellWidth;
  int col = mouseY / cellWidth;
  
  println( "SQUARE CLICKED.... " + row + col );
}





//Create graph of distances from goal
int[][] lableGraph( int[][] m, int[] s, int[] g ) {

  //Initialize graph to hold distances from goal to all -1
  int[][] dist = new int[ maze.length ][ maze.length ];
  for ( int i = 0; i < dist.length; i++ ) {
    for ( int j = 0; j < dist[0].length; j++ ) {
      dist[i][j] = -1;
    }
  }

  //queue to hold squares to search.  Implemented as an ArrayList
  ArrayList<int[]> queue = new ArrayList<int[]>();

  //Set the distance of the goal as zero and add the goal to the queue
  dist[g[0]][g[1]] = 0;
  queue.add( g );

  //Continue searching until the queue is empty or the start has been found.
  while ( ! queue.isEmpty () ) {
        
    //Pop the first element from the queue
    int[] arr = queue.get( 0 );
    queue.remove(0);

    int value = dist[arr[0]][arr[1]] + 1;

    //Check each of the elements next to the current one and add dist and to the queue if it is valid
    //A valid move happens if it is in the maze, not a wall, and not already labled
    //Above
    int[] temp0 = { arr[0] - 1, arr[1]};
    if ( isValidMove( m, dist, temp0[0], temp0[1] ) ){
      dist[temp0[0]][temp0[1]] = value;
      queue.add( temp0 );
      if ( temp0[0] == s[0] && temp0[1] == s[1] ) {
        return dist;
      }
    }
    //Below
    int[] temp1 = { arr[0] + 1, arr[1]};
    if ( isValidMove( m, dist, temp1[0], temp1[1] ) ){
      dist[temp1[0]][temp1[1]] = value;
      queue.add( temp1 );
      if ( temp1[0] == s[0] && temp1[1] == s[1] ) {
        return dist;
      }
    }
    //Right
    int[] temp2 = { arr[0], arr[1] - 1};
    if ( isValidMove( m, dist, temp2[0], temp2[1] ) ){
      dist[temp2[0]][temp2[1]] = value;
      queue.add( temp2 );
      if ( temp2[0] == s[0] && temp2[1] == s[1] ) {
        return dist;
      }
    }
    //Left
    int[] temp3 = { arr[0], arr[1] + 1};
    if ( isValidMove( m, dist, temp3[0], temp3[1] ) ){
      dist[temp3[0]][temp3[1]] = value;
      queue.add( temp3 );
      if ( temp3[0] == s[0] && temp3[1] == s[1] ) {
        return dist;
      }
    }
  }
  return dist;
}


boolean isValidMove( int[][] m, int[][] d, int x, int y ) {
  //See if in bounds
  if ( x < 0 || y < 0 || x >= m.length || y >= m[0].length ) {
    return false;
  }
  //See if valid location
  if ( m[x][y] == 1 ) {
    return false;
  }
  //See if already assigned
  if ( d[x][y] != -1 ) {
    return false;
  }
  //If none of those checks failed valid location
  return true;
}







// A Cell object
class Cell {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  int locX, locY;
  float x, y;   // x,y location
  float w, h;   // width and height
  float angle; // angle for oscillating brightness
  int wall;    // wall or open square
  int dist;    //distance from the goal


  // Cell Constructor
  Cell(int tlocX, int tlocY, float tempX, float tempY, float tempW, float tempH, int tempWall, int tempDist) {
    locX = tlocX;
    locY = tlocY;
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    wall = tempWall;
    dist = tempDist;
  } 


  void display() {
    stroke(100);
    //Color appropriately
    //if goal
    if ( locX==goal[1] && locY==goal[0] ) {
      fill( 255, 0, 0 );
    } 
    else if ( locX==start[1] && locY==start[0] ) {
      fill( 0, 255, 0 );
    } 
    else if ( wall == 1 ) {
      fill( 75 );
    } 
    else {
      fill( 255 );
    }
    rect(x, y, w, h); 

    //Draw the number in the center of the square
    textFont(f);       
    fill(0);
    textAlign(CENTER);
    if ( dist != -1 ) {
    //if( true ){
      text( dist, x + w/2, y+h/2);
    }
  }
}

