#include <Adafruit_NeoPixel.h>

#define PIN 5
#define NUM_LED 120

uint8_t serialData[35*3+2];

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LED, PIN, NEO_GRB);


int index = 0;
int pixelColorIndex = 0;

void setup() {
  // put your setup code here, to run once:
  strip.begin();

  strip.setBrightness(50);

  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  while(Serial.available() > 0)
  {
    serialData[index++] = (uint8_t)Serial.read();
  }

  Serial.write('y\n');
  index = 0;
  
  //strip.fill(strip.Color(0, 255, 0));

  for(int i = 37 ; i < 38 ; i++)
  {
    //strip.setPixelColor(i, strip.Color(serialData[pixelColorIndex], serialData[pixelColorIndex+1], serialData[pixelColorIndex+2]));
    //pixelColorIndex += 3;

    //strip.fill(strip.Color(serialData[0], serialData[1], serialData[2]));
    strip.setPixelColor(37, strip.Color(serialData[0], serialData[1], serialData[2]));
    //strip.setPixelColor(71, strip.Color(serialData[3], serialData[4], serialData[5]));
    //strip.setPixelColor(66, strip.Color(serialData[3], serialData[4], serialData[5]));
    break;
  }
  

  strip.show();
}



// for(;;){

// 		if (Serial.available() > 0) {
// 			led_color[index++] = (uint8_t)Serial.read();

// 			if (index >= NUM_DATA){

// 				Serial.write('y');
// 				last_afk =  millis();
// 				index = 0;		

// 				if ((led_color[0] == 'o') && (led_color[1] == 'z')){
// 					// update LEDs
// 					for(int i=0; i<NUM_LED; i++){
//             int led_index = i*3 + 2;
//             strip.setPixelColor(i, strip.Color(led_color[led_index], led_color[led_index+1], led_color[led_index+2]));
//           } 					
            
//           strip.show(); 					 				
//         }		
//       }
//     }
        
//       else{
//         cur_time = millis();
//         if (cur_time - last_afk > RECON_TIME){
//           Serial.write('y');
//           last_afk =  cur_time;
// 				  index = 0;
// 			  }
// 		  }

// 	}

// }