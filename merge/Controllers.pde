import controlP5.*;
ControlP5 cp5;
Slider speed;
Slider volumeSlider;
float volume = 1;
float speedFactor = 1;
int summaryIntervalMillis = 500;

void initControls() {
  cp5 = new ControlP5(this);

  //cp5.addSlider("animation_minutes_slider")
  //  .setPosition(300, 10)
  //  .setRange(.1, 8)
  //  .setValue(4)
  //  ;

  cp5.addSlider("speed_slider")
    .setPosition(300, 20)
    .setRange(0, 5)
    .setValue(1)
    ;
}

void volume_slider(float val) {
  volume = map(val, 0, 1, .03, 5);
}

void speed_slider(float val) {
  speedFactor = map(val, 0, 1, .2, 2);
}

void animation_minutes_slider(float val) {
  animationSeconds = int(map(val, .1, 8, 10, 5*60));
}

void summary_interval_millis(float val) {
  summaryIntervalMillis = int(val);
}

void displayTimeline(int y, int h) {
  //fill(0);
  ////stroke(0, 100);
  //rect(0, y, width, y+h);

  stroke(255);
  strokeWeight(2);
  noFill();
  line(0, y+h/2, width, y+h/2);
  float d = map(percentageComplete, 0, 1, 0, width);
  ellipse(d, y+h/2, 15, 15);
  if (d > width) end = true;
}


void displayInfo() {
  fill(0);
  rect(0, 0, width, 50);
  displayTimeline(50, 50);
  
  
  noStroke();
  fill(255);
  textSize(10);
  text("" + nfc(frameRate, 2), 10, 18);
  text(environment.getName(), 10, 40);
  text(int(environment.transitionPercent*100)+"%", 50, 40);
}
