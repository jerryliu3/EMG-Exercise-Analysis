const int selectPinA = 10;
const int selectPinB = 11;
const int dataStream = A5;
const int outputPin1 = A3;
const int outputPin2 = A4;
const int analogReads[8] = {2, 3, 4, 5, 6, 7, 8, 9};
const int analogOutPin = 5;

void setup() 
{
  Serial.begin(9600); // Initialize the serial port
  pinMode(analogOutPin, OUTPUT);
  for (int i=0; i<8; i++)
  {
    pinMode(analogReads[i], OUTPUT);
//    if (i==1 || i==3 || i==5 || i == 7)
      digitalWrite(analogReads[i], HIGH);
//    else
//      digitalWrite(analogReads[i], LOW);
  }
  
  pinMode(selectPinA, OUTPUT);
  pinMode(selectPinB, OUTPUT);
//  pinMode(dataStream, INPUT);
  pinMode(outputPin1, INPUT);
  pinMode(outputPin2, INPUT);
}

void loop() 
{
  analogWrite(analogOutPin, 123);
  //Serial.println(analogRead(dataStream));
  // Loop through all four permutations.
  for (int i=0; i<4; i++)
  {
    if (i==0) //channel 1: 6 & 10
    {
      analogWrite(analogOutPin, 123);
      Serial.println("Channel 1");
      digitalWrite(selectPinA, LOW);
      digitalWrite(selectPinB, LOW);
      //Serial.println(analogRead(dataStream));
      //Serial.print(analogRead(dataStream)/1023.0*5.0);
      //Serial.print(",");

      Serial.println(String(analogRead(outputPin1)*5.0/1023.0) + '\t' + String(analogRead(outputPin2)*5.0/1023.0));
//      delay(500);
    }
    else if (i==1) //5 & 11
    {
      analogWrite(analogOutPin, 123);
      digitalWrite(selectPinA, LOW);
      digitalWrite(selectPinB, HIGH);
      //Serial.println(analogRead(dataStream));
      //Serial.print(analogRead(dataStream)/1023.0*4.0);
      //Serial.print(",");
      Serial.println(String(analogRead(outputPin1)*5.0/1023.0) + '\t' + String(analogRead(outputPin2)*5.0/1023.0));
//      delay(500);

    }
    else if (i==2) //4 & 12
    {
      analogWrite(analogOutPin, 123);
      digitalWrite(selectPinA, HIGH);
      digitalWrite(selectPinB, LOW);
      //Serial.println(analogRead(dataStream));
      //Serial.print(analogRead(dataStream)/1023.0*3.0);
      //Serial.print(",");
      Serial.println(String(analogRead(outputPin1)*5.0/1023.0) + '\t' + String(analogRead(outputPin2)*5.0/1023.0));
//      delay(500);

    }
    else //3 & 13
    {
      analogWrite(analogOutPin, 123);
      digitalWrite(selectPinA, HIGH);
      digitalWrite(selectPinB, HIGH);
      //Serial.println(analogRead(dataStream));
      //Serial.println(analogRead(dataStream)/1023.0*2.0);
      Serial.println(String(analogRead(outputPin1)*5.0/1023.0) + '\t' + String(analogRead(outputPin2)*5.0/1023.0));
//      delay(500);
    }
  }
}
