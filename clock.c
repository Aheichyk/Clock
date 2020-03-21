#include <mega8.h>

// I2C Bus functions
#include <i2c.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here
#define HOUR_M 1
#define MIN_M 2
#define SEC_M 3
#define WEEK_M 4
unsigned char hour,min,sec,week,day,mon,year,ring_set;
unsigned int bt_set=0;
unsigned int get_time=0;
unsigned char set_mode=0;
unsigned char set;
unsigned char mode;
unsigned char ring;
unsigned char ring_disp=0;



void WriteEeprom(unsigned int addr, unsigned char data) {
  /* Wait for completion of previous write */
  while(EECR & (1<<EEWE));
  /* Set up address and data registers */  
  EEAR = addr;
  EEDR = data;
  /* Write logical one to EEMWE */
  EECR |= (1<<EEMWE);
  /* Start eeprom write by setting EEWE */
  EECR |= (1<<EEWE);  
}

unsigned char ReadEeprom(unsigned int addr) {
  /* Wait for completion of previous write */
  while(EECR & (1<<EEWE));
  /* Set up address register */ 
  EEAR = addr;
  /* Start eeprom read by writing EERE */
  EECR |= (1<<EERE);
  /* Return data from data register */   
  return EEDR;
}

void buzzer() {
    static unsigned char old_min;
    if (old_min != min) {
        // Check buzzer every minute
        if (ReadEeprom((week-1)*3)) {
            // Ring was set
            unsigned char ring_hour = ReadEeprom((week-1)*3+2);
            if (ring_hour == hour) {
                unsigned char ring_min = ReadEeprom((week-1)*3+1);
                if (ring_min == min) {
                    // BUZZER!!!!! pi pi pi pi
                }
            }
        }
    }
    old_min = min;
}

void set_button() {
    // Long & One touch
    printf("Set:mode:%d\r",set_mode);
    if (set_mode==HOUR_M) {
        hour++;
        if (hour > 23) hour=0;
    } else if (set_mode==MIN_M) {
        min++;
        if (min > 59)  min=0;
    } else if (set_mode==SEC_M) {
        sec++;
        if (sec > 59) sec=0;
    } else if (set_mode==WEEK_M) {
        week++;
        if (week > 7) week=1;
    } else if (ring_disp) {
        ring_set = !ring_set;
    } 
}

void mode_button() {
    // One touch
    printf("Setup\r");
    set_mode++; // Setup clock mode 0 - None,1-Hour,2-Min,3-Sec,4-week   
    if (!ring_disp) {
        if (set_mode > WEEK_M) {
            set_mode=0;
            rtc_set_time(hour,min,sec);
            rtc_set_date(week,day,mon,year);
        }
    } else if (ring_disp) {
        if (set_mode > MIN_M) {
            set_mode=0;  
            // Save ring settings to eeprom
            WriteEeprom((ring_disp-1)*3+1,min);
            WriteEeprom((ring_disp-1)*3+2,hour);
        }
    }
}

void ring_button() {
    // One touch  
    // Reset setup mode   
    set_mode = 0;  
    ring_disp++; // None 0, Ring 1,2,3,4,5,6,7
    if (ring_disp > 1) {  
        // Save ring set
        WriteEeprom((ring_disp-2)*3,ring_set);
    }
    if (ring_disp > 7) ring_disp = 0;
    // Read ring settings from eeprom
    if (ring_disp) {
        // Read from EEPROM   
        ring_set = ReadEeprom((ring_disp-1)*3); 
        min = ReadEeprom((ring_disp-1)*3+1);
        hour = ReadEeprom((ring_disp-1)*3+2);
    }
}

void display(unsigned int flashing) {
    static char symbol;
    symbol++;
    if (symbol > 5) {
        symbol = 0;
    }
    //symbol = 5;    
    // OFF display   
    PORTD &= 0x03;
    PORTC &= 0xF0;
    PORTB.7 = 1;   

    if (symbol == 0) {
        PORTC |= (0x0F & (hour / 10));
    } else if (symbol == 1) {
        PORTC |= (0x0F & (hour % 10));   
    } else if (symbol == 2) {
        PORTC |= (0x0F & (min / 10));
    } else if (symbol == 3) {
        PORTC |= (0x0F & (min % 10));
    } else if (symbol == 4) {
        PORTC |= (0x0F & (sec / 10));   
    } else if (symbol == 5) {     
        // Show week in last symbol
        if (set_mode == WEEK_M) {
            PORTC |= (0x0F & (week % 10));
        } else if (ring_disp) {
            PORTC |= (0x0F & (ring_disp % 10));
        } else {
            PORTC |= (0x0F & (sec % 10));
        }
    }
    
    if (symbol == 1) {  
        // Point after hours
        PORTB.7 = 0;
    } else if (symbol == 3 && !ring_disp) {
        // Point after mins
        PORTB.7 = 0;
    } else if (symbol == 5 && ring_set) {
        // Point after secs
        PORTB.7 = 0;
    }  
    
    if (flashing < 500) {   
        if (symbol >= 0 && symbol <= 1 && set_mode == HOUR_M) {
            // Flashing hour
            return;
        } else if (symbol >= 2 && symbol <= 3 && set_mode == MIN_M) {
            // Flashing min
            return;
        } else if (symbol >= 4 && symbol <= 5 && set_mode == SEC_M) {
            // Flashing sec
            return;
        } else if (symbol == 5 && set_mode == WEEK_M) {
            // Flashing week
            return;
        }   
    }
    
    if (set_mode == WEEK_M && symbol < 5) {
        // Don't show first 5 symbols
        return;    
    }
    
    if (ring_disp && symbol > 3 && symbol < 5) {   
        // Don't show last 2 symbols
        return;
    }
    
    // Next symbol 
    PORTD |= (1 << (2 + symbol)); 
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
    // Reinitialize Timer 0 value
    TCNT0=0x83;
    // Place your code here  
    // Read timeout   
    if (get_time > 0) get_time--;   
    // One touch
    if (PINB.0 != set) {
        if (!set) {
            // Button released
            set_button();  
        }         
        set = PINB.0;
    }  
    // Long touch    
    if (PINB.0 == 0) {
        bt_set++;
        if (bt_set > 1500) {
            bt_set = 1000;
            set_button();
        }
    } else bt_set = 0;
    // One touch
    if (PINB.1 != mode) {
        if (!mode) {  
            // Button released
            mode_button();
        }
        mode = PINB.1;
    }     
    // One touch
    if (PINB.2 != ring) {
        if (!ring) {
            // Button released
            ring_button();
        }    
        ring = PINB.2;
    }     
    // Flashing 500ms
    static unsigned int flashing;
    flashing++;
    if (flashing > 999) flashing = 0;
    
    // Display  4ms - one symbol
    static char disp;
    disp++;
    if (disp > 3) disp = 0;
    if (disp == 0) display(flashing);     
               
    // Back to time screen
    static unsigned long back2time;
    if (ring_disp || set_mode) {
        back2time++;
    }
    if (back2time > 300000) {
        set_mode = 0;
        ring_disp = 0;
        back2time = 0;
    }  
    
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=1 Bit0=1 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x83;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);



// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Bit-Banged I2C Bus initialization
// I2C Port: PORTC
// I2C SDA bit: 4
// I2C SCL bit: 5
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 0
rtc_init(0,0,0);

set = PINB.0;
mode = PINB.1;
ring = PINB.2;

// Global enable interrupts
#asm("sei")

while (1) {
      // Place your code here     
      if (get_time == 0) {    
            if (!set_mode && !ring_disp) {
                rtc_get_time(&hour,&min,&sec);          
                rtc_get_date(&week,&day,&mon,&year);    
                buzzer();
                printf("w%d_%d:%d:%d\r",week,hour,min,sec);  
            } else printf("set_mode:%d: w%d_%d:%d:%d\r",set_mode,week,hour,min,sec);
            get_time = 100; // 500*1ms = 500ms     
      }  
      }   
}
