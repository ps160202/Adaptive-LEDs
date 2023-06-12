import java.awt.*;
import java.awt.image.*;
import processing.serial.*;

import java.io.IOException;
import java.io.File;
import javax.imageio.ImageIO;

//A Rectangle specifies an area in a coordinate space that is enclosed by the Rectangle object's upper-left point (x,y) in the coordinate space, its width, and its height.
Rectangle dispTop, dispLeft, dispRight, dispBottomLeft, dispBottomRight;

//This class is used to generate native system input events for the purposes of test automation, self-running demos, and other applications where control of the mouse and keyboard is needed.
//The primary purpose of Robot is to facilitate automated testing of Java platform implementations
Robot bot;

int screenWidthPix = 1920;
int screenHeightPix = 1080;

int ssWidth = 1836;
int ssWidthBottom = 864;
int ssHeight = 900;
int squareSize = 108;
int squareArea = squareSize * squareSize;

int noOfLeds = 49;

int[][] ledColor = new int[noOfLeds][3];
byte[] serialData = new byte[noOfLeds*3+2];
int data_index = 0;


Serial port;

void setup () {
  size(1700, 900);
  
  dispBottomLeft = new Rectangle(42, 972, ssWidthBottom, squareSize); //PIXELS FOR THE BOTTOM LEFT OF THE SCREEN
  dispLeft = new Rectangle(0, 108, squareSize, ssHeight); //PIXELS FOR THE LEFT SIDE OF THE SCREEN
  dispTop = new Rectangle(42, 0, ssWidth, squareSize); //PIXELS FOR THE TOP OF THE SCREEN
  dispRight = new Rectangle(1812, 108, squareSize, ssHeight); //PIXELS FOR THE RIGHT SIDE OF THE SCREEN
  dispBottomRight = new Rectangle(1014, 972, ssWidthBottom, squareSize); //PIXELS FOR THE BOTTOM LEFT OF THE SCREEN
  
  
  try   {
    bot = new Robot();
  }
  catch (AWTException e)  {
    println("Robot class not supported by your system!");
    exit();
  }
  
  String path = "D:// Shot.jpg";
  
  BufferedImage screenshot = bot.createScreenCapture(dispBottomRight);
  
  try {
    ImageIO.write(screenshot, "jpg", new File(path));
  }
  catch (IOException ext) {
  }
  
  // Open serial port. this assumes the Arduino is the
  // first/only serial device on the system.  If that's not the case,
  // change "Serial.list()[0]" to the name of the port to be used:
  // you can comment it out if you only want to test it without the Arduino

  port = new Serial(this, "COM1", 9600);

  // A special header expected by the Arduino, to identify the beginning of a new bunch data.  
  serialData[0] = 'o';
  serialData[1] = 'z';
}

void draw () {
  int r=0, g=0, b=0;
  
  BufferedImage screenshotBottomLeft = bot.createScreenCapture(dispBottomLeft);
  BufferedImage screenshotLeft = bot.createScreenCapture(dispLeft);
  BufferedImage screenshotTop = bot.createScreenCapture(dispTop);
  BufferedImage screenshotRight = bot.createScreenCapture(dispRight);
  BufferedImage screenshotBottomRight = bot.createScreenCapture(dispBottomRight);
  

  int[] pixelBottomLeft = ((DataBufferInt)screenshotBottomLeft.getRaster().getDataBuffer()).getData();
  int[] pixelLeft = ((DataBufferInt)screenshotLeft.getRaster().getDataBuffer()).getData();
  int[] pixelTop = ((DataBufferInt)screenshotTop.getRaster().getDataBuffer()).getData();
  int[] pixelRight = ((DataBufferInt)screenshotRight.getRaster().getDataBuffer()).getData();
  int[] pixelBottomRight = ((DataBufferInt)screenshotBottomRight.getRaster().getDataBuffer()).getData();
  
  int serialIndex = 2;
  
  PImage pi = createImage(108, 108, RGB);
  
  int imageindex = 0;
  
  //---------------BOTTOM LEFT BAR---------------------
  for(int k = 7 ; k >= 0 ; k--)
  {
    r=0;
    g=0;
    b=0;
    
    int adjust = abs(k-7);
    
    for(int i = 0 ; i < squareSize ; i++)
    {
      for(int j  = adjust*squareSize ; j < adjust*squareSize+squareSize ; j++)
      {        
        int loc = j + i * ssWidthBottom;
        
        r += red (pixelBottomLeft[loc]);
        g += green (pixelBottomLeft[loc]);
        b += blue (pixelBottomLeft[loc]);    
        
        /*if(k == 6)
          pi.pixels[imageindex++] = color(r, g, b);*/
      }
    }
    
    r /= squareArea;
    g /= squareArea;
    b /= squareArea;
    
    ledColor[k][0] = (int)r;
    ledColor[k][1] = (int)g;
    ledColor[k][2] = (int)b;
    
    //pi.pixels[imageindex++] = color(r, g, b);
    
    serialData[serialIndex++] = (byte)ledColor[k][0];
    serialData[serialIndex++] = (byte)ledColor[k][1];
    serialData[serialIndex++] = (byte)ledColor[k][2];
  }
  
  //-------------------------LEFT SIDE------------------------------
  for(int k = 15 ; k >= 8 ; k--)
  {
    r=0;
    g=0;
    b=0;
    
    int adjust = abs(k-15);
    
    for(int i = adjust*squareSize ; i < adjust*squareSize+squareSize ; i++)
    {
      for(int j  = 0 ; j < squareSize ; j++)
      {        
        int loc = j + i * squareSize;
        
        r += red (pixelLeft[loc]);
        g += green (pixelLeft[loc]);
        b += blue (pixelLeft[loc]);    
        
        /*if(k == 6)
          pi.pixels[imageindex++] = color(r, g, b);*/
      }
    }
    
    r /= squareArea;
    g /= squareArea;
    b /= squareArea;
    
    ledColor[k][0] = (int)r;
    ledColor[k][1] = (int)g;
    ledColor[k][2] = (int)b;
    
    //pi.pixels[imageindex++] = color(r, g, b);
    
    serialData[serialIndex++] = (byte)ledColor[k][0];
    serialData[serialIndex++] = (byte)ledColor[k][1];
    serialData[serialIndex++] = (byte)ledColor[k][2];
  }
  
  //---------------TOP BAR---------------------
  for(int k = 16 ; k < 33 ; k++)
  {
    r=0;
    g=0;
    b=0;
    
    int adjust = k - 16;
    
    for(int i = 0 ; i < squareSize ; i++)
    {
      for(int j  = adjust*squareSize ; j < adjust*squareSize+squareSize ; j++)
      {        
        int loc = j + i * ssWidth;
        
        r += red (pixelTop[loc]);
        g += green (pixelTop[loc]);
        b += blue (pixelTop[loc]);    
        
        /*if(k == 6)
          pi.pixels[imageindex++] = color(r, g, b);*/
      }
    }
    
    r /= squareArea;
    g /= squareArea;
    b /= squareArea;
    
    ledColor[k][0] = (int)r;
    ledColor[k][1] = (int)g;
    ledColor[k][2] = (int)b;
    
    //pi.pixels[imageindex++] = color(r, g, b);
    
    serialData[serialIndex++] = (byte)ledColor[k][0];
    serialData[serialIndex++] = (byte)ledColor[k][1];
    serialData[serialIndex++] = (byte)ledColor[k][2];
  }
  
  //-------------------------RIGHT SIDE------------------------------
  for(int k = 33 ; k < 41 ; k++)
  {
    r=0;
    g=0;
    b=0;
    
    int adjust = k-33;
    
    for(int i = adjust*squareSize ; i < adjust*squareSize+squareSize ; i++)
    {
      for(int j  = 0 ; j < squareSize ; j++)
      {        
        int loc = j + i * squareSize;
        
        r += red (pixelRight[loc]);
        g += green (pixelRight[loc]);
        b += blue (pixelRight[loc]);
      }
    }
    
    r /= squareArea;
    g /= squareArea;
    b /= squareArea;
    
    ledColor[k][0] = (int)r;
    ledColor[k][1] = (int)g;
    ledColor[k][2] = (int)b;
    
    //pi.pixels[imageindex++] = color(r, g, b);
    
    serialData[serialIndex++] = (byte)ledColor[k][0];
    serialData[serialIndex++] = (byte)ledColor[k][1];
    serialData[serialIndex++] = (byte)ledColor[k][2];
  }
  
  //---------------BOTTOM RIGHT BAR---------------------
  for(int k = 48 ; k >= 41 ; k--)
  {
    r=0;
    g=0;
    b=0;
    
    int adjust = abs(k-41);
    
    for(int i = 0 ; i < squareSize ; i++)
    {
      for(int j  = adjust*squareSize ; j < adjust*squareSize+squareSize ; j++)
      {        
        int loc = j + i * ssWidthBottom;
        
        r += red (pixelBottomRight[loc]);
        g += green (pixelBottomRight[loc]);
        b += blue (pixelBottomRight[loc]);    
        
        /*if(k == 6)
          pi.pixels[imageindex++] = color(r, g, b);*/
      }
    }
    
    r /= squareArea;
    g /= squareArea;
    b /= squareArea;
    
    ledColor[k][0] = (int)r;
    ledColor[k][1] = (int)g;
    ledColor[k][2] = (int)b;
    
    //pi.pixels[imageindex++] = color(r, g, b);
    
    serialData[serialIndex++] = (byte)ledColor[k][0];
    serialData[serialIndex++] = (byte)ledColor[k][1];
    serialData[serialIndex++] = (byte)ledColor[k][2];
  }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  //------------DISPLAY------------------
  PImage[] avg = new PImage[noOfLeds];
  
  //Bottom Left Display
  for(int i = 0 ; i < 8 ; i++)
  {
    avg[i] = createImage(100, 50, RGB);
    for(int j = 0 ; j < avg[i].pixels.length ; j++)
    {
      avg[i].pixels[j] = color(ledColor[i][0], ledColor[i][1], ledColor[i][2]);
      //avg[i].pixels[j] = color((int)serialData[i*3], (int)serialData[i*3+1], (int)serialData[i*3+2]);
    }
    
    int adjust = abs(i-7);
    image(avg[i], adjust*100, 850);
  }
  
  //Left Display
  for(int i = 8 ; i < 16 ; i++)
  {
    avg[i] = createImage(50, 100, RGB);
    for(int j = 0 ; j < avg[i].pixels.length ; j++)
    {
      avg[i].pixels[j] = color(ledColor[i][0], ledColor[i][1], ledColor[i][2]);
      //avg[i].pixels[j] = color((int)serialData[i*3], (int)serialData[i*3+1], (int)serialData[i*3+2]);
    }
    
    int adjust = abs(i-15);
    image(avg[i], 0, adjust*100+50);
  }  
  
  //Top Display
  for(int i = 16 ; i < 33 ; i++)
  {
    avg[i] = createImage(100, 50, RGB);
    for(int j = 0 ; j < avg[i].pixels.length ; j++)
    {
      avg[i].pixels[j] = color(ledColor[i][0], ledColor[i][1], ledColor[i][2]);
      //avg[i].pixels[j] = color((int)serialData[i*3], (int)serialData[i*3+1], (int)serialData[i*3+2]);
    }
    
    int adjust = i-16;
    image(avg[i], adjust*100, 0);
  }
  
  //Right Display
  for(int i = 33 ; i < 41 ; i++)
  {
    avg[i] = createImage(50, 100, RGB);
    for(int j = 0 ; j < avg[i].pixels.length ; j++)
    {
      avg[i].pixels[j] = color(ledColor[i][0], ledColor[i][1], ledColor[i][2]);
      //avg[i].pixels[j] = color((int)serialData[i*3], (int)serialData[i*3+1], (int)serialData[i*3+2]);
    }
    
    int adjust = i-33;
    image(avg[i], 1650, adjust*100+50);
  }
  
  //Bottom Right Display
  for(int i = 41 ; i < 49 ; i++)
  {
    avg[i] = createImage(100, 50, RGB);
    for(int j = 0 ; j < avg[i].pixels.length ; j++)
    {
      avg[i].pixels[j] = color(ledColor[i][0], ledColor[i][1], ledColor[i][2]);
      //avg[i].pixels[j] = color((int)serialData[i*3], (int)serialData[i*3+1], (int)serialData[i*3+2]);
    }
    
    int adjust = abs(i-41);
    image(avg[i], adjust*100+900, 850);
  }
  
  port.write(serialData[0]); // Issue data to Arduino
  port.write(serialData[1]);
  port.write(serialData[2]);
}
