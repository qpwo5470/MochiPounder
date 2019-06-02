class MochiPink {
  float posX, posY;
  float centerX, centerY;
  float speed = 5;
  int size = 80;
  int actualSize = int(size*.25);
  float timeLimit;
  float spawnTime;
  int point;
  boolean live = true;
  boolean horizontal;
  PImage mochiPink; 
  MochiPink(PImage mochiPink) {
    this.timeLimit=random(12,15);
    this.spawnTime=millis();
  }
}
