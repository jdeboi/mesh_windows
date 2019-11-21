int triggerFrequency = 100;
long lastTriggerTime = 0;

Environment[] environments; 
final int SKIP = 0;
final int AVERAGE = 1;
final int SUM = 2;

// TRANSITION VARIABLES
final int OFF = 0;
final int TRANS_IN = 1;
final int TRANS_OUT = -1;
final int ON = 2;

// ENVIRONMENT VARIABLES
boolean end = false;
Environment environment;
boolean isSPE = false;
int SPESpacing;
int SPELasts = 5 * 1000;
int SPETime = 0;




void initEnvironments() {
  SPESpacing = int(animationSeconds/3) * 1000;
  environments = new Environment[4];
  environments[0] = new Environment("LEO", 0, .05, .95, 1.0);
  environments[1] = new Environment("GCR", .05, .4, 0.6, 0.95);
  environments[2] = new Environment("MARS", 0.4, 0.6);
  environments[3] = new Environment("SPE");

  environment = environments[0];
}

void triggerSPE() {
  isSPE = !isSPE;
  SPETime = millis();
}

void updateSPE() {
  if (!isSPE) {
    if (millis() - SPETime > SPESpacing) {
      triggerSPE();
    }
  } else {
    if (millis() - SPETime > SPELasts) {
      triggerSPE();
    }
  }
}

void updateEnvironment() {
  for (int i = 0; i < 3; i++) {
    if (environments[i].isEnv()) {
      environment = environments[i];
      return;
    }
  }
  environment = environments[0];
}


class Environment {

  String name;
  ArrayList<Particle> particles;

  int transitionMode = 0;
  long transitionStarted = 0;
  float transitionPercent = 0;
  boolean isOn = false;

  double totalEnergy = 0;
  float totalEnergyInterval = 0;
  float energyRate = 0;

  float[][] startStop;
  int numTimes = 0;
  int currentTime = 0;
  long lastStatisticsTime = 0;

  int mode = 0;

  float totalSum = 0;
  float totalSumEnergy = 0;

  Environment(String n, float s0, float e0, float s1, float e1) {
    name = n;
    Table tab;
    tab = loadTable(name + ".csv", "header");
    particles = new ArrayList<Particle>();
    int c = cSkip;
    if (name.equals("SPE")) c = 1;
    initTab(tab, particles, rSkip, c, SUM);

    startStop = new float[2][2];
    startStop[0][0] = s0;
    startStop[0][1] = e0;
    startStop[1][0] = s1;
    startStop[1][1] = e1;
    if (s0 > -1) numTimes++;
    if (s1 > -1) numTimes++;
  }

  Environment(String n) {
    this(n, -1, -1, -1, -1);
  }

  Environment(String n, float start, float stop) {
    this(n, start, stop, -1, -1);
  }


  void setCurrentTime() {
    currentTime = 0;
    if (numTimes > 1 && percentageComplete >= startStop[1][0] 
      && percentageComplete < startStop[1][1]) {
      currentTime = 1;
    }
  }

  void updateStatistics() {
    if (millis() - lastStatisticsTime > summaryIntervalMillis) {
      lastStatisticsTime = millis();
      energyRate = totalEnergyInterval * 1.0 / summaryIntervalMillis;
      //println(name, energyRate, totalEnergy);
      //sendOscSummary(name, totalEnergyInterval , energyRate);
      totalEnergyInterval = 0;
    }
  }

  void display(int y) {
    for (Particle p : particles) {
      p.move(y, name);
      p.sendMessage(name);
    }
  }

  void resetStats() {
    totalEnergy = 0;
    totalEnergyInterval = 0;
    energyRate = 0;
  }

  boolean isEnv() {
    if (numTimes > 0 && percentageComplete >= startStop[0][0] 
      && percentageComplete < startStop[0][1]) {
      if (!isOn) resetStats();
      isOn = true;
      return true;
    } else if (numTimes > 1 && percentageComplete >= startStop[1][0] 
      && percentageComplete < startStop[1][1]) {
      if (!isOn) resetStats();
      isOn = true;
      return true;
    }
    isOn = false;
    return false;
  }



  void displayHeatMapSum() {
    colorMode(HSB, 255);
    int w = 40;
    int h = 15;
    for (Particle p : particles) {
      float ratio = p.flux/totalSum;
      float f = map(ratio, 0, 1, 0, 255);
      f = constrain(f, 0, 240);
      fill(f, 255, 255);
      rect( p.c * w, p.r * h, w, h);
      fill(0);
      text(nf(ratio, 0, 2), p.c * w, p.r * h+h);
    }
  }



  void displayHeatMapTotalE() {
    int w = 40;
    int h = 15;
    for (Particle p : particles) {
      float ratio = p.flux*p.energy*p.mass/totalSumEnergy;
      float f = map(ratio, 0, 1, 0, 255);
      fill(f, 255, 255);
      rect( p.c * w, p.r * h, w, h);
      fill(0);
      text(nf(ratio, 0, 2), p.c * w, p.r * h+h);
    }
  }

  void displayHeatMapE() {
    colorMode(HSB, 255);
    int w = 40;
    int h = 15;
    for (Particle p : particles) {
      double ratio = p.flux*p.energy*p.mass;
      float lg = (float) Math.log(ratio);
      //println(ratio, Math.log(ratio));
      //float flg = (float)ratio;
      float f = map(lg, -2, 20, 0, 255);
      f = constrain(f, 0, 200);
      fill(f, 255, 255);
      rect( p.c * w, p.r * h, w, h);
      fill(0);
      text(int(lg), p.c * w, p.r * h+h);
    }
  }

  // flux
  void displayHeatMap() {
    int w = 40;
    int h = 15;
    for (Particle p : particles) {
      float ratio = p.flux;
      float f = map(log10(ratio), -9, 6, 0, 255);
      fill(f, 255, 255);
      rect( p.c * w, p.r * h, w, h);
      fill(0);
      text(nf(log10(ratio), 0, 2), p.c * w, p.r * h+h);
    }
  }

  void displayEnvironmentName(int x, int y) {
    // title
    stroke(255);
    fill(255);
    textSize(40);
    text(name, x + 100, y + 100);
  }

  String getName() {
    return name;
  }

  void setStage() {
    if (name.equals("SPE")) {
      if (isSPE) mode = ON;
      else mode = OFF;
      transitionPercent = 1;
      return;
    }
    setCurrentTime();
    float transitionBuffer = 0.025;
    float start = startStop[currentTime][0];
    float end =  startStop[currentTime][1];
    if (percentageComplete - start < transitionBuffer) {
      mode = TRANS_IN;
      transitionPercent = map(percentageComplete - start, 0, transitionBuffer, 0, 1);
    } else if (percentageComplete > start && percentageComplete < end) {
      mode = ON;
      transitionPercent = 1;
    } else if (percentageComplete >= end && percentageComplete < end + transitionBuffer) {
      mode = TRANS_OUT;
      transitionPercent = map(percentageComplete, end, end+ transitionBuffer, 1, 0);
    } else {
      mode = OFF;
      transitionPercent = 1;
    }
  }



  void initTab(Table tab, ArrayList<Particle> particles, int rSkip, int cSkip, int mode) {

    int r = 0;
    int c = 0;

    int row = tab.getRowCount()/rSkip+1;
    int col = (tab.getColumnCount()-1)/cSkip+1;
    if (cSkip == 1) col = tab.getColumnCount() -1;

    float[][] arr = new float[row][col];
    float[] energies = new float[row];

    for (int y = 0; y < tab.getRowCount(); y+= rSkip) {
      c = 0;
      energies[r] = tab.getFloat(y, 0);
      for (int x = 1; x < tab.getColumnCount(); x+= cSkip) {
        if (c < arr[0].length && r < arr.length) {
          if (mode == SUM) arr[r][c] = sumCube(tab, y, x, cSkip, rSkip);
          else if (mode == AVERAGE) arr[r][c] = averageCube(tab, y, x, cSkip, rSkip);
          else arr[r][c] = tab.getFloat(y, x);
        }

        c++;
      }
      r++;
    }


    totalSum = 0;
    for (int rr = 0; rr < arr.length; rr ++) {
      for (int cc = 0; cc < arr[0].length; cc++) {
        int mass = cc * cSkip+1;
        float totalE = energies[rr] * mass*arr[rr][cc];
        if (log10(totalE) > -1) {
          //totalSum += arr[rr][cc];
          //totalSumEnergy += arr[rr][cc] * energies[rr]* mass;

          int lg = int(log10(arr[rr][cc]));

          if (name == "SPE") lg *= 5;
          else if (name == "MARS") lg *= 5;

          particles.add(new Particle(energies[rr], mass, arr[rr][cc], rr, cc));
          totalSumEnergy += arr[rr][cc] * energies[rr]* mass;

          for (int j = 1; j < lg; j++) {
            particles.add(new Particle(energies[rr], mass, arr[rr][cc], rr, cc));
          }
        }
      }
    }
  }



  float sumRow(Table tab, int row, int startC, int w) {
    float sum = 0; 
    for (int i = startC; i < w + startC && i < tab.getColumnCount(); i++) {
      sum += tab.getFloat(row, i);
    }

    return sum;
  }

  float averageRow(Table tab, int row, int startC, int num) {
    float sum = 0; 
    int tot = 0; 
    for (int i = startC; i < num + startC && i < tab.getColumnCount(); i++) {
      tot++; 
      sum += tab.getFloat(row, i);
    }
    return sum/tot;
  }

  float sumCube(Table tab, int row, int col, int w, int h) {
    float sum = 0; 
    for (int i = row; i < row + h && i < tab.getRowCount(); i++) {
      sum += sumRow(tab, i, col, w);
    }
    return sum;
  }


  float averageCube(Table tab, int row, int col, int w, int h) {
    float sum = 0; 
    int tot = 0; 
    for (int i = row; i < h + row && i < tab.getRowCount(); i++) {
      tot++; 
      sum += averageRow(tab, i, col, w);
    }
    return sum/tot;
  }


  void printSpecs() {
    println("------------------------"); 
    println(name + " Specs"); 
    println("log total flux " + int(log10(totalSum)));
    println("log total energy " + int(log10(totalSumEnergy)));

    //println("Max log10: " + log10(getMax(arr))); 
    //println("Min log10: " + log10(getMin(arr)));
  }

  float getMax(float arr[][]) {
    float max = 0; 
    for (int i = 0; i < arr.length; i++) {
      float m = max(arr[i]); 
      if (m > max) max = m;
    }
    return max;
  }

  float getMin(float arr[][]) {
    float min = 1000000; 
    for (int i = 0; i < arr.length; i++) {
      float m = min(arr[i]); 
      if (m < min) min = m;
    }
    return min;
  }

  void setParticles(int viewY) {
    for (Particle p : particles) {
      p.setParticle();
    }
  }
}


void displayAllEnvironments() {
  viewH = 150;
  int i = 1;
  for (int j = 0; j < 4; j++) {

    pushMatrix();
    translate(0, i*viewH);
    for (Particle p : environments[j].particles) {
      p.move(i*viewH, environments[j].name);
      p.sendMessage(environments[j].getName());
    }
    popMatrix();
    i++;
  }
}
