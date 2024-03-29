import processing.video.*;
import ddf.minim.*;

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

void setup() {
  minim = new Minim(this);
  size (1920, 1080);
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

void draw() {
  scale(float(width)/1920.0);
  switch(status) {
  case 0:  //Intro Vid
    image(intro, width/2, height/2, width, height);
    if (intro.duration() - intro.time() <= 0.5) {
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
    if (ending.duration() - ending.time() <= 0.5) {
      status = 1;
    }
    break;
  }
}

void gameplay() {
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

void setStage(int stageValue) {
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

void interaction() {
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

void autoSpawn() {
  if (stage < 3) {
    if (millis()>lastSpawnTime+spawnInterval) {
      //spawn
      int type=int(random(100));
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
      int type=int(random(100));
      if (type<75) {
        spawn(2);
      } else {
        spawn(3);
      }
      lastSpawnTime = millis();
    }
  }
}

void spawn(int type) {
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

void mousePressed() {
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
      hammers.add(new Hammer(tempPounder, yc.getPosX(), yc.getPosY(), float(mouseX)*1920.0/float(width), float(mouseY)*1920.0/float(width)));
    }
    break;
  case 3:  //Game Over
    break;
  case 4:  //Ending Credit
    break;
  }
}

void keyPressed() {
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

void keyReleased() {
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

void movieEvent(Movie m) {
  m.read();
}
