/*
  ReadAnalogVoltage
  Reads an analog input on pin 0, converts it to voltage, and prints the result to the serial monitor.
  Graphical representation is available using serial plotter (Tools > Serial Plotter menu)
  Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.

  This example code is in the public domain.
*/
int selectorOne = 10; 
int selectorTwo = 11;
int selectorThree = 5;
int selectorFour = 6;
int i = 0;

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  pinMode(selectorOne, INPUT);
  pinMode(selectorTwo, INPUT);
  pinMode(selectorThree, OUTPUT);
  pinMode(selectorFour, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  digitalWrite(selectorFour, LOW);
  digitalWrite(selectorThree, LOW);
  // read the input on analog pin 5:
  int sensorValue = analogRead(A5);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  float voltage = sensorValue * (10.0 / 1023.0);
  // print out the value you read:
  Serial.println(voltage);

  //Serial.println(sensorValue);

  //pinMode(selectorOne, INPUT);
//  if (i > 500){
//    pinMode(selectorOne, OUTPUT);
//    digitalWrite(selectorOne, LOW);
//  }
//  if (i > 1000){
//    pinMode(selectorOne, INPUT);
//    i = 0;
//  }
//  i = i+1;

}
