import ddf.minim.*;

//Sound
Minim minim;
AudioPlayer bgm;
AudioPlayer slap;

//IMAGES
PImage background;
PImage img1, img2;
PImage tempPounder;
PImage tempWall;
PImage [] mochies = new PImage[4];

//OBJECTS
ArrayList<Hammer>hammers=new ArrayList<Hammer>();
YC yc;
ArrayList<Mochi>mochisgay = new ArrayList<Mochi>();

//VARIABLES
int[] dir = {0, 0, 0, 0};
int lastSpawnTime = 0;
int spawnInterval = 5000;


void setup() {
  minim = new Minim(this);
  size (1920, 1080);
  imageMode(CENTER);
  background = loadImage("mochibackground.png");
  img1 = loadImage("yc1.png");
  img2 = loadImage("yc2.png");
  tempPounder=loadImage("hammer.png");
  mochies[0] = loadImage("MOCHI_PINK.png");
  mochies[1] = loadImage("MOCHI_GREEN.png");
  mochies[2] = loadImage("MOCHI_BLACK.png");
  mochies[3] = loadImage("MOCHI_GOLD.png");
  tempWall=loadImage("obstacle.png");
  bgm = minim.loadFile("bgm.wav");
  slap = minim.loadFile("slap2.mp3");
  yc = new YC(img1, img2, img1);
  bgm.loop();
}

void draw() {
  scale(float(width)/1920.0);
  background(background);
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
  if (millis()>lastSpawnTime+spawnInterval) {
    //spawn
    spawn(0);
    lastSpawnTime = millis();
  }
}

void spawn(int type) {
  switch(type){
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
  }
}

void mousePressed() {
  if (hammers.size() == 0) {
    hammers.add(new Hammer(tempPounder, yc.getPosX(), yc.getPosY(), float(mouseX)*1920.0/float(width), float(mouseY)*1920.0/float(width)));
  }
}

void keyPressed() {
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
}

void keyReleased() {
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
}
