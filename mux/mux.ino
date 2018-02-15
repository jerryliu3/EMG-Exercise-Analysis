const int selectPinA = 12;
const int selectPinB = 13;
const int dataStream = A5;
//const int outputPin1 = A3;
//const int outputPin2 = A4;
const int analogReads[8] = {2, 3, 4, 5, 6, 7, 8, 9};

void setup() 
{
  Serial.begin(9600); // Initialize the serial port

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
  pinMode(dataStream, INPUT);
//  pinMode(outputPin1, INPUT);
//  pinMode(outputPin2, INPUT);
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
      Serial.print(analogRead(dataStream)/1023.0*5.0);
      Serial.print(",");
//Serial.println(String(analogRead(outputPin1)*5.0/1023.0) + '\t' + String(analogRead(outputPin2)*5.0/1023.0));
    }
    else if (i==1)
    {
      digitalWrite(selectPinA, LOW);
      digitalWrite(selectPinB, HIGH);
      Serial.print(analogRead(dataStream)/1023.0*4.0);
      Serial.print(",");
//Serial.println(String(analogRead(outputPin1)*4.0/1023.0) + '\t' + String(analogRead(outputPin2)*4.0/1023.0));

    }
    else if (i==2)
    {
      digitalWrite(selectPinA, HIGH);
      digitalWrite(selectPinB, LOW);
      Serial.print(analogRead(dataStream)/1023.0*3.0);
      Serial.print(",");
//Serial.println(String(analogRead(outputPin1)*3.0/1023.0) + '\t' + String(analogRead(outputPin2)*3.0/1023.0));

    }
    else
    {
      digitalWrite(selectPinA, HIGH);
      digitalWrite(selectPinB, HIGH);
      Serial.println(analogRead(dataStream)/1023.0*2.0);
//Serial.println(String(analogRead(outputPin1)*2.0/1023.0) + '\t' + String(analogRead(outputPin2)*2.0/1023.0));
    }
  }
}

