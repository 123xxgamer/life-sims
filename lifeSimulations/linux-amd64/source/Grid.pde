class Grid {

  Cell[][] grd;
  int sz; //size

  Grid (int numRows, int numCols, int lifeDensity) {
    grd= new Cell[numRows][numCols];
    sz=width/numCols;
    createGrid(lifeDensity);
  }//constructor

  void createGrid (int lifeDensity) {
    for (int r=0; r<grd.length; r++) {
      for (int c=0; c<grd[r].length; c++) {
        float v=random(100);
        if (v<=lifeDensity) {
          grd[r][c]=new Cell(sz*c, sz*r+infoHeight, sz, LIVE);
        } else {
          grd[r][c]=new Cell(sz*c, sz*r+infoHeight, sz, DEAD);
        }
      }
    }
  }// instantiate grd with Cells

  void displayAll () {
    for (int r=0; r<grd.length; r++) {
      for (int c=0; c<grd[r].length; c++) {
        grd[r][c].display();
      }
    }
  }// display() all Cells in grd

  int[][] neighbors8() {
    int[][] numAlive=new int[grd.length][grd[0].length];
    for (int r=0; r<grd.length; r++) {
      for (int c=0; c<grd[r].length; c++) {

        if (c>0) {
          if (grd[r][c-1].state==LIVE) {
            numAlive[r][c]++;
          }
        }
        if (c<(grd[r].length-1)) {
          if (grd[r][c+1].state==LIVE) {
            numAlive[r][c]++;
          }
        }
        if (r>0) {
          if (grd[r-1][c].state==LIVE) {
            numAlive[r][c]++;
          }
        }
        if (r<(grd.length-1)) {
          if (grd[r+1][c].state==LIVE) {
            numAlive[r][c]++;
          }
        }
        if (c>0&&r>0) {
          if (grd[r-1][c-1].state==LIVE) {
            numAlive[r][c]++;
          }
        }
        if (c<(grd[r].length-1)&&r>0) {
          if (grd[r-1][c+1].state==LIVE) {
            numAlive[r][c]++;
          }
        }
        if (r<(grd.length-1)&&c<(grd[r].length-1)) {
          if (grd[r+1][c+1].state==LIVE) {
            numAlive[r][c]++;
          }
        }
        if (r<(grd.length-1)&&c>0) {
          if (grd[r+1][c-1].state==LIVE) {
            numAlive[r][c]++;
          }
        }
      }
    }
    return numAlive;
  }// return number of alive 8 neighbors
  void playSim(int[][] numsAlive,int rulesIndex) {
    for (int r=0; r<grd.length; r++) {
      for (int c=0; c<grd[r].length; c++) {
        //grd[r][c].updateNextStateLife(numsAlive[r][c]);
        grd[r][c].updateNextState(numsAlive[r][c],rules[rulesIndex]);
      }
    }
    updateStates();
  }// update next state for all with Life logic, then update state
  void updateStates() {
    for (int r=0; r<grd.length; r++) {
      for (int c=0; c<grd[r].length; c++) {
        grd[r][c].changeState();
      }
    }
  }// update state from next state
}//class Grid
