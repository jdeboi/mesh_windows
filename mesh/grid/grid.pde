void setup() {
  fullScreen(2);
}

void draw(){ 
  background(0);
  stroke(255);
  strokeWeight(5);
  translate(0,                                                                                                                                                                                                                             0);
  
  

  float spacing = 150 + 100 * sin(millis()/4000.0);
  
  for (float x = 300; x < width-300; x += spacing) {
    for (float y = 500; y < height; y += spacing) {
      line(x, 0, x, height);
      line(0, y, width, y);
    }
  }
  
}
