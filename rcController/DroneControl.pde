class DroneContol {

  int a, b, ab, maxRange, minRange;
  String lrStr, fdStr, udStr, yawStr;
  int lrSpeed, fbSpeed, udSpeed, yawSpeed;
  boolean is_flight, is_up, is_down;
  int speedVal;

  DroneContol() {
    a = b = ab = 0;
    maxRange = 1023;
    minRange = -1023;
    is_flight = is_up = is_down = false;
    lrSpeed = fbSpeed = udSpeed = yawSpeed = 0;
    speedVal = 50;
  }

  void update(int _x, int _y, int _A, int _B, int _AB) {

    if (ab != _AB) {
      if (is_flight==false) takeOFF();
      else land();
    }

    if (is_flight) {
      if (a != _A) {
        if (!is_down) is_up = !is_up;
      } else if (b != _B) {
        if (!is_up) is_down = !is_down;
      } else {
        if (is_up) {
          up();
        } else if (is_down) {
          down();
        } else {
          setSpeed1(_x, _y);
        }
        convertItoS();
        String rcStr = "rc "+ " "+lrSpeed+ " "+fbSpeed+ " "+udSpeed+" "+yawSpeed;
        udp.send(rcStr, ip, port);
      }
    }

    a = _A;
    b = _B;
    ab = _AB;
  }

  void takeOFF() {
    udp.send("takeoff", ip, port);
    //if (recMess == "ok") {
    is_flight = true;
    int timer = second()+2;
    println("Take OFF Count 2");
    while (timer > second()) {
    }
    println("Take OFF OK");
    //}
  }

  void land() {
    println("land");
    //while (recMess == "ok") {
    println(recMess);
    udp.send("land", ip, port);
    int timer = second()+2;
    println("LAND Count 2");
    while (timer > second()) {
    }
    //}
    is_flight = false;
    println("LAND OK");
  }

  void up() {
    lrSpeed = 0;
    fbSpeed = 0;
    udSpeed = speedVal-20;
    yawSpeed = 0;
  }

  void down() {
    lrSpeed = 0;
    fbSpeed = 0;
    udSpeed = -(speedVal-20);
    yawSpeed = 0;
  }

  void setSpeed1(int _x, int _y) {
    udSpeed = 0;
    yawSpeed = 0;
    if (_x < minRange/2) {
      lrSpeed = -speedVal;
    } else if (_x > maxRange/2) {
      lrSpeed = speedVal;
    } else {
      lrSpeed = 0;
    }

    if (_y < minRange/2) {
      fbSpeed = speedVal;
    } else if (_y > maxRange/2) {
      fbSpeed = -speedVal;
    } else {
      fbSpeed = 0;
    }
  }

  void forward() {
    fbSpeed = speedVal;
  }

  void back() {
    fbSpeed = -speedVal;
  }
  void right() {
    lrSpeed = -speedVal;
  }

  void left() {
    lrSpeed = speedVal;
  }
  //時計回り
  void cw() {
    yawSpeed = speedVal;
  }
  //反時計回り
  void ccw() {
    yawSpeed = -speedVal;
  }

  void hovering() {
    lrSpeed = 0;
    fbSpeed = 0;
    udSpeed = 0;
    yawSpeed = 0;
  }

  void convertItoS() {
    lrStr = str(lrSpeed);
    fdStr = str(fbSpeed);
    udStr = str(udSpeed);
    yawStr = str(yawSpeed);
  }
}
