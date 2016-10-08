/* Sid Gupta
   April 1, 2016
   Makes a landscape with six elements (two players, tree, sun, cloud, and projectile), and uses mathematical concepts to calculate the projectiles motion based off of user input
   */

//set variables for calculations
boolean engagedP1 = false;
boolean engagedP2 = false;
int w = 0;
int h = 0;
int initialW;
int initialH = 320;
int vix =0;
int viy = 0;

//variables for making the parabola
int x1;
int x2;
float y1;
float y2;
float halfDist;
int parabolaH;
float halfT;
float xV;
float yV;
int y;
float a;
float b;
int x;

//variables for timer
float fullT;
float vDispl;
float startTime = millis();
int move;
float movePS;
boolean begin = false;
int counter;
//x coordinate variable for the cloud
int xC = 20;
  int sunX = 0;

void setup() {
  //sets up the size
  size(1400, 650);
}

void draw() {
  //draws the blue sky and  green ground
  background(162, 212, 255);
  fill(39, 118, 32);
  rect(0, 400, 1400, 400);
  
  //draws the red player one
  fill(245, 22, 22);
  rect(150, 300, 20, 100);
  triangle(150,300,160,290,170,300);
  //draws the blue player two
  fill(51, 106, 211);
  rect(1230, 300, 20, 100);
  triangle(1230,300,1240,290,1250,300);

  //draw the starting circles, coloured blue and are on the left and right of the landscape
  fill(25, 139, 132);
  ellipse(160, 320, 10, 10);
  ellipse(1240, 320, 10, 10);

  //draw the drag zone for both players (left and right) coloured yellow-ish and transparent
  fill(240, 150, 134, 135);
  rect(0, 320, 160, 480);
  rect(1240, 320, 160, 480);

  //draw the initial velocity arrow based off mouse input
  line(initialW, initialH, w+initialW, initialH-h);

  //begin custom shape (tree) coloured brown
  fill(170, 99, 5);
  beginShape();
  //point on tree at the ground
  vertex(650, 400);
  //point on tree above the ground
  vertex(665, 380);
  //point connecting first branch
  vertex(665, 330);
  //point branching out first branch
  vertex(650, 332);
  //tip of first branch
  vertex(620, 318);
  //point coming back into first branch
  vertex(652, 320);
  //point connecting second branch
  vertex(665, 325);
  //point branching out second branch
  vertex(653, 300);
  //tip of second branch
  vertex(627, 310);
  //second point on second branch
  vertex(648, 290);
  //point connecting third branch
  vertex(665, 310);
  //branching out third branch
  vertex(667, 279);
  //tip of third branch
  vertex(670, 260);
  //third point on third branch
  
  //all of these points are the same as above, but use 'diff' method to reflect all the points upon the line x=670
  vertex(diff(667), 279);
  vertex(diff(670), 310);
  vertex(diff(665), 290);
  vertex(diff(627), 310);
  vertex(diff(653), 300);
  vertex(diff(665), 325);
  vertex(diff(652), 320);
  vertex(diff(620), 318);
  vertex(diff(650), 332);
  vertex(diff(665), 330);
  vertex(diff(665), 380);
  vertex(diff(650), 400);
  //close shape
  endShape(CLOSE);  

  //draw yellow sun, can move with arrow keys
  fill(252, 252, 8);
  ellipse(sunX, 0, 200, 200);
  if(keyPressed==true && key==CODED){
    if(keyCode==LEFT){
      sunX-=5;
    }else if(keyCode==RIGHT){
      sunX+=5;
    }
  }


  //draw white moving cloud
  fill(255, 255, 255);
  //if the cloud goes out of bounds, wrap it back by resetting the x coordinate value
  if (xC+20>=1400) {
    xC=20;
  }
  //draw the cloud, and increment the x coordinate
  ellipse(xC, 100, 70, 70);
  xC++;


  fill(158, 66, 216);

  
  //if the user let go of the mouse click, launch the projectile
  if (begin==true) {
    //run this as many times as the number of x coordinates in the parabola
    if (counter<=move) {
      //if the first player launched it
      if (engagedP1==true) {
        //if the time has reached the increment time per second, move the x coordinate further and calculate the corresponding y coordinage
        if (movePS<=startTime) {
          x+=8;
          y = (int)((a*pow((x-xV), 2)+yV));
          //draw the new projectile
          ellipse(x, y, 10, 10);
          //reset the start time
          startTime = millis();
          //add 8 to the counter (since you moved 8 x coordinates)
          counter+=8;
        }
      } else if (engagedP2==true) {
        if (movePS<=startTime) {
          x-=8;
          y = (int)((a*pow((x-xV), 2)+yV));
          ellipse(x, y, 10, 10);
          startTime = millis();
          counter+=8;
        }
      }
    } else {
      //if the counter has reached its max x coordinates, then the projectile has finished its motion
      begin=false;
    }
  }
}




//method used to calculate the initial velocity and trajectory of the projectile based off user mouse input
void mouseDragged() {
  //if player 1 is shooting
  if (engagedP1==true) {
    //if they're within the drag zone
    if (mouseX>=0 && mouseX<=160) {
      if (mouseY>=320 && mouseY<=650) {
        //initial width is 160 from the far left
        initialW = 160;
        //calculates the horizontal component of velocity by getting distance between initial width and dragged point
        w = initialW-mouseX;
        //calculates the vertical component of velocity by getting distance between initial height and dragged point
        h = mouseY-320;
        //sets these values to variables
        vix = w;
        viy = h; 
        
        //using physics concepts and kinematics equations,
        //calculates the height of the parabola by getting the time it takes for the vertical velocity to reach zero, and then calculating vertical displacement
        halfT = (-viy)/-9.8;
        parabolaH = (int)((initialH) - (((viy)*(halfT))+(-4.9*(pow(halfT, 2)))));
        //calculates the range of the parabola by getting the horizontal displacement at half time and doubling it. sets these values to variables
        x1 = initialW;
        x2 = (int)(initialW + (2*(vix*halfT)));
        halfDist = initialW/2 + x2/2;
        //sets calculated values to variables
        y1 = initialH;
        y2 = initialH;
        xV = halfDist;
        yV = parabolaH;
        //the amount of x coordinates that will be moved
        move = x2-initialW;
        //calculates the total vertical displacement
        vDispl = (((viy)*(halfT))+(-4.9*(pow(halfT, 2))))/10;
        //calculates the total time it takes
        fullT = (sqrt((-vDispl/-4.9)))*1000;
        //calculates how often the x coordinates should increment
        movePS = fullT/move;
        x = 160;
      }
    }
    //almost identical kinematics equations and calculations used here as above, but simply modified to fit the reflected axis
  } else if (engagedP2==true) {
    if (mouseX>=1240 && mouseX<=1400) {
      if (mouseY>=320 && mouseY<=650) {
        initialW = 1240;
        w = initialW-mouseX;
        h = mouseY-320;
        vix = w;
        viy = h; 
        halfT = (-viy)/-9.8;
        parabolaH = (int)((initialH) - (((viy)*(halfT))+(-4.9*(pow(halfT, 2)))));
        x1 = (int)(initialW + (2*(vix*halfT)));
        x2 = initialW;
        halfDist = initialW/2 + x1/2;
        y1 = initialH;
        y2 = initialH;
        xV = halfDist;
        yV = parabolaH;
        move = initialW-x1;
        vDispl = (((viy)*(halfT))+(-4.9*(pow(halfT, 2))))/10;
        fullT = (sqrt((-vDispl/-4.9)))/1000;
        movePS = fullT/move;
        x = x2;
      }
    }
  }
}

//when mouse is released
void mouseReleased() {
  //reset width and height
  w = 0;
  h = 0;
  //calculate step pattern of parabola
  a = ((initialH-yV)/(pow((x2-xV), 2)));
  //start the timing loop and motion
  begin = true;
  startTime = millis();
  counter = 0;
}

void mousePressed() {
  //if they click within the player1 ellipse, they are controlling player1 motion
  if (mouseX>=150 && mouseX<=170) {
    if (mouseY>=310 && mouseY<=330) {
      engagedP1 = true;
      engagedP2 = false;
    }
    //if they click within the player2 ellipse, they are controlling player2 motion
  } else if (mouseX>=1230 && mouseX<=1250) {
    if (mouseY>=310 && mouseY<=330) {
      engagedP2 = true;
      engagedP1 = false;
    }
  }
}


//it was really weird having to deal with the negative y axis, so I made this method to make matters easier (converts from quadrant 2 to quadrant 1)
public static int flip(int val) {
  int xPos = 650-val;
  return xPos;
}

//calculates the distance from the line x=670 and adds it to 670 to reflect points on the tree
public static int diff(int val) {
  return ((670-val)+670);
}