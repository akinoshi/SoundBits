int MOUNTAIN_MIN = 40;
int MOUNTAIN_MAX = 15;
float TREE_TOP = 0.75;
int SPIRAL_MIN = 10;
int SPIRAL_MAX = 15;
int RAIN_WIDTH = 100;
int BG_OFFSET = 150;
int GRADIENT_OFFSET = -100;
ObjectManager om;
Curve c;
Screenshot s;
boolean curveFlag = false;
boolean screenFlag = false;
int r = 255;
int targetR = 255;
int g = 255;
int targetG = 255;
int b = 255;
int targetB = 255;
ArrayList trees = new ArrayList();
boolean treeFlag = false;

class Three {  
  Three() {}
  
  void setup() {
    om = new ObjectManager();
    c = new Curve();
    //println("P360 Performance Initialized");
    background(255);
  }
  
  void draw() {
    background(255);

    if (!screenFlag) {
      // Increment or decrement color
      if (r > targetR) r--;
      if (r < targetR) r++;
      if (g > targetG) g--;
      if (g < targetG) g++;
      if (b > targetB) b--;
      if (b < targetB) b++;
      
      // Draw gradient on top  
      beginShape(QUADS);
      noStroke();
      fill(r,g,b);
      vertex(0,0);
      vertex(width,0);
      fill(255,255,255);
      vertex(width,height/2+GRADIENT_OFFSET);
      vertex(0,height/2+GRADIENT_OFFSET);
      endShape();
      
      drawShadowWorld();
      om.displayBG();
      
      om.update();
      om.display();
      
      if (curveFlag) {
        c.update();
        c.display();
      }
    }
    
    if (screenFlag) {
      s.update();
      s.display();
      if (s.x > width) {
        om.clear();
        screenFlag = false;
        r = 255;
        g = 255;
        b = 255;
        targetR = 255;
        targetG =255;
        targetB = 255;
        c.vectors.clear();
        c.vectorArray.clear();
        c.position = new PVector(width/2, height/2);
        c.vectorArray.add(new ArrayList());
        c = new Curve();
        curveFlag = false;
      }
    }
  
    // Yuen's part
    if (cntTwo == 1) {
      for (int i = 0; i < om.mountains.size(); i++) {
        Mountain m = (Mountain) om.mountains.get(i);
        m.amp = 1.0;
        m.move();
      }
      cntTwo = 0;
    }
    if (cntTwo == 2) {
      for (int i = 0; i < om.mountains.size(); i++) {
        Mountain m = (Mountain) om.mountains.get(i);
        m.amp = 2.0;
        m.move();
      }
      cntTwo = 0;
    }
  
    if (cntOne > 0) {
      if (treeFlag) trees.add(new Tree(int(map(cntOne, 50, 85, 0, width))));
      cntOne = 0;
    }
  
    for (int i = trees.size()-1; i >= 0; i--) {
        Tree tree = (Tree) trees.get(i);
        tree.update();
        tree.display();
        if (tree.y > height) trees.remove(i);
    }
    
    // Mouse pointer
    stroke(255,0,0);
    strokeWeight(2);
    point(mouseX,mouseY);
    strokeWeight(1);
  }
  
  void keyPressed() {
    switch(key) {
      case '1':
        om.addObject(1);
        break;
      case '2':
        om.addObject(2);
        break;
      case '3':
        om.addObject(3);
        break;
      case '4':
        om.addObject(4);
        break;
      case '5':  
        om.addObject(5);
        break;
      case '6':
        om.incBG();
        break;
      case '7':
        om.decBG();
        break;
      case 's':
        //save("P360.png");
        break;
      case 'q':
        om.removeHead();
        break;
      case 'w':
        om.removeTail();
        break;
      case 'l':
        om.toggleLine();
        break;
      case ' ':
        screenFlag = true;
        s = new Screenshot();
        trees.clear();
        treeFlag = false;
        break;
      case 'c':
        curveFlag = true;
        c.toggle();
        camera(width/2.0, height/2.0, (height/2.0) / tan(PI*60.0 / 360.0), width/2.0, height/2.0, 0, 0, 1, 0);
        break;
      case 'g':
        targetR = int(random(255));
        targetG = int(random(255));
        targetB = int(random(255));
        break;
      case 't':
        treeFlag = !treeFlag;
        break;
      case 'z':
        targetR = 255;
        targetG =255;
        targetB = 255;
        break;
    }
  }

}
//======================================================================
class Ball { 
  float x = width/2; 
  float y = height/2; 
  float xv = -3+random(6); 
  float yv = -random(4); 
  float maxYV = 20; 
  float gravity = 0.1; 
  float friction = 1; 
  //float radius = random(50) + 20;
  float radius = 20;
  color c = color(random(255),random(255),random(255));
   
  Ball(){  } 
 
  Ball(float xp,float yp) 
  { 
    x = xp; 
    y = yp;
  } 
 
  Ball(float xp,float yp,float xvel,float yvel) 
  { 
    this(xp, yp); 
    xv = xvel; 
    yv = yvel; 
  } 
 
  void run() 
  { 
    update(); 
    render(); 
  } 
 
  public void update() 
  { 
    if(x <= radius) 
    { 
      xv = abs(xv); 
    }  
    else if(x >= width - radius) 
    { 
      xv = -abs(xv); 
    } 
 
    if(y + radius >= height) 
    { 
      yv = -abs(yv); 
      if(y + radius - height >= 0.15) 
      { 
        y = height - radius; 
        if(yv > -0.1) 
        { 
          xv *= 0.96; 
        } 
      } 
    } 
 
    if((yv < maxYV)) 
    { 
      yv += gravity; 
    } 
    yv *= friction; 
    //println(yv); 
    y += yv; 
 
    x += xv; 
  } 
 
  void render() 
  { 
    noStroke();
    //fill(c);
    fill(51, 51, 51);
    ellipse(x,y,radius,radius); 
  }
  
  void drawBallShadow() {
    float x = 70.0;
    float y = 0.958 * height;
    pushMatrix();
    translate(0, height*0.666, 0);
    translate(0,0,0-y);
    rotateX(DEG_TO_RAD*x);
    translate(0,0, -10);
    noStroke();
    //fill(shadowColor);
    fill(0);
    
    noStroke();
    fill(168, 194, 193);
    ellipse(this.x,this.y,radius,radius);
    
    popMatrix();
  }
}
//======================================================================
class Bubble {
  float x, y;
  PVector position;
  PImage img;
  float w, h;
  float imgWidth, imgHeight;
  
  Bubble(PImage img) {
    position = new PVector(mouseX, mouseY);
    // Please load all the images at the main
    this.img = img;
    w = img.width / 10;
    h = img.height / 10;
  }
  
  void update() {
    imgWidth += w;
    if (imgWidth > img.width) imgWidth = img.width;
    //if (imgWidth > img.width || imgWidth < 0) w = -w;
    imgHeight += h;
    if (imgHeight > img.height) imgHeight = img.height;
    //if (imgHeight > img.height || imgHeight < 0) h = -h;  
  }
  
  void display() {
    imageMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    image(img, 0, 0, imgWidth, imgHeight);
    popMatrix();
    imageMode(CORNER);
  }
  
}
//======================================================================
class Curve {
  PVector position, velocity;
  ArrayList vectors;
  boolean deadFlag = false;
  float noiseX, noiseY;
  boolean cameraFlag = false;
  ArrayList vectorArray;
  
  Curve() {
    //position = new PVector(mouseX, mouseY);
    position = new PVector(width/2, height/2);
    //position = new PVector(width/4, height);
    //position = new PVector(0, height/2);
    velocity = new PVector();
    vectors = new ArrayList();
    noiseX = random(width);
    noiseY = random(height);
    //println("(noiseX, noiseY) = (" + noiseX + ", " + noiseY + ")");
    vectorArray = new ArrayList();
    vectorArray.add(new ArrayList());
  }

  void update() {
    velocity.x = 5 * (noise(noiseX / 10 + position.y / 100) - 0.5);
    velocity.y = 5 * (noise(noiseY / 10 + position.x / 100) - 0.5);
    position.add(velocity);
    
    if (position.x < 0 || position.x > width || position.y < 0 || position.y > height) {
      //deadFlag = true;
    }
    
    /*
    if(position.x<0)position.x+=width; 
    if(position.x>width)position.x-=width; 
    if(position.y<0)position.y+=height; 
    if(position.y>height)position.y-=height; 
    
    //vectors.add(new PVector(position.x, position.y));
    if (!deadFlag) vectors.add(new PVector(position.x, position.y));
    */
    
    if (position.x < 0) {
      position.x += width;
      vectorArray.add(new ArrayList());
    } else if (position.x > width) {
      position.x -= width;
      vectorArray.add(new ArrayList());
    } else if (position.y < 0) {
      position.y += height;
      vectorArray.add(new ArrayList());
    } else if (position.y > height) {
      position.y -= height;
      vectorArray.add(new ArrayList());
    }
    
    ArrayList vector = (ArrayList) vectorArray.get(vectorArray.size()-1);
    vector.add(new PVector(position.x, position.y));
  }

  void display() { 
    stroke(0); 
    noFill();
    //strokeWeight(2);
    //beginShape();
    
    for (int j = 0; j < vectorArray.size(); j++) {
    ArrayList vectors = (ArrayList) vectorArray.get(j);
    
    beginShape();
    for (int i = 0; i < vectors.size(); i++) {
      PVector vector = (PVector) vectors.get(i);
      vertex(vector.x, vector.y);
      //if (cameraFlag) camera(vector.x, vector.y, (height/2.0) / tan(PI*60.0 / 360.0), vector.x, vector.y, 0, 0, 1, 0);
      //if (cameraFlag) camera(vector.x, vector.y, height/10.0, vector.x, vector.y, 0, 0, 1, 0);
      if (cameraFlag && j == vectorArray.size()-1) camera(vector.x, vector.y, height/10.0, vector.x, vector.y, 0, 0, 1, 0);
    }
    endShape();
    
    }
    
    //endShape();
  }
  
  void toggle() {
    cameraFlag = !cameraFlag;
  }
}
//======================================================================
class Mountain {
// Spring simulation constants
float M = 0.8;   // Mass
float K = 0.2;   // Spring constant
float D = 0.92;  // Damping
float R = -120;    // Rest position
float movePos = 0;

// Spring simulation variables
float ps = -60.0; // Position
float vs = 0.0;  // Velocity
float as = 0;    // Acceleration
float f = 0;     // Force

float xpos, ypos;
Polygon p;
float amp = 1.0;

Mountain () {
  xpos = mouseX;
  ypos = mouseY;
  //R = random(-60, -20);
  R = -random(height/MOUNTAIN_MIN, height/MOUNTAIN_MAX);
  ps = 0.5 * R;
  movePos = 0.3 * R;
}

void update() {
  f = -K * (ps - R);    // f=-ky
  as = f / M;           // Set the acceleration, f=ma == a=f/m
  vs = D * (vs + as);   // Set the velocity
  ps = ps + vs;         // Updated position
  if(abs(vs) < 0.1) vs = 0.0;
  
  float b_width = 0.5 * ps + -8;
  int[] x = new int[3];
  x[0] = int(xpos);
  x[1] = int(xpos-b_width*amp);
  x[2] = int(xpos+b_width*amp);
  int[] y = new int[3];
  y[0] = int(ypos+ps*amp);
  y[1] = int(ypos);
  y[2] = int(ypos);
  p = new Polygon(x, y, 3);
}

void display() {  
  pushMatrix();
  translate(xpos, ypos);
  float b_width = 0.5 * ps + -8;
  //triangle(0, ps + 100, -b_width, 200, b_width, 200);
  noStroke();
  fill(249, 72, 78);
  //triangle(0, ps, -b_width, 0, b_width, 0);
  triangle(0, ps*amp, -b_width*amp, 0, b_width*amp, 0);
  popMatrix();
}

void move() {
  ps = movePos;
}

void drawMountainShadow() {
  float x = 70.0;
  float y = 0.958 * height;
  pushMatrix();
  translate(0, height*0.666, 0);
  translate(0,0,0-y);
  rotateX(DEG_TO_RAD*x);
  translate(0,0, -10);
  noStroke();
  //fill(shadowColor);
  fill(0);
  
  pushMatrix();
  translate(xpos, ypos);
  float b_width = 0.5 * ps + -8;
  //triangle(0, ps + 100, -b_width, 200, b_width, 200);
  noStroke();
  fill(168, 194, 193);
  triangle(0, ps*amp, -b_width*amp, 0, b_width*amp, 0);
  popMatrix();
  
  popMatrix(); 
}

}
//======================================================================
class ObjectManager {
  ArrayList balls;
  ArrayList bubbles;
  ArrayList mountains;
  ArrayList rains;
  ArrayList layers;
  ArrayList spirals = new ArrayList();
  PImage[] images;
  PImage[] bgs;
  boolean lineFlag = false;
  int cnt = -1;

  ObjectManager() {
    bubbles = new ArrayList();
    mountains = new ArrayList();
    balls = new ArrayList();
    layers = new ArrayList();
    rains = new ArrayList();
    images = new PImage[4];
    images[0] = loadImage("c0.png");
    images[1] = loadImage("c1.png");
    images[2] = loadImage("c2.png");
    images[3] = loadImage("c3.png");
    bgs = new PImage[29];
    for (int i = 0; i < 29; i++) {
      bgs[i] = loadImage("bg" + i + ".png");
    }
  }

  void addObject(int mode) {
    layers.add(mode);
    switch(mode) {
      case 1:
        mountains.add(new Mountain());
        break;
      case 2:
        rains.add(new Rain());
        break;
      case 3:
        balls.add(new Ball(mouseX, mouseY));
        break;
      case 4:
        bubbles.add(new Bubble(images[int(round(random(3)))]));
        break;
      case 5:
        spirals.add(new Spiral());
        break;
    }
    //println(layers.size());
  }

  void update() {
    int cntOne = 0;
    int cntTwo = 0;
    int cntThree = 0;
    for (int i = 0; i < layers.size(); i++) {
      switch((Integer) layers.get(i)) {
        case 1:
          Mountain mountain = (Mountain) mountains.get(cntOne);
          mountain.update();
          cntOne++;
          break;
        case 3:
          Ball ball = (Ball) balls.get(cntTwo);
          ball.update();
          cntTwo++;
          break;
        case 4:
          Bubble bubble = (Bubble) bubbles.get(cntThree);
          bubble.update();
          cntThree++;
          break;
      }
    }
    
    for (int i = 0; i < rains.size(); i++) {
      Rain rain = (Rain) rains.get(i);
      rain.update(this);
    }
    
  }
  
  void display() {
    int cntOne = 0;
    int cntTwo = 0;
    int cntThree = 0;
    int cntFive = 0;
    
    for (int i = 0; i < layers.size(); i++) {
      switch((Integer) layers.get(i)) {
        case 1:
          Mountain mountain = (Mountain) mountains.get(cntOne);
          mountain.display();
          cntOne++;
          break;
        case 3:
          Ball ball = (Ball) balls.get(cntTwo);
          ball.render();
          cntTwo++;
          break;
        case 4:
          Bubble bubble = (Bubble) bubbles.get(cntThree);
          bubble.display();
          cntThree++;
          break;
        case 5:
          Spiral spiral = (Spiral) spirals.get(cntFive);
          spiral.display();
          cntFive++;
          break;
      }
    }
    
    noFill();
    stroke(0);
    beginShape();
    int counter = 0;
    for (int i = 0; i < balls.size(); i++) {
      Ball ball = (Ball) balls.get(i);
      if (lineFlag) vertex(ball.x, ball.y);
    }
    endShape();
    
  }
  
  void removeHead() {
    if (layers.size() != 0) {
      switch((Integer) layers.get(0)) {
        case 1:
          mountains.remove(0);
          break;
        case 2:
          rains.remove(0);
          break;
        case 3:
          balls.remove(0);
          break;
        case 4:
          bubbles.remove(0);
          break;
        case 5:
          spirals.remove(0);
          break;
      }
      layers.remove(0);
    }
  }
  
  void removeTail() {
    if (layers.size() > 0) {
      switch((Integer) layers.get(layers.size()-1)) {
        case 1:
          mountains.remove(mountains.size()-1);
          break;
        case 2:
          rains.remove(rains.size()-1);
          break;
        case 3:
          balls.remove(balls.size()-1);
          break;
        case 4:
          bubbles.remove(bubbles.size()-1);
          break;
        case 5:
          spirals.remove(spirals.size()-1);
      }
      layers.remove(layers.size()-1);
    }
  }
  
  void toggleLine() {
    lineFlag = !lineFlag;
  }
  
  void displayBG() {
    pushMatrix();
    //scale(0.8333333);
    //scale(0.5333333);
    if (cnt != -1) image(bgs[cnt], 0, BG_OFFSET);
    popMatrix();
  }
  
  void incBG() {
    if (cnt < 28) cnt++;
  }
  
  void decBG() {
    if (cnt > -1) cnt--;
  }

  void clear() {
    balls.clear();
    bubbles.clear();
    mountains.clear();
    rains.clear();
    layers.clear();
    spirals.clear();
    cnt = -1;
  }
}
//======================================================================
class Rain {
  int x, y;
  ArrayList rain = new ArrayList();
  
  Rain() {
    x = mouseX;
    y = mouseY;
  }
  
  void update(ObjectManager om) {
    rain.add(new Drop(random(x-RAIN_WIDTH/2, x+RAIN_WIDTH/2), y, 0, random(6,8)));
    
    Drop rd;
    Polygon p;
      
    for (int i = rain.size()-1; i >=0; i--) {
      rd = (Drop) rain.get(i);
      
      for (int j = 0; j < om.mountains.size(); j++) {
      Mountain m = (Mountain) om.mountains.get(j);
      p = (Polygon) m.p;
        
      if (rd.y > height) {
        rain.remove(i);
        break;
      } else if (p.contains(rd.x,rd.y+rd.dy)) {
        rain.remove(i);
        break;
      }
      
      }
      
    }
    
    for (int i = 0; i < rain.size(); i++) {
      rd = (Drop) rain.get(i);
      rd.touch();
      rd.draw();
    }
      
    }
}

class Drop{
  float x,y;
  float dx,dy;
   
  Drop(float x, float dx, float dy){
    this.x = x;
    y = 90;
    this.dx = dx;
    this.dy = dy;
  }
  
  Drop(float x, float y, float dx, float dy){
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
  }
   
  void touch(){
    x += dx;
    y += dy;
  }
  
  void draw(){
    //stroke(82, 194, 196);
    stroke(0);
    line(x,y,x+dx,y+dy);
  }
}
//======================================================================
class Screenshot {
  PImage img;
  int x, y;
  int mode = int(random(3));
  
  Screenshot() {
    save("Screenshot.png");
    img = loadImage("Screenshot.png");
  }
  
  void update() {
    x += 50;
    //x = int(random(width));
  }
  
  void display() {
    //image(img, 0, 0);
    //filter(BLUR, 5);
    //background(0);
    
    switch(mode) {
    
    case 0:
    // Split into two
    copy(img, 0,        0, width, height/2,  x,        0, width, height/2);
    copy(img, 0, height/2, width, height/2, -x, height/2, width, height/2);
    break;
    
    case 1:
    // Split into four
    copy(img, 0,          0, width, height/4,  x,          0, width, height/4);
    copy(img, 0,   height/4, width, height/4, -x,   height/4, width, height/4);
    copy(img, 0,   height/2, width, height/4,  x,   height/2, width, height/4);
    copy(img, 0, 3*height/4, width, height/4, -x, 3*height/4, width, height/4);    
    break;
    
    case 2:
    // Split into six
    copy(img, 0,          0, width, height/6,  x,          0, width, height/6);
    copy(img, 0,   height/6, width, height/6, -x,   height/6, width, height/6);
    copy(img, 0, 2*height/6, width, height/6,  x, 2*height/6, width, height/6);
    copy(img, 0, 3*height/6, width, height/6, -x, 3*height/6, width, height/6);
    copy(img, 0, 4*height/6, width, height/6,  x, 4*height/6, width, height/6);
    copy(img, 0, 5*height/6, width, height/6, -x, 5*height/6, width, height/6);
    break;
    
    case 3:
    // Split into eight
    copy(img, 0,          0, width, height/8,  x,          0, width, height/8);
    copy(img, 0,   height/8, width, height/8, -x,   height/8, width, height/8);
    copy(img, 0, 2*height/8, width, height/8,  x, 2*height/8, width, height/8);
    copy(img, 0, 3*height/8, width, height/8, -x, 3*height/8, width, height/8);
    copy(img, 0, 4*height/8, width, height/8,  x, 4*height/8, width, height/8);
    copy(img, 0, 5*height/8, width, height/8, -x, 5*height/8, width, height/8);
    copy(img, 0, 6*height/8, width, height/8,  x, 6*height/8, width, height/8);
    copy(img, 0, 7*height/8, width, height/8, -x, 7*height/8, width, height/8);    
    break;
    }
    
  }

}
//======================================================================
class Spiral {
  int   LATHE_STEPS=(int)random(10,20);
  float LATHE_STEP_SIZE=TWO_PI/LATHE_STEPS;
  //int numRings=(int)random(40,60);
  //int numRings=10;
  int numRings=(int)random(SPIRAL_MIN, SPIRAL_MAX);
  float xx=0,yy=0,px=0,py=0;
  float angle=0;
  float xoff=mouseX;
  float yoff=mouseY;
  float zoff=random(1000);
  float xscale=random(0.55,0.7);
  float noiseScale=random(0.05,0.2);
  float displace;
  float displaceF=random(10,20);
 
  float[][] vertexes;
  int vertCount;
  int x, y;
 
  Spiral() {    
    // set number of octaves and their amplitude falloff
    // used by the perlin noise function
    noiseDetail((int)random(2,5),random(0.6));
  
    // move to correct position
    translate(xoff,yoff);
    
    // initialize radius list
    // use a random radius for each angle
    float[] radList=new float[LATHE_STEPS];
    for(int i=0; i<LATHE_STEPS; i++) radList[i]=random(10);
    
    // setup 2D vertexlist
    float[][] vertexList=new float[LATHE_STEPS*numRings][2];
    vertexes = new float[LATHE_STEPS*numRings][2];
    vertCount=0;
        
    // sample noise space and create vertex list
    for(int i=0; i<numRings; i++) {
      for(int j=0; j<LATHE_STEPS; j++) {
        // compute current xy position
        xx=radList[j]*cos(angle);
        yy=radList[j]*sin(angle);
        // add point to vertex list
        vertexList[vertCount][0]=xx*xscale;
        vertexList[vertCount++][1]=yy;
        // compute noise at this point
        displace=noise((xoff+xx)*noiseScale,(yoff+yy)*noiseScale,zoff);
        // use the noise value to displace radius for the current angle
        radList[j]+=displaceF*displace;
        // on to the next direction
        angle+=LATHE_STEP_SIZE;
      }
      // continue with next ring
    }
    
    for(int j=0; j<vertCount; j++) {
      //vertex(vertexList[j][0]+random(-2,2),vertexList[j][1]+random(-4,4));
      //vertexes[j][0] = vertexList[j][0] + random(-2, 2);
      //vertexes[j][1] = vertexList[j][1] + random(-2, 2);
      vertexes[j][0] = vertexList[j][0];
      vertexes[j][1] = vertexList[j][1];
    }
    
    x = mouseX;
    y = mouseY;
  }
 
  void display() {
  
  // draw 10 slightly random copies of the computed spiral
  noFill();
  stroke(0);
  pushMatrix();
  
  beginShape();
  translate(x+random(-2,2), y+random(-2,2));
  for (int i = 0; i < vertCount; i++) {
    vertex(vertexes[i][0], vertexes[i][1]);
  }
  endShape();
  popMatrix();
  }
  
}
//======================================================================
class Tree {
  float x, y;

  Tree(int x) {
    this.x = x;
    //y = 3 * height / 4;
    y = TREE_TOP * height;
  }

  void update() {
    //y += height/60;
    y += height/120;
  }
  
  void display() {
    noStroke();
    fill(83, 174, 71);
    float newY = 2*(height-y)/3;
    ellipse(x, y+(height-y)/3, newY, newY);
    stroke(0);
    line(x, y, x, height);
    line(x, y+(height-y)/3, x+(newY/2)*sin(PI/4), (y+(height-y)/3)-(newY/2)*sin(PI/4));
    line(x-(newY/2), y+(newY/2), x, y+newY);
  }
  
  void drawTreeShadow() {
    float xpos = 70.0;
    float ypos = 0.958 * height;
    pushMatrix();
    translate(0, height*0.666, 0);
    translate(0,0,0-ypos);
    rotateX(DEG_TO_RAD*xpos);
    translate(0,0, -10);
    noStroke();
    //fill(shadowColor);
    fill(0);
    
    pushMatrix();
    noStroke();
    float newY = 2*(height-y)/3;
    fill(168, 194, 193);
    ellipse(x, y+(height-y)/3, newY, newY);
    popMatrix();
    
    popMatrix(); 
  }
}
//======================================================================
void drawShadowWorld(){
  float x = 70.0;
  float y = 0.958 * height;
  pushMatrix();
  translate(0, height*0.666, 0);
  translate(0,0,0-y);
  rotateX(DEG_TO_RAD*x);
  translate(0,0, -10);
  noStroke();
  //fill(shadowColor);
  fill(168, 194, 193);
  popMatrix();
  
  for (int i = 0; i < om.mountains.size(); i++) {
    Mountain m = (Mountain) om.mountains.get(i);
    m.drawMountainShadow();
  }
  
  for (int i = 0; i < om.balls.size(); i++) {
    Ball ball = (Ball) om.balls.get(i);
    ball.drawBallShadow();
  }
  
  for (int i = 0; i < trees.size(); i++) {
    Tree tree = (Tree) trees.get(i);
    tree.drawTreeShadow();
  }
}
