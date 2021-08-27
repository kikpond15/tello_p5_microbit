import hypermedia.net.*;
import processing.serial.*;
Serial microbit;
UDP udp;
DroneContol drone;

String ip = "192.168.10.1"; 
int port = 8889;
int mbitX, mbitY, mbitA, mbitB, mbitAB = 0;
String recMess;

void setup() {
  String []portName = Serial.list();
  println(portName);
  microbit = new Serial(this, portName[3], 115200);
  drone = new DroneContol();
  udp = new UDP(this, port);
  udp.listen(true);
  udp.send("command", ip, port);
}

void draw() {
  drone.update(mbitX,mbitY,mbitA,mbitB,mbitAB);
}

void serialEvent(Serial microbit) {
  String str = microbit.readStringUntil('\n');


  if (str != null) {
    str = trim(str);
    //String []strs = split(str, ',');
    //println(strs);

      int []sensors = int(split(str, ','));
      mbitX = sensors[0];
      mbitY = sensors[1];
      mbitA = sensors[2];
      mbitB = sensors[3];
      mbitAB = sensors[4];
      //println("x="+ sensors[0]+ ", y="+ sensors[1]+ ", A="+ sensors[2]+ ", B="+ sensors[3]+ ", AB="+ mbitAB);
  }
}

void keyPressed(){
  if(key == 't'){
    udp.send("takeoff", ip, port);
  } else if(key == 'l'){
    udp.send("land", ip, port);
  } else if(key == 'b'){
    udp.send("battery?", ip, port);
  }
}

void receive(byte[] data, String ip, int port) {
  // 後ろ2バイトは改行コード
  data = subset(data, 0, data.length);
  recMess = new String(data);
  println(recMess);
}
