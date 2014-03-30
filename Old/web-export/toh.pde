int TOWER_WIDTH, TOWER_HEIGHT, TOWER_BASE, TOWER_SIXTH; 
int T1_L, T1_C, T1_R, T2_L, T2_C, T2_R, T3_L, T3_C, T3_R;
Disc[] disc = new Disc[3]; //number of discs
int []tower = new int[3]; //to track what y-dir to draw at;
float xOffset = 0.0; 
float yOffset = 0.0; 
void setup() {

  size(1000, 500);

  TOWER_WIDTH = width/20; //width of tower spire
  TOWER_HEIGHT = height - TOWER_WIDTH * 3; //highest y-coord of the tower
  TOWER_BASE = width - (2 * TOWER_WIDTH); //width of tower base
  TOWER_SIXTH = TOWER_BASE / 6 ;//maximum size of one disc

  T1_L = TOWER_WIDTH; //tower 1 left
  T1_C = TOWER_WIDTH + TOWER_SIXTH; //tower 1 center 
  T1_R = TOWER_WIDTH + TOWER_SIXTH * 2; //tower 1 right / tower 2 left border
  T2_C = TOWER_WIDTH + TOWER_BASE / 2; //tower 2 center
  T3_L = TOWER_WIDTH + TOWER_SIXTH * 4; //tower 2 right / tower 3 left border
  T3_C = TOWER_WIDTH + TOWER_SIXTH * 5; //tower 3 center
  T3_R = TOWER_WIDTH + TOWER_BASE; //tower 3 right border

  for (int i = 0; i < tower.length; i++) {
    tower[i] = 1; //all start on tower 1
  }

  for (int i = 0; i < disc.length; i++) {
    disc[i] = new Disc (T1_C, 100*(i+1)+TOWER_WIDTH, (i+1), 1); //starting on peg 1  
    disc[i].pickedUp = false;
  }
}

int bottomRung(int goal_tower_center) { 
  return 0;
}

void drop() {
}

void pickUp() {
}

void draw() { 
  fill(22, 82, 20); //green background;
  rect(0, 0, width, height);

  //tower
  fill(92, 34, 17); //brown
  rect(T1_C - TOWER_WIDTH/2, height - TOWER_HEIGHT, TOWER_WIDTH, TOWER_HEIGHT); // left tower
  rect(T2_C - TOWER_WIDTH/2, height - TOWER_HEIGHT, TOWER_WIDTH, TOWER_HEIGHT); //center tower    
  rect(T3_C - TOWER_WIDTH/2, height - TOWER_HEIGHT, TOWER_WIDTH, TOWER_HEIGHT); // right tower
  rect(TOWER_WIDTH, height - (TOWER_WIDTH), width - (2 * TOWER_WIDTH), 50); //tower base

  //discs
  fill(255, 0, 0);

  for (int i=0; i< disc.length; i++) { 
    if (disc[i].isWithinDisc())
      fill(255, 100, 100); 
    else  fill(255, 0, 0);

    disc[i].draw(); //starting on peg 1
  }

  //grid(); //TEMP
}

void mousePressed() {
  for (int i=0; i< disc.length; i++) {
    if (disc[i].isWithinDisc()) {
      disc[i].pickedUp = true;
    }
    else {
      disc[i].pickedUp = false;
    }
    xOffset = mouseX-disc[i].x;
    yOffset = mouseX-disc[i].y;
  }
}

void mouseDragged() {
  for (int i=0; i< disc.length; i++) {
    if (disc[i].pickedUp) {
      disc[i].update();  //locked
    }
  }
}

void mouseReleased() {
  for (int i=0; i< disc.length; i++) {
    if (disc[i].pickedUp) {
      disc[i].pickedUp = false;
      if (mouseX < T1_R) {
        disc[i].x = T1_C;
      }
      else if (mouseX > T3_L) {
        disc[i].x = T3_C;
      }
      else disc[i].x = T2_C;
    }
  }
}

void grid() {
  line(T1_L, 0, T1_L, height); //tower 1 left border
  line(T1_C, 0, T1_C, height); //tower 1 center
  line(T1_R, 0, T1_R, height); //tower 1 right / tower 2 left border
  line(T2_C, 0, T2_C, height); //tower 2 center
  line(T3_L, 0, T3_L, height); //tower 2 right / tower 3 left border
  line(T3_C, 0, T3_C, height); //tower 3 center
  line(T3_R, 0, T3_R, height); //tower 3 right border
}

class Disc {
  int x, y, size, peg;
  boolean WithinDisc, pickedUp;
  int leftWall = x -(size * 100)/2;
  int rightWall = leftWall + size * 100;
  int upperWall = size * 100 ;
  int lowerWall = upperWall + 100;

  Disc(int dx, int dy, int ds, int dp) {
    x = dx;
    y = dy;
    size = ds;
    peg = dp;
    WithinDisc = false;
  }

  boolean isWithinDisc() {   
    leftWall = x - (size * 100)/2;
    rightWall = leftWall + size * 100;
    upperWall = y; //size * 100 ;
    lowerWall = upperWall + 100; //upperWall + 100;
    return (mouseX > leftWall && (mouseX < rightWall) 
      && (mouseY > upperWall) && (mouseY < lowerWall));
  }

  void draw() {

    rect(x - (size * 100)/2, y, size * 100, 100);
  }

  void update() {
    x = mouseX - (size * 100)/50;
    y = mouseY - (100/2);
  }
}


