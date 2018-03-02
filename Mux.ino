//Plot the four different channels in live time! 
const int selectPinA = 10;
const int selectPinB = 11;
//const int dataStream = A5; For testing purposes
const int outputPin1 = A3;
const int outputPin2 = A4;

float myArray[]= {0,0,0,0};
int sensorValue = analogRead(outputPin1) + analogRead(outputPin2); //Add together to simulate IA of EMG. 

void setup() 
{
  Serial.begin(115200); // Initialize the serial port
  pinMode(selectPinA, OUTPUT);
  pinMode(selectPinB, OUTPUT);
  //pinMode(dataStream, INPUT);
  pinMode(outputPin1, INPUT);
  pinMode(outputPin2, INPUT);
}

void loop() 
{
  // Loop through all four permutations.
  for (int i=0; i<4; i++)
  {
    if (i==0) 
    {
      digitalWrite(selectPinA, LOW);
      digitalWrite(selectPinB, LOW);
    }
    else if (i==1) 
    {
      digitalWrite(selectPinA, LOW);
      digitalWrite(selectPinB, HIGH);
    }
    else if (i==2) 
    {
      digitalWrite(selectPinA, HIGH);
      digitalWrite(selectPinB, LOW);
    }
    else
    {
      digitalWrite(selectPinA, HIGH);
      digitalWrite(selectPinB, HIGH);
    }
    sensorValue = analogRead(outputPin1) + analogRead(outputPin2);
    myArray[i] = sensorValue;
    Serial.print(myArray[0]);
    Serial.print(",");
    Serial.print(myArray[1]);
    Serial.print(",");
    Serial.print(myArray[2]);
    Serial.print(",");
    Serial.println(myArray[3]);
  }
}
