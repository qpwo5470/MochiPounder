class MochiGray extends Mochi {
  float speedX;
  float speedY;
  
  MochiGray(PImage img, float positionX, float positionY) {
    super(img);
    posX = positionX;
    posY = positionY;
    speedX = random(-10,10);
    speedY = random(-10,10);
    this.point=-2;
  }
  void move() {
    posX += speedX;
    posY += speedY;
  }
}
