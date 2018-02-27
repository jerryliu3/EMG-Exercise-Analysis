int selectorOne = 5; 
int selectorTwo = 6;
int selectorThree = 10;
int selectorFour = 11;
boolean choose = true;
int i = 0;
float myArray[]= {0,0};
int sensorValue = analogRead(A5);

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  pinMode(selectorOne, INPUT);
  pinMode(selectorTwo, INPUT);
  pinMode(selectorThree, INPUT);
  pinMode(selectorFour, INPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  pinMode(selectorOne, INPUT);
  pinMode(selectorTwo, INPUT);
  pinMode(selectorThree, OUTPUT);
  pinMode(selectorFour, OUTPUT);
  digitalWrite(selectorThree, LOW);
  digitalWrite(selectorFour, LOW);
  //delay(300);
    
  // read the input on analog pin 5:
  sensorValue = analogRead(A5);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 10V):
  myArray[0] =  sensorValue * (10.0 / 1023.0);
    
  pinMode(selectorOne, OUTPUT);
  pinMode(selectorTwo, OUTPUT);
  digitalWrite(selectorOne, LOW);
  digitalWrite(selectorTwo, LOW);
  pinMode(selectorThree, INPUT);
  pinMode(selectorFour, INPUT);
  //delay(300);

  // read the input on analog pin 5:
  sensorValue = analogRead(A5);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 10V):
  myArray[1] = sensorValue * (10.0 / 1023.0);
  
  // print out the value you read:
  Serial.print(myArray[0]);
  Serial.print(",");
  Serial.println(myArray[1]);
}
