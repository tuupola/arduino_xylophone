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

#define LED    13        /* Blinking led is in pin 13. */

#define SD21   0x61      /* Address of servo controller in I2C bus. */
#define TEMPO  200      
#define HAMMER_THROW 21  /* (15) How low hammer hits. */
#define HAMMER_TIME  19  /* (19) How long hammer stays down. Can't touch this! */
#define SERVO_CENTER 122 /* (119) Starting height of the hammers. */

#define COMPLETE  0
#define CONNECTED 1
#define NEW_SONG  2
#define RECORDING 3

int status = COMPLETE;

byte mac[]    = {0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED}; /* Arduino MAC address. */
byte server[] = {212, 47, 219, 73}; /* Webserver IP address. */

int servo[] = {0x3F, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b};
int servo_adjust[] = {-7, +8, -20, +17, -3, +17, -18, +4, -8, +15, -20, +18, +4};
int num_servos = 13;

Client client(server, 4567);

String notes           = "CDEFGABcdefga";
                          
String jingle_bells    = "E,E,E, ,E,E,E, ,E,G,C,D,E, , ,F,F,F,F,F,E,E,E,E,D,D,E,E, ,G, ,G,G,F,D,C, ";
String servo_test      = "C,D,E,F,G,A,B,c,d,e,f,g,a,g,f,e,d,c,B,A,G,F,E,D,C, ";
String servo_test2      = "C,C,C,C,C,C,C,C,D,D,D,D,D,D,D,D,E,E,E,E,E,E,E, ";

String twinkle_twinkle = "C,C,G,G,A,A,G, ,F,F,E,E,D,D,C, ,G,G,F,F,E,E,D, ,G,G,F,F,E,D,C, ";

String song;     /* Song data received from webserver. */ 
String song_id;  /* Song id of the above song. */

void setup(){
    Serial.begin(115200);
    Serial.println("debug:Starting Arduino.");

    /* Request IP address from DHCP... */
    int dhcp_result = Dhcp.beginWithDHCP(mac);
    
    /* ... and print it out for debugging purposes. */
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

    /* Run servo tests on startup. */
    delay(1000);    
    Serial.println("debug:First servo test.");
    play(servo_test, 200);
    Serial.println("debug:Second servo test.");
    play(servo_test, 100);
    Serial.println("debug:Third servo test.");
    play(servo_test, 80);
    delay(1000);  

    play(jingle_bells, 200);
    delay(1000);  
  
}

void loop() {
    /* Blink led so we know Arduino is alive. */
    digitalWrite(LED, HIGH);

    switch (status) {
        /* Connect to webserver. */
        case COMPLETE:
            connect();
            break;
        /* If connected request next song and disconnect. */
        case CONNECTED:
            request_next_song();
            delay(1000);
            disconnect();
            break;
        /* Instruct MacBook to start recording and play the song. */    
        case NEW_SONG:
            record_song();                
            break;
        /* Wait until MacBook tells it has finished recording. */
        case RECORDING:
            wait_for_laptop();
    }

    /* Blink led so we know Arduino is alive. */
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
        /* Song data starts after we receive = character. */
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
}

void record_song() {
    status = RECORDING;
    
    /* Tell MacBook to start recording. */
    Serial.print("record:song-");
    Serial.print(song_id);
    Serial.println(".mov");
    
    /* Delay 5 seconds for webcam to catch up. */
    delay(5000);
    
    /* Play song twice. */
    play(song, TEMPO);
    play(song, TEMPO);

    /* Add some silence to the end of the video. */
    delay(3000);

    /* Tell MacBook to stop recording. */
    Serial.print("stop:song-");
    Serial.print(song_id);
    Serial.println(".mov");
}

void wait_for_laptop() {
    Serial.println("debug:Waiting for laptop to be ready.");
    
    /* MacBook tells it is ready by sending character 'c'. */
    while (Serial.available() > 0) {
        if (Serial.read() == 'c') {
            status = COMPLETE;
            Serial.println("debug:Entering next loop.");
        }
    }
}

/* Play single note in simple mode. */
void note(char s) {
    int i = notes.indexOf(s);
    if (-1 != i) {
        hammer_down(s);
        delay(HAMMER_TIME);
        hammer_up(s);
    }
}

/* Hits the hammer down for given note. */
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

/* Moves hammer of given note back up. */
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
    for (int x = 0; x < l; x++) {
        if (',' == s[x]) {
            delay(HAMMER_TIME);
            center_all_servos();
            delay(tempo);
        } else {
            hammer_down(s[x]);            
        }
    }
    center_all_servos();

}

void center_all_servos() {
    for (int i = 0; i < num_servos; i++) {
        Wire.beginTransmission(SD21);
        Wire.send(servo[i]);    
        Wire.send(SERVO_CENTER + servo_adjust[i]);
        Wire.endTransmission();
    }
}

