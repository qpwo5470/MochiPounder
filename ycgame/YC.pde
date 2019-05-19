class YC {
  int hp = 3;
  int direction = 0;
  float size = 100;
  float speed = 10;
  float posX = 450;
  float posY = 450;
  PImage image;
  PImage death;

  YC (PImage image, PImage death) {
    this.image = image;
    this.death = death;
  }
  void display() {
    image(image, posX, posY, size, size*1.5);
  }
  void move() {
    if (posX > 0 + size && posX < 1920 - size && posY > 0 + size && posY < 1080 - size) {
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
    } else {
      if (posX <= 0 + size) {
        posX = 5 + size;
      } else if (posX >= 1920 - size) {
        posX = 1915 - size;
      }
      if (posY <= 0 + size*1.5) {
        posY = 5 + size*1.5;
      } else if (posY >= 1080 - size*1.5) {
        posY = 1075 - size*1.5;
      }
    }
  }
  void setDirection(int dir) {
    direction = dir;
  }
  float getPosX() {
    return posX;
  }
  float getPosY() {
    return posY;
  }
}
