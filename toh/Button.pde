//In case we need a button class

class Button {

  color storedColor;
  int x;
  int y;
  int w;
  int h;
  String title;

  Button(color i, int bx, int by, int bw, int bh, String t) {
    storedColor = i;
    x = bx;
    y = by;
    w = bw;
    h = bh;
    title = t;
  }

  void draw() {
    fill(storedColor);
    rect(x, y, w, h);
    if ( title != null ) {
      fill(color(0, 0, 0));
     text(title, x, y, w, h); 
    }
  }

  boolean contains(int mx, int my) {
    if ( mx > x && mx < x + w ) {
      if ( my > y && my < y + h ) {
        return true;
      }
    }
    return false;
  }
}

