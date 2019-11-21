import oscP5.*;
import netP5.*;
OscP5 oscP5;
/* a NetAddress contains the ip address and port number of a remote location in the network. */
NetAddress myRemoteLocation; 

void initOsc() {
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  oscP5 = new OscP5(this, 12000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1", 14000);
}

void sendOsc(String planet, double x, double y, double z) {
  OscMessage myMessage = new OscMessage("/planet");
  myMessage.add(planet);
  myMessage.add((float)x); 
  myMessage.add((float)y); 
  myMessage.add((float)z);

  oscP5.send(myMessage, myRemoteLocation);
}


void oscEvent(OscMessage theOscMessage) {
    /* rates
        60 - min/sec
        3600 - hour/ sec
        86400 - day/sec
        52 594.8766 -- 6 months/5 min
        */

    if (theOscMessage.checkAddrPattern("/planets/rate")==true) {
           rate = theOscMessage.get(0).intValue();
   } 
   
   if (theOscMessage.checkAddrPattern("/planets/messageRate")==true) {
     messageRate = theOscMessage.get(0).intValue();
   }
   
   if (theOscMessage.checkAddrPattern("/speed")==true) {
     speedFactor = theOscMessage.get(0).floatValue();
   }
}

void sendOSCMessages() {
  if (millis() - lastMessage > (1000 / messageRate)) {
    for (Planet p : planets) {
      sendOsc(p.name, p.x, p.y, p.z);
    }
    lastMessage = millis();
  }
}

void sendOsc(String env, float energy, int mass, int r, int c) {
  OscMessage myMessage = new OscMessage("/particle");
  myMessage.add(env);
  myMessage.add(energy); 
  myMessage.add(mass);
  myMessage.add(r);
  myMessage.add(c);
  oscP5.send(myMessage, myRemoteLocation);
}
