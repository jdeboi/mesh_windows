float animationSeconds = 5*60;
boolean SEND_DEBUG = true;
boolean HEAT_MAP =  false;


// DATA
int rSkip = 5;
int cSkip = 5;

// MARS VOYAGE VARIABLES
int numTravelDays = 500+9*30*2; // 9 months traveling each way, 500 days on Mars
int astronautSurfaceArea = 1700; // cm2
int animationFrames = int(animationSeconds * frameRate);
long startTime = 0;
long elapsedTime = 0;
float percentageComplete = 0;
boolean isStopped = false;

int viewH;

void initWaves() {
  viewH = height;
  lights();

  //colorMode(HSB, 255);
  initEnvironments();
  //initOsc();


  background(0);
  noStroke();

  int i = 100;
  for (Environment e : environments) {
    i++;
    e.setParticles(i * 100 + 200);
    //println(e.getName(), e.particles.size());
    e.printSpecs();
  }
}

void displayWaves() {




  pushMatrix();

  float alpha = 10;
  fill(0, alpha);
  rect(0, 0, width, height);



  //displayAllEnvironments();
  translate(0, height/2-viewH/2);
  environment.display(200);
  if (isSPE)  environments[3].display(200);

  popMatrix();



  displayInfo();
  // update

  updateEnvironment();
  //updateSPE();

  if (!isStopped) updateTime();
  if (percentageComplete > 1) {
    percentageComplete = 1;
  }


  //saveFrame("frames/####.png");
}




color getHealthColor() {
  color col;
  col = lerpColor(color(0, 255, 0), color(255, 0, 0), percentageComplete);
  col = color(red(col), green(col), blue(col), 100);
  return col;
}



void keyPressed() {
  if (key == 's') {
    triggerSPE();
  } else if (key == ' ') {
    isStopped = !isStopped;
  }
}

void updateTime() {
  // frameRate * animationSeconds = totalFrames
  // time / frame = 1/ frameRate;
  float numFrames = frameRate * animationSeconds;
  float increment = 1.0/numFrames;
  percentageComplete += increment*speedFactor;
}


// Calculates the base-10 logarithm of a number
float log10 (float x) {
  return (log(x) / log(10));
}

// Calculates the base-10 logarithm of a number
double log10 (double x) {
  return (Math.log(x) / Math.log(10));
}

void mouseP(int x, int w) {


  //startTime = millis();
  percentageComplete = map(x, 0, w, 0, 1);
  //currentTime = int(percentageComplete * animationSeconds * 1000);

  for (int i = 0; i < environments.length; i++) {
    environments[i].setParticles(i*100 + 200);
  }
}

void mousePressed() {

  if (mouseY > 50 && mouseY < 100) {
    //startTime = millis();
    percentageComplete = map(mouseX, 0, width, 0, 1);
    //currentTime = int(percentageComplete * animationSeconds * 1000);
  }
  for (int i = 0; i < environments.length; i++) {
    environments[i].setParticles(i*100 + 200);
  }
}
