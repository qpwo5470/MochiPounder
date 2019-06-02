//This mochi is the parent
class Mochi {
  float posX, posY;
  float centerX, centerY;
  float speed = 5;
  int size = 80;
  int actualSize = int(size*.25);
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
    this.horizontal = int(random(2)) == 0;
    this.timeLimit=random(12000,15000);
    this.point=1;
    this.spawnTime=millis();
  }

  void display() {
    imageMode(CENTER);
    image(mochiImg, posX, posY, size, size);
    if(millis()-spawnTime>timeLimit){
      live=false;
    }
  }

  void move() {
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

  float[] getPos() {
    float[] tempPos = {posX, posY};
    return tempPos;
  }

  void pound() {
    live = false;
  }

  boolean isLive() {
    return live;
  }

  int getSize() {
    return actualSize;
  }
  int getPoint(){
    return point;
  }
}
