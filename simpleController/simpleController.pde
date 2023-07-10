/*
microbit program here
https://makecode.microbit.org/S70876-27321-00007-77896
*/

import hypermedia.net.*;
import processing.serial.*;
Serial microbit;
UDP udp;

String ip = "192.168.10.1";
int port = 8889;
int readVal = -1;
String distance = str(30);

void setup() {
  size(400, 400);
  String []portName = Serial.list();
  for (String s : portName) {
    println(s);
  }
  microbit = new Serial(this, portName[2], 115200);
  udp = new UDP(this, port);
  udp.listen(true);
  udp.send("command", ip, port);
}

void draw() {
  background(200);
  if (microbit.available() > 0) {
    String s = microbit.readString();
    readVal = int(s);
    println(readVal);

    if (readVal == 0) {
      udp.send("takeoff", ip, port);
    } else if (readVal == 1) {
      udp.send("land", ip, port);
    } else if (readVal == 2) {
      udp.send("forward " + distance, ip, port);
    } else if (readVal == 3) {
      udp.send("left " + distance, ip, port);
    } else if (readVal == 4) {
      return ; 
    } else if (readVal == 5) {
      udp.send("right " + distance, ip, port);
    } else if (readVal == 6) {
      udp.send("back " + distance, ip, port);
    }
  }
}


void keyPressed() {
  if (key == 't') {
    udp.send("takeoff", ip, port);
  } else if (key == 'l') {
    udp.send("land", ip, port);
  } else if (key == 'b') {
    udp.send("battery?", ip, port);
  }
}

void receive(byte[] data, String ip, int port) {
  // 後ろ2バイトは改行コード
  data = subset(data, 0, data.length);
  String recMess = new String(data);
  println(recMess);
}
