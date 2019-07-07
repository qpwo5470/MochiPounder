class MochiBoss extends Mochi {
  int lives = 80;
  int lastSpawnTime = 0;
  int spawnInterval = 1000;
  ArrayList<Mochi>mochisgay;
  int lastmoved = 0;
  float speedX = 0;
  float speedY = 0;
  PImage blackMochi;

  MochiBoss(PImage img, PImage black, ArrayList<Mochi> mochisgay) {
    super(img);
    this.posX = width/2;
    this.posY = height/2;
    this.point = 1;
    this.mochisgay = mochisgay;
    blackMochi = black;
    size = 600;
    timeLimit = 1000000;
  }
  void display() {
    imageMode(CENTER);
    image(mochiImg, posX, posY, size/3*2, size/3*2);
    if (millis()-spawnTime > timeLimit) {
      live = false;
    }
    rectMode(CORNER);
    fill(0);
    rect(100, height-150, width-200, 50);
    fill(0, 255, 0);
    rect(100, height-150, map(lives, 0, 100, 0, width-200), 50);
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
    if (millis()%80 == 0) {
      posX += random(-300, 300);
      posY += random(-300, 300);
    }
    if (posX <= 0 || posX >= 1920) {
      posX = width/2;
    }
    if (posY <= 0 || posY >= 1080) {
      posY = height/2;
    }
  }
  void pound() {
    println(lives);
    lives --;
    if (lives < 1) {
      live = false;
      this.point = 1000;
    }
  }
}
