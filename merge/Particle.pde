


class Particle {

  float energy;
  float mass;
  float flux;

  PVector loc;
  int r, c;

  float posX, posY, posZ, incr, theta;
  color  clr;
  int dir = random(1) >= 0.5 ? 1 : -1;

  Particle(float e, int m, float flux, int r, int c) {
    energy = e;
    mass = m;
    this.flux = flux;
    this.r = r;
    this.c = c;
    this.loc = new PVector(r * 10, c * 10);

    clr = getEnergyColor();
  }


  int getMassSize() {
    int sz = int(map(mass, 1, 60, 2, 8));
    sz = constrain(sz, 2, 8);
    //println(mass, sz);
    return sz;
  }

  void display() {
    noStroke();
    fill(clr);
    ellipse(posX, posY, getMassSize(), getMassSize());
  }

  public void move(int y, String name) {
    // 
    if (environment.name.equals("GCR") && this.r%5 == 0) {
      setParticle();
      display();
      //updateGalaxy();
      //displayGalaxy();
    } else if (environment.name.equals("MARS")  && this.r%5 == 0) {
      setParticle();
      if (this.r %2 == 0) display();
    } else {
      update(y, name);
      wrap();
      display();
    }
  }

  void displayGalaxy() {
    fill(clr);
    ellipse(posX, posY, getMassSize()+posZ, getMassSize()+posZ);
  }

  void updateGalaxy() {
    int w2=width/2;
    int h2= height/2;
    float d2 = dist(0, 0, w2, h2);

    int mode = 5; // this.r%8;
    float speed = 0.8;
    int convergeX = (mode/3)%3;
    int convergeY = mode%3;
    int wfull = width;
    int controlX = int(map(convergeX, 0, 2, wfull*(1-speed), wfull*speed));
    int controlY = int(map(convergeY, 0, 2, height*(1-speed), height*speed));
    posX = posX-map(controlX, 0, width, -0.05, 0.05)*(w2-posX);
    posY = posY-map(controlY, 0, height, -0.05, 0.05)*(h2-posY);
    posZ = posZ+0.2-0.6*noise(posX, posY, frameCount);

    if (posY < 0 || posY > height || posX < 0 || posX > width) {
      setParticle();
    }
  }

  void update(int y, String name) {
    incr +=  .008;
    theta = noise(posX * .006, (posY+ y) * .004, incr) * TWO_PI;
    //int sign = r%2 == 0 ? -1 : 1;
    int direction = posX > width/2 ? -1 : 1;
    int dirX = direction;
    int dirY = direction;
    if (name.equals("GCR")) direction = dir;

    if (name.equals("SPE")) {
      dirX = posX > width/2 ? -1 : 1;
      dirY = posY > height/2 ? 1 : -1;
    }

    posX +=dirX* 2 * cos(theta);
    posY +=dirY *2 * sin(theta);
  }

  void wrap() {
    int h = viewH;
    int w = width;
    //if (posX < 0) posX = w;
    //if (posX > w) posX =  0;

    //if (posY < 0 ) posY = h-1;
    //if (posY > h) posY =  0;

    if (posX < 0)   setParticle();
    if (posX > w)   setParticle();

    if (posY < 0 )   setParticle();
    if (posY > h)   setParticle();
  }

  void display(PGraphics g) {
  }

  color getTotalEnergyColor() {
    float e = energy * mass;
    float logE = log10(e);
    color col;
    if (logE < 2) col = lerpColor(color(255, 0, 0), color(255, 255, 0), map(logE, -2, 2, 0, 1));
    else if (logE < 4) col = lerpColor(color(0, 255, 0), color(0, 255, 255), map(logE, 2, 4, 0, 1));
    else col = lerpColor(color(0, 255, 255), color(255, 100, 255), map(logE, 4, 5, 0, 1));
    //int brightness = int (constrain(map(logE, -2, 8, 150, 255), 150, 255));
    col = color(col);
    return col;
  }

  color getEnergyColor() {
    // original
    //color c1 = color(0, 0, 155);
    //color c2 = color(0, 0, 255);
    //color c3 = color(200, 100, 0);
    //color c4 = color(230, 0, 0);
    //color c5 = color(255, 0, 0);
    
    color c1 = color(55);
    color c2 = color(150);
    color c3 = color(255);
    color c4 = color(0,0, 255);
    color c5 = color(0, 255, 0);


    // rainbow
    //color c1 = color(255, 0, 0);
    //color c2 = color(255, 255, 0);
    //color c3 = color(0, 255, 0);
    //color c4 = color(0, 0, 255);
    //color c5 = color(255, 0, 255);

    float b1 = 2;
    float b2 = 3;
    float b3 = 3.5;

    float logE = log10(energy);
    color col;
    if (logE < b1) {
      float per = map(logE, -2, b1, 0, 1);
      col = lerpColor(c1, c2, per);
    } else if (logE < b2) {
      float per = map(logE, b1, b2, 0, 1);
      col = lerpColor(c2, c3, per);
    } else if (logE < b3) {
      float per = map(logE, b2, b3, 0, 1);
      col = lerpColor(c3, c4, per);
    } else {
      float per = map(logE, b3, 5, 0, 1);
      col = lerpColor(c4, c5, per);
    }
    return col;
  }

  color getEnergyColorOG(int alpha) {
    float logE = log10(energy);
    color col;
    if (logE < 2) col = lerpColor(color(255, 0, 0), color(255, 255, 0), map(logE, -2, 2, 0, 1));
    else if (logE < 4) col = lerpColor(color(0, 255, 0), color(0, 0, 255), map(logE, 2, 4, 0, 1));
    else col = lerpColor(color(0, 0, 255), color(255, 0, 255), map(logE, 4, 5, 0, 1));
    col = color(col, alpha);
    return col;
  }

  void setParticle() {
    posX = random(width);
    posY = random(viewH);
    posZ = getMassSize();
  }

  void sendMessage(String name) {
    //if (random(1) > 0.995) {
    //  setParticle();
    //}
    if (random(1) > 0.9) {
      sendOsc(name, energy, int(mass), r, c);
    }
  }
  
 
}
