int selectorOne = 5; 
int selectorTwo = 6;
int selectorThree = 10;
int selectorFour = 11;
boolean choose = true;
int i = 0;
double firstArray[]= [0,0];


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
  if(i == 2000){
    i = 0;
  }
  else if(i<=1000) {
    pinMode(selectorOne, INPUT);
    pinMode(selectorTwo, INPUT);
    pinMode(selectorThree, OUTPUT);
    pinMode(selectorFour, OUTPUT);
    digitalWrite(selectorThree, LOW);
    digitalWrite(selectorFour, LOW);
  }
  else {
    pinMode(selectorOne, OUTPUT);
    pinMode(selectorTwo, OUTPUT);
    digitalWrite(selectorOne, LOW);
    digitalWrite(selectorTwo, LOW);
    pinMode(selectorThree, INPUT);
    pinMode(selectorFour, INPUT);
  }


  // read the input on analog pin 5:
  int sensorValue = analogRead(A5);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  float voltage = sensorValue * (10.0 / 1023.0);
  // print out the value you read:
  Serial.print(voltage);
  Serial.print("\t");
  Serial.println(i);
  
  i++;
}
