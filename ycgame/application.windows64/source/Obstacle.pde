class Obstacle {
  int originXpos;
  int originYpos;
  PImage wall;

  Obstacle(PImage wall, int originXpos, int originYpos) {
    this.wall=wall;
    this.originXpos=originXpos;
    this.originYpos=originYpos;
  }

  boolean hit(float posX, float posY) {
    float d=dist(originXpos, originYpos, posX, posY);
    if (d<50) {
      return true;
    } else {
      return false;
    }
  }
}
