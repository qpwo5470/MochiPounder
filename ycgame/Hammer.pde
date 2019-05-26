class Hammer {
  //Variables
  float posX; 
  float posY;
  float speedX;
  float speedY;
  float speed=15;
  int size = 70;
  PImage pounder; 
  float rotAngle=0;
  boolean unpound = true;
  //Constructor
  Hammer(PImage pounder, float posX, float posY, float mouseX, float mouseY) {
    this.pounder=pounder;
    this.posX=posX;
    this.posY=posY;
    float d=dist(posX, posY, mouseX, mouseY);
    float dx=mouseX-posX;
    float dy=mouseY-posY;
    speedX=(dx/d)*speed;
    speedY=(dy/d)*speed;
  } 
  //Methods (Functions)
  void move() {
    posX+=speedX;
    posY+=speedY;
    rotAngle+=0.5;
    if((posX<0 || posX>1920) || (posY<0 || posY>1080)){
      unpound = false;
    }
  }
  void display() {
    imageMode(CENTER);
    pushMatrix();
    translate(posX, posY);
    rotate(rotAngle);
    image(pounder, 0, 0, size, size);
    popMatrix();
  }
  //Return
  float[] getPos() {
    float[] tempPos = {posX, posY};
    return tempPos;
  }
  
  void pound(){
    unpound = false;
  }
  
  boolean isUnpound(){
    return unpound;
  }
  
  int getSize(){
    return size;
  }
  
}
