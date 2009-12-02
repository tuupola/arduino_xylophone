#include <Client.h>
#include <Ethernet.h>

#include <Dhcp.h>
#include <WString.h>
#include <Wire.h>

#include <ctype.h>

#define SD21   0x61
#define BOUNCE 80
#define TEMPO  500
#define LED    13

#define DISCONNECTED 0
#define CONNECTED 1
#define RECORDING 2
#define COMPLETE 3

int status = DISCONNECTED;

byte mac[]    = {0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED};
byte server[] = {192, 168, 1, 120};

int servo[] = {0x3F, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d};
int servo_center[] = {114, 110, 133, 131, 122,130, 115, 112, 117, 139, 130, 132, 127, 127, 123};
int num_servos = 15;

Client client(server, 4567);

String notes           = "CDEFGABcdefga";
                          
String jingle_bells    = "E,E,E, ,E,E,E, ,E,G,C,D,E, ,  ,F,F,F,F,F,E,E,E,E,D,D,E,E, ,G, ,G,G,F,D,C, ";
String twinkle_twinkle = "CCGGAAG FFEEDDC GGFFEED GGFFEDC ";

String song;
String song_id;

void setup(){
    Serial.begin(19200);
  
    Serial.println("debug:Starting Arduino.");
    int dhcp_result = Dhcp.beginWithDHCP(mac);
  
    if (1 == dhcp_result)  {
        byte dhcp_data[4];
        char ip[4];
        //Serial.print("debug:Arduino ip ");
        Dhcp.getLocalIp(dhcp_data);
        for(int i = 0; i < 4; i++) {
            //Serial.print(itoa(dhcp_data[i], ip, 10));
            //Serial.print(".");
        }
        //Serial.println();
        //Serial.print("debug:Gateway ip ");
        Dhcp.getGatewayIp(dhcp_data);
        for(int i = 0; i < 4; i++) {
            //Serial.print(itoa(dhcp_data[i], ip, 10));
            //Serial.print(".");
        }
        //Serial.println();    
    } else {
        Serial.println("debug:Could not get IP address.");
    }
    
    Wire.begin();
    pinMode(LED, OUTPUT);     
    center_all_servos();
    
}

void loop() {
    digitalWrite(LED, HIGH);
    //int result = memoryTest();
    //Serial.print("debug:Memory ");
    //Serial.print(result,DEC);
    //Serial.println(" bytes free");
            
    switch (status) {
        case DISCONNECTED:
            connect();
            break;
        case CONNECTED:
            request_next_song();
            record_song();                
            break;
        case RECORDING:
            wait_for_laptop();
            break;       
        case COMPLETE:
            disconnect();
            break;
    }
    digitalWrite(LED, LOW);
    center_all_servos();
    delay(1000);
}

void connect() {
    if (client.connect()) {
        //Serial.println("debug:Connected...");
        status = CONNECTED;
    } else {
        //Serial.println("debug:Connection failed...");
        status = COMPLETE;  
    }
}

void disconnect() {
    //Serial.println("debug:Disconnecting...");
    client.stop();
    status = DISCONNECTED;
}

void request_next_song() {
    song    = ' ';
    song_id = ' ';
    //Serial.println("debug:Requesting next song...");
    boolean start_mark_received = false;
    client.println("GET /next HTTP/1.0");
    client.println();
    delay(50);
    while (client.available()) {
        char c = client.read();
        if (start_mark_received) {
            if (isdigit(c)) {
                song_id.append(c);
            } else {
                song.append(c);                
            }
        } else if (c == '=') {
            start_mark_received = true;
        }
    }
    //Serial.println(song);
}

void record_song() {
    if (song.length() > 0) {
        status = RECORDING;
        Serial.print("record:");
        Serial.println(song_id);
        play(song);
        //play(jingle_bells);
        Serial.print("stop:");
        Serial.println(song_id);
    } else {
        //Serial.println("debug:No song in queue..");
        status = COMPLETE;        
    }
}

void wait_for_laptop() {
    //Serial.println("debug:Waiting for laptop to be ready.");
    while (Serial.available() > 0) {
        if (Serial.read() == 'c') {
            status = COMPLETE;
        }
    }
}

/*
void note(char s) {
    int i = notes.indexOf(s);
    if (-1 != i) {
        hammer_down();
        delay(50);
        hammer_up();
    }
}
*/

void hammer_down(char s) {
    int i = notes.indexOf(s);
    /* Ignore any carbage we might receive. */
    if (-1 != i) {
        //Serial.print(s);
        Wire.beginTransmission(SD21);
        Wire.send(servo[i]);    
        Wire.send(servo_center[i] - 20);
        Wire.endTransmission();
    }
}

void hammer_up(char s) {
    int i = notes.indexOf(s);
    /* Ignore any carbage we might receive. */
    if (-1 != i) {
        Wire.beginTransmission(SD21);
        Wire.send(servo[i]);
        Wire.send(servo_center[i]);
        Wire.endTransmission();
    }
}

void play(char *s) {
    int l = strlen(s);
    //Serial.print("Debug:");
    for (int x = 0; x < l; x++) {
        if (',' == s[x]) {
            delay(50);
            center_all_servos();
            delay(TEMPO);
        } else {
            hammer_down(s[x]);            
        }
    }
    //Serial.println();
}

void center_all_servos() {
    for (int i = 0; i < num_servos; i++) {
        Wire.beginTransmission(SD21);
        Wire.send(servo[i]);    
        Wire.send(servo_center[i]);
        Wire.endTransmission();
    }
}

// this function will return the number of bytes currently free in RAM
int memoryTest() {
  int byteCounter = 0; // initialize a counter
  byte *byteArray; // create a pointer to a byte array
  // More on pointers here: http://en.wikipedia.org/wiki/Pointer#C_pointers

  // use the malloc function to repeatedly attempt allocating a certain number of bytes to memory
  // More on malloc here: http://en.wikipedia.org/wiki/Malloc
  while ( (byteArray = (byte*) malloc (byteCounter * sizeof(byte))) != NULL ) {
    byteCounter++; // if allocation was successful, then up the count for the next try
    free(byteArray); // free memory after allocating it
  }
  
  free(byteArray); // also free memory after the function finishes
  return byteCounter; // send back the highest number of bytes successfully allocated
}

