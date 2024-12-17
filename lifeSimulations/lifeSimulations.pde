//State variables
boolean DEAD=false;
boolean LIVE=true;

// game rules array and indices, rules taken from https://en.wikipedia.org/wiki/Life-like_cellular_automaton
int[][][] rules = {{{3}, {2, 3}}, {{1, 3, 5, 7}, {1, 3, 5, 7}}, {{2}, {}}, {{2, 5}, {4}}, {{3}, {0, 1, 2, 3, 4, 5, 6, 7, 8}}, {{3, 4}, {3, 4}}, {{3, 5, 6, 7, 8}, {5, 6, 7, 8}}, {{3, 6}, {1, 2, 5}}, {{3, 6}, {2, 3}}, {{3, 6, 7, 8}, {3, 4, 6, 7, 8}}, {{3, 6, 8}, {2, 4, 5}}, {{4, 6, 7, 8}, {3, 5, 6, 7, 8}}};//3D array of all simulation rules; indices below
int LIFE=0;
int REPLICATOR=1;
int SEEDS=2;
int RULE4=3;//this rule had no name on wikipedia :(
int LIFE_WITHOUT_DEATH=4;
int LIFE34=5;
int DIAMOEBA=6;
int TWOBYTWO=7;
int HIGHLIFE=8;
int DAYANDNIGHT=9;
int MORLEY=10;
int ANNEAL=11;

//color variables
color[][] colors={{#000000,#FFFFFF,color(150, 255, 180)},{color(50,70,10),color(170,150,180),color(240,250,180)},{color(70,10,50),color(150,180,110),color(180,240,250)},{color(100,10,10),color(100,255,150),color(250,200,250)},{color(10,10,100),color(255,50,50),color(210,225,255)}}; //array of color schemes; each sub array is ALIVECOLOR, DEADCOLOR, INFOAREACOLOR
int colorScheme=0;

//setup variables
int lifeDensity = 25;
int NUM_ROWS = 100;
int ROW_LENGTH = 100;

// other driver variables
boolean play;
int gameMode;//simulation index
int maxSpeed=10;
Grid grd;
int sz;
int speed; //maxSpeed is fastest speed, lower is slower. speed 1 is maxSpeed/60 fps.
int infoHeight=155;//height of info area at the top


void settings() {
  int gWidth=((displayHeight-infoHeight-250+ROW_LENGTH/2)/ROW_LENGTH)*ROW_LENGTH;
  size(gWidth, gWidth+infoHeight);
}

void setup() {
  frameRate(60);
  speed=3;
  background(colors[colorScheme][2]);
  textAlign(CENTER, CENTER);
  play = false;
  gameMode=LIFE;

  grd = new Grid(NUM_ROWS, ROW_LENGTH, lifeDensity);

  sz=grd.sz;
}//setup

void draw() {
  runSimulation();
  displayInfo();
}//draw

void keyPressed() {
  if (key==' ') {
    play=!play;
  }
  if (key=='r') {
    play=false;
    grd = new Grid(NUM_ROWS, ROW_LENGTH, lifeDensity);
  }
  if (key=='b') {
    play=false;
    grd = new Grid(NUM_ROWS, ROW_LENGTH, 0);
  }
  if (key=='1') {
    gameMode=LIFE;
  }
  if (keyCode==UP) {
    if (speed<maxSpeed) {
      speed++;
    }
  }
  if (keyCode==DOWN) {
    if (speed>1) {
      speed--;
    }
  }
  if (keyCode==RIGHT) {
    if (gameMode<rules.length-1) {
      gameMode++;
    }
  }
  if (keyCode==LEFT) {
    if (gameMode>0) {
      gameMode--;
    }
  }
  if (key=='a') {
    if (lifeDensity>0) {
      lifeDensity-=5;
    }
  }
  if (key=='d') {
    if (lifeDensity<100) {
      lifeDensity+=5;
    }
  }
  if (key=='c') {
    if (colorScheme<colors.length-1) {
      colorScheme++;
    }
  }
  if (key=='z') {
    if (colorScheme>0) {
      colorScheme--;
    }
  }
}//keyPressed

void mousePressed() {
  if (mouseY>infoHeight) {
    int adjustedMouseY=mouseY-infoHeight;
    grd.grd[adjustedMouseY/sz][mouseX/sz].state=!grd.grd[adjustedMouseY/sz][mouseX/sz].state;
  }
}
void mouseDragged() {
  if (mouseY>infoHeight) {
    int adjustedMouseY=mouseY-infoHeight;
    if (0<mouseX && mouseX<width && 0<adjustedMouseY && adjustedMouseY<height) {
      if ((pmouseX/sz!=mouseX/sz || (pmouseY-infoHeight)/sz!=adjustedMouseY/sz)&&mouseY<height) {
        grd.grd[adjustedMouseY/sz][mouseX/sz].state=!grd.grd[adjustedMouseY/sz][mouseX/sz].state;
      }
    }
  }
}
String mode(int game) {
  if (game==LIFE) {
    return "Life\nRule: B3/S23";
  }
  if (game==REPLICATOR) {
    return "Replicator\nRule: B1357/S1357";
  }
  if (game==SEEDS) {
    return "Seeds\nRule: B2/S";
  }
  if (game==RULE4) {
    return "Rule 4\nRule: B25/S4";
  }
  if (game==LIFE_WITHOUT_DEATH) {
    return "Life without Death\nRule: B3/S012345678";
  }
  if (game==LIFE34) {
    return "34 Life\nRule: B34/S34";
  }
  if (game==DIAMOEBA) {
    return "Diamoeba\nRule: B35678/S5678";
  }
  if (game==TWOBYTWO) {
    return "2x2\nRule: B36/S125";
  }
  if (game==HIGHLIFE) {
    return "High Life\nRule: B36/S23";
  }
  if (game==DAYANDNIGHT) {
    return "Day & Night\nRule: B3678/S34678";
  }
  if (game==MORLEY) {
    return "Morley\nRule: B368/S245";
  }
  if (game==ANNEAL) {
    return "Anneal\nRule: B4678/S35678";
  }
  return "PROGRAM ERROR: RESTART SIMULATION";//this line should never be reached, but the function needs a backup return statement in case none of the if statements can be reached
}
void runSimulation() {
  if (frameCount%(maxSpeed+1-speed)==0) {
    grd.displayAll();
    if (play) {
      grd.playSim(grd.neighbors8(), gameMode);
    }
  }
}
void displayInfo() {
  fill(colors[colorScheme][2]);
  stroke(colors[colorScheme][2]);
  rect(0, 0, width, infoHeight);
  fill(0);
  textSize(infoHeight/6);
  textAlign(LEFT,CENTER);
  text("Simulation: "+mode(gameMode)+"\nSpeed: "+speed+"\nLife density on reset: "+lifeDensity+"%", width/24, infoHeight/2); // display current game mode and speed
  textSize(infoHeight/10);
  //textAlign(CENTER,CENTER);
  text("Controls:\nleft/right arrow to switch simulation\nspace to pause/unpause\nr to reset randomly; b to clear\nup/down arrow to change speed\nclick/drag mouse to change cell state\na/d to change life density on reset\nz/c to change color scheme", width/2, infoHeight/2);
}
