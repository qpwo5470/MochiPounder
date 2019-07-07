class MochiGold extends Mochi {
  int lastmoved = 0;
  float speedX = 0;
  float speedY = 0;
  MochiGold(PImage img) {
    super(img);
    this.horizontal = int(random(2)) == 0;
    this.timeLimit = 5000;
    this.point = 10;
  }
  void move() {
    posX += speedX;
    posY += speedY;
    if (millis()-lastmoved > 1000) {
      speedX = random(-20, 20);
      speedY = random(-20, 20);
    }
  }
}
