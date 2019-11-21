void setup() {
  fullScreen(2);
  
}

void draw() {
  background(0);
  strokeWeight(3);
  stroke(255);
  noFill();
  
  float dim = 100;
  translate(0, height - dim);
  for (int i = 0; i < 10; i ++) {
    rect(i*dim + 100, 0, dim, dim);
  }
}
