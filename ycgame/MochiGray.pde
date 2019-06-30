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
  void move() {
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
