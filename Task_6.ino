
// these constants won't change:
const int ledPin = 13;      // led connected to digital pin 13
const int knockSensor = A0; // the piezo is connected to analog pin 0
const int threshold = 50;  // threshold value to decide when the detected sound is a knock or not
const int threshold_press = 110;//pressure sensor

// these variables will change:
int sensorReading = 0;      // variable to store the value read from the sensor pin
int ledState = LOW;         // variable used to store the last LED status, to toggle the light
int signalcount=0;
unsigned int time_start = 0;
unsigned int time_end = 0;

//photocell unit
unsigned int last_time = 0;
int threshold_photocell_low = 300;
int threshold_photocell_high = 500;

void setup() {
 pinMode(ledPin, OUTPUT); // declare the ledPin as as OUTPUT
 Serial.begin(9600);       // use the serial port
 time_start = time_end = 0;
 last_time = analogRead(A3);
}

void loop() {
  // read the sensor and store it in the variable sensorReading:
  
  sensorReading = analogRead(knockSensor);    
  ++time_end;
  int time_delta = time_end - time_start;
  // if the sensor reading is greater than the threshold:
  if (sensorReading >= threshold) {
    ledState = !ledState;
    digitalWrite(ledPin, ledState);
    signalcount++;
  }
  
  if( time_delta >= 22 )
  {
      if(signalcount>=3){
      signalcount = 3;
      }
      Serial.write(signalcount);
      //Serial.println(signalcount);
      //delay(100);  // delay to avoid overloading the serial port buffer
      signalcount=0;
      time_end=0;
  }
  
  //press control
  int sensorReading1 = analogRead(A1);//volume controlt
  int sensorReading2 = analogRead(A2);//forward control
  const char volume = 4;
  const char forward = 5;
  const char light = 6;
  //const int volume = 4;
  //const int forward = 5;
   if (sensorReading1 > threshold_press) {
      Serial.write(volume);//volume
     // Serial.println(sensorReading1);
    }
  else{
    if (sensorReading2 > threshold_press) {
      Serial.write(forward);//forward
    //  Serial.println(sensorReading2);
    }
  }

  int PhotocellReading = analogRead(A3);
  if (last_time >= threshold_photocell_high && PhotocellReading <= threshold_photocell_low)
  {
      Serial.write(light);
  }
  last_time = PhotocellReading;
  delay(100);
}

