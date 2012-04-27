float cZoom;

class Two {
  Window w = new Window(300, 300, width*4);
  ArrayList windows;
  ArrayList points;
  int stopWindow = -1;
  int leapCnt = 0;
  int counter = 0;
  int mode = 0;
  float xmag, ymag = 0;
  float newXmag, newYmag = 0;
  boolean chairFlag = false;
  boolean bgFlag = true;
  float cRed;
  float cGreen;
  float cBlue;

  Two() {}
  
  void setup() {
    windows = new ArrayList();
    points = new ArrayList();
    addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
      public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
        mouseWheel(evt.getWheelRotation());
    }});
    //println("MRT Performance Initialized");
    background(255);
  }
  
  void draw() {
    if (bgFlag) background(255);
    rotateY(radians(40));
    
    for (int i = 0; i < windows.size(); i++) {
      Window window = (Window) windows.get(i);
      window.update();
    }
    
    for (int i = 0; i < windows.size(); i++) {
      Window window = (Window) windows.get(i);
      window.display();
    }
    
    if (stopWindow > 0) {
      //strokeWeight(2);
      stroke(0);
      noFill();
        
      for (int i = 0; i < leapCnt*3; i=i+3) {  
        bezier((Float)points.get(i),
        (Float)points.get(i+1),
        (Float)points.get(i+2),
        (Float)points.get(i),
        (Float)points.get(i+1),
        (Float)points.get(i+2)+500.0,
        (Float)points.get(i+3),
        (Float)points.get(i+4),
        (Float)points.get(i+5)+500.0,
        (Float)points.get(i+3),
        (Float)points.get(i+4),
        (Float)points.get(i+5));
      }
      
      // Draws a last leap line as red color
      if (leapCnt > 0) {
        stroke(255, 0, 0);
        int m = leapCnt*3-3;
        bezier((Float)points.get(m),
          (Float)points.get(m+1),
          (Float)points.get(m+2),
          (Float)points.get(m),
          (Float)points.get(m+1),
          (Float)points.get(m+2)+500.0,
          (Float)points.get(m+3),
          (Float)points.get(m+4),
          (Float)points.get(m+5)+500.0,
          (Float)points.get(m+3),
          (Float)points.get(m+4),
          (Float)points.get(m+5));
      }
    }
    
    if (cntOne > 0) {
      switch (mode) {
      case 1:
        windows.add(new Window(300, 300, width*4));
        break;
      case 2:
        if (stopWindow < windows.size()-1) {
          stopWindow++;
          Window window = (Window) windows.get(stopWindow);
          window.stop();
          points.add(window.targetPos);
          points.add(window.y);
          points.add(-window.z);
        }
        break;
      case 3:
        if (leapCnt < points.size()/3 - 1) {
          leapCnt++;
        }
        break;
      case 4:
        if (leapCnt > 0) {
          leapCnt--;
        }
        break;
      case 5:
        cRed = random(255);
        cGreen = random(255);
        cBlue = random(255);
        break;
      case 6:
        cZoom = random(100);
        break;
      default:
        break;
      }
      cntOne = 0;
    }
  
    if (chairFlag) {
    
    rotateY(radians(-40));
    translate(width/2, height/2, cZoom);
  
    newXmag = mouseX/float(width) * TWO_PI;
    newYmag = mouseY/float(height) * TWO_PI;
  
    float diff = xmag-newXmag;
    if (abs(diff) >  0.01) { 
      xmag -= diff/4.0; 
    }
  
    diff = ymag-newYmag;
    if (abs(diff) >  0.01) { 
      ymag -= diff/4.0; 
    }
  
    rotateX(-ymag); 
    rotateY(-xmag); 
    
    scale(200);
    stroke(0);
    //strokeWeight(2);
    //fill(0, 128, 0, 100);
    fill(cRed, cGreen, cBlue, 100);
  
    // Left-Top Triangle
    beginShape();
    vertex(-0.95,  1.00,  0.00);
    vertex(-1.00,  0.60, -0.05);
    vertex(-1.00,  1.00,  0.05);
    endShape(CLOSE);
  
    // Left Surface
    beginShape();
    vertex(-1.00,  1.00,  0.05);
    vertex(-1.00,  0.60, -0.05);
    vertex(-1.00,  0.20, -0.10);  
    bezierVertex(-1.00,  0.12, -0.12,
                 -1.00,  0.12, -0.12,
                 -1.00,  0.10, -0.20);
    vertex(-1.00,  0.10, -0.75);
    vertex(-1.00,  0.00, -0.75);
    vertex(-1.00, -0.05,  0.05);
    vertex(-1.00,  0.20,  0.05);
    endShape(CLOSE);
  
    // Left-Top Seat
    beginShape();
    vertex( 0.00,  0.10, -0.20);
    vertex( 0.00,  0.10, -0.80);
    vertex(-0.95,  0.10, -0.80);
    vertex(-1.00,  0.10, -0.75);
    vertex(-1.00,  0.10, -0.20);
    endShape(CLOSE);  
  
    // Left Seat & Back Joint
    beginShape();
    vertex( 0.00,  0.20, -0.10);
    bezierVertex( 0.00,  0.12, -0.12,
                  0.00,  0.12, -0.12,
                  0.00,  0.10, -0.20);
    vertex(-1.00,  0.10, -0.20);
    bezierVertex(-1.00,  0.12, -0.12,
                 -1.00,  0.12, -0.12,
                 -1.00,  0.20, -0.10);
    endShape(CLOSE);
    
    // Left-Front Back
    beginShape();
    vertex(-0.05,  1.00,  0.00);
    vertex( 0.00,  0.60,  0.00);
    vertex( 0.00,  0.20, -0.10);
    vertex(-1.00,  0.20, -0.10);
    vertex(-1.00,  0.60, -0.05);
    vertex(-0.95,  1.00,  0.00);
    vertex(-0.90,  1.00,  0.00);
    bezierVertex(-0.80,  1.00,  0.025,
                 -0.10,  1.00,  0.025,
                 -0.05,  1.00,  0.00);
    endShape(CLOSE);
    
    // Left-Front Surface
    beginShape();
    vertex( 0.00,  0.10, -0.80);
    vertex( 0.00,  0.00, -0.80);
    vertex(-0.95,  0.00, -0.80);
    vertex(-0.95,  0.10, -0.80);
    endShape(CLOSE);
  
    // Left-Front Curve
    beginShape();
    vertex(-1.00,  0.10, -0.75);
    vertex(-1.00,  0.00, -0.75);
    vertex(-0.95,  0.00, -0.80);
    vertex(-0.95,  0.10, -0.80);
    endShape(CLOSE);
  
    //---------------------------------------------------------------
  
    // Right-Top Triangle
    beginShape();
    vertex( 0.95,  1.00,  0.00);
    vertex( 1.00,  0.60, -0.05);
    vertex( 1.00,  1.00,  0.05);
    endShape(CLOSE);
  
    // Right Surface
    beginShape();
    vertex( 1.00,  1.00,  0.05);
    vertex( 1.00,  0.60, -0.05);
    vertex( 1.00,  0.20, -0.10);  
    bezierVertex( 1.00,  0.12, -0.12,
                  1.00,  0.12, -0.12,
                  1.00,  0.10, -0.20);
    vertex( 1.00,  0.10, -0.75);
    vertex( 1.00,  0.00, -0.75);
    vertex( 1.00, -0.05,  0.05);
    vertex( 1.00,  0.20,  0.05);
    endShape(CLOSE);
  
    // Right-Top Seat
    beginShape();
    vertex( 0.00,  0.10, -0.20);
    vertex( 0.00,  0.10, -0.80);
    vertex( 0.95,  0.10, -0.80);
    vertex( 1.00,  0.10, -0.75);
    vertex( 1.00,  0.10, -0.20);
    endShape(CLOSE);  
  
    // Right Seat & Back Joint
    beginShape();
    vertex( 0.00,  0.20, -0.10);
    bezierVertex( 0.00,  0.12, -0.12,
                  0.00,  0.12, -0.12,
                  0.00,  0.10, -0.20);
    vertex( 1.00,  0.10, -0.20);
    bezierVertex( 1.00,  0.12, -0.12,
                  1.00,  0.12, -0.12,
                  1.00,  0.20, -0.10);
    endShape(CLOSE);
    
    // Right-Front Back
    beginShape();
    vertex( 0.05,  1.00,  0.00);
    vertex( 0.00,  0.60,  0.00);
    vertex( 0.00,  0.20, -0.10);
    vertex( 1.00,  0.20, -0.10);
    vertex( 1.00,  0.60, -0.05);
    vertex( 0.95,  1.00,  0.00);
    vertex( 0.90,  1.00,  0.00);
    bezierVertex( 0.80,  1.00,  0.025,
                  0.10,  1.00,  0.025,
                  0.05,  1.00,  0.00);
    endShape(CLOSE);
    
    // Right-Front Surface
    beginShape();
    vertex( 0.00,  0.10, -0.80);
    vertex( 0.00,  0.00, -0.80);
    vertex( 0.95,  0.00, -0.80);
    vertex( 0.95,  0.10, -0.80);
    endShape(CLOSE);
  
    // Right-Front Curve
    beginShape();
    vertex( 1.00,  0.10, -0.75);
    vertex( 1.00,  0.00, -0.75);
    vertex( 0.95,  0.00, -0.80);
    vertex( 0.95,  0.10, -0.80);
    endShape(CLOSE);
  
  //--------------------------------------------------------------
  
    // Center-Front
    beginShape();
    vertex(-0.05,  1.00,  0.00);
    vertex( 0.00,  0.60,  0.00);
    vertex( 0.05,  1.00,  0.00);
    endShape(CLOSE);
  
    // Top Surface
    beginShape();
    vertex(-1.00,  1.00,  0.05);
    vertex( 1.00,  1.00,  0.05);
    vertex( 0.95,  1.00,  0.00);
    bezierVertex( 0.10,  1.00,  0.025,
                  0.80,  1.00,  0.025,
                  0.05,  1.00,  0.00);
    vertex(-0.05,  1.00,  0.00);
    bezierVertex(-0.10,  1.00,  0.025,
                 -0.80,  1.00,  0.025,
                 -0.95,  1.00,  0.00);
    endShape(CLOSE);
    }
  }

  void keyPressed() {
    if (key == 'a') {
      windows.add(new Window(300, 300, width*4));
    }
    
    // Manually stops a window
    if (key == 's') {
      if (stopWindow < windows.size()-1) {
        stopWindow++;
        Window window = (Window) windows.get(stopWindow);
        window.stop();
        points.add(window.targetPos);
        points.add(window.y);
        points.add(-window.z);
      }
    }
    
    // Manually adds a leap line
    if (key == 'l') {
      if (leapCnt < points.size()/3 - 1) {
        leapCnt++;
      }
    }
    
    // Deletes a last leap line
    if (key == 'd') {
      if (leapCnt > 0) {
        leapCnt--;
      }
    }
    
    // Clears all windows and leap lines
    if (key == 'c') {
      windows.clear();
      points.clear();
      stopWindow = -1;
      leapCnt = 0;
    }
    
    if (key == 32) {
      chairFlag = !chairFlag; 
    }
    
    if (key == 'p') {
      cRed = random(255);
      cGreen = random(255);
      cBlue = random(255); 
    }
    
    if (key == 't') bgFlag = !bgFlag;
    
    if (key == '0') mode = 0;
    if (key == '1') mode = 1;
    if (key == '2') mode = 2;
    if (key == '3') mode = 3;
    if (key == '4') mode = 4;
    if (key == '5') mode = 5;
    if (key == '6') mode = 6;
    if (key == '7') mode = 7;
    if (key == '8') mode = 8;
    if (key == '9') mode = 9;
  }

}

// MRT window class
class Window {
  float wWidth;
  float wHeight;
  float wPos;                // Position
  float wRed;
  float wGreen;
  float wBlue;        
  float velocity;            // Velocity
  float accel;               // Acceleration
  float force;               // Force
  float targetPos;           // Target position
  float y;
  float z;
  boolean stopped = false;   // Stop flag
  
  // Spring simulation constants
  float M = 0.8;             // Mass
  float K = 0.2;             // Spring constant
  float D = 0.92;            // Damping
  
  float S = 40;              // Speed (speed of window moving)
  float R = 200;             // Range (range of window stopping)
  
  Window(float w, float h, float pos) {
    wWidth = w;
    wHeight = h;
    wPos = pos;
    wRed = random(255);
    wGreen = random(255);
    wBlue = random(255);
    stopped = false;
    y = random(-height, height*2);
    z = random(height*3);
  }
  
  void update() {
    if (stopped) {
      force = -K * (wPos - targetPos);
      accel = force / M;                  // Set the acceleration
      velocity = D * (velocity + accel);  // Set the velocity
      wPos = wPos + velocity;             // Update position
    } else {
      wPos = wPos - S;
      if (wPos < -width/2) {
        wPos = width*4;
      }
    }
  }
  
  void display() {
    noStroke();
    pushMatrix();
    translate(wPos, y, -z);
    beginShape();
    fill (wRed, wGreen, wBlue, 100);
    vertex(-1 * wWidth/2, -1 * wHeight/2);
    vertex( 1 * wWidth/2, -1 * wHeight/2);
    vertex( 1 * wWidth/2,  1 * wHeight/2);
    vertex(-1 * wWidth/2,  1 * wHeight/2);
    endShape();
    popMatrix();
  }
  
  void stop() {
    stopped = true;
    targetPos = wPos - R;
  }
}

void mouseWheel(int delta) {
  cZoom += 5*float(delta);
}

