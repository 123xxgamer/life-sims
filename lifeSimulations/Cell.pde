class Cell {

  //display related fields
  int size;
  PVector corner; //top left corner

  //current state and next state
  boolean state;
  boolean nextState;


  Cell(int _x, int _y, int sz, boolean st) {
    corner = new PVector(_x, _y);
    size = sz;
    state = st;
  }

  void display() {
    //set fill color based on state
    if (state == DEAD) {
      fill(colors[colorScheme][1]);
      stroke(colors[colorScheme][1]);
    } else if (state == LIVE) {
      fill(colors[colorScheme][0]);
      stroke(colors[colorScheme][0]);
    }
    square(corner.x, corner.y, size);
  }

  //calculate next state
  void updateNextStateLife(int numLiveNeighbors) {
    if (state==LIVE && (numLiveNeighbors<2 || numLiveNeighbors>3)) {
      nextState=DEAD;
    } else if (state==DEAD && numLiveNeighbors==3) {
      nextState=LIVE;
    } else {
      nextState=state;
    }
  }//updateState

  void updateNextState(int numLiveNeighbors, int[][] rule) {
    if (state==DEAD) {
      boolean living=false;
      for (int i=0; i<rule[0].length; i++) {
        if (numLiveNeighbors==rule[0][i]) {
          living=true;
          break;
        }
      }
      if (living) {
        nextState=LIVE;
      } else {
        nextState=DEAD;
      }
    } else { //state==LIVE
      boolean dying=true;
      for (int i=0; i<rule[1].length; i++) {
        if (numLiveNeighbors==rule[1][i]) {
          dying=false;
          break;
        }
      }
      if (dying) {
        nextState=DEAD;
      } else {
        nextState=LIVE;
      }
    }
  }//updateState

  void changeState() {
    state = nextState;
  }//changeState
}//Cell class
