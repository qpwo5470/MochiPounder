class Obstacle {
  int originXpos;
  int originYpos;
  PImage wall;
  
  Obstacle(PImage wall,int originXpos, int originYpos){
    this.wall=wall;
    this.originXpos=originXpos;
    this.originYpos=originYpos;
    float d=dist(originXpos,originYpos,posX,posY);
  }
  
}
