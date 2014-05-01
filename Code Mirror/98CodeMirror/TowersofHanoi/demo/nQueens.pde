// NEXT GOALS:
// DONE 1. turn queens red that conflict with choice
// DONE 2. implement a slow solving method
// DONE 3. change circles to queen images
// DONE 4. Fix color scheme (beige/khaki tiles?)
// DONE 5. Debug queue/ animation
// 6. Semantic debugging - turn queens red
// 7. Implement interface with JS for running user code

/// Javascript interface ///

interface JavaScript {
  void log_Processing_error(String error_message);
}

void bindJavascript(JavaScript js) {
  javascript = js;
}

JavaScript javascript;

/// End Javascript interface ///

int w, h;
int cols, rows, side;
//PImage queen_img;
PShape queen_img_black, queen_img_green, queen_img_red;
int board[][];
boolean is_board_solved;
//int mouse_click_x, mouse_click_y;
float time;
//int red_queens_row[];
//int red_queens_col[];
//char queen_char = 9819;
ArrayList<MoveFrame> animation_queue;
boolean is_animation;
long animation_speed;

ArrayList<MoveFrame> debug_queue;
boolean is_debug_mode;
int curr_step;

boolean is_run_mode;

//String glob_string;

void setup() {
  w = 320;
  h = 320;
  size(w, h);
  
  cols = 8;
  rows = 8;
  side = w / cols;
  
  board = new int[rows][cols];
  for (int i=0; i<rows; i++) {
    for (int j=0; j<cols; j++) {
      board[i][j] = 0;
    }
  }
  is_board_solved = false;
  animation_queue = new ArrayList<MoveFrame>();
  is_animation = false;
  animation_speed = 1000;
  
  queen_img_black = loadShape("chessQueenPiece_black.svg");
  queen_img_green = loadShape("chessQueenPiece_green.svg");
  queen_img_red = loadShape("chessQueenPiece_red.svg");
//  queen_img = loadImage("BlackCircle.gif");
//  last_time = millis();
//  println(queen_char);

//glob_string = "test 123";
  is_debug_mode = false;
  curr_step = 0;
}

void draw() {
  
  if (!animation_queue.isEmpty() && is_animation) {
    animate(animation_queue);
    if (animation_queue.isEmpty()) {
//      println("animation finished");
      is_animation = false;
    }
  }
  
  for (int i=0; i<rows; i++) {
    for (int j=0; j<cols; j++) {
      int x = j * side;
      int y = i * side;
      
      stroke(0);
      if ( ( (j+i) % 2 ) == 1 ) {
//        fill(200);
        fill(243, 229, 171);
      } else {
        fill(255);
      }
      
      rect(x, y, side, side);
//      queen_img.resize(side, side);
//      image(queen_img, 0, 0, side, side);
      
      if (board[i][j] == 1) {
//        image(queen_img, x, y, side, side);
        if (is_board_solved) {
          shape(queen_img_green, x + side/4, y, side/2, side);
        } else {
          shape(queen_img_black, x + side/4, y, side/2, side);
        }
//        ellipse(x + side/2, y + side/2, side/1.25, side/1.25);
//      shape(queen_img_black, x + side/4, y, side/2, side);
      
      } else if (board[i][j] == -1) {
        fill(255, 0, 0);
        rect(x, y, side, side);
//        delay(10000);
        if (millis() > time + 500 ) {
          board[i][j] = 0;
        }
      } else if (board[i][j] == -2) {
        shape(queen_img_red, x + side/4, y, side/2, side);
      }
    }
  }
}

void keyPressed() {
  // 48 is ASCII value for '0'
  
  // TEST DEBUG //
  
  if (key == 'd') {
    if (!is_debug_mode) {
      enterDebugMode();
    } else {
      exitDebugMode();
    }
  }
  
  if (key == 'f') {
    stepForward();
  }
  
  if (key == 'b') {
    stepBack();
  }
  
  if (is_debug_mode) {
    return;
  }
  
  int val = int(key) - 48;
//  println(key);
//  println(val);
  // no solution exists for n queens for n = 2, 3
  if (val > 0 && val < 9 && val != 2 && val != 3) {
    clearBoard();
//    animation_queue.clear();
    cols = val;
    rows = val;
    side = w / cols;
  }
  
//  switch (key) {
//    case 'A':
//      val = 10;
//      break;
//    case 'B':
//      val = 11;
//      break;
//    case 'C':
//      val = 12;
//      break;
//    case 'D':
//      val = 13;
//      break;
//    case 'E':
//      val = 14;
//      break;
//  }
  
  
  
  if (key == 'n') {
    clearBoard();
//    animation_queue.clear();
  }
  
  if (key == 's') {
    solveBoard();
  }
  
  if (key == 'a') {
    is_animation = true;
    solveBoard();
//    println("pressed a");
  }
  
//  if (key == CODED) {
//    if (keyCode == KeyEvent.VK_F1) { 
//      setup();
//    }
//  }
}

void mouseClicked() {
  
  if (is_debug_mode) {
    return;
  }
//  mouse_click_x = mouseX;
//  mouse_click_y = mouseY;
//  int col = floor(mouse_click_x / side);
//  int row = floor(mouse_click_y / side);
  int col = floor(mouseX / side);
  int row = floor(mouseY / side);
  handleMove(row, col);
  
  // TEST //
//  if (javascript != null) {
//    javascript.log_Processing_error("test 123");
//  }
  
}
  // want to flip sign on mouse click, not just set true
  // want to check if it's a valid move here too!
//  println(row);
//  println(col);
//  println(isMoveValid(row, col));
// FACTORIZE -> handleMove --> call from solver
//  if (board[row][col] == 0) {
//    if ( isMoveValid(row, col) ) {
//      board[row][col] = 1;
//      if ( isBoardSolved() ) {
//        is_board_solved = true;
//      }
//    } else {
//      board[row][col] = -1;
//      time = millis();
//    }
//  } else {
//    board[row][col] = 0;
//    is_board_solved = false;
////    delay(50000);
//  }
//  
//}

//void mouseReleased() {
//  int col = floor(mouse_click_x / side);
//  int row = floor(mouse_click_y / side);
//  
//  println(board[row][col]);
//  
//  if (board[row][col] == 2) {
//  
//    // pause
//    for (int i=0; i<10; i++) {}
//    println("finished loop");
//    board[row][col] = 0;
//  }
//  
//}

void handleMove(int row, int col) {
  
//  if (javascript != null) {
//    javascript.log_Processing_error("test 123");
//  }
  
  if (board[row][col] == 0) {
    
    if ( isMoveValid(row, col) ) {
      board[row][col] = 1;
      if ( isBoardSolved() ) {
        is_board_solved = true;
      }
    } else {
//      if (javascript != null) {
//          javascript.log_Processing_error("ERROR: You can't place a queen on the same horizontal, vertical, or diagonal of another queen.");
//      }
      board[row][col] = -1;
      time = millis();
    }
  
  } else {
    board[row][col] = 0;
    is_board_solved = false;
  }
   
}

boolean isMoveValid(int row, int col) {
  
  for (int i=0; i<rows; i++) {
    if (board[i][col] == 1) {
      
      // send error message to user
      if (javascript != null) {
        javascript.log_Processing_error("ERROR: You can't place a queen in the same column as another queen.");
      }
      return false;
    }
  }
  
//  println("row is empty");
  
  for (int j=0; j<cols; j++) {
    if (board[row][j] == 1) {
      
      // send error message to user
      if (javascript != null) {
        javascript.log_Processing_error("ERROR: You can't place a queen in the same row as another queen.");
      }
      return false;
    }
  }
  
//  println("column is empty");
  
  int j = col;
  int i = row;
  while (i < rows && j < cols) {
    if (board[i][j] == 1) {
      // send error message to user
      if (javascript != null) {
        javascript.log_Processing_error("ERROR: You can't place a queen on the same diagonal as another queen.");
      }
      return false;
    }
    i++;
    j++;
  }
  
  j = col;
  i = row;
  while (i >= 0 && j >=0) {
    if (board[i][j] == 1) {
      // send error message to user
      if (javascript != null) {
        javascript.log_Processing_error("ERROR: You can't place a queen on the same diagonal as another queen.");
      }
      return false;
    }
    i--;
    j--;
  }
  
  j = col;
  i = row;
  while (i < rows && j >=0) {
    if (board[i][j] == 1) {
      // send error message to user
      if (javascript != null) {
        javascript.log_Processing_error("ERROR: You can't place a queen on the same diagonal as another queen.");
      }
      return false;
    }
    i++;
    j--;
  }
  
  j = col;
  i = row;
  while (i >= 0 && j < cols) {
    if (board[i][j] == 1) {
      // send error message to user
      if (javascript != null) {
        javascript.log_Processing_error("ERROR: You can't place a queen on the same diagonal as another queen.");
      }
      return false;
    }
    i--;
    j++;
  }
  
//  println("diagonals are empty");
  
  return true;
}

boolean isBoardSolved() {
  
  int num_queens = 0;
  for (int i=0; i<rows; i++) {
    for (int j=0; j<cols; j++) {
      if (board[i][j] == 1) {
        num_queens++;
      }
    }
  }
    
//    println(num_queens);
    
    if (num_queens == cols) {
      return true;
    } else {
      return false;
    }
}

void solveBoard() {
//  noLoop();
  clearBoard();
  animation_queue.clear();
  solveBoard_helper(0);
  if (is_animation || is_debug_mode) {
//    println("solved for animation");
    clearBoard();
  } else {
    animation_queue.clear();
  }
//  loop();
}

void solveBoard_helper(int row) {
//  time = millis();
//  int frame_prev_row = row;
//  int frame_prev_col = -1;

  int col = -1;
  for (int j=0; j<cols; j++) {
//    println(row);
//    println(j);
    if (board[row][j] == 1) {
//      frame_prev_col = j;
      
      col = j;
      board[row][j] = 0;
//      redraw();
      break;
    }
  }
//  println(col);
//  println(row);
//  println("---");
  
  do {
    if ( col < (cols - 1) ) {
      if (col != -1) {
        addMoveFrame(row, col, animation_queue);
      }
      col++;
      addMoveFrame(row, col, animation_queue);
    } else {
      addMoveFrame(row, col, animation_queue);
//      if (row > 0) {
//      while (millis() > time + 500 ) {}
      solveBoard_helper(row - 1);
//      solveBoard_helper(row - 1);
      
      if (is_board_solved) {
        return;
      }
//      } else {
//        println("error");
//        return;
//      }
    }
    
  } while (!isMoveValid(row, col));
  
//  print("row: ");
//  println(row);
//  print("col: ");
//  println(col);
  board[row][col] = 1;
//  redraw();
  if (isBoardSolved()) {
//    println("success");
    is_board_solved = true;
    return;
  } else {
//    while (millis() > time + 500 ) {}
    solveBoard_helper(row + 1);
//    }
//    solveBoard_helper(row + 1);
  }
  
}

void clearBoard() {
  for (int i=0; i<rows; i++) {
    for (int j=0; j<cols; j++) {
      board[i][j] = 0;
    }
  }
  is_board_solved = false;
//  animation_queue.clear();
}

void resetQueenColor() {
  for (int i=0; i<rows; i++) {
    for (int j=0; j<cols; j++) {
      if (board[i][j] > 1 || board[i][j] < 0) {
        board[i][j] = 1;
      }
    }
  }
}

//////////////// - ANIMATION QUEUE - ////////////////

class MoveFrame {
//  int prev_row;
//  int prev_col;
  
  int row;
  int col;
}

void addMoveFrame(int row, int col, ArrayList<MoveFrame> queue) {
  MoveFrame move_frame = new MoveFrame();
  
//  move_frame.prev_row = prev_row;
//  move_frame.prev_col = prev_col;
  
  move_frame.row = row;
  move_frame.col = col;
  
  queue.add(move_frame);
//  println("new frame added");
}

void animate(ArrayList<MoveFrame> animation_queue) {
  MoveFrame move_frame = animation_queue.get(0);
  animation_queue.remove(0);
//  int prev_row = move_frame.prev_row;
//  int prev_col = move_frame.prev_col;
  int row = move_frame.row;
  int col = move_frame.col;
  
//  println("start wait");
  
  long start = millis();
  while (millis() - start < animation_speed) {}
//  if (prev_col != -1) {
//    handle_move(prev_row, prev_col);
//  }

//  println("end wait");
//  print("handling row", row);
//  println("and col", col);

  handleMove(row, col);
}

//void debug(ArrayList<MoveFrame> animation_queue) {
//  
//}

///////////////// DEBUG MODE /////////////////////////

// FIX USER INPUT - IE HOW TO SOLVE FROM CODEMIRROR
void stepForward() {
  if ( curr_step < (debug_queue.size() - 1) ) {
    curr_step = curr_step + 1;
    MoveFrame move_frame = debug_queue.get(curr_step);
    int row = move_frame.row;
    int col = move_frame.col;
    placeQueen(row, col);
  }
  
}

void stepBack() {
  if (curr_step > 0) {
    MoveFrame move_frame = debug_queue.get(curr_step);
    int row = move_frame.row;
    int col = move_frame.col;
    placeQueen(row, col);
    curr_step = curr_step - 1;
  }
}

void enterDebugMode() {
  if (debug_queue.size() > 0) {
    is_debug_mode = true;
  } else {
    if (javascript != null) {
      javascript.log_Processing_error("ERROR: You have to run your code before you can debug it.");
    }
  }
//  solveBoard();
}

void exitDebugMode() {
  is_debug_mode = false;
//  clearBoard();
}

//////////////// - END DEBUG MODE - ////////////////

//////////////// - RUN MODE - ////////////////

void enterRunMode() {
  debug_queue.clear();
  is_run_mode = true;
}

void exitRunMode() {
  is_run_mode = false;
}

//////////////// - USER CODE INTERFACE - ////////////////

// this function should place queen regardless of 
// correctness, but color it red if it's wrong

// FIGURE OUT TO PUT INTO DEBUG QUEUE - MAYBE COMBINE PLACE AND
// REMOVE FUNCTIONS...
void placeQueen(int row, int col) {
  if (board[row][col] == 0) {
    if ( isMoveValid(row, col) ) {
      board[row][col] = 1;
    } else {
      board[row][col] = -2;
    }
  } else {
    if (javascript != null) {
      javascript.log_Processing_error("ERROR: There's already a queen on the square.");
    }
  }
  
  if (is_run_mode) {
    addMoveFrame(row, col, debug_queue);
  }
}

void removeQueen(int row, int col) {
  if (board[row][col] != 0) {
    board[row][col] = 0;
  } else {
    if (javascript != null) {
      javascript.log_Processing_error("ERROR: There's no queen on the square to be removed.");
    }
  }
}

boolean isQueen(int row, int col) {
  if (board[row][col] != 0) {
    return true;
  } else {
    return false;
  }
}

int getNumCols() {
  return cols;
}

int getNumRows() {
  return rows;
}

//////////////// - END USER CODE INTERFACE - ////////////////

// step_forward
// step_back

//void pushMoveToList() {
//  
//}

// better named function, for testing purposes
//void placeQueen(int row, int col) {
//  handleMove(row, col);
//}

//////////////// - TESTING - ////////////////


//String log_Processing_error() {
//  String string_1 = "test 123";
//  return string_1;
//}
