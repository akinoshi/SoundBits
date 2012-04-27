import processing.opengl.*;
import netP5.*;
import oscP5.*;
import java.awt.*;

One sceneOne;
Two sceneTwo;
Three sceneThree;
int scene = 1;
int cntOne = 0;
int cntTwo = 0;
OscP5 oscP5;

void init() {
  frame.dispose();
  frame.setUndecorated(true);
  super.init();
}

void setup() {
  oscP5 = new OscP5(this, 12000);
  size(1024, 768, OPENGL);
  //background(255);
  sceneOne = new One();
  sceneTwo = new Two();
  sceneThree = new Three();
  sceneOne.setup();
  sceneTwo.setup();
  sceneThree.setup();
  frame.setLocation(0,0);
}

void draw() {
  if (scene == 1) sceneOne.draw();
  if (scene == 2) sceneTwo.draw();
  if (scene == 3) sceneThree.draw();
}

void keyPressed() {
  if (scene == 1) sceneOne.keyPressed();
  if (scene == 2) sceneTwo.keyPressed();
  if (scene == 3) sceneThree.keyPressed();
  if (key == 10) {
    scene++;
    if (scene > 3) scene = 1;
    if (scene == 1) sceneOne.setup();
    if (scene == 2) sceneTwo.setup();
    if (scene == 3) background(255);
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/test")) cntOne = theOscMessage.get(0).intValue();
  if (theOscMessage.addrPattern().equals("/test2")) cntTwo = theOscMessage.get(0).intValue();
  //println(cntOne + " : " + cntTwo);
}


