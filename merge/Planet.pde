import java.lang.Math;
import java.util.Arrays;
import java.time.LocalDateTime;



class Planet {
  double x;
  double y;
  double z;
  double JDE;
  int size;
  color col;

  String name;
  String fileName;
  String [] lines;

  String [] myLines;

  Table table;
  int frameIndex = 0;

  Planet(String name, String file, int sz, color col) {
    this.name = name;
    this.col = col;
    fileName = file;
    lines = loadStrings(fileName);
    myLines = loadStrings(fileName);
    JDE = getJDEDate(2018, 5, 11);  // to 2020 12/11 = 2 years 7 months = 2 * 365 + 7 * 30
    size = sz;

    table = new Table();
    table.addColumn("t");
    table.addColumn("x");
    table.addColumn("y");
    table.addColumn("z");
  }

  void display() {
    pushMatrix();
    fill(col);
    lights();
    noStroke();
    translate((float)x*100, (float)z*100, (float)y*100);
    sphere(size);
    popMatrix();
  }

  void calculatePrecomputedValues() {
    //frameIndex++;
    //frameIndex = frameCount;
    //frameIndex += speedFactor;
    frameIndex = int(map(percentageComplete, 0, 1, 0, table.getRowCount()-1));

    TableRow row = table.getRow(frameIndex%table.getRowCount());
    x = row.getFloat("x");
    y = row.getFloat("y");
    z = row.getFloat("z");
  }

  void calculateVariableValues() {
    variable varX;
    variable varY;
    variable varZ;


    varX = new variable(1);
    String [] newLines = varX.calculateVariable(JDEtoT(JDE), lines);
    x = varX.value;

    varY = new variable(2);
    myLines = varY.calculateVariable(JDEtoT(JDE), newLines);
    y = varY.value;

    varZ = new variable(3);
    newLines = varZ.calculateVariable(JDEtoT(JDE), myLines);
    z = varZ.value;
  }

  double calculateDistance() {
    double distance;

    distance = Math.sqrt(x*x + y*y + z*z);
    return distance;
  }

  double calculateDistanceFromPlanet(Planet that) {
    double distance;

    distance = Math.sqrt(Math.pow((this.x - that.x), 2) + Math.pow((this.y - that.y), 2) + Math.pow((this.z - that.z), 2));
    return distance;
  }

  double getT() {
    LocalDateTime time = LocalDateTime.now();
    double UCT_time;
    double JDE;
    double myT;

    UCT_time = (double)((time.getHour() + 5)*3600 + time.getMinute()*60 + time.getSecond() + 65)/(24 * 3600);
    JDE = (2 - (3.0/400)*time.getYear()) + time.getDayOfMonth() + 365.25*(time.getYear() + 4716) + 30.0001*(time.getMonthValue() + 1) - 1524.5 + UCT_time;
    myT = (double)(JDE - 2451545) / (365250);

    return myT;
  }

  double getTDate(int year, int month, int day, int hour, int minute, int second) {
    LocalDateTime time = LocalDateTime.of(year, month, day, hour, minute, second);
    double UCT_time;
    double JDE;
    double myT;

    UCT_time = (double)((time.getHour() + 5)*3600 + time.getMinute()*60 + time.getSecond() + 65)/(24 * 3600);
    JDE = (2 - (3.0/400)*time.getYear()) + time.getDayOfMonth() + 365.25*(time.getYear() + 4716) + 30.0001*(time.getMonthValue() + 1) - 1524.5 + UCT_time;
    myT = (double)(JDE - 2451545) / (365250);

    return myT;
  }

  double getJDE() {
    LocalDateTime time = LocalDateTime.now();
    double UCT_time;
    double JDE;

    UCT_time = (double)((time.getHour() + 5)*3600 + time.getMinute()*60 + time.getSecond() + 65)/(24 * 3600);
    JDE = (2 - (3.0/400)*time.getYear()) + time.getDayOfMonth() + 365.25*(time.getYear() + 4716) + 30.0001*(time.getMonthValue() + 1) - 1524.5 + UCT_time;
    return JDE;
  }

  double JDEtoT(double myJDE) {
    double myT = (double)(myJDE - 2451545) / (365250);
    return myT;
  }

  void changeJDE(double day) {
    // 1s = 1/(3600 * 24) T units (days)
    //JDE += change/(3600 * 24);
    JDE += day;
  }

  void addLocation() {
    TableRow newRow = table.addRow();
    newRow.setFloat("t", table.getRowCount() - 1);
    newRow.setFloat("x", (float)x);
    newRow.setFloat("y", (float)y);
    newRow.setFloat("z", (float)z);
  }

  void saveLocation() {
    saveTable(table, "data/computed/" + name + ".csv");
  }

  void loadPrecomputed() {
    table = loadTable("data/computed/" + name + ".csv", "header");
  }

  double getJDEDate(int year, int month, int day) {
    LocalDateTime time = LocalDateTime.of(year, month, day, 0, 0, 0);
    double UCT_time;
    double JDE;

    UCT_time = (double)((time.getHour() + 5)*3600 + time.getMinute()*60 + time.getSecond() + 65)/(24 * 3600);
    JDE = (2 - (3.0/400)*time.getYear()) + time.getDayOfMonth() + 365.25*(time.getYear() + 4716) + 30.0001*(time.getMonthValue() + 1) - 1524.5 + UCT_time;
    return JDE;
  }


  float[] calculateVariablesOnce(double myT) {
    float [] variables = new float[2];
    variable varX;
    variable varY;

    varX = new variable(1);
    String [] newLines = varX.calculateVariable(myT, lines);
    variables[0] = (float)varX.value;

    varY = new variable(2);
    myLines = varY.calculateVariable(myT, newLines);
    variables[1] =  (float)varY.value;

    return variables;
  }

  PVector getStart() {
    TableRow row = table.getRow(0);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    float z = row.getFloat("z");
    return new PVector(x*100, y*100, z*100);
  }

  PVector getEnd() {
    TableRow row = table.getRow(table.getRowCount()-1);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    float z = row.getFloat("z");
    return new PVector(x*100, y*100, z*100);
  }

  PVector getFlight(int days) {
    int index = int(map(days, 0, numDays, 0, table.getRowCount()-1));
    TableRow row = table.getRow(index);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    float z = row.getFloat("z");
    return new PVector(x*100, y*100, z*100);
  }
}
