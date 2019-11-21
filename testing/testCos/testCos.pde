void setup() {

  size(900, 900);

}

void draw() {
  
  background(0);
  fill(255);
  for (int i = 0; i < width; i++) {
    ellipse(i, 500 + 300*cos((i+mouseX)*1.0/width*2*PI), 3, 3);
  }
}
