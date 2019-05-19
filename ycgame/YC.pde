class YC {
  int hp = 3;
  int direction = 0;
  float speed = 10;
  float posX = 0;
  float posY = 0;
  PImage image;
  PImage death;

  YC (PImage image, PImage death) {
    this.image = image;
    this.death = death;
  }
  void display() {
    image(image, posX, posY, 100, 140);
  }
  void move() {
    switch (direction) {
    case 1:
      posX += speed;
      break;
    case 3:
      posX += speed/sqrt(2);
      posY += speed/sqrt(2);
      break;
    case 2:
      posY += speed;
      break;
    case 6:
      posX -= speed/sqrt(2);
      posY += speed/sqrt(2);
      break;
    case 4: 
      posX -= speed;
      break;
    case 12:
      posX -= speed/sqrt(2);
      posY -= speed/sqrt(2);
      break;
    case 8:
      posY -= speed;
      break;
    case 9:
      posX += speed/sqrt(2);
      posY -= speed/sqrt(2);
      break;
    }
  }
  void setDirection(int dir) {
    direction = dir;
  }
}
