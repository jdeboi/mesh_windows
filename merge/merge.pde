/*
  set to SAVING_PRECOMPUTE to true to save locations to .csv 
 if it's false, each planet will load a table of precomputed 
 and subsequently display that data
 */
boolean SAVING_PRECOMPUTE = false; 

/*
  This number represents how many total frames to precompute
 for the final animation.
 30 frames/sec * 60 sec/min * 3 = 3 minutes of frames
 */
int frameR = 20;
float timeJump = 0.15;
int numDays = 2 * 365 + 7 * 30;  //(2018, 5, 11) to 2020 12/11 = 2 years 7 months = 2 * 365 + 7 * 30
//int totalDurationFrames = frameR * 60 * 5; 
int totalDurationFrames = int(numDays/timeJump);


import java.lang.Math;
import java.util.Arrays;
import java.time.LocalDateTime;


Planet[] planets;
long lastMessage = 0;
double rate;
int messageRate;
import peasy.*;
PeasyCam cam;

int dataSet = 8;
double [] var_x = new double[8];
double [] var_y = new double[8];
double [] var_z = new double[8];
double x_axis, y_axis, z_axis;



void setup() {
  //size(800, 800, P3D);
  fullScreen(2);
  println(this);

  smooth(8);
  frameRate(frameR);

  //initWindow();
  initControls();

  int[] planetSizes = {2, 6, 10, 8, 50, 45, 40, 40 };
  color[] colors = {
    color(150), // mercury
    color(#EDEBAF), // venus 
    color(#0088F5), // earth
    color(#9D0D16), // mars
    color(150, 50, 0), 
    color(20, 150, 100), 
    color(0, 50, 200), 
    color(0, 0, 250)
  };

  String[] names = {"Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"};
  String[] abbrev = {"mer", "ven", "ear", "mar", "jup", "sat", "nep", "ura"};
  planets = new Planet[8];
  for (int i = 0; i < 8; i++) {
    String str = "./VSOP87_Data/VSOP87C." + abbrev[i]+ ".txt";
    planets[i] = new Planet(names[i], str, planetSizes[i], colors[i]);
  }

  initOsc();


  //cam = new PeasyCam(this, 512);
  //cam.setFreeRotationMode();

  x_axis = 50;
  y_axis = -50;
  z_axis = 50;

  rate = 52594.8766;
  messageRate = 1;

  if (!SAVING_PRECOMPUTE) loadPrecomputed();

  initWaves();
}

void draw() {

  if (SAVING_PRECOMPUTE) {
    changeLocations();
    saveLocations();
    background(0);
    fill(255);
    text("saving..." + frameCount + "/"+ totalDurationFrames, width/2, height/2);
  } else {
    changeLocationsPrecomputed();
    displayFrameRate();

    displayPlanets();
    sendOSCMessages();

    displayWaves();
  }
}

void displayCurve() {
  //double TiThere = planets[2].JDEtoT(planets[2].getJDEDate(2018, 5, 11)); // earth start
  //double TjThere = planets[3].JDEtoT(planets[3].getJDEDate(2018, 11, 7)); // mars when gets there
  //double TiBack = planets[2].JDEtoT(planets[2].getJDEDate(2020, 6, 14));  // mars when leaves
  //double TjBack = planets[3].JDEtoT(planets[3].getJDEDate(2020, 12, 11)); // earth when arrives

  //float[] iThere = planets[2].calculateVariablesOnce(TiThere); // 
  //float[] jThere = planets[3].calculateVariablesOnce(TjThere);
  //float[] iBack = planets[2].calculateVariablesOnce(TiBack);
  //float[] jBack = planets[3].calculateVariablesOnce(TjBack);

  PVector earthDepart = planets[2].getStart();
  PVector earthArrive = planets[2].getEnd();

  PVector marsArrive = planets[3].getFlight(int(5*30.5 + 26)); // 11/7/18 - 5/11/18 = 5 months 26 days = 5*30.5 + 26
  PVector marsDepart = planets[3].getFlight(int(2*365+1*30.5 + 3)); // 6/14/20 - 5/11/18 = 2 years, 1 month, 3 days 


  stroke(50);
  int sz = 40;
  pushMatrix(); //for the curve
  //translate(earthDepart.x*100, earthDepart.z*100, earthDepart.y*100);
  //println(earthDepart.x*100);


  fill(255, 255, 0);
  ellipse(0, 0, sz, sz);

  fill(255, 0, 0);



  noFill();
  stroke(255);
  strokeWeight(10);

  /////////////// To Mars
  // curve(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
  // xyz1 = begincontrol, xyz2 = firstpt, xyz3 = secondpt, yxz4 = endcontrol, 
  curve(earthDepart.x, earthDepart.z-50, earthDepart.y+300, earthDepart.x, earthDepart.z, earthDepart.y, marsArrive.x, marsArrive.z, marsArrive.y, marsArrive.x + 50, marsArrive.z + 50, 800);


  /////////////// Back to Earth
  stroke(255, 0, 255);
  curve(marsDepart.x-500, marsDepart.z, marsDepart.y-300, marsDepart.x, marsDepart.z, marsDepart.y, earthArrive.x, earthArrive.z, earthArrive.y, earthArrive.x - 500, earthArrive.z + 50, 0);

  popMatrix();
}

void loadPrecomputed() {
  for (Planet p : planets) {
    p.loadPrecomputed();
  }
}

void saveLocations() {
  for (Planet p : planets) {
    p.addLocation();
  }
  if (frameCount == totalDurationFrames) {
    for (Planet p : planets) {
      p.saveLocation();
    }
    exit();
  }
}

void changeLocationsPrecomputed() {
  for (Planet p : planets) {
    p.calculatePrecomputedValues();
  }
}

void changeLocations() {
  for (Planet p : planets) {
    p.calculateVariableValues();
    p.changeJDE(timeJump);
  }
}



void displayFrameRate() {
  // framerate
  //cam.beginHUD();
  fill(255);
  text(frameRate, 10, 10);
  //cam.endHUD();
}

void displayPlanets() {

  pushMatrix();
  //rotateX(radians(45*sin(millis()/1000.0)));
  //rotateZ(radians(90));
  translate(width/2, height/2, 400);

  rotateX(radians(90));
  //displayCurve();
  displaySun();

  for (Planet p : planets) {

    p.display();
  }

  popMatrix();
}

void displaySun() {
  pushMatrix(); //for the sun 
  lights();
  noStroke();
  fill(color(200, 150, 0));
  translate(0.0, 0.0, 0.0);
  sphere(25);
  popMatrix();
}


color mapColor(double _x, double _y, double _z)
{
  int r = int(map((float)_x, 0, (float)x_axis, 0, 255));
  int g = int(map((float)_y, 0, (float)y_axis, 0, 255));
  int b = int(map((float)_z, 0, (float)z_axis, 0, 255));
  return color(r, g, b);
}

void axis()
{
  strokeWeight(2);
  stroke(255, 0, 0);
  line(0, 0, 0, (float)x_axis, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, (float)y_axis, 0); 
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, (float)z_axis);
}
