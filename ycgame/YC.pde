class YC {
  int hp = 3;
  int direction = 0;
  float sizeX = 43;
  float sizeY = 130;
  float constrainGap = 5;
  float speed = 4;
  float posX = 450;
  float posY = 450;
  PImage image;
  PImage img1, img2;
  PImage death;

  YC (PImage img1, PImage img2, PImage death) {
    this.img1 = img1;
    this.img2 = img2;
    this.image = img1;
    this.death = death;
  }
  void display() {
    if (direction >0) {
      image = (int(millis()/150)%2 == 0)? img1:img2;
    }
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
    } else if (posX >= 1920 - sizeX/2) {
      posX = 1920-constrainGap - sizeX/2;
    }
    if (posY <= 0 + sizeY/2) {
      posY = constrainGap + sizeY/2;
    } else if (posY >= 1080 - sizeY/2) {
      posY = 1080-constrainGap - sizeY/2;
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
