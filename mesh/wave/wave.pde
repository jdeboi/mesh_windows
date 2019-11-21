                                                                  float time = 0;
float x = 0;

void setup() {
  //size(1400, 500);
  fullScreen(2);
  background (0);
}

void draw() {
  translate(0, 500);
  fill(0, 7);
  noStroke();
  rect(0, 0, width, height);
  
  x = 0;
  
  while (x < width) {
    stroke(255);
    point(x, 100 + 200 * noise (x * 0.01, time));
    x = x + 1;
  }
  
  time = time + 0.03;
}
