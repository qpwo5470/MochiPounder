PImage img;
ArrayList<Hammer>hammers=new ArrayList<Hammer>();
PImage tempPounder;
YC yc;
int[] dir = {0, 0, 0, 0};

void setup() {
  size (1920, 1080);
  imageMode(CENTER);
  img = loadImage("yc.png");
  tempPounder=loadImage("hammer.png");
  yc = new YC(img, img);
}

void draw() {
  background(255);
  yc.move();
  yc.display();
  for(int i=0;i<hammers.size();i++){
    Hammer part=hammers.get(i);
    part.display();
    part.move();
  }
}

void mousePressed(){
  hammers.add(new Hammer(tempPounder,yc.getPosX(),yc.getPosY(),mouseX,mouseY));
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
  for(int i = 0; i<dir.length; i++){
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
  for(int i = 0; i<dir.length; i++){
    dirSum += dir[i];
  }
  yc.setDirection(dirSum);
}
