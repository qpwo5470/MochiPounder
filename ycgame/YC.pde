class YC {
  int hp = 3;
  int direction = 0;
  float sizeX = 76;
  float sizeY = 134;
  float constrainGap = 5;
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
    image(image, posX, posY, sizeX, sizeY);
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
    if (posX <= 0 + sizeX/2) {
      posX = constrainGap + sizeX/2;
    } else if (posX >= width - sizeX/2) {
      posX = width-constrainGap - sizeX/2;
    }
    if (posY <= 0 + sizeY/2) {
      posY = constrainGap + sizeY/2;
    } else if (posY >= height - sizeY/2) {
      posY = height-constrainGap - sizeY/2;
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
