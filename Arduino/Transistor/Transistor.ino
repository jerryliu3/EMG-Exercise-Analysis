int selectorOne = 13; 
boolean choose = true;
int i = 0;
float myArray[]= {0,0};
int sensorValue = analogRead(A5);

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  pinMode(selectorOne, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  digitalWrite(selectorOne, HIGH);
  delay(5000);
  digitalWrite(selectorOne, LOW);
  delay(5000);
}
