//
// NB! This is a file generated from the .4Dino file, changes will be lost
//     the next time the .4Dino file is built
//
#include <SPI.h>
#include <math.h>

// Define LOG_MESSAGES to a serial port to send SPE errors messages to. Do not use the same Serial port as SPE
//#define LOG_MESSAGES Serial

#define RESETLINE     30

#define DisplaySerial Serial1


#include "Picaso_Serial_4DLib.h"
#include "Picaso_Const4D.h"

Picaso_Serial_4DLib Display(&DisplaySerial);

// Uncomment to use ESP8266
//#define ESPRESET 17
//#include <SoftwareSerial.h>
//#define ESPserial SerialS
//SoftwareSerial SerialS(8, 9) ;
// Uncomment next 2 lines to use ESP8266 with ESP8266 library from https://github.com/itead/ITEADLIB_Arduino_WeeESP8266
//#include "ESP8266.h"
//ESP8266 wifi(SerialS,19200);

// routine to handle Serial errors
void mycallback(int ErrCode, unsigned char Errorbyte)
{
#ifdef LOG_MESSAGES
  const char *Error4DText[] = {"OK\0", "Timeout\0", "NAK\0", "Length\0", "Invalid\0"} ;
  LOG_MESSAGES.print(F("Serial 4D Library reports error ")) ;
  LOG_MESSAGES.print(Error4DText[ErrCode]) ;
  if (ErrCode == Err4D_NAK)
  {
    LOG_MESSAGES.print(F(" returned data= ")) ;
    LOG_MESSAGES.println(Errorbyte) ;
  }
  else
    LOG_MESSAGES.println(F("")) ;
  while (1) ; // you can return here, or you can loop
#else
  // Pin 13 has an LED connected on most Arduino boards. Just give it a name
#define led 13
  while (1)
  {
    digitalWrite(led, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(200);                // wait for a second
    digitalWrite(led, LOW);    // turn the LED off by making the voltage LOW
    delay(200);                // wait for a second
  }
#endif
}
// end of routine to handle Serial errors

void setup()
{
// Ucomment to use the Serial link to the PC for debugging
//  Serial.begin(115200) ;        // serial to USB port
// Note! The next statement will stop the sketch from running until the serial monitor is started
//       If it is not present the monitor will be missing the initial writes
//    while (!Serial) ;             // wait for serial to be established

  pinMode(RESETLINE, OUTPUT);       // Display reset pin
digitalWrite(RESETLINE, 1);       // Reset Display, using shield
  delay(100);                       // wait for it to be recognised
digitalWrite(RESETLINE, 0);       // Release Display Reset, using shield
// Uncomment when using ESP8266
//  pinMode(ESPRESET, OUTPUT);        // ESP reset pin
//  digitalWrite(ESPRESET, 1);        // Reset ESP
//  delay(100);                       // wait for it t
//  digitalWrite(ESPRESET, 0);        // Release ESP reset
  delay(3000) ;                     // give display time to startup

  // now start display as Serial lines should have 'stabilised'
  DisplaySerial.begin(200000) ;     // Hardware serial to Display, same as SPE on display is set to
  Display.TimeLimit4D = 5000 ;      // 5 second timeout on all commands
  Display.Callback4D = mycallback ;

// uncomment if using ESP8266
//  ESPserial.begin(115200) ;         // assume esp set to 115200 baud, it's default setting
                                    // what we need to do is attempt to flip it to 19200
                                    // the maximum baud rate at which software serial actually works
                                    // if we run a program without resetting the ESP it will already be 19200
                                    // and hence the next command will not be understood or executed
//  ESPserial.println("AT+UART_CUR=19200,8,1,0,0\r\n") ;
//  ESPserial.end() ;
//  delay(10) ;                         // Necessary to allow for baud rate changes
//  ESPserial.begin(19200) ;            // start again at a resonable baud rate
  Display.gfx_ScreenMode(LANDSCAPE) ; // change manually if orientation change
  // put your setup code here, to run once:

  attachInterrupt( digitalPinToInterrupt(2), interrupt, RISING);

  digitalWrite(13, HIGH);

  //Display.print("Coucou\r\n");
  Display.gfx_Cls();                    // clear the screen
  Initialise();
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
} // end Setup **do not alter, remove or duplicate this line**

//on d�clare en volatile toutes les variables acc�d�es dans l'interruption (car thread diff�rent)
const unsigned char Ts_Size=20;
const unsigned char Ts_Max=Ts_Size-1;
volatile unsigned long Ts[Ts_Size];
volatile unsigned char Written[Ts_Size];
volatile unsigned char iTs=0;
volatile unsigned char state = LOW; //alternance des interruptions

//String NomFichier="";
//String linuxNomFichier= "";
//String urlNomFichier="";
void Log_to_File()
  {
  unsigned char All_written= true;

  for (unsigned char i=0; i<=Ts_Max; i++)
    {
    if (Written[i]) continue;

    All_written= false;
    break;
    }
  if (All_written) return;

  /*
  const int taille=1024;
  char lpstrNomFichier[taille];
  linuxNomFichier.toCharArray( lpstrNomFichier, taille);
  File F= FileSystem.open( lpstrNomFichier, FILE_APPEND);
  */
  for (unsigned char i=0; i<=Ts_Max; i++)
    {
    if (Written[i]) continue;

    Display_Ti( i);
    //F.println( String(Ts[i]));
    Written[i]= true;
    }
  //F.close();

  }

unsigned long old_y=0;
void Display_Ti( unsigned char _i)
  {
  const int w4duino_dx=320; const int w4duino_max_x= w4duino_dx-1;
  const int w4duino_dy=240; const int w4duino_max_y= w4duino_dy-1;
  //const int pouls_min=20; const int pouls_max=200;
  const int pouls_min=40; const int pouls_max=100;
  const unsigned long ms_from_minute=60000;
  const double cx= 2*(double)w4duino_dx / (double)ms_from_minute;//2 largeur d'�cran par minute
  const double cy= (double)w4duino_dy / (pouls_max-pouls_min);
  unsigned char i_1= _i > 0 ? _i-1 : Ts_Max;
  unsigned long T_1= Ts[ i_1];
  unsigned long T  = Ts[_i  ];
  unsigned long delta= T - T_1;
  if (delta==0) return;
  double pouls= double(ms_from_minute) / (double)delta;
  if ((pouls<pouls_min)||(pouls_max<pouls)) return;
  unsigned long y= w4duino_dy-cy*(pouls-pouls_min);
  unsigned long dx= round(delta * cx);
  unsigned long largeur= w4duino_dx-dx;
  unsigned long old_x= largeur;

  Display.gfx_ScreenCopyPaste(dx, 0, 0, 0, largeur, w4duino_dy);
  //Display.gfx_Line(w4duino_max_x, 0, w4duino_max_x, w4duino_max_y, BLACK);   // draw line, can be patterned();
  Display.gfx_RectangleFilled(old_x,0,w4duino_max_x,w4duino_max_y, BLACK);    // draw filled rectangle
  Display.gfx_Line(old_x, old_y, w4duino_max_x, y, GREEN);   // draw line, can be patterned();
  //Display.gfx_PutPixel(w4duino_max_x, y, GREEN);            // set point at x y


  /*
  Serial.print( "pouls: "); Serial.print( pouls);
  Serial.print( " delta: "); Serial.print( delta);
  Serial.print( " cx: "); Serial.print( cx);
  Serial.print( " dx: "); Serial.print( dx);
  Serial.print( " y: "); Serial.print( y);
  Serial.print( " largeur: "); Serial.print( largeur);
  Serial.println("");
  */
  old_y=y;
  }

void interrupt()
  {
  state= !state;
  Ts[iTs]= millis();
  Written[iTs]=false;
  iTs= Ts_Max == iTs ? 0 : iTs+1;
  }

void Traite_data()
  {
  /*
  for (unsigned char i=0; i<=Ts_Max; i++)
    Bridge.put( String(i), String(Ts[i]));
  */
  Log_to_File();
  }

void Initialise()
  {
  for (unsigned char i=0; i<=Ts_Max; i++)
    {
    Ts[i]=0;
    Written[i]= true;
    }
  }

void loop()
{
  // put your main code here, to run repeatedly:
  Traite_data();
  digitalWrite(13, state);
}

