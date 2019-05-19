PImage img;
YC yc;
int[] dir = {0, 0, 0, 0};

void setup() {
  size (800, 800);
  img = loadImage("image/yc.png");
  yc = new YC(img, img);
}

void draw() {
  background(255);
  yc.move();
  yc.display();
  println(dir);
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
