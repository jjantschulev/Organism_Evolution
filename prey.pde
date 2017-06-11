class Prey {
  
  PVector pos, vel, acc, dir, random;
  float[] DNA;
  int hu;
  int lifespan, health, generation, children;
  float speed, awareness, accuracy, fierceness, instinct, iq, digestion;
  float yoff = random(100000);
  float size = 30;
  boolean dead;
  
  Prey (PVector _pos) {
    pos = new PVector();
    pos.set(_pos);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
    dir = new PVector(0,0);
    random = new PVector();
    DNA  = new float[7];
    lifespan = 0;
    health = 1000;
    generation = 0;
    dead = false;
    hu = floor(random(255));
  }
  
  void update () {
    updateDNAVariables();
    setRandom();
    if(closestPredetor() != null){
      if(dist(closestPredetor().pos.x, closestPredetor().pos.y, pos.x, pos.y)<awareness){
        dir.set(closestPredetor().pos.x - pos.x, closestPredetor().pos.y - pos.y);
        dir.mult(-1);
      }else{
        if(closestFood() != null){
          float distToFood = dist(closestFood().pos.x, closestFood().pos.y, pos.x, pos.y);
          if(dist(closestFood().pos.x, closestFood().pos.y, pos.x, pos.y)<awareness){
            dir.set(closestFood().pos.x - pos.x, closestFood().pos.y - pos.y);
          }else{
            dir.set(random.x - pos.x, random.y - pos.y);
          }
          if(distToFood<closestFood().size){
            health+=closestFood().size * 20;
            closestFood().eaten = true;
          }
        }else{
          dir.set(random.x - pos.x, random.y - pos.y);
        }
      }
    }else{
      if(closestFood() != null){
        float distToFood = dist(closestFood().pos.x, closestFood().pos.y, pos.x, pos.y);
        if(dist(closestFood().pos.x, closestFood().pos.y, pos.x, pos.y)<awareness){
          dir.set(closestFood().pos.x - pos.x, closestFood().pos.y - pos.y);
        }else{
          dir.set(random.x - pos.x, random.y - pos.y);
        }
        if(distToFood<closestFood().size){
          if(random(1)<accuracy){
            health+=closestFood().size * 16 * digestion;
          }
          closestFood().eaten = true;
        }
      }else{
        dir.set(random.x - pos.x, random.y - pos.y);
      }
    }
    //acc.set(dir);
    //acc.setMag(0.2);
    vel.add(dir);
    //vel.mult(0.96);
    vel.setMag(speed);
    pos.add(vel);
    
    if(lifespan>1000&&health>1000 && children<6){
      if(random(1)<0.008){
         reproduce();
         children++;
      }
    }
    
    health--;
    lifespan++;
    if(health<=0){
      dead = true;
    }
  }
  
  void show () {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir.heading() + PI/2);
    if(showDebug){
      if(currentMousePrey!=null){
        if(this == currentMousePrey){
          strokeWeight(5);
          stroke(255, 255,0);
          noFill();
          ellipse(0, 0, awareness*2, awareness*2);
        }else{
          strokeWeight(1);
          stroke(255);
          noFill();
          ellipse(0, 0, awareness*2, awareness*2);
        }
      }else{
        strokeWeight(1);
        stroke(255);
        noFill();
        ellipse(0, 0, awareness*2, awareness*2);
      }
    }
    noStroke();
    colorMode(HSB);
    fill(hu, 360, 360);
    colorMode(RGB);
    //fill(0, 255, 255, map(health, 0, 1000, 0, 255)); Jacob Schneider
    triangle(0, 0, 0, -20, -10, 10);
    triangle(0, 0, 0, -20, 10, 10);
    popMatrix();

  }
  
  Predetor closestPredetor(){
    if(predetors.size()>0){
      float distanceToPred = 1000000;
      Predetor closePred = predetors.get(0);
      for(int i = 0; i < predetors.size(); i++){
        Predetor predetor = predetors.get(i);
        if(dist(predetor.pos.x, predetor.pos.y, pos.x, pos.y)< distanceToPred){
          distanceToPred = dist(predetor.pos.x, predetor.pos.y, pos.x, pos.y);
          closePred = predetor;
        }
      }
      return closePred;
    }else{
      return null;
    }
  }
  
  void setDNA (float _speed, float _awareness, float _accuracy, float _fierceness, float _instinct, float _iq, float _digestion) {
    DNA[0] = _speed;
    DNA[1] = _awareness;
    DNA[2] = _accuracy;
    DNA[3] = _fierceness;
    DNA[4] = _instinct;
    DNA[5] = _iq;
    DNA[6] = _digestion;
  }
  void mutate(Prey babyOrganism){
    float[] mdna = babyOrganism.DNA;
    mdna[0] += random(-1, 1);
    mdna[1] += random(-8, 8);
    mdna[2] += random(-0.1, 0.1);
    mdna[3] += random(-6, 6);
    mdna[4] += random(-5, 5);
    mdna[5] += random(-10, 10);
    mdna[6] += random(-0.2, 0.2);
    babyOrganism.DNA = mdna;
  }
  
  Food closestFood() {
    if(foods.size()>0){
      float distanceToFood = 1000000;
      Food closestFood = foods.get(0);
      for(int i = 0; i < foods.size(); i++){
        Food food = foods.get(i);
        if(dist(food.pos.x, food.pos.y, pos.x, pos.y)< distanceToFood){
          distanceToFood = dist(food.pos.x, food.pos.y, pos.x, pos.y);
          closestFood = food;
        }
      }
      return closestFood;
    }else{
      return null;
    }
  }
  void reproduce () {
    Prey baby;
    baby = new Prey(pos);
    baby.setDNA(DNA[0],DNA[1],DNA[2], DNA[3], DNA[4], DNA[5], DNA[6]);
    baby.generation = generation + 1;
    mutate(baby);
    baby.hu = hu;
    prey.add(baby);
  }
  void updateDNAVariables(){
    speed = DNA[0];
    awareness = DNA[1];
    accuracy = DNA[2];
    fierceness = DNA[3];
    instinct = DNA[4];
    iq = DNA[5];
    digestion = DNA[6];
  }
  
  void setRandom () {
    random.set(constrain(map(noise(yoff), 0.4, 0.6, 0, width),0,width), constrain(map(noise(yoff+100), 0.4, 0.6, 0, height), 0, height));
    yoff+=0.006;
  }
}