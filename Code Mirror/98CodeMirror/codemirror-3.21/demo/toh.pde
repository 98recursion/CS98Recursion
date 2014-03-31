//toh.pde
//towers of hanoi
//only the top disc on the peg can be clicked
//drag and drop
//if move legal, peg snaps to bottom of peg over which disc dropped
// if move illegal, snaps back to previous peg

//temporary tests:
//press t to autosolve towers
//press r to reset towers
//press 3 - 9 or 0 to init 3-9 or 10 discs

int PEG_WIDTH, PEG_HEIGHT, PEG_BASE, BASE_SIXTH;
int T1_L, T1_C, T1_R, T2_L, T2_C, T2_R, T3_L, T3_C, T3_R;
int total_discs, disc_height, disc_width_per_size;
Disc inHand = null;

//int savedTime, totalTime;
//boolean solved = false; /////////////////TEMP 

Peg[] peg = new Peg[3];

float xOffset = 0.0; 
float yOffset = 0.0; 

void setTotalDiscs(int total) {
  total_discs = total;
  disc_height = ((PEG_HEIGHT - PEG_WIDTH) / total_discs) - (height/100);  //   = PEG_HEIGHT / total_discs or less, is height of one disc  
  disc_width_per_size = (BASE_SIXTH * 2) / total_discs; // = total disc_width / size, is between PEG_WIDTH and BASE_SIXTH

  //init three pegs, no discs
  peg[0] = new Peg(1, T1_C);
  peg[1] = new Peg(2, T2_C);
  peg[2] = new Peg(3, T3_C);

  //initialize discs on peg[0]/ peg 1 / T1_C
  for (int i = total_discs - 1; i >= 0; i--) {
    // Disc(center_x, top_y, size, peg)
    peg[0].push(new Disc(T1_C, height - PEG_WIDTH - (disc_height * (total_discs - i)), i+1));
    //println(peg[0].discs);   
    //println("top_index: "+ peg[0].top_index);
  }

}

void setup() {

  size(650, 325);

//  savedTime = millis();
//  totalTime = 5000;

  PEG_WIDTH = width/20; //width of peg spire
  PEG_HEIGHT = height - PEG_WIDTH * 3; //highest y-coord of the peg, has gap of 3 peg-width above top of screen
  PEG_BASE = width - (2 * PEG_WIDTH); //width of peg base. base height = peg width
  BASE_SIXTH = PEG_BASE / 6 ;//maximum size of one disc

  T1_L = PEG_WIDTH; //peg 1 left
  T1_C = PEG_WIDTH + BASE_SIXTH; //peg 1 center 
  T1_R = PEG_WIDTH + BASE_SIXTH * 2; //peg 1 right / peg 2 left border
  T2_C = PEG_WIDTH + PEG_BASE / 2; //peg 2 center
  T3_L = PEG_WIDTH + BASE_SIXTH * 4; //peg 2 right / peg 3 left border
  T3_C = PEG_WIDTH + BASE_SIXTH * 5; //peg 3 center
  T3_R = PEG_WIDTH + PEG_BASE; //peg 3 right border

  //total_discs = 3; //max # of pegs, set with setCapacity(int);
  //disc_height = (PEG_HEIGHT - PEG_WIDTH) / total_discs; //= PEG_HEIGHT / total_discs or less, is height of one disc
  //disc_width_per_size = (BASE_SIXTH - (PEG_WIDTH)) / total_discs; // = total disc_width / size, is between PEG_WIDTH and BASE_SIXTH 
  setTotalDiscs(3); //best between 3 and 10 
}

void draw() {
  fill(22, 82, 20); //green
  noStroke();
  rect(0, 0, width, height); //background
  stroke(0);

  //peg base in background
  fill(92, 34, 17); //brown
  rect(PEG_WIDTH, height - (PEG_WIDTH), width - (2 * PEG_WIDTH), 50); //peg base
  rect(T1_C - PEG_WIDTH/2, height - PEG_HEIGHT, PEG_WIDTH, PEG_HEIGHT - PEG_WIDTH);
  rect(T2_C - PEG_WIDTH/2, height - PEG_HEIGHT, PEG_WIDTH, PEG_HEIGHT - PEG_WIDTH);
  rect(T3_C - PEG_WIDTH/2, height - PEG_HEIGHT, PEG_WIDTH, PEG_HEIGHT - PEG_WIDTH);

  //pegs
  for (int i=0; i< peg.length; i++) {
    peg[i].draw();
  }

  if (inHand != null) {   
    //fill(0, 0, 180); //darker blue
    fill(inHandColor()); 
    inHand.draw();
  }

  //grid(); //TEMP

}

//colors green if inHand is legal addition to peg it is over, else red
color inHandColor(){
  if ((overPeg1() && peg[0].isLegalAddition(inHand))||
 (overPeg2() && peg[1].isLegalAddition(inHand)) ||
(overPeg3() && peg[2].isLegalAddition(inHand))) {
  return color(0, 255, 0); //green
}
  else
  return color(255, 0, 0); //red
}

//temp: trigger autoiterate once after keypressed
void keyPressed(){
  if (!mousePressed){ //else clones inHand
  
   if (key == 't' || key == 'T') {
    setTotalDiscs(total_discs);
    solve_hanoi(total_discs, 1, 3);
  }
   else if ((key == 'r' || key == 'R') ){
 setTotalDiscs(total_discs);
 }
 else if ((key == '3') ){
 setTotalDiscs(3);
 }
  else if ((key == '4') ){
 setTotalDiscs(4);
 }
   else if ((key == '5') ){
 setTotalDiscs(5);
 }
   else if ((key == '6') ){
 setTotalDiscs(6);
 }
   else if ((key == '7') ){
 setTotalDiscs(7);
 }
   else if ((key == '8') ){
 setTotalDiscs(8);
 }
   else if ((key == '9') ){
 setTotalDiscs(9);
 }
   else if ((key == '0') ){
 setTotalDiscs(10);
 }
  }
}

void mousePressed() {
  Peg currPeg = null;
  if (overPeg1()) {
    currPeg = peg[0];
  } 
  else if (overPeg2()) {
    currPeg = peg[1];
  }
  else if (overPeg3()) {
    currPeg = peg[2];
  }
  if (inHand == null && currPeg.isWithinTopDisc()) {
    inHand = currPeg.pop();
    inHand.prevPeg = currPeg; //
    //println("inHand: " + inHand);
    xOffset = mouseX - inHand.x;
    yOffset = mouseX - inHand.y;
  }
  else {
    xOffset = 0;
    yOffset = 0;
  }
}

void mouseDragged() {
  if (inHand != null) {
    inHand.update();  //locked
  }
}

void mouseReleased() {
  if (inHand != null) {
    if (overPeg1() && peg[0].isLegalAddition(inHand)) {
      peg[0].push(inHand);
      //println("peg[0]: "+ peg[0].top_index);
    }
    else if (overPeg2() && peg[1].isLegalAddition(inHand)) {
      peg[1].push(inHand);
      //println("peg[1]: "+ peg[1].top_index);
    }
    else if (overPeg3() && peg[2].isLegalAddition(inHand)) {
      peg[2].push(inHand);
      //println("peg[2]: "+ peg[2].top_index);
    }
    else inHand.prevPeg.push(inHand);
  }
  inHand = null;
}


void grid() {
  line(T1_L, 0, T1_L, height); //peg 1 left border
  line(T1_C, 0, T1_C, height); //peg 1 center
  line(T1_R, 0, T1_R, height); //peg 1 right / peg 2 left border
  line(T2_C, 0, T2_C, height); //peg 2 center
  line(T3_L, 0, T3_L, height); //peg 2 right / peg 3 left border
  line(T3_C, 0, T3_C, height); //peg 3 center
  line(T3_R, 0, T3_R, height); //peg 3 right border
}


boolean overPeg1() {
  return mouseX < T1_R;
}

boolean overPeg2() {
  return mouseX >= T1_R && mouseX <= T3_L;
}

boolean overPeg3() {
  return mouseX > T3_L;
}

//----------
class Disc {
  int x, y, size, leftWall, rightWall, upperWall, lowerWall;
  Peg prevPeg;
  Disc(int dx, int dy, int ds) {
    x = dx; //centermost x
    y = dy; // uppermost y
    size = ds;
    prevPeg = null;
  }

  String toString() {
    return "{disc " + size +"}";
  }

  boolean isWithinDisc() {
    leftWall = x - (disc_width_per_size * size /2);
    rightWall = leftWall + (disc_width_per_size * size);
    upperWall = y;
    lowerWall = upperWall + disc_height;
    return (mouseX > leftWall && (mouseX < rightWall) 
      && (mouseY > upperWall) && (mouseY < lowerWall));
  }

  void draw() {
    //top x corner with disc width offset, top y, disc width, disc_height
    float drawWidth =  constrain(disc_width_per_size * size, PEG_WIDTH + 2, BASE_SIXTH * 2);

    rect(x - (drawWidth)/2, y, drawWidth, disc_height);
    
    //black text label
    fill(0,150);
    textAlign(CENTER); 
    textSize(disc_height);
    text(size, x , y + disc_height - (disc_height/10));
  }

  void update() {
    x = mouseX;
    y = mouseY - (disc_height/2);
  }
}

//----------
class Peg {
  Disc discs[];
  int peg_number, center_x, top_index;

  Peg(int n, int x) {
    center_x = x;
    discs = new Disc[total_discs];
    top_index = -1;
    peg_number = n;
  }
  

  String toString() {
    return "#"+ peg_number+ ": " + discs;
  }

  boolean isEmpty() {
    return top_index == -1;
  }

  //if peg is empty or addition is smaller than top disc on peg
  boolean isLegalAddition(Disc d) {
    return (isEmpty()) || (d.size < discs[top_index].size);
  }

  boolean isWithinTopDisc() {
    return (isEmpty()) || discs[top_index].isWithinDisc();
  }
  
  Disc topDisc() {
    return discs[top_index];
  }

  void push(Disc disc) {
    if (top_index < total_discs) {
      //println("PUSH: " + disc +" to [" + top_index + "] of Peg#" + peg_number );
      top_index++;
      discs[top_index] = disc;
      disc.x = x_by_peg(peg_number);
      disc.y = y_by_index(top_index);
      //println("NewTopIndex: " + disc +" to [" + top_index + "] of Peg#" + peg_number );
    }
  }

  Disc pop() {
    Disc toReturn = null;
    if (discs != null && top_index > -1) {
      //println("POP:"+ discs[top_index] + " from ["+ top_index + "] of Peg#"+ peg_number);
      toReturn = discs[top_index];
      discs[top_index] = null;
      top_index = top_index - 1;
    }
    return toReturn;
  }

  int x_by_peg(int curr_peg) {
    if (curr_peg == 1) { 
      return T1_C;
    }
    else if (curr_peg == 2) { 
      return T2_C;
    } 
    else //(curr_peg == 3)
    { 
      return T3_C;
    }
  }

  int y_by_index(int curr_index) {
    return height - PEG_WIDTH - (disc_height * (curr_index + 1)) ;
  }

  void draw() {
    for  (int i=0; i< discs.length; i++) {  
      if (discs[i] != null) {
        if (inHand == null && discs[i].isWithinDisc() && i == top_index) {  
          fill(30, 30, 255); //highlighted blue
        }
        else {
          fill(0, 0, 255); //blue
        }
        discs[i].draw();
      }
    }
    
    fill(0);
    textSize(PEG_WIDTH-4);
    text(peg_number, center_x, height - PEG_WIDTH/4);
    
  }
}

//////////////////////////////////////////////////////////////////////

//todo:test moves passed to move_disc, probably by report why move is wrong: 
//disc/peg # out of bounds, 
//disc_number not found on from_peg, 
//disc_number not top-most disc on from_peg
//disc push !(isLegalAddition), cannot push legally
void move_disc(int disc_number, int from_peg, int to_peg) {

 // int passedTime = millis() - savedTime;
 // if (passedTime > totalTime) {
    
    println("Moving Disc "+disc_number+" from Peg "+from_peg+" to Peg "+to_peg+".");
    Disc d = peg[from_peg - 1].pop();
    peg[to_peg - 1].push(d);

 //   savedTime = millis();
//  }

}

  void solve_hanoi(int n, int start_peg, int end_peg) {

    // the peg that's not the start or end peg
    int spare_peg;

    // base case where there's only one disk
    if (n == 1) { 
      move_disc(n, start_peg, end_peg);
    }

    // recursive case where there's more than one disk
    else{

      // determine which peg is the spare peg
      spare_peg = 6 - start_peg - end_peg;

      // move all the disks except the bottom one to the spare peg
      solve_hanoi(n - 1, start_peg, spare_peg);

      // move the bottom disk from the start peg to the end peg
      move_disc(n, start_peg, end_peg);

      // solve one disk smaller problem of moving the remaining disks, which are on the spare peg, to the end peg
      solve_hanoi(n - 1, spare_peg, end_peg);
    }
  }
  
  //solve_hanoi(3, 1, 3);

