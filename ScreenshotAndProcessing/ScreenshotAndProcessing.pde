import java.awt.*;
import java.awt.image.*;
import processing.serial.*;

//A Rectangle specifies an area in a coordinate space that is enclosed by the Rectangle object's upper-left point (x,y) in the coordinate space, its width, and its height.
Rectangle disp;

//This class is used to generate native system input events for the purposes of test automation, self-running demos, and other applications where control of the mouse and keyboard is needed.
//The primary purpose of Robot is to facilitate automated testing of Java platform implementations
Robot bot;

int screenWidthPix = 1920;
int screenHeightPix = 1080;

byte[] serialData  = new byte[ 1 * 3 + 2];
int data_index = 0;

Serial port;

void setup () {
  size(200, 200);
  
  disp = new Rectangle(new Dimension(screenWidthPix, screenHeightPix));
  
  try   {
    bot = new Robot();
  }
  catch (AWTException e)  {
    println("Robot class not supported by your system!");
    exit();
  }
  
  // Open serial port. this assumes the Arduino is the
  // first/only serial device on the system.  If that's not the case,
  // change "Serial.list()[0]" to the name of the port to be used:
  // you can comment it out if you only want to test it without the Arduino

  port = new Serial(this, "COM4", 9600);

  // A special header expected by the Arduino, to identify the beginning of a new bunch data.  
  serialData[0] = 'o';
  serialData[1] = 'z';
}

void draw () {
  int r=0, g=0, b=0;
  
  BufferedImage screenshot = bot.createScreenCapture(disp);
  
  int[] pixel = ((DataBufferInt)screenshot.getRaster().getDataBuffer()).getData();
  
  for(int i = 0 ; i < pixel.length ; i++)
  {
    r += red (pixel[i]);
    g += green (pixel[i]);
    b += blue (pixel[i]);
    
    //r += pixel[i] & 0x00ff0000;            
    //g += pixel[i] & 0x0000ff00;            
    //b += pixel[i] & 0x000000ff;
  }
  
  r /= pixel.length;
  g /= pixel.length;
  b /= pixel.length;
  
  byte[] ledColor = new byte[3];
  ledColor[0] = (byte)r;
  ledColor[1] = (byte)g;
  ledColor[2] = (byte)b;
  
  port.write(ledColor); // Issue data to Arduino

  
  
  PImage avgCol = createImage (150, 150, RGB);
  for(int i = 0 ; i < avgCol.pixels.length ; i++)
    avgCol.pixels[i] = color(r,g,b);
    
  //image(avgCol, 0, 0);
}
