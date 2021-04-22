#include <Wire.h>
#include "skywriter.h"

#define PIN_TRFR  0   
#define PIN_RESET 3

void setup() {
  Serial.begin(9600); //how many bit per second
  while(!Serial){};
  Serial.println("Hello World!");
  
  Skywriter.begin(PIN_TRFR, PIN_RESET);
  Skywriter.onXYZ(handle_xyz);
}

void loop() {
  Skywriter.poll();
}

void handle_xyz(unsigned int x, unsigned int y, unsigned int z){
 char buf[17];
 sprintf(buf, "%05u:%05u:%05u", x, y, z);  //
 Serial.println(buf);
 delay(0.01);
}
