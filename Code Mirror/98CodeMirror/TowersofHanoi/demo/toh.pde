//toh.pde
//interactive towers of hanoi
//drag and drop
//only the top disc on the peg can be clicked
//click topmost peg and drag to another peg
//if move legal, peg snaps to bottom of the new peg
// if move illegal, snaps back to previous peg
//while in hand, if move legal then disc positive color, else negative
//
//temporary tests:
//press t to autosolve towers
//press r to reset towers
//press 3 - 9 or 0 to init 3-9 or 10 discs
//press - or + to decr or incr # of discs, between 1 and 10

color BACKGROUND = color (170); //grey
color PEG = color(82, 24, 17); //brown
color PEGTEXT = color(0); //black
color DISCTEXT = color(0, 180); //black, slightly transparent
color DISC_NEUTRAL = color(2, 142, 155);//(51, 51, 255); //blue
color DISC_HIGHLIGHT = color(53, 192, 205);//(112, 146, 190);//light blue
color DISC_WRONG = color(255, 13, 0); //red
color DISC_RIGHT = color(255, 154, 64); //light orange
color DISC_WIN = color(0, 198, 24); //green

int MAX_DISCS = 9;

int peg_width, peg_height, peg_base, base_sixth;
int T1_L, T1_C, T1_R, T2_L, T2_C, T2_R, T3_L, T3_C, T3_R;
int total_discs, disc_height, disc_width_per_size;
Disc inHand = null;
boolean solve;
ArrayList<Move> queue;
ArrayList<String> report;
long wait;
int mode = 0; // 0 = run, 1 = debug
int counter = 0;
long globalTime = 0;
/*Button b;
 ArrayList<Button> blist = new ArrayList<Button>();*/

Peg[] peg = new Peg[3];

float xOffset = 0.0;
float yOffset = 0.0;

void setTotalDiscs(int total) {
  
  total_discs = total;
  
  if (total_discs <= 0) {
    report.add("Error: Disc total is too small. Total number of discs must be between 1 and "+MAX_DISCS+".");
    total_discs = 1;
  } else if (total_discs > MAX_DISCS) {
    report.add("Error: Disc total is too large. Total number of discs must be between 1 and "+MAX_DISCS+".");
    total_discs = MAX_DISCS;
  } else {
    total_discs = total;
  }
  
  // disc_height  = peg_height / total_discs or less, is height of one disc  
  // disc_height = ((peg_height - peg_width) / total_discs) - (height/100);  
  int disc_height_unconstrained;
  disc_height_unconstrained = ((peg_height - peg_width) / total_discs) - (height/100);
  //make height of 1 or 2 lone discs no larger than heights in a stack of 6  
  disc_height = min(disc_height_unconstrained, ((peg_height - peg_width) / 6) - (height/100));  

  //disc_width_per_size = total disc_width / size, is between peg_width and base_sixth
  //disc_width_per_size = (base_sixth * 2) / total_discs;
  //disc_width_per_size = ((base_sixth * 2) - peg_width) / total_discs;

  //init three pegs, no discs
  peg[0] = new Peg(1, T1_C);
  peg[1] = new Peg(2, T2_C);
  peg[2] = new Peg(3, T3_C);

  //initialize discs on peg[0]/ peg #1 / T1_C
  for (int i = total_discs - 1; i >= 0; i--) {
    // Disc(center_x, top_y, size, peg)
    peg[0].push(new Disc(T1_C, height - peg_width - (disc_height * (total_discs - i)), i+1));
    //println(peg[0].discs);   
    //println("top_index: "+ peg[0].top_index);
  }
}

void increaseTotalDiscs() {
  int incr = total_discs + 1;
  if (incr <= MAX_DISCS) {
    setTotalDiscs(incr);
  }
}

void decreaseTotalDiscs() {
  int decr = total_discs - 1;
  if (decr >= 1) {
    setTotalDiscs(decr);
  }
}

void setup() {
  size(570, 340);//size(580, 350); //size(650, 400)
  queue = new ArrayList<Move>();
  report = new ArrayList<String>();
  solve = false;

  peg_width = width/20; //width of peg spire
  //peg_height = height - peg_width * 3; //highest y-coord of the peg, has gap of 3 peg-width above top of screen
  peg_height = height - peg_width * 2 ; //highest y-coord of the peg, has gap of 3 peg-width above top of screen
  peg_base = width - (2 * peg_width); //width of peg base. base height = peg width
  base_sixth = peg_base / 6 ;//maximum size of one disc

  T1_L = peg_width; //peg 1 left
  T1_C = peg_width + base_sixth; //peg 1 center 
  T1_R = peg_width + base_sixth * 2; //peg 1 right / peg 2 left border
  T2_C = peg_width + peg_base / 2; //peg 2 center
  T3_L = peg_width + base_sixth * 4; //peg 2 right / peg 3 left border
  T3_C = peg_width + base_sixth * 5; //peg 3 center
  T3_R = peg_width + peg_base; //peg 3 right border

  //sets # of discs and updates disc's height and width accordingly
  setTotalDiscs(3); //best between 3 and 9
  
  wait = 1000;

  /*
  blist.add(new Button(c, 70, 10, 100, 40, "Reset"));
   blist.add(new Button(c, 190, 10, 100, 40, "Solve"));
   blist.add(new Button(c, 310, 10, 100, 40, "+"));
   blist.add(new Button(c, 430, 10, 100, 40, "-"));*/
}

void draw() {

  if (queue.size() > counter && mode == 0 && millis() - globalTime > wait) {
    animate(queue);
  }
  fill(BACKGROUND); //background
  noStroke();
  rect(0, 0, width, height); //background

  //peg base in background
  fill(PEG); //brown
  rect(peg_width, height - (peg_width), width - (2 * peg_width), 50); //peg base
  rect(T1_C - peg_width/2, height - peg_height, peg_width, peg_height - peg_width, 30, 30, 0, 0);
  rect(T2_C - peg_width/2, height - peg_height, peg_width, peg_height - peg_width, 30, 30, 0, 0);
  rect(T3_C - peg_width/2, height - peg_height, peg_width, peg_height - peg_width, 30, 30, 0, 0);

  stroke(0);

  //pegs
  for (int i=0; i< peg.length; i++) {
    peg[i].draw();
  }

  if (inHand != null) {   
    fill(inHandColor()); 
    inHand.draw();
  }

  /* for ( Button b : blist ) {
   b.draw();
   } */
  //grid(); //TEMP
}

void animate(ArrayList<Move> queue) {
  Move m = queue.get(counter); 
  counter++;
  int n = m.n;
  int to = m.to;
  int from = m.from;
  if(checkDiscTopsPeg(n, from)){
	report.add("Moving Disc "+n+" from Peg "+from+" to Peg "+to+".\n");
	draw_disc(n, from, to);
  }
  globalTime = millis();
}

void animate_immediate(ArrayList<Move> queue) {
  Move m = queue.get(counter); 
  counter++;
  int n = m.n;
  int to = m.to;
  int from = m.from;
  if(checkDiscTopsPeg(n, from)){
	report.add("Moving Disc "+n+" from Peg "+from+" to Peg "+to+".\n");
	draw_disc(n, from, to);
  }
}

void animate_back(ArrayList<Move> queue) {
  Move m = queue.get(--counter); 
  int n = m.n;
  int from = m.to;
  int to = m.from;
  if(checkDiscTopsPeg(n, from)){
	report.add("Moving Disc "+n+" from Peg "+from+" to Peg "+to+".\n");
	draw_disc(n, from, to);
  }
}

//colors if inHand is legal addition to peg it is over, else red
color inHandColor() {
  if ((overPeg1() && peg[0].isLegalAddition(inHand))||
    (overPeg2() && peg[1].isLegalAddition(inHand)) ||
    (overPeg3() && peg[2].isLegalAddition(inHand))) {
    return color(DISC_RIGHT); // yellow
  }
  else
    return color(DISC_WRONG); //red
}

//temp: trigger autoiterate once after keypressed
void keyPressed() {
  if (!mousePressed) { //else clones inHand

      if (key == 't' || key == 'T') {
      setTotalDiscs(total_discs);
      solve_hanoi(total_discs, 1, 3);
    }
    else if ((key == 'r' || key == 'R') ) {
      setTotalDiscs(total_discs);
    }

    else if (key == '-' || key == '_' ) {
      decreaseTotalDiscs();
    }

    else if (key == '='|| key == '+' ) {
      increaseTotalDiscs();
    }

    else if ((key == '3') ) {
      setTotalDiscs(3);
    }
    else if ((key == '4') ) {
      setTotalDiscs(4);
    }
    else if ((key == '5') ) {
      setTotalDiscs(5);
    }
    else if ((key == '6') ) {
      setTotalDiscs(6);
    }
    else if ((key == '7') ) {
      setTotalDiscs(7);
    }
    else if ((key == '8') ) {
      setTotalDiscs(8);
    }
    else if ((key == '9') ) {
      setTotalDiscs(9);
    }
    else if ((key == '0') ) {
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
  else {
    currPeg = peg[2];
  }
  if (inHand == null && currPeg.isWithinTopDisc()) {
    inHand = currPeg.pop();
    if (inHand != null) {
      inHand.prevPeg = currPeg; 
      //println("inHand: " + inHand);
      xOffset = mouseX - inHand.x;
      yOffset = mouseX - inHand.y;
    }
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
  int x, y, size, disc_width;
  int leftWall, rightWall, upperWall, lowerWall;
  Peg prevPeg;
  Disc(int dx, int dy, int ds) {
    x = dx; //centermost x
    y = dy; // uppermost y
    size = ds;
    disc_width = peg_width + ((base_sixth * 2) - peg_width) / total_discs * size;
    //disc_height defined in setTotalDiscs()
    prevPeg = null;
  }

  String toString() {
    return "{disc " + size +"}";
  }

  boolean isWithinDisc() {
    leftWall = x - (disc_width/2);
    rightWall = leftWall + (disc_width);
    upperWall = y;
    lowerWall = upperWall + disc_height;
    return (mouseX > leftWall && (mouseX < rightWall) 
      && (mouseY > upperWall) && (mouseY < lowerWall));
  }

  void draw() {
    //top x corner with disc width offset, top y, disc width, disc_height

    //float drawWidth =  constrain(disc_width_per_size * size, peg_width + 2, base_sixth * 2);
    //int drawWidth = (base_sixth * 2 - disc_width_per_size) * size;
    // peg_width + 2, base_sixth * 2 ;

    //rect(x, y, width, height, topleftradius, toprightradius, brradius, blradius)
    //rect(x - (drawWidth)/2, y, drawWidth, disc_height); 

    int discX = x - (disc_width)/2;
    int discY = y;

    //disc
    rect(discX, discY, disc_width, disc_height, 15, 15, 15, 15); 

    //shine
    noStroke();
    fill(255, 30);
    //ellipse(discX + disc_height/4, discY + disc_height/3, disc_height/2 - 5, disc_height/2);
    rect(discX+10, discY+4, disc_width-40, 2*disc_height/3 - 20, 15, 15, 15, 15); //top bar
    rect(discX+disc_width-25, discY+4, 2*disc_height/3 - 20, 2*disc_height/3 - 20, 15, 15, 15, 15); //top dot
    rect(discX+3, discY+2, disc_width - disc_height/3, 2*disc_height/3, 15, 15, 15, 15); //inner
    rect(discX+3, discY+2, disc_width-5, 5*disc_height/6, 15, 15, 15, 15); //outer

    //rect(discX+10, discY + disc_height- disc_height/4, disc_width-20, 5, 15, 15, 15, 15); 

    stroke(0);

    //black text label
    fill(DISCTEXT);
    textAlign(CENTER); 
    textSize(disc_height);
    text(size, x, y + disc_height - (disc_height/10));
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
  
  int topDiscSize(){
	return topDisc().size;
  }

  //if peg is legal, every disc on peg is smaller than the disc below it 
  boolean pegIsLegal() {
    //0 or 1 disc on peg
    if (isEmpty()) {
      return true;
    }
    else {
      for (int i = 1; i <= top_index; i++) {  
        if (discs[i].size > discs[i - 1].size) {
          return false;
        }
      }
    }
    return true;
  }

  boolean winCondition() {
    return (peg_number == 3 && top_index + 1 == total_discs);
  }

  void push(Disc disc) {
    if (top_index < total_discs) {
      //println("PUSH: " + disc +" to [" + top_index + "] of Peg#" + peg_number );
      top_index++;
      discs[top_index] = disc;
      disc.x = x_by_peg(peg_number);
      disc.y = y_by_index(top_index);
      //println("NewTopIndex: " + disc +" to [" + top_index + "] of Peg#" + peg_number );

      if (!pegIsLegal())
        report.add("Error: There is a disc on Peg# " + peg_number + " that is larger than the disc below it.\n");
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
    return height - peg_width - (disc_height * (curr_index + 1));
  }

  void draw() {
    for  (int i=0; i< discs.length; i++) {  
      if (discs[i] != null) {
        if (inHand == null && discs[i].isWithinDisc() && i == top_index) {  
          fill(DISC_HIGHLIGHT);
        }
        else if (i != 0 && discs[i].size > discs[i - 1].size ) { //if current disc not bottom and current disc larger than disc below it
          fill(DISC_WRONG);
        }
        else if (winCondition()) {
          fill(DISC_WIN);
        }
        else {
          fill(DISC_NEUTRAL);
        }
        discs[i].draw();
      }
    }

    fill(PEGTEXT);
    textSize(peg_width);
    text(peg_number, center_x, height - peg_width / 5);
  }
}

/////////////////////////////////////////////////////////////////////////////
//running example::

//disc/peg # out of bounds, 
//disc_number not found on from_peg, 
//disc_number not top-most disc on from_peg
//disc push !(isLegalAddition), cannot push legally
void draw_disc(int disc_number, int from_peg, int to_peg) {

  Disc d = peg[from_peg - 1].pop();
  peg[to_peg - 1].push(d);
}
void solve_hanoi(int n, int start_peg, int end_peg) {

  // the peg that's not the start or end peg
  int spare_peg;

  // base case where there's only one disk
  if (n == 1) { 
    move_disc(n, start_peg, end_peg);
  }

  // recursive case where there's more than one disk
  else {
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

boolean checkDiscTopsPeg(int n, int from){
	if (peg[from-1].isEmpty()){
		report.add("Error: Cannot move Disc "+ n +" from Peg "+ from +" because Peg "+ from +" is empty.\n");
		return false;
	}	
	else if (n != peg[from-1].topDiscSize()){
		report.add("Error: Cannot move Disc "+ n +" from Peg "+ from +" because Disc " + peg[from-1].topDiscSize()+ " is the top disc on Peg " + from + ".\n" );
		return false;
	}

	return true;
}

void move_disc(int n, int from, int to) {
  Move m = new Move();
  m.n = n;
  m.from = from;
  m.to = to;
  queue.add(m);
}

//solve_hanoi(3, 1, 3);

class Move {
  int n;
  int to;
  int from;
}

void debug() {
  mode = 1;
}

void step_forward() {
  if (queue.size() > counter) {
    animate_immediate(queue);
  }
}

void runMode() {
  mode = 0;
}

void step_back() {
  if (counter >= 1) {
    animate_back(queue);
  }
}

void reset_queue() {
  queue = new ArrayList<Move>();
  report = new ArrayList<String>();
  counter = 0;
}

String getMessage() {
  String value = "";
  while (report.size () != 0) {
    value += report.get(0);
    report.remove(0);
  }
  return value;
}

