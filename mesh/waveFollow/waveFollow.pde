
import java.util.ArrayList;
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;


PVector[] depthMap;



void setup() {
  //size(512, 424, P3D);

  fullScreen(P3D,2);

  //surface.setSize(1200, 768);
  //frame = new Frame();

  kinect = new KinectPV2(this);

  //Enables depth and Body tracking (mask image)
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);

  kinect.init();

  depthMap = new PVector[KinectPV2.WIDTHDepth*KinectPV2.HEIGHTDepth];

  initParticles();
  //people = new Person[6];
  //for (int i = 0; i < people.length; i++) {
  //  people[i] = new Person( 0, 0, width, height, 1500, 4000, i); //i*width/4, height, i);
  //}
}

void draw() {
  background(0);
  depthMap = depthMapRealWorld();

  drawPeopleCircles();
  //drawParticles();

  noFill();
  stroke(255);
  //strokeWeight(8);
  //ellipse(width/2 + width/6*sin(millis()/3000.0), height-100, 100, 100);

  //drawShape(width/2, height -100);

  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

void drawPeopleCircles() {
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    int jointType = KinectPV2.JointType_Head;
    KJoint j =  skeleton.getJoints()[jointType]; 

    jointType = KinectPV2.JointType_HandRight;
    KJoint jL =  skeleton.getJoints()[jointType]; 
    jointType = KinectPV2.JointType_HandLeft;
    KJoint jR =  skeleton.getJoints()[jointType];
    float z = getZ(j);
    if (z > 1300) {
     updateWave(z, j);
    }
  }
}

void updateWave(float z, KJoint j) {
  float x = j.getX();
  float y = j.getY();

  //float realX = map(x, 100, 400, 450, 900);
   float realX = map(x, 100, 400, 250, 1100);
  float realY = map(y, 100, 0, height-20, height-50);
  realY += map(z, 1300, 1600, 0, -10);
  displayWave(realX);
}

void drawShape(float realX, float realY) {
  stroke(255);
  noFill();
  strokeWeight(10);

  //ellipse(realX, realY, 100, 100);

  rectMode(CENTER);
  //rect(realX, realY, 100, 100);

  float diam = 100;

  pushMatrix();
  //colorMode(HSB, 255);
  translate(realX, realY);
  stroke(0, 255, 255);
  line(-diam/2, -diam/2, -diam/2, diam/2); // left
  stroke(255, 0, 255);            
  line(-diam/2, diam/2, diam/2, diam/2);  // bottom
  stroke(255, 255, 0);
  line(diam/2, diam/2, diam/2, -diam/2);  // right
  stroke(0, 255, 0);
  line(diam/2, -diam/2, -diam/2, -diam/2); // top
  popMatrix();
}

float getZ(KJoint j) {
  int w = KinectPV2.WIDTHDepth;
  int h = KinectPV2.HEIGHTDepth;
  PVector pos = j.getPosition();
  int idx = constrain(w * (int) pos.y + (int) pos.x, 0, w*h);
  float z = depthMap[idx].z;
  return z;
}


// all functions below used to generate depthMapRealWorld point cloud
PVector[] depthMapRealWorld()
{
  int w = KinectPV2.WIDTHDepth;
  int h = KinectPV2.HEIGHTDepth;

  int[] depth = kinect.getRawDepthData();
  int skip = 1;
  for (int y = 0; y < h; y+=skip) {
    for (int x = 0; x < w; x+=skip) {
      int offset = x + y * w;
      //calculate the x, y, z camera position based on the depth information
      PVector point = depthToPointCloudPos(x, y, depth[offset]);
      depthMap[w * y + x] = point;
    }
  }
  return depthMap;
}

PVector getDepthMapAt(int x, int y) {
  PVector dm = depthMap[KinectPV2.WIDTHDepth * y + x];
  return new PVector(dm.x, dm.y, dm.z);
}


//calculte the xyz camera position based on the depth data
PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue)/ (1.0f); // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}
