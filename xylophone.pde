#include <Client.h>
#include <Ethernet.h>
#include <Dhcp.h>
#include <WString.h>
#include <Wire.h>

#define SD21   0x61
#define BOUNCE 80
#define TEMPO  150
#define LED    13

#define DISCONNECTED 0
#define CONNECTED 1
#define SONG_AVAILABLE 2
#define READING 3
#define COMPLETE 4
#define PAUSING 5

int status = DISCONNECTED;

byte mac[]    = {0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED};
byte server[] = {192, 168, 1, 66};

int servo[] = {0x3F, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d};
int servo_center[] = {114, 110, 133, 131, 122,130, 115, 112, 117, 139, 130, 132, 127, 127, 123};
int num_servos = 15;

Client client(server, 4567);

String notes           = "CDEFGABcdefgab";
String jingle_bells    = "EEE EEE EGCDE   FFFFFEEEEDDEE G GGFDC ";
String twinkle_twinkle = "CCGGAAG FFEEDDC GGFFEED GGFFEDC ";

char song[128][14]; 

void setup(){
    Serial.begin(9600);
  
    Serial.print("Requesting ip address...");
    int dhcp_result = Dhcp.beginWithDHCP(mac);
  
    if (1 == dhcp_result)  {
        Serial.println("OK");
        byte dhcp_data[4];
        char ip[4];
        Serial.print("Arduino ip: ");
        Dhcp.getLocalIp(dhcp_data);
        for(int i = 0; i < 4; i++) {
            Serial.print(itoa(dhcp_data[i], ip, 10));
            Serial.print(".");
        }
        Serial.println();
        Serial.print("Gateway ip: ");
        Dhcp.getGatewayIp(dhcp_data);
        for(int i = 0; i < 4; i++) {
            Serial.print(itoa(dhcp_data[i], ip, 10));
            Serial.print(".");
        }
        Serial.println();    
    }
    
    Wire.begin();
    pinMode(LED, OUTPUT);     
    center_all_servos();
    
}

void loop() {
    digitalWrite(LED, HIGH);
    switch (status) {
        case DISCONNECTED:
            connect();
            break;
        case CONNECTED:
            request_next_song();
            record_song();
            break;
        case COMPLETE:
            disconnect();
            break;
    }
  
    digitalWrite(LED, LOW);
    delay(1000);
    //servo_test();
}

void connect() {
    if (client.connect()) {
        Serial.println("Connected...");
        status = CONNECTED;
    } else {
        Serial.println("Connection failed...");
        status = COMPLETE;  
    }
}

void disconnect() {
    Serial.println("Disconnecting...");
    client.stop();
    status = DISCONNECTED;
}

void request_next_song() {
    Serial.println("Requesting next song...");
    boolean start_mark_received = false;
    char get[100];
    client.println("GET /next HTTP/1.0");
    client.println();
    delay(50);
    while (client.available()) {
        char c = client.read();
        if (start_mark_received == true) {
            Serial.print(c);
        } else if (c == '-') {
            start_mark_received = true;
        }
    }
}

void record_song() {
    Serial.println("Recording...");
    status = COMPLETE;
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

