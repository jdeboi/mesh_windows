float lastSpacing = 0;

void displayGrid(float z) {


  stroke(255);
  strokeWeight(5);
  float spacing = map(z, 1300, 2300, 150, 40);
  spacing = constrain(spacing, 40,  150);

  translate(spacing*1.0/2, spacing*1.0/2);
  for (float x = width/2; x < width-300; x += spacing) {
    for (float y = 500; y < height; y += spacing) {
      line(x, 0, x, height);
      line(0, y, width, y);
    }
  }
  for (float x = width/2; x > 300; x -= spacing) {
    for (float y = 500; y < height; y += spacing) {
      line(x, 0, x, height);
      line(0, y, width, y);
    }
  }
}
