class Predetor {
  
  PVector pos, vel, acc, dir, random;
  float[] DNA;
  int lifespan, health, generation, children;
  float speed, awareness, accuracy, fierceness, instinct, iq, digestion;
  float yoff = random(100000);
  
  Predetor(PVector _pos){
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
  }
  
  
  void update () {
    updateDNAVariables();
    setRandom();
    
    if(closestPrey() != null){
      if(dist(closestPrey().pos.x, closestPrey().pos.y, pos.x, pos.y)<awareness){
        dir.set(closestPrey().pos.x - pos.x, closestPrey().pos.y - pos.y);
      }else{
        dir.set(random.x - pos.x, random.y - pos.y);
      }
      float distToPrey = dist(closestPrey().pos.x, closestPrey().pos.y, pos.x, pos.y);
      if(distToPrey<closestPrey().size*0.25){
        health+=closestPrey().size * 15 * digestion;
        closestPrey().dead = true;
      }
    }else{
      dir.set(random.x - pos.x, random.y - pos.y);
    }
    //acc.set(dir);
    //acc.setMag(0.2);
    vel.add(dir);
    //vel.mult(0.96);
    vel.setMag(speed);
    pos.add(vel);
    
    if(lifespan>1200&&health>1000 && children<3){
      if(random(1)<0.004){
         reproduce();
         children++;
      }
    }
    
    health--;
    lifespan++;
    
  }
  
  
  void show () {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir.heading() + PI/2);
    if(showDebug){
      if(currentMousePredetor!=null){
        if(this == currentMousePredetor){
          strokeWeight(5);
          stroke(255, 255, 0);
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
    fill(255, 0, 0, map(health, 0, 1000, 0, 255));
    triangle(10, -20, -10, -20, 0, 10);
    triangle(10, -20, 0, 10, 20, 20);
    triangle(-10, -20, 0, 10, -20, 20);
    popMatrix();

  }
  
  
  
  
  
  void reproduce () {
    Predetor babyPred;
    babyPred = new Predetor(pos);
    babyPred.setDNA(DNA[0],DNA[1],DNA[2], DNA[3], DNA[4], DNA[5], DNA[6]);
    babyPred.generation = generation + 1;
    mutate(babyPred);
    predetors.add(babyPred);
  }
  void mutate(Predetor babyPredetor){
    float[] mdna = babyPredetor.DNA;
    mdna[0] += random(-2.5, 2.5);
    mdna[1] += random(-10, 10);
    mdna[2] += random(-0, 0.1);
    mdna[3] += random(-6, 6);
    mdna[4] += random(-5, 5);
    mdna[5] += random(-10, 10);
    mdna[6] += random(-0.2, 0.2);
    babyPredetor.DNA = mdna;
  }
  Prey closestPrey() {
    if(prey.size()>0){
      float distanceToFood = 1000000;
      Prey closestPrey = prey.get(0);
      for(int i = 0; i < prey.size(); i++){
        Prey preyi = prey.get(i);
        if(dist(preyi.pos.x, preyi.pos.y, pos.x, pos.y)< distanceToFood){
          distanceToFood = dist(preyi.pos.x, preyi.pos.y, pos.x, pos.y);
          closestPrey = preyi;
        }
      }
      return closestPrey;
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