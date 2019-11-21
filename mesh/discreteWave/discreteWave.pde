PImage tunnel;
PGraphics canvas;
void setup() {
  fullScreen(2);
  //size(500, 500);
  float factor = 0.1;
}    

void draw() {
  background(0);
  //wave();

  translate(0, 400);
  discreteWave(100, 150);
   //translate(0, 100);
  discreteWave(-100, 150);
}




void discreteWave(int amp, int spacing) {
  discreteWave(amp, spacing, millis()/1000.0);
}


void discreteWave(float amp, int spacing, float period) {

  pushMatrix();
  translate(0, abs(amp)*2);
  //translate(0, height-amp);
  stroke(255);
  strokeWeight(3);
  int i = 0;
  int w = 0;    
  //line(x, 0,x,  height);
  while (w < width) {
    float sp = spacing;
    float y0 = amp*sin(w/100.0 + period);  
    float y1 = amp*sin((w+sp)/100.0 + period);


    line(w, y0, w+sp, y0);
    line(w+sp, y0, w+sp, y1);
    w += sp;
    i++;
  }
  popMatrix();
}

void discreteWaveX(float amp, int spacing, float x) {

  pushMatrix();
  translate(0, abs(amp)*2);
  //translate(0, height-amp);
  stroke(255);
  strokeWeight(3);
  int i = 0;
  int w = 0;    
  //line(x, 0,x,  height);
  while (w < width) {
    //for (int i = 0; i < width; i += spacing) {
    float period = millis()/600.0;
    float sp = spacing;
    float y0 = amp/5*sin(w/100.0 + period);  
    float y0f = y0 + amp*cos((w-x+width/2)*1.0/width*2*PI);
    float y1 = amp/5*sin((w+sp)/100.0 + period);
    float y1f = y1 + amp*cos((w+sp-x+width/2)*1.0/width*2*PI);


    line(w, y0f, w+sp, y0f);
    line(w+sp, y0f, w+sp, y1f);
    w += sp;
    i++;
  }
  popMatrix();
}



void wave() {
  pushMatrix();
  float amp = 100;
  translate(0, height-amp);
  stroke(255);
  strokeWeight(3);
  int spacing =1;
  for (int i = 0; i < width; i += spacing) {
    float y0 = amp*sin(i/100.0 + millis()/1000.0);
    float y1 = amp*sin((i+spacing)/100.0 + millis()/1000.0);
    line(i, y0, i+spacing, y1);
    //line(i+spacing, y0, i+spacing, y1);
  }
  popMatrix();
}
