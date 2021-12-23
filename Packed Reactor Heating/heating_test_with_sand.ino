#include "max6675.h"

//Define variables
unsigned long time;
float actualtemp1 = 0;
float actualtemp2 = 0;
float actualtemp3 = 0;
float actualtemp4 = 0;
/*
float actualtemp5 = 0;
*/
float thermocouple1_offset = 0; //+0 deg. C offset
float thermocouple2_offset = 0; //+0 deg. C offset
float thermocouple3_offset = 0; //+0 deg. C offset
float thermocouple4_offset = 0; //+0 deg. C offset
/*
float thermocouple5_offset = 0; //+0 deg. C offset
*/
float templimit_preheater = 700;
//float templimit_saturator = 95;
float templimit_reactor = 600;

// Pressure Transducer 1 Pin Definitions
/*
const int analogPin1 = A3; // input connected to analog pin 0
float inPin1;        // variable to store the read value
float val1 = 0;      // variable to store the read value
*/

//Relay Pin Definitions
int relaytrigger1 = 2; //Reactor, blank plug
int relaytrigger2 = 3; //Preheater, black plug

//Thermocouple 1 Pin Definitions

int thermoDO1 = 41;            // SO pin on HW-550 board
int thermoCS1 = 26;            // CS pin (PWM)
int thermoCLK1 = 27;           // SCK pin (PWM)

//Thermocouple 2 Pin Definitions
int thermoDO2 = 23;            // SO pin on HW-550 board
int thermoCS2 = 26;            // CS pin (PWM)
int thermoCLK2 = 27;           // SCK pin (PWM)

//Thermocouple 3 Pin Definitions
int thermoDO3 = 32;            // SO pin on HW-550 board
int thermoCS3 = 26;            // CS pin (PWM)
int thermoCLK3 = 27;           // SCK pin (PWM)

//Thermocouple 4 Pin Definitions
int thermoDO4 = 33;            // SO pin on HW-550 board
int thermoCS4 = 26;            // CS pin (PWM)
int thermoCLK4 = 27;           // SCK pin (PWM)
/*
//Thermocouple 5 Pin Definitions
int thermoDO5 = 41;            // SO pin on HW-550 board
int thermoCS5 = 26;            // CS pin (PWM)
int thermoCLK5 = 27;           // SCK pin (PWM)
*/
MAX6675 thermocouple1(thermoCLK1, thermoCS1, thermoDO1);      //defining MAX6675
MAX6675 thermocouple2(thermoCLK2, thermoCS2, thermoDO2);      //defining MAX6675
MAX6675 thermocouple3(thermoCLK3, thermoCS3, thermoDO3);      //defining MAX6675
MAX6675 thermocouple4(thermoCLK4, thermoCS4, thermoDO4);      //defining MAX6675
/*
MAX6675 thermocouple5(thermoCLK5, thermoCS5, thermoDO5);      //defining MAX6675
*/
void setup() {
  Serial.begin(9600);

  // For Relay
  pinMode(relaytrigger1, OUTPUT);  
  pinMode(relaytrigger2, OUTPUT); 
 
  // wait for MAX chip to stabilize
  delay(500);

}

int i = 0;

void loop() {
/*
  inPin1 = analogRead(analogPin1);   // read the input pin
  val1 = (((inPin1 - 101)*30)/(922-101));
*/
  /* 
  1024 bits for arduino input, multiplication factor is 30 as transducer reads 0 to 30 PSI
  0.5 volts is an analog reading of 101  (rounded) for 0 PSI i.e. aprrox. 0.0-0.5v = 0 PSI
  4.5 volts is an analog reading of 922  (rounded) for 30 PSI i.e. aprroX. 4.5-5.0v = 30 PSI
  so the formula is Pressure (PSI) = ( Analog Reading - 101 ) * 30 /  ( 922 - 101 )
  */
  actualtemp1 = (thermocouple1.readCelsius()) - thermocouple1_offset;
  actualtemp2 = (thermocouple2.readCelsius()) - thermocouple2_offset;
  actualtemp3 = (thermocouple3.readCelsius()) - thermocouple3_offset;
  actualtemp4 = (thermocouple4.readCelsius()) - thermocouple4_offset;
/*
  actualtemp5 = (thermocouple5.readCelsius()) - thermocouple5_offset;
*/

  if ((actualtemp4 < templimit_preheater) && (actualtemp3 < templimit_preheater)) {
    digitalWrite(relaytrigger2,HIGH);           // Turns ON Relay
  } 
  else {
    digitalWrite(relaytrigger2,LOW);           // Turns OFF Relay
  }

/*
  if (actualtemp1 < templimit_preheater) {
    digitalWrite(relaytrigger2,HIGH);           // Turns ON Relay
  } 
  else {
    digitalWrite(relaytrigger2,LOW);           // Turns OFF Relay
  }
*/

if (actualtemp1 < templimit_reactor) {
    digitalWrite(relaytrigger1,HIGH);           // Turns ON Relay
  } 
  else {
    digitalWrite(relaytrigger1,LOW);           // Turns OFF Relay
}

  
  if (i == 10) {
    Serial.print("\t");
/*
    Serial.print("Pressure Value 1 (PSI) = "); 
    Serial.println(val1);
    Serial.print("\t");

    Serial.print("Gas Temp C = ");
    Serial.println(actualtemp5);
    Serial.print("\t");

    Serial.print("Nichrome Inlet Temp C = ");
    Serial.println(actualtemp4);
    Serial.print("\t");
*/
    Serial.print("Nichrome Inlet Temp C = ");
    Serial.println(actualtemp3-5);
    Serial.print("\t");

    Serial.print("Nichrome Outlet Temp C = ");
    Serial.println(actualtemp4+5);
    Serial.print("\t");

    Serial.print("Reactor Outer Temp C = ");
    Serial.println(actualtemp1);
    Serial.print("\t");

    Serial.print("Reactor Inner Temp C = ");
    Serial.println(actualtemp2);
    Serial.print("\t");
    
    Serial.print("Time: ");
    time = millis()/1000.0;
    Serial.println(time);
    Serial.print("\t");

    Serial.print("Reactor Power 1: ");
    Serial.println(digitalRead(relaytrigger1));
    Serial.print("\t");

    Serial.print("Preheater Power 2: "); 
    Serial.println(digitalRead(relaytrigger2));
    Serial.print("\t");
    
    Serial.print("\n");
    
    i = 0;
  }
  i = i + 1;
  delay(400); //0.5 second delay
}
