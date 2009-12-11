/*
 * Xylophone - Arduino sketch for Internet controlled xylophone
 *
 * Copyright (c) 2009 Mika Tuupola
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Project home:
 *   https://github.com/tuupola/arduino_xylophone
 *
 */

#include <Client.h>
#include <Ethernet.h>

#include <Dhcp.h>
#include <WString.h>
#include <Wire.h>

#include <ctype.h>

#define SD21   0x61
#define HAMMER_THROW 15 /* How low hammer hits. */
#define HAMMER_TIME  19 /* How long hammer stays down. Can't touch this! */
#define TEMPO  200
#define LED    13
#define SERVO_CENTER 118

#define COMPLETE 0
#define CONNECTED 1
#define NEW_SONG 2
#define RECORDING 3

int status = COMPLETE;

byte mac[]    = {0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED};
byte server[] = {192, 168, 1, 65};

int servo[] = {0x3F, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b};
int servo_adjust[] = {-3, +8, -20, +17, -2, +15, -18, +4, -7, +16, -18, +19, +6};
int num_servos = 13;

Client client(server, 4567);

String notes           = "CDEFGABcdefga";
                          
String jingle_bells    = "E,E,E, ,E,E,E, ,E,G,C,D,E, , ,F,F,F,F,F,E,E,E,E,D,D,E,E, ,G, ,G,G,F,D,C, ";
String servo_test      = "C,D,E,F,G,A,B,c,d,e,f,g,a,g,f,e,d,c,B,A,G,F,E,D,C, ";
String servo_test2      = "C,C,C,C,C,C,C,C,D,D,D,D,D,D,D,D,E,E,E,E,E,E,E, ";

String twinkle_twinkle = "C,C,G,G,A,A,G, ,F,F,E,E,D,D,C, ,G,G,F,F,E,E,D, ,G,G,F,F,E,D,C, ";

String song;
String song_id;

void setup(){
    Serial.begin(115200);
  
    Serial.println("debug:Starting Arduino.");

    int dhcp_result = Dhcp.beginWithDHCP(mac);
  
    if (1 == dhcp_result)  {
        byte dhcp_data[4];
        char ip[4];
        Serial.print("debug:Arduino ip ");
        Dhcp.getLocalIp(dhcp_data);
        for(int i = 0; i < 4; i++) {
            Serial.print(itoa(dhcp_data[i], ip, 10));
            Serial.print(".");
        }
        Serial.println();
        delay(1000);
        Serial.print("debug:Gateway ip ");
        Dhcp.getGatewayIp(dhcp_data);
        for(int i = 0; i < 4; i++) {
            Serial.print(itoa(dhcp_data[i], ip, 10));
            Serial.print(".");
        }
        Serial.println();    
    } else {
        Serial.println("debug:Could not get IP address.");
    }

    Wire.begin();
    pinMode(LED, OUTPUT);     
    center_all_servos();


    delay(1000);    
    Serial.println("debug:First servo test.");
    play(servo_test, 200);
    Serial.println("debug:Second servo test.");
    play(servo_test, 100);
    Serial.println("debug:Third servo test.");
    play(servo_test, 80);
    delay(1000);    

}

void loop() {
    digitalWrite(LED, HIGH);
    //int result = memoryTest();
    //Serial.print("debug:Memory ");
    //Serial.print(result,DEC);
    //Serial.println(" bytes free");

    switch (status) {
        case COMPLETE:
            connect();
            break;
        case CONNECTED:
            request_next_song();
            delay(1000);
            disconnect();
            break;
        case NEW_SONG:
            record_song();                
            break;
        case RECORDING:
            wait_for_laptop();
    }
    digitalWrite(LED, LOW);
    center_all_servos();
    delay(5000);
}

void connect() {
    if (client.connect()) {
        Serial.println("debug:Connected to webserver.");
        status = CONNECTED;
    } else {
        Serial.println("debug:Connection to webserver failed.");
        status = COMPLETE;  
    }
}

void disconnect() {
    Serial.println("debug:Disconnecting from webserver.");
    client.stop();
}

void request_next_song() {
    song    = ' ';
    song_id = ' ';
    Serial.println("debug:Requesting next song.");
    boolean start_mark_received = false;
    client.println("GET /next HTTP/1.0");
    client.println();
    delay(500);
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
    if (song.length() > 0) { 
        status = NEW_SONG;
        Serial.print("debug:New song with length of ");
        Serial.print(song.length());
        Serial.println(".");
    } else {
        Serial.println("debug:No new songs.");
        status = COMPLETE;
    }
    //Serial.println(song);
}

void record_song() {
    status = RECORDING;
    Serial.print("record:song-");
    Serial.print(song_id);
    Serial.println(".mov");
    /* Delay 5 seconds for webcam to catch up. */
    delay(5000);
    play(song, TEMPO);
    play(song, TEMPO);
    //play(jingle_bells, TEMPO);
    //play(jingle_bells, TEMPO);
    Serial.print("stop:song-");
    Serial.print(song_id);
    Serial.println(".mov");
}

void wait_for_laptop() {
    Serial.println("debug:Waiting for laptop to be ready.");
    while (Serial.available() > 0) {
        if (Serial.read() == 'c') {
            status = COMPLETE;
            Serial.println("debug:Entering next loop.");
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
        Wire.send(SERVO_CENTER + servo_adjust[i] - HAMMER_THROW);
        Wire.endTransmission();
    }
}

void hammer_up(char s) {
    int i = notes.indexOf(s);
    /* Ignore any carbage we might receive. */
    if (-1 != i) {
        Wire.beginTransmission(SD21);
        Wire.send(servo[i]);
        Wire.send(SERVO_CENTER + servo_adjust[i]);
        Wire.endTransmission();
    }
}

void play(char *s, int tempo) {
    int l = strlen(s);
    //Serial.print("Debug:");
    for (int x = 0; x < l; x++) {
        if (',' == s[x]) {
            delay(HAMMER_TIME);
            center_all_servos();
            delay(tempo);
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
        Wire.send(SERVO_CENTER + servo_adjust[i]);
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

