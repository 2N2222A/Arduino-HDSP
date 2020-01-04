/*
HDSP-0960 display test code by JS106351
This code sends multiplexed BCD signals to HP/Avago Numeric Displays.  The HDSP-0960 is similar in functionality to the TIL311
but does not display Hexadecimal numbers, only numeric.  This code takes the time since the last uC reset [millis()] parses and 
separates the number into digits and is then written to the display.  

This is a condensed and updated version of the code I originally posted.  In this new version, the code is easier to read and understand, 
and it is more efficient.  

*/


//BCD data bus for the displays
#define d0 9
#define d1 10
#define d2 11
#define d3 12 

//display digit latch
#define a0 4
#define a1 5
#define a2 6
#define a3 7

unsigned char ones;
unsigned char tens;
unsigned char hundreds;
unsigned char thousands;
unsigned long  x;
  
/*
Layout of the displays:
                THOU HUNS TENS ONES
Display layout:  8----8----8----8
                 ^    ^    ^    ^
                 |    |    |    |
Latch Position:  3    2    1    0

*/

void setup(){
  pinMode(13, OUTPUT);
  pinMode(d0, OUTPUT);
  pinMode(d1, OUTPUT);
  pinMode(d2, OUTPUT);
  pinMode(d3, OUTPUT);
  pinMode(a0, OUTPUT);
  pinMode(a1, OUTPUT);
  pinMode(a2, OUTPUT);
  pinMode(a3, OUTPUT);
    
  digitalWrite(a0, HIGH);
  digitalWrite(a1, HIGH);
  digitalWrite(a2, HIGH);
  digitalWrite(a3, HIGH);
}

  
void loop(){
  
  x = millis()/100;
  
  digitalWrite(13, HIGH);

  ones = x % 10;
  tens = (x / 10) % 10;
  hundreds = (x / 100) % 10;
  thousands = (x / 1000) % 10;

  writeNumber(ones, a0);
  writeNumber(tens, a1);
  writeNumber(hundreds, a2);
  writeNumber(thousands, a3);
 
  delay(100);
  digitalWrite(13, LOW);  //for testing purposes
  delay(10);

}

//Convert Normal Decimal(hexadecimal) into Binary Coded Decimal for the display to understand the data

unsigned char decToBcd(unsigned char val){
  return ( (val/10*16) + (val%10) );
}



void writeNumber(unsigned char value, unsigned char digit){

  unsigned char BCD_value;

  BCD_value = decToBcd(value);

  digitalWrite(digit, LOW);  //Enable selected digit to recive data
  digitalWrite(d0, (BCD_value & 0x01));          //LSB
  digitalWrite(d1, ((BCD_value >> 1) & 0x01));
  digitalWrite(d2, ((BCD_value >> 2) & 0x01));
  digitalWrite(d3, ((BCD_value >> 3) & 0x01));     //MSB
  digitalWrite(digit, HIGH);  //Disable selected digit after loading data 

}
