ArrayList<Hammer>hammers=new ArrayList<Hammer>();
PImage tempPounder;
void setup(){
  size(1000,1000);
  tempPounder=loadImage("hammer.png");
}
void draw(){
  background(255);
  for(int i=0;i<hammers.size();i++){
    Hammer part=hammers.get(i);
    part.display();
    part.move();
  }

}
void mousePressed(){
  hammers.add(new Hammer(tempPounder,450,450,mouseX,mouseY));
}
