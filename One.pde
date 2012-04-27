class One {
  PVector position, velocity;
  int timer, step;
  boolean loopFlag = false;
  Robot robot;
  float xmag, ymag = 0;
  float newXmag, newYmag = 0;
  int a, b, c, d, e, f, p, w, w1, w2;
  int [][] maze;
  int [] mz, path = new int [4];
  float[] rightHandX = { 44, 43, 56, 57, 71, 72, 10,  0,  9, 14,
                         18, 11, 23, 29, 34, 30, 41, 44, 48, 46,
                         61, 62};
  float[] rightHandY = { 88, 67, 65, 45, 45,103, 99, 28, 26, 53,
                         51,  4,  4, 47, 47,  2,  1, 45, 45,  0,
                          1, 45};
  float[] leftHandX =  { 35, 33, 14, 13,  0,  2, 69, 71, 64, 60, 
                         57, 59, 49, 45, 42, 42, 31, 28, 25, 23,
                          8,  7};
  float[] leftHandY =  { 90, 65, 63, 42, 40,106,109, 31, 29, 60,
                         59, 10,  7, 57, 57,  3,  0, 53, 52,  2,
                          1, 41};
  ArrayList tree;
  
  One() {}
    
  void setup() {
    background(255);
    position = new PVector(423, 290);
    velocity = new PVector(1, 0);
    timer = 154;
    //timer = 0;
    step = -1;
    //step = 19;
    try { robot = new Robot(); }
    catch (AWTException e) { exit(); }
    w = 5;
    w1 = w - 1;
    w2 = 2*w - 1;
    f = 31;
    c = 0;
    d = 0;
    e = f-1;
    maze = new int [f][f];
    tree = new ArrayList();
    loopFlag = false;
    stroke(0);
  }
  
  void draw() {
    noCursor();
    
    if (loopFlag) {
      if (step == 7) {
        background(255);
        pushMatrix();
        translate(502, 368);
        newXmag = mouseX/float(width) * TWO_PI;
        newYmag = mouseY/float(height) * TWO_PI;  
        float diff = xmag-newXmag;
        if (abs(diff) >  0.01) { xmag -= diff/4.0; }
        diff = ymag-newYmag;
        if (abs(diff) >  0.01) { ymag -= diff/4.0; }
        rotateX(-ymag); 
        rotateY(-xmag);
        noFill();
        box(138);
        popMatrix();
      }
      
      if (step == 21) {
        if (tree.size() < 10000) {
        for (int i = tree.size()-1; i >= 0; i--) {
          Branch branch = (Branch) tree.get(i);
          branch.update();
          branch.render();
          if (branch.timeToBranch()) {
            tree.remove(i);
            tree.add(branch.branch( 90f));
            tree.add(branch.branch(-90f));
          }
        }
        }
      }
    } else {
      if (step >= 0 && step < 17) {      
        timer--;
        point(position.x, position.y);
        position.add(velocity);
      }
      
      if (step > 16 && step < 19) {
        pushMatrix();
        translate(423, 289);
        fill(0);
        noStroke();
        p = 0;
        if (c > 0) { if (maze[c-1][d] == 0) { path[p++] = 1; }}
        if (d > 0) { if (maze[c][d-1] == 0) { path[p++] = 2; }}
        if (c < e) { if (maze[c+1][d] == 0) { path[p++] = 4; }}
        if (d < e) { if (maze[c][d+1] == 0) { path[p++] = 8; }}
        if (p > 0) {
          timer--;
          p = path[floor(random(p))];
          maze[c][d] += p;
          switch(p) {
          case 1:
            maze[--c][d] = 4;
            rect(c*w+1, d*w+1, w2, w1);
            break;
          case 2:
            maze[c][--d] = 8;
            rect(c*w+1, d*w+1, w1, w2);
            break;
          case 4:
            rect(c*w+1, d*w+1, w2, w1);
            maze[++c][d] = 1;
            break;
          case 8:
            rect(c*w+1, d*w+1, w1, w2);
            maze[c][++d] = 2;
            break;
          }
        } 
        else {
          p = 0;
          while (p == 0) {
            c = floor(random(f));
            d = floor(random(f));
            p = maze[c][d];
          }
        }
        popMatrix();
      }
      
      if (step == 18) {
        pushMatrix();
        noStroke();
        fill(255,10);
        translate(414,373);
        scale(1.5);
        beginShape();
        vertex(0,108);
        bezierVertex(-5,-7,59,0,59,0);
        bezierVertex(81,3,101,16,108,39);
        bezierVertex(126,99,126,220,126,220);
        vertex(137,220);
        vertex(141,-63);
        vertex(-21,-62);
        vertex(-18,108);
        endShape(CLOSE);
        popMatrix();
      }   
    }
    
    // State machine controlled by step
    if (timer == 0) {
      switch(step) {
        case 0:
          velocity.set(0, 1, 0);
          timer = 154;
          step++;
          break;
        case 1:
          velocity.set(-1, 0, 0);
          timer = 154;
          step++;
          break;
        case 2:
          velocity.set(0, -1, 0);
          timer = 154;
          step++;
          break;
        case 3:
          position.set(423+16+2, 290+16+1, 0);
          velocity.set(1, 0, 0);
          timer = 124;
          step++;
          break;
        case 4:
          velocity.set(0, 1, 0);
          timer = 125;
          step++;
          break;
        case 5:
          velocity.set(-1, 0, 0);
          timer = 125;
          step++;
          break;
        case 6:
          velocity.set(0, -1, 0);
          timer = 126;
          robot.mouseMove(0, 0);
          step++;
          break;
        case 7:
          loopFlag = true;
          break;
        case 8:
          loopFlag = false;
          background(255);
          rect(424, 290, 154, 154);
          rect(423+16+2, 290+16+1, 125, 125);
          position.set(423+16+2, 290+16+1, 0);
          velocity.set(1, 0, 0);
          timer = 124;
          stroke(255);
          step++;
          break;
        case 9:
          velocity.set(0, 1, 0);
          timer = 125;
          step++;
          break;
        case 10:
          velocity.set(-1, 0, 0);
          timer = 125;
          step++;
          break;
        case 11:
          velocity.set(0, -1, 0);
          timer = 126;
          step++;
          break;
        case 12:
          position.set(423, 290, 0);
          velocity.set(1, 0, 0);
          timer = 154;
          step++;
          break;
        case 13:
          velocity.set(0, 1, 0);
          timer = 154;
          step++;
          break;
        case 14:
          velocity.set(-1, 0, 0);
          timer = 154;
          step++;
          break;
        case 15:
          velocity.set(0, -1, 0);
          timer = 154;
          step++;
          break;
        case 16:
          timer = 960;
          step++;
          break;
        case 17:
          background(255);
          timer = 960;
          c = f/2;
          d = f-1;
          for (a=0;a<f;a++) {
            mz = maze[a];
            for (b=0;b<f;b++) {
              mz[b] = 0;
            }
          }
          step++;
          break;
        case 18:
          pushMatrix();
          translate(414,373);
          scale(1.5);
          // Delete gray maze
          noStroke();
          fill(255);
          beginShape();
          vertex(0,108);
          bezierVertex(-5,-7,59,0,59,0);
          bezierVertex(81,3,101,16,108,39);
          bezierVertex(126,99,126,220,126,220);
          vertex(137,220);
          vertex(141,-63);
          vertex(-21,-62);
          vertex(-18,108);
          endShape(CLOSE);
          popMatrix();
          step++;
          break;
        case 19:
          break;
        case 20:
          pushMatrix();
          translate(414,373);
          scale(1.5);          
          // Draw face
          stroke(0);
          noFill();
          beginShape();
          vertex(30,169);
          vertex(27,109);
          vertex(0,108);
          bezierVertex(-5,-7,59,0,59,0);
          bezierVertex(81,3,101,16,108,39);
          bezierVertex(126,99,126,220,126,220);
          vertex(32,214);
          vertex(30,169);
          bezierVertex(30,169,38,174,61,168);
          endShape();
          // Draw eye
          beginShape();
          vertex(31,68);
          bezierVertex(31,68,42,86,56,70);
          endShape();
          popMatrix();
          // Draw right hand
          pushMatrix();
          translate(309,584);
          beginShape();
          for (int i = 0; i < rightHandX.length; i++) {
            vertex(rightHandX[i], rightHandY[i]);
          }
          endShape();
          popMatrix();
          // Draw left hand
          pushMatrix();
          translate(673,569);
          beginShape();
          for (int i = 0; i < leftHandX.length; i++) {
            vertex(leftHandX[i], leftHandY[i]);
          }
          endShape();
          popMatrix();
          break;
        case 21:
          loopFlag = true;
          Branch branch = new Branch(new PVector(498, 373), new PVector(0f, -1f), 100);
          tree.add(branch);
          break;
      }
    }
  }
  
  void keyPressed() {
    if (step == -1 && key == ' ') step++;
    if (step ==  7 && key == ' ') step++;
    if (step == 20 && key == ' ') step++;
    if (step == 19 && key == ' ') step++;
  }
}

class Branch {
  PVector loc;
  PVector vel;
  float timer;
  float timerstart;

  Branch(PVector l, PVector v, float n) {
    loc = l.get();
    vel = v.get();
    timerstart = n;
    timer = timerstart;
  }
  
  void update() {
    loc.add(vel);
  }
  
  void render() {
    stroke(0);
    point(loc.x,loc.y);
  }
  
  boolean timeToBranch() {
    timer--;
    if (timer < 0) {
      return true;
    } else {
      return false;
    }
  }

  Branch branch(float angle) {
    float theta = vel.heading2D();
    float mag = vel.mag();
    theta += radians(angle);
    PVector newvel = new PVector(mag*cos(theta),mag*sin(theta));
    return new Branch(loc,newvel,timerstart*0.66f);
  }  
}
