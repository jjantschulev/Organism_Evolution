ArrayList<Prey> prey = new ArrayList();
ArrayList<Predetor> predetors = new ArrayList();
ArrayList<Food> foods = new ArrayList();
Prey currentMousePrey;
Predetor currentMousePredetor;
boolean showDebug = true;

void setup () {
  fullScreen();
  noStroke();
  for(int i = 0; i < 50; i++){
    foods.add(new Food());
  }
  if(loadTable("data/preyGenome.csv", "header")==null){
    createRandomPreyObject();
  }else{
    readPreyGenome();
  }
  if(loadTable("data/predetorGenome.csv", "header")==null){
    //createRandomPredetorObject();
  }else{
    //readPredetorGenome();
  }

}

void draw () {
  background(0);
  showPredetors();
  showPrey();
  showFood();
  
 
  drawDebug();
}


void mousePressed () {
  //if(dist(mouseX, mouseY, 0, 0)<150){
  //  if(showDebug){
  //    showDebug=false;
  //  }else{
  //    showDebug=true;
  //  }
  //} else if (dist(mouseX, mouseY, width, 0)<150){
  //  savePreyGenome();
  //  savePredetorGenome();
  //}
}
void keyPressed(){
  if(key=='d'){
    if(showDebug){
      showDebug=false;
    }else{
      showDebug=true;
    }
  }else if (key=='s'){
    savePreyGenome();
    savePredetorGenome();
  }else if (key=='r'){
    saveRandomPreyGenome();
    saveRandomPredetorGenome();
  }
}

void drawDebug(){
  if(showDebug){
    
    
    fill(255);
    textSize(15);
    text("Prey Amount: "+prey.size()+"\n"+"Predetor Amount: "+predetors.size(), 10, 30);
    showAvgPreyDNA(90);
    showPreyInfo(380);
    showPredetorInfo(660);
  }
}

void showAvgPreyDNA (float y) {
  text("Avg Prey DNA:", 10, y);
  text("Speed: "+calcAvgPreyDNA()[0],30, y+20);
  text("Awareness: "+calcAvgPreyDNA()[1], 30, y+40);
  text("Accuracy: "+calcAvgPreyDNA()[2], 30, y+60);
  text("Fierceness: "+calcAvgPreyDNA()[3], 30, y+80);
  text("Instinct: "+calcAvgPreyDNA()[4], 30, y+100);
  text("IQ: "+calcAvgPreyDNA()[5], 30, y+120);
  text("Digestion: "+calcAvgPreyDNA()[6], 30, y+140);
}

void readPreyGenome(){
  Table table;
  table = loadTable("data/preyGenome.csv", "header");
  for(TableRow row : table.rows()){
    Prey newPrey = new Prey(new PVector(random(width), random(height)));
    float speed = row.getFloat("speed");
    float awareness = row.getFloat("awareness");
    float accuracy = row.getFloat("accuracy");
    float fierceness = row.getFloat("fierceness");
    float instinct = row.getFloat("instinct");
    float iq = row.getFloat("iq");
    float digestion = row.getFloat("digestion");
    newPrey.setDNA(speed, awareness, accuracy, fierceness, instinct, iq, digestion);
    prey.add(newPrey);
  }
}
void readPredetorGenome(){
  Table table;
  table = loadTable("data/predetorGenome.csv", "header");
  for(TableRow row : table.rows()){
    Predetor newPredetor = new Predetor(new PVector(random(width), random(height)));
    float speed = row.getFloat("speed");
    float awareness = row.getFloat("awareness");
    float accuracy = row.getFloat("accuracy");
    float fierceness = row.getFloat("fierceness");
    float instinct = row.getFloat("instinct");
    float iq = row.getFloat("iq");
    float digestion = row.getFloat("digestion");
    newPredetor.setDNA(speed, awareness, accuracy, fierceness, instinct, iq, digestion);
    predetors.add(newPredetor);
  }
}

void savePreyGenome(){
  Table table;
  table = new Table();
  table.addColumn("id");
  table.addColumn("speed");
  table.addColumn("awareness");
  table.addColumn("accuracy");
  table.addColumn("fierceness");
  table.addColumn("instinct");
  table.addColumn("iq");
  table.addColumn("digestion");
  
  for(int i = 0; i<prey.size(); i++){
    Prey preyi = prey.get(i);
    float[] current = preyi.DNA;
    TableRow newRow = table.addRow();
    newRow.setInt("id", i);
    newRow.setFloat("speed", current[0]);
    newRow.setFloat("awareness", current[1]);
    newRow.setFloat("accuracy", current[2]);
    newRow.setFloat("fierceness", current[3]);
    newRow.setFloat("instinct", current[4]);
    newRow.setFloat("iq", current[5]);
    newRow.setFloat("digestion", current[6]);
  }
  saveTable(table, "data/preyGenome.csv");
}


void savePredetorGenome(){
  Table table;
  table = new Table();
  table.addColumn("id");
  table.addColumn("speed");
  table.addColumn("awareness");
  table.addColumn("accuracy");
  table.addColumn("fierceness");
  table.addColumn("instinct");
  table.addColumn("iq");
  table.addColumn("digestion");
  
  for(int i = 0; i<predetors.size(); i++){
    Predetor predetor = predetors.get(i);
    float[] current = predetor.DNA;
    TableRow newRow = table.addRow();
    newRow.setInt("id", i);
    newRow.setFloat("speed", current[0]);
    newRow.setFloat("awareness", current[1]);
    newRow.setFloat("accuracy", current[2]);
    newRow.setFloat("fierceness", current[3]);
    newRow.setFloat("instinct", current[4]);
    newRow.setFloat("iq", current[5]);
    newRow.setFloat("digestion", current[6]);
  }
  saveTable(table, "data/predetorGenome.csv");
}


void showPredetors(){
  for(int i = predetors.size()-1; i >= 0; i--){
    Predetor predetor = predetors.get(i);
    predetor.update();
    predetor.show();
    if(predetor.health<=0){
      predetors.remove(i);
    }
    if(predetor.lifespan>40000){
      predetors.remove(i);
    }
    if(dist(mouseX, mouseY, predetor.pos.x, predetor.pos.y)<predetor.awareness){
      if(mousePressed){
        currentMousePredetor = predetor;
      }
    }
    if(currentMousePredetor!=null){
      if(currentMousePredetor.health<0){
        currentMousePredetor = null;
      }
    }
  }
}
void showPrey(){
  for(int i = prey.size()-1; i >= 0; i--){
    Prey preyi = prey.get(i);
    preyi.update();
    preyi.show();
    if(preyi.dead){
      prey.remove(i);
    }
    if(preyi.lifespan>15000){
      prey.remove(i);
    }
    if(dist(mouseX, mouseY, preyi.pos.x, preyi.pos.y)<preyi.awareness){
      if(mousePressed){
        currentMousePrey = preyi;
      }
    }
    if(currentMousePrey!=null){
      if(currentMousePrey.dead){
        currentMousePrey = null;
      }
    }
  }
}
void showFood(){
  for(int i = foods.size()-1; i >= 0; i--){
    Food food = foods.get(i);
    food.update();
    food.show();
    if(food.eaten){
      foods.remove(i);
    }
  }
  if(random(1)<0.06){
    foods.add(new Food());
  }
}
void createRandomPreyObject(){
  
  for(int i = 0; i < 20; i++){
    prey.add(new Prey(new PVector(random(width), random(height))));
    Prey preyi = prey.get(i);
    preyi.setDNA(random(2, 5),random(20,60),random(0.2, 0.5), random(40, 70),random(2, 5),random(30, 40),random(0.8, 1.5));
  }
  
}

void createRandomPredetorObject(){
  for(int i = 0; i < 6; i++){
    predetors.add(new Predetor(new PVector(random(width), random(height))));
    Predetor predetor = predetors.get(i);
    predetor.setDNA(random(4, 7),random(25,55),random(0.2, 0.5), random(80, 120),random(2, 5),random(30, 40),random(0.6, 1.5));
  }
}

void showPreyInfo(float y){
  if(currentMousePrey!=null){
    text("Selected Prey:", 10, y-100);
    text("Lifetime: "+currentMousePrey.lifespan, 30, y-80);
    text("Health: "+currentMousePrey.health, 30, y-60);
    text("Generation: "+currentMousePrey.generation, 30, y-40);
    text("Children: "+currentMousePrey.children, 30, y-20);
    text("DNA:", 30, y);
    text("Speed: "+currentMousePrey.speed, 50, y+20);
    text("Awareness: "+currentMousePrey.awareness, 50, y+40);
    text("Accuracy: "+currentMousePrey.accuracy, 50, y+60);
    text("Fierceness: "+currentMousePrey.fierceness, 50, y+80);
    text("Instinct: "+currentMousePrey.instinct, 50, y+100);
    text("IQ: "+currentMousePrey.iq, 50, y+120);
    text("Digestion: "+currentMousePrey.digestion, 50, y+140);
  }
}
void showPredetorInfo(float y){
  if(currentMousePredetor!=null){
    text("Selected Predetor:", 10, y-100);
    text("Lifetime: "+currentMousePredetor.lifespan, 30, y-80);
    text("Health: "+currentMousePredetor.health, 30, y-60);
    text("Generation: "+currentMousePredetor.generation, 30, y-40);
    text("Children: "+currentMousePredetor.children, 30, y-20);
    text("DNA:", 30, y);
    text("Speed: "+currentMousePredetor.speed, 50, y+20);
    text("Awareness: "+currentMousePredetor.awareness, 50, y+40);
    text("Accuracy: "+currentMousePredetor.accuracy, 50, y+60);
    text("Fierceness: "+currentMousePredetor.fierceness, 50, y+80);
    text("Instinct: "+currentMousePredetor.instinct, 50, y+100);
    text("IQ: "+currentMousePredetor.iq, 50, y+120);
    text("Digestion: "+currentMousePredetor.digestion, 50, y+140);
  }
}


void saveRandomPreyGenome(){
  Table table;
  table = new Table();
  table.addColumn("id");
  table.addColumn("speed");
  table.addColumn("awareness");
  table.addColumn("accuracy");
  table.addColumn("fierceness");
  table.addColumn("instinct");
  table.addColumn("iq");
  table.addColumn("digestion");
  
  for(int i = 0; i<20; i++){
    float[] current = {random(2, 5),random(20,60),random(0.2, 0.5), random(40, 70),random(2, 5),random(30, 40),random(0.8, 1.5)};
    TableRow newRow = table.addRow();
    newRow.setInt("id", i);
    newRow.setFloat("speed", current[0]);
    newRow.setFloat("awareness", current[1]);
    newRow.setFloat("accuracy", current[2]);
    newRow.setFloat("fierceness", current[3]);
    newRow.setFloat("instinct", current[4]);
    newRow.setFloat("iq", current[5]);
    newRow.setFloat("digestion", current[6]);
  }
  saveTable(table, "data/preyGenome.csv");
}

void saveRandomPredetorGenome(){
  Table table;
  table = new Table();
  table.addColumn("id");
  table.addColumn("speed");
  table.addColumn("awareness");
  table.addColumn("accuracy");
  table.addColumn("fierceness");
  table.addColumn("instinct");
  table.addColumn("iq");
  table.addColumn("digestion");
  
  for(int i = 0; i<6; i++){
    float[] current = {random(4, 7),random(15,50),random(0.2, 0.5), random(80, 120),random(2, 5),random(30, 40),random(0.6, 1.5)};
    TableRow newRow = table.addRow();
    newRow.setInt("id", i);
    newRow.setFloat("speed", current[0]);
    newRow.setFloat("awareness", current[1]);
    newRow.setFloat("accuracy", current[2]);
    newRow.setFloat("fierceness", current[3]);
    newRow.setFloat("instinct", current[4]);
    newRow.setFloat("iq", current[5]);
    newRow.setFloat("digestion", current[6]);
  }
  saveTable(table, "data/predetorGenome.csv");
}

float[] calcAvgPreyDNA () {
  float[] avgPreyDNA = new float[7];
  for(int i = 0; i<prey.size(); i++){
    Prey preyi = prey.get(i);
    for(int j = 0; j<avgPreyDNA.length; j++){
      avgPreyDNA[j] += preyi.DNA[j];
    }
  }
  for(int j = 0; j<avgPreyDNA.length; j++){
    avgPreyDNA[j] = avgPreyDNA[j]/prey.size();
  }
  return avgPreyDNA;
}
float[] calcAvgPredetorDNA () {
  float[] avgPredetorDNA = new float[7];
  for(int i = 0; i<predetors.size(); i++){
    Predetor predetor = predetors.get(i);
    for(int j = 0; j<avgPredetorDNA.length; j++){
      avgPredetorDNA[j] += predetor.DNA[j];
    }
  }
  for(int j = 0; j<avgPredetorDNA.length; j++){
    avgPredetorDNA[j] = avgPredetorDNA[j]/prey.size();
  }
  return avgPredetorDNA;
}