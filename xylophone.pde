#include <WString.h>
#include <Wire.h>


#define SD21   0x61
#define BOUNCE 80
#define TEMPO  150
#define LED    13

int servo[] = {0x3F, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d};
int servo_center[] = {114, 110, 133, 131, 122,130, 115, 112, 117, 139, 130, 132, 127, 127, 123};
int num_servos = 15;

String notes = "CDEFGABcdefgab";

void setup(){
  Wire.begin();
  Serial.begin(9600);
  pinMode(LED, OUTPUT);     
  center_all_servos();
}

void loop() {
  //play("CDEFGABcdefgab");
  play("EEE EEE EGCDE   FFFFFEEEEDDEE G GGFDC ");
  digitalWrite(LED, LOW);
  delay(1000);
  play("CCGGAAG FFEEDDC GGFFEED GGFFEDC ");
  delay(1000);
  //servo_test();
}

void note(char s) {
  int i = notes.indexOf(s);
  Serial.print(s);
  Serial.print(":");
  Serial.print(i);
  Serial.print(":");
  Serial.println(servo[i]);
  Wire.beginTransmission(SD21);
  Wire.send(servo[i]);    
  Wire.send(servo_center[i] - 20);
  Wire.endTransmission();
  delay(50);
  Wire.beginTransmission(SD21);
  Wire.send(servo[i]);
  Wire.send(servo_center[i]);
  Wire.endTransmission();

}

void play(char *s) {
  int l = strlen(s);
  for (int x = 0; x < l; x++) {
    note(s[x]);
    delay(TEMPO);
  }
}


void center_all_servos() {
  for (int i = 0; i < num_servos; i++) {
    Wire.beginTransmission(SD21);
    Wire.send(servo[i]);    
    Wire.send(servo_center[i]);
    Wire.endTransmission();
  }
}

