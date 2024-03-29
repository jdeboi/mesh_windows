Particle[] p = new Particle[800];
int diagonal;


void setup() {
  for (int i = 0; i<p.length; i++) {
    p[i] = new Particle();
    p[i].o = random(1, random(1, width/p[i].n));
  }
  fullScreen(2);
  diagonal = (int)sqrt(width*width + height * height)/2;
  background(0);
  noStroke();
  fill(255);
  frameRate(30);
}
float rotation = 0;
void draw() {
  if (!mousePressed)  {
    background(0);
  }

  translate(width/2, height/2);
  rotation-=0.002;
  rotate(rotation);

  for (int i = 0; i<p.length; i++) {
    p[i].draw();
    if (p[i].drawDist()>diagonal) {
      p[i] = new Particle();
    }
  }
}

class Particle {
  float n;
  float r;
  float o;
  int l;
  Particle() {
    l = 1;
    n = random(1, width/2);
    r = random(0, TWO_PI);
    o = random(1, random(1, width/n));
  }

  void draw() {
    l++;
    pushMatrix();
    rotate(r);
    translate(drawDist(), 0);
    stroke(255, min(l, 255));
    noFill();
    ellipse(0, 0, width/o/8, width/o/8);
    popMatrix();

    o-=0.07;
  }
  float drawDist() {
    return atan(n/o)*width/HALF_PI;
  }
}
