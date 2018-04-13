//Plot the four different channels in live time! 
const int selectPinA0 = 10;
const int selectPinA1 = 11;
const int outputPin1 = A3;
//const int outputPin2 = A4;

int sensorValue = analogRead(outputPin1); //+ analogRead(outputPin2); //Add together to simulate IA of EMG. 

void setup() 
{
  Serial.begin(9600); // Initialize the serial port
  pinMode(selectPinA0, OUTPUT);
  pinMode(selectPinA1, OUTPUT);
  pinMode(outputPin1, INPUT);
  //pinMode(outputPin2, INPUT);
}

void loop() 
{
  // Loop through all four permutations.
  for (int i=0; i<4000; i++)
  {
    if (i<1000) // Left Bicep
    {
      digitalWrite(selectPinA0, LOW);
      digitalWrite(selectPinA1, LOW);
    }
    else if (i<2000) // Right Bicep
    {
      digitalWrite(selectPinA0, HIGH);
      digitalWrite(selectPinA1, LOW);
    }
    else if (i<3000) // Left Forearm
    {
      digitalWrite(selectPinA0, LOW);
      digitalWrite(selectPinA1, HIGH);
    }
    else // Right Forearm
    {
      digitalWrite(selectPinA0, HIGH);
      digitalWrite(selectPinA1, HIGH);
    }
    sensorValue = analogRead(outputPin1); //+ analogRead(outputPin2);
    //Serial.println(sensorValue * (10.0 / 1023.0));
    Serial.print(String(i) + ",");
    Serial.println(sensorValue*(10.0/1023.0),10);
  }
}
