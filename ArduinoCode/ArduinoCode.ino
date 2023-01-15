#include <Adafruit_NeoPixel.h>

#define PIN 5
#define NUM_LED 120

uint8_t ledColor[3];

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LED, PIN, NEO_GRB);


void setup() {
  // put your setup code here, to run once:
  strip.begin();

  strip.setBrightness(50);

  Serial.begin(9600);
  Serial.print("ack");

  int index = 0;

  for(;;)
  {
    if(Serial.available() > 0)
    {
      ledColor[index++] = (uint8_t)Serial.read();

      if(index > 2)
      {
        strip.fill(strip.Color(ledColor[0], ledColor[1], ledColor[2]));
      }

      strip.show();
    }
    else
    {
      index = 0;
    }
  }
}

int index=0;

void loop() {
  // put your main code here, to run repeatedly:
  
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