import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ycgame extends PApplet {




//Sound
Minim minim;
AudioPlayer bgm;
AudioPlayer slap;

//IMAGES
PImage [] background = new PImage[4];
PImage img1, img2;
;
PImage tempPounder;
PImage tempWall;
PImage main;
PImage gameover;
PImage [] mochies = new PImage[5];
PImage logo;
PImage storymode;
PImage title;

//VIDEOS
Movie intro;
Movie ending;


//OBJECTS
ArrayList<Hammer>hammers=new ArrayList<Hammer>();
YC yc;
ArrayList<Mochi>mochisgay = new ArrayList<Mochi>();

//VARIABLES
int status = 0;
int stage = 0;

int[] dir = {0, 0, 0, 0};

int lastSpawnTime = 0;
int spawnInterval = 750;

int score = 0;
int threshold = 25;

float time = 1000;
float clock = 0;

int[] stageTime = {60, 45, 30, 100};

boolean bossExist = false;

//CHEAT
String scoreCode = "wwssadad";
String scoreCode2 = "WWSSADAD";
String text = "wwwwwwww";

public void setup() {
  minim = new Minim(this);
  
  imageMode(CENTER);
  rectMode(CENTER);
  intro = new Movie(this, "intro.mp4");
  ending = new Movie(this, "ending.mp4");
  logo = loadImage("epicgamers.png");
  storymode = loadImage("storymode.png");
  title = loadImage("title.png");
  background[0] = loadImage("background1.png");
  background[1] = loadImage("background2.png");
  background[2] = loadImage("background3.png");
  background[3] = loadImage("background2.png");
  img1 = loadImage("yc1.png");
  img2 = loadImage("yc2.png");
  main = loadImage("main.png");
  tempPounder=loadImage("hammer.png");
  mochies[0] = loadImage("MOCHI_PINK.png");
  mochies[1] = loadImage("MOCHI_GREEN.png");
  mochies[2] = loadImage("MOCHI_BLACK.png");
  mochies[3] = loadImage("MOCHI_GOLD.png");
  mochies[4] = loadImage("giant_mochi.png");
  tempWall=loadImage("obstacle.png");
  gameover = loadImage("gameover.jpg");
  bgm = minim.loadFile("bgm.mp3");
  slap = minim.loadFile("slap2.mp3");
  intro.play();
}

public void draw() {
  scale(PApplet.parseFloat(width)/1920.0f);
  switch(status) {
  case 0:  //Intro Vid
    image(intro, width/2, height/2, width, height);
    if (intro.duration() - intro.time() <= 0.5f) {
      status++;
    }
    break;
  case 1:  //Main Screen
    background(main);
    image(logo, 1750, 120, 200, 200);
    image(title, 1600, 280, 900, 300);
    image(storymode, 1600, 700, 600, 150);

    break;
  case 2:  //Gameplay
    background(background[stage]);
    gameplay();
    break;
  case 3:  //Game Over
    if (bgm.isPlaying()) {
      bgm.pause();
      bgm.rewind();
    }
    image(gameover, width/2, height/2, width, height);
    noStroke();
    fill(0);
    rectMode(CENTER);
    rect(width/2, height/2, 840, 200);
    textSize(140);
    textAlign(CENTER, CENTER);
    fill(255);
    text("GAME OVER", width/2, height/2);
    break;
  case 4:  //Ending Credit
    image(ending, width/2, height/2, width, height);
    if (ending.duration() - ending.time() <= 0.5f) {
      status = 1;
    }
    break;
  }
}

public void gameplay() {
  autoSpawn();
  yc.move();
  yc.display();

  for (int i=0; i<mochisgay.size(); i++) {
    Mochi gaymochi = mochisgay.get(i);
    gaymochi.display();
    gaymochi.move();
  }

  for (int i=0; i<hammers.size(); i++) {
    Hammer part=hammers.get(i);
    part.display();
    part.move();
  }

  interaction();

  //GAME INTERFACE
  textSize(60);
  for (int x = -3; x < 4; x++) {
    for (int y = -3; y < 4; y++) {
      textAlign(LEFT, TOP);
      fill(255);
      text("POINTS:"+score, 20+x, y);
      textAlign(CENTER, TOP);
      clock=millis();
      text("TIME:"+nfc((time-clock)/1000, 1), 940+x, y);
    }
  }
  textAlign(LEFT, TOP);
  fill(0);
  text("POINTS:"+score, 20, 0);
  textAlign(CENTER, TOP);
  clock=millis();
  text("TIME:"+nfc((time-clock)/1000, 1), 940, 0);

  //Game Over
  if (clock >= time) {
    if (score >= threshold) {
      if (stage < 3) {
        stage++;
        setStage(stage);
      } else if (stage == 3) {
        ending.play();
        status = 4;
      } else {
        status = 3;
      }
    } else {
      status = 3;
    }
  }
}

public void setStage(int stageValue) {
  hammers = new ArrayList<Hammer>();
  yc = new YC(img1, img2, img1);
  mochisgay = new ArrayList<Mochi>();
  score = 0;
  clock = 0;
  threshold = 25 + stageValue*10;
  if (stageValue == 3) threshold = 500;
  time = stageTime[stageValue]*1000;
  time += millis();
}

public void interaction() {
  //actual interaction
  for (int i=0; i<hammers.size(); i++) {
    Hammer hammer=hammers.get(i);
    for (int j=0; j<mochisgay.size(); j++) {
      Mochi gaymochi = mochisgay.get(j);
      //check if they are hit
      float[] hammerPos = hammer.getPos();
      float[] mochiPos = gaymochi.getPos();
      float distance = dist(mochiPos[0], mochiPos[1], hammerPos[0], hammerPos[1]);
      if (distance < hammer.getSize()+gaymochi.getSize()) {
        slap.rewind();
        slap.play();
        hammer.pound();
        gaymochi.pound();
        score+=gaymochi.getPoint();
      }
    }
  }
  //removing dead stuffs
  for (int i=0; i<hammers.size(); i++) {
    Hammer hammer=hammers.get(i);
    if (!hammer.isUnpound()) {
      hammers.remove(hammers.indexOf(hammer));
      i--;
    }
  }
  for (int i=0; i<mochisgay.size(); i++) {
    Mochi gaymochi = mochisgay.get(i);
    if (!gaymochi.isLive()) {
      mochisgay.remove(mochisgay.indexOf(gaymochi));
      i--;
    }
  }
}

public void autoSpawn() {
  if (stage < 3) {
    if (millis()>lastSpawnTime+spawnInterval) {
      //spawn
      int type=PApplet.parseInt(random(100));
      if (type<40) {
        spawn(0);
      } else if (type<70) {
        spawn(1);
      } else if (type<95) {
        spawn(2);
      } else {
        spawn(3);
      }
      lastSpawnTime = millis();
    }
  } else {
    if (bossExist == false) {
      spawn(4);
      bossExist = true;
    }
    if (millis()>lastSpawnTime+spawnInterval) {
      //spawn
      int type=PApplet.parseInt(random(100));
      if (type<75) {
        spawn(2);
      } else {
        spawn(3);
      }
      lastSpawnTime = millis();
    }
  }
}

public void spawn(int type) {
  switch(type) {
  case 0:
    mochisgay.add(new MochiPink(mochies[0]));
    break;
  case 1:
    mochisgay.add(new MochiGreen(mochies[1]));
    break;
  case 2:
    mochisgay.add(new MochiBlack(mochies[2]));
    break;
  case 3:
    mochisgay.add(new MochiGold(mochies[3]));
    break;
  case 4:
    mochisgay.add(new MochiBoss(mochies[4], mochies[2], mochisgay));
    break;
  }
}

public void mousePressed() {
  switch(status) {
  case 0:  //Intro Vid

    break;
  case 1:  //Main Screen
    if (1600-300<=mouseX && mouseX<=1600+300 && 625<=mouseY && mouseY<=775) {
      setStage(stage);
      status = 2;
      bgm.loop();
    }
    break;
  case 2:  //Gameplay
    if (hammers.size() == 0) {
      hammers.add(new Hammer(tempPounder, yc.getPosX(), yc.getPosY(), PApplet.parseFloat(mouseX)*1920.0f/PApplet.parseFloat(width), PApplet.parseFloat(mouseY)*1920.0f/PApplet.parseFloat(width)));
    }
    break;
  case 3:  //Game Over
    break;
  case 4:  //Ending Credit
    break;
  }
}

public void keyPressed() {
  text = text.substring(1) + key;

  if (text.equals(scoreCode) || text.equals(scoreCode2)) {
    score += 10;
  }
  switch(status) {
  case 0:  //Intro Vid

    break;
  case 1:  //Main Screen

    break;
  case 2:  //Gameplay
    if (key == 'w' || key == 'W') {
      dir[0]=8;
    }
    if (key == 'a' || key == 'A') {
      dir[1]=4;
    }
    if (key == 's' || key == 'S') {
      dir[2]=2;
    }
    if (key == 'd' || key == 'D') {
      dir[3]=1;
    }
    int dirSum = 0;
    for (int i = 0; i<dir.length; i++) {
      dirSum += dir[i];
    }
    yc.setDirection(dirSum);
    break;
  case 3:  //Game Over
    if (key == ' ') {
      status = 1;
    }
    break;
  case 4:  //Ending Credit
    break;
  }
}

public void keyReleased() {
  switch(status) {
  case 0:  //Intro Vid

    break;
  case 1:  //Main Screen

    break;
  case 2:  //Gameplay
    if (key == 'w' || key == 'W') {
      dir[0]=0;
    }
    if (key == 'a' || key == 'A') {
      dir[1]=0;
    }
    if (key == 's' || key == 'S') {
      dir[2]=0;
    }
    if (key == 'd' || key == 'D') {
      dir[3]=0;
    }
    int dirSum = 0;
    for (int i = 0; i<dir.length; i++) {
      dirSum += dir[i];
    }
    yc.setDirection(dirSum);
    break;
  case 3:  //Game Over
    break;
  case 4:  //Ending Credit

    break;
  }
}

public void movieEvent(Movie m) {
  m.read();
}
class Hammer {
  //Variables
  float posX; 
  float posY;
  float speedX;
  float speedY;
  float speed=15;
  int size = 35;
  PImage pounder; 
  float rotAngle=0;
  boolean unpound = true;
  //Constructor
  Hammer(PImage pounder, float posX, float posY, float mouseX, float mouseY) {
    this.pounder=pounder;
    this.posX=posX;
    this.posY=posY;
    float d=dist(posX, posY, mouseX, mouseY);
    float dx=mouseX-posX;
    float dy=mouseY-posY;
    speedX=(dx/d)*speed;
    speedY=(dy/d)*speed;
  } 
  //Methods (Functions)
  public void move() {
    posX+=speedX;
    posY+=speedY;
    rotAngle+=0.5f;
    if((posX<0 || posX>1920) || (posY<0 || posY>1080)){
      unpound = false;
    }
  }
  public void display() {
    imageMode(CENTER);
    pushMatrix();
    translate(posX, posY);
    rotate(rotAngle);
    image(pounder, 0, 0, size, size);
    popMatrix();
  }
  //Return
  public float[] getPos() {
    float[] tempPos = {posX, posY};
    return tempPos;
  }
  
  public void pound(){
    unpound = false;
  }
  
  public boolean isUnpound(){
    return unpound;
  }
  
  public int getSize(){
    return size;
  }
  
}
//This mochi is the parent
class Mochi {
  float posX, posY;
  float centerX, centerY;
  float speed = 5;
  int size = 80;
  int actualSize = PApplet.parseInt(size*.25f);
  PImage mochiImg;
  float spawnTime;
  float timeLimit;
  int point;
  boolean live = true;
  boolean horizontal;


  Mochi(PImage img) {
    this.mochiImg = img;
    this.posX = random(1920);
    this.posY = random(1080);
    this.centerX = posX;
    this.centerY = posY;
    this.horizontal = PApplet.parseInt(random(2)) == 0;
    this.spawnTime = millis();
    this.timeLimit=random(12000, 15000);
    this.point=1;
  }

  public void display() {
    imageMode(CENTER);
    image(mochiImg, posX, posY, size, size);
    if (millis()-spawnTime > timeLimit) {
      live = false;
    }
  }

  public void move() {
    if (horizontal) {
      posX += speed;
      if (abs(posX-centerX) > 100) {
        speed = -speed;
      }
    } else { //vertical movement
      posY += speed;
      if (abs(posY-centerY) > 100) {
        speed = -speed;
      }
    }
  }

  public float[] getPos() {
    float[] tempPos = {posX, posY};
    return tempPos;
  }

  public void pound() {
    live = false;
  }

  public boolean isLive() {
    return live;
  }

  public int getSize() {
    return actualSize;
  }
  public int getPoint() {
    return point;
  }
}
class MochiBlack extends Mochi {
  MochiBlack(PImage img) {
    super(img);
    this.point=-2;
  }

  public void move() {
  }
}
class MochiBoss extends Mochi {
  int lives = 80;
  int lastSpawnTime = 0;
  int spawnInterval = 1000;
  ArrayList<Mochi>mochisgay;
  int lastmoved = 0;
  float speedX = 0;
  float speedY = 0;
  PImage blackMochi;

  MochiBoss(PImage img, PImage black, ArrayList<Mochi> mochisgay) {
    super(img);
    this.posX = width/2;
    this.posY = height/2;
    this.point = 1;
    this.mochisgay = mochisgay;
    blackMochi = black;
    size = 600;
    timeLimit = 1000000;
  }
  public void display() {
    imageMode(CENTER);
    image(mochiImg, posX, posY, size/3*2, size/3*2);
    if (millis()-spawnTime > timeLimit) {
      live = false;
    }
    rectMode(CORNER);
    fill(0);
    rect(100, height-150, width-200, 50);
    fill(0, 255, 0);
    rect(100, height-150, map(lives, 0, 100, 0, width-200), 50);
  }

  public void move() {
    posX += speedX;
    posY += speedY;
    if (millis()-lastmoved > 1000) {
      speedX = random(-5, 5);
      speedY = random(-5, 5);
    }
    if (millis()>lastSpawnTime+spawnInterval) {
      mochisgay.add(new MochiGray(blackMochi, posX, posY));
      lastSpawnTime = millis();
    }
    if (millis()%80 == 0) {
      posX += random(-300, 300);
      posY += random(-300, 300);
    }
    if (posX <= 0 || posX >= 1920) {
      posX = width/2;
    }
    if (posY <= 0 || posY >= 1080) {
      posY = height/2;
    }
  }
  public void pound() {
    println(lives);
    lives --;
    if (lives < 1) {
      live = false;
      this.point = 1000;
    }
  }
}
class MochiGold extends Mochi {
  int lastmoved = 0;
  float speedX = 0;
  float speedY = 0;
  MochiGold(PImage img) {
    super(img);
    this.horizontal = PApplet.parseInt(random(2)) == 0;
    this.timeLimit = 5000;
    this.point = 10;
  }
  public void move() {
    posX += speedX;
    posY += speedY;
    if (millis()-lastmoved > 1000) {
      speedX = random(-20, 20);
      speedY = random(-20, 20);
    }
  }
}
class MochiGray extends Mochi {
  float speedX;
  float speedY;
  
  MochiGray(PImage img, float positionX, float positionY) {
    super(img);
    posX = positionX;
    posY = positionY;
    speedX = random(-10,10);
    speedY = random(-10,10);
    this.point=-5;
  }
  public void move() {
    posX += speedX;
    posY += speedY;
    if (posX <= 0 || posX >= 1920) {
      live = false;
    }
    if (posY <= 0 || posY >= 1080) {
      live = false;
    }
  }
}
class MochiGreen extends Mochi{
  MochiGreen(PImage img) {
    super(img);
    
    
    this.point=2;
    
  }
}
class MochiPink extends Mochi{
  
  MochiPink(PImage img) {
    super(img);
    this.point = 1;

  }

  public void move(){
    
  }
}
class Obstacle {
  int originXpos;
  int originYpos;
  PImage wall;

  Obstacle(PImage wall, int originXpos, int originYpos) {
    this.wall=wall;
    this.originXpos=originXpos;
    this.originYpos=originYpos;
  }

  public boolean hit(float posX, float posY) {
    float d=dist(originXpos, originYpos, posX, posY);
    if (d<50) {
      return true;
    } else {
      return false;
    }
  }
}
class YC {
  int hp = 3;
  int direction = 0;
  float sizeX = 43;
  float sizeY = 130;
  float constrainGap = 5;
  float speed = 4;
  float posX = 450;
  float posY = 450;
  PImage image;
  PImage img1, img2;
  PImage death;

  YC (PImage img1, PImage img2, PImage death) {
    this.img1 = img1;
    this.img2 = img2;
    this.image = img1;
    this.death = death;
  }
  public void display() {
    if (direction >0) {
      image = (PApplet.parseInt(millis()/150)%2 == 0)? img1:img2;
    }
    image(image, posX, posY, sizeX, sizeY);
  }
  public void move() {
    switch (direction) {
    case 1:
      posX += speed;
      break;
    case 3:
      posX += speed/sqrt(2);
      posY += speed/sqrt(2);
      break;
    case 2:
      posY += speed;
      break;
    case 6:
      posX -= speed/sqrt(2);
      posY += speed/sqrt(2);
      break;
    case 4: 
      posX -= speed;
      break;
    case 12:
      posX -= speed/sqrt(2);
      posY -= speed/sqrt(2);
      break;
    case 8:
      posY -= speed;
      break;
    case 9:
      posX += speed/sqrt(2);
      posY -= speed/sqrt(2);
      break;
    }
    if (posX <= 0 + sizeX/2) {
      posX = constrainGap + sizeX/2;
    } else if (posX >= 1920 - sizeX/2) {
      posX = 1920-constrainGap - sizeX/2;
    }
    if (posY <= 0 + sizeY/2) {
      posY = constrainGap + sizeY/2;
    } else if (posY >= 1080 - sizeY/2) {
      posY = 1080-constrainGap - sizeY/2;
    }
  }
  public void setDirection(int dir) {
    direction = dir;
  }
  public float getPosX() {
    return posX;
  }
  public float getPosY() {
    return posY;
  }
}
  public void settings() {  size (1920, 1080); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "ycgame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
