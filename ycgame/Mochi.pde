//This mochi is the parent
class Mochi{
  float posX, posY;
  PImage mochiImg;
  boolean live = true;
  
  Mochi(PImage img){
    this.mochiImg = img;
    this.posX = random(width);
    this.posY = random(height);
  }
  
  void display() {
    imageMode(CENTER);
    image(mochiImg, posX, posY
  
}
