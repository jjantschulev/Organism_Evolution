class Food {
  boolean eaten;
  PVector pos;
  float size;
  Food(){
    pos = new PVector(random(0,width), random(0,height));
    eaten = false;
    size = random(7, 14);
  }
  
  void update () {
    if(random(1)<0.03&&size<random(18, 23)){
      size++;
    }
  }
  
  void show () {
    fill(0, 255, 0);
    ellipse(pos.x, pos.y, size, size);
  }
  
}