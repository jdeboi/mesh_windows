void setup() {
  fullScreen(2);
}

void draw() {
  background(0);
  
  //stroke(255);
  //noFill();
  //ellipse(width/2 + 35*sin(millis()/1000.0), height-35, 20, 20);
  
  //stroke(255);
  //noFill();
  //int diam = 50;
  //ellipse(width/2+ 25*sin(millis()/1000.0), height-diam/2, diam, diam);
  
  // with smoke, all the rects, smallest at front
  //fill(255);
  //rectMode(CENTER);
  //noStroke();
  //int h = 100;
  //rect(width/2+ 75*sin(millis()/2000.0), height-h/2, 25, h); 
  
  stroke(255);
  noFill();
  translate(width/2, height);
  rectMode(CENTER);
  for (int i = 0; i < 5; i++) {
    int diam = 40 - i*5;
    //ellipse(-i*50, -diam - i * 5, diam, diam);
    //ellipse(i*50, -diam - i * 5, diam, diam);
    rect(-i*50, -diam - i * 5, diam, diam);
    rect(-i*50, -diam - i * 5, diam, diam);
  }
  
}
