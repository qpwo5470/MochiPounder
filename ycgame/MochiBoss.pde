class MochiBoss extends Mochi {
  int lives = 20;
  int lastSpawnTime = 0;
  int spawnInterval = 1000;
  ArrayList<Mochi>mochisgay;
  int lastmoved = 0;
  float speedX = 0;
  float speedY = 0;
  PImage blackMochi;

  MochiBoss(PImage img, PImage black, ArrayList<Mochi> mochisgay) {
    super(img);
    this.point=+100;
    this.mochisgay = mochisgay;
    blackMochi = black;
  }

  void move() {
    posX += speedX;
    posY += speedY;
    if (millis()-lastmoved > 1000) {
      speedX = random(-5, 5);
      speedY = random(-5, 5);
    }
    if (millis()>lastSpawnTime+spawnInterval) {
      mochisgay.add(new MochiGray(blackMochi, posX, posY));
      lastSpawnTime = millis();
    }
  }
  void pound() {
    lives --;
    if (lives < 1) {
      live = false;
    }
  }
}
