/**
 * GOC-IOS firmeware
 * 
 * Andrew Lukefahr
 * lukefahr@umich.edu
 *
 */

#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include "app_error.h"
#include "nrf_delay.h"

#include "goc.h"
#include "led.h"

// NOTE:  the LED driver assumes active-high
// but we are driving to a FET that is active-low
// so all the led_* commands will be backwards

const uint32_t GOC_LED_IR =  23;
const uint32_t GOC_LED_WHITE = 24;

float _clk_freq; //GOC frequency
bool _default_on; //LED on normally
uint32_t _active_led; //which LED to use

static void _goc_write_byte_PWM( const uint32_t led,  const float freq, const uint8_t byte);
static void _goc_write_byte_manchester( const uint32_t led,  const float freq, const uint8_t byte);
static void _goc_default();

/**
 *
 */
void goc_init()
{
    //initialize our LEDs
    led_init(GOC_LED_IR);
    led_init(GOC_LED_WHITE);
    led_on(GOC_LED_IR); 
    led_on(GOC_LED_WHITE); 
    
    //assume white led
    goc_set_active_led( GOC_LED_WHITE);

    //assume we want the LED off by default
    goc_set_default(0);

    //assume slowfreq is 15 Hz
    goc_set_clk( 15.); 

}


/**
 * @return 0: success, 1:failure
 */
int goc_set_active_led(uint32_t led)
{
    if (led == GOC_LED_WHITE){
        _active_led = led;
        return 0;
    } else if  (led == GOC_LED_IR){
        _active_led = led;
        return 0;
    } else {
        return 1;
    }
}

/** 
 *
 */
uint32_t goc_get_active_led()
{
    return _active_led;
}

/**
 *
 */
void goc_set_default( const uint8_t on_by_default)
{
    _default_on = on_by_default;
    _goc_default(); 
}

/**
 *
 */
uint8_t goc_get_default()
{
    return _default_on;
}

/**
 *
 */
void goc_set_clk( const float clk_freq )
{
    _clk_freq = clk_freq;
}

/** 
 *
 */
float goc_get_clk()
{
    return _clk_freq;
}


/**
 *
 */
void goc_write( const uint8_t * data, const uint32_t size)
{
    const uint8_t * const end = data + size;
    while ( data != end){
        _goc_write_byte_PWM(_active_led, _clk_freq , *data);
        data++;
    }

    _goc_default();
}


/**
 *
 */
void goc_write_manchester( const uint8_t * data, const uint32_t size)
{
    const uint8_t * const end = data + size;
    while ( data != end){
        _goc_write_byte_manchester(_active_led, _clk_freq , *data);
        data++;
    }

    _goc_default();
}


/**
 * resets the LED back to default state
 */
void _goc_default()
{
    if (_default_on) led_off(_active_led);
    else led_on(_active_led);
}


/**
 * writes a byte over GOC using older PWM encoding
 */
void _goc_write_byte_PWM( const uint32_t led,  const float freq, const uint8_t byte)
{
    //scale factors for frequency
    const float t_short_duty = 0.2; //20%
    const float t_long_duty = 0.8; // 80%

    //calculate the pulse lengts in microseconds (us)
    float t_period = 1.0 / freq;
    uint32_t t_short_on_us = (uint32_t) (t_short_duty * t_period * 1E6);
    uint32_t t_long_on_us  = (uint32_t) (t_long_duty  * t_period * 1E6);

    uint32_t t_short_off_us = (uint32_t) ((1.0-t_short_duty) * t_period * 1E6);
    uint32_t t_long_off_us  = (uint32_t) ((1.0-t_long_duty ) * t_period * 1E6);

    uint8_t bit;
    for (int32_t i = 7; i >= 0 ; --i){
        bit = (byte>> i) & 0x1; //get 1 bit of byte

        //blink on
        led_toggle(led); 
        //delay t_short (if 0) or t_long (if 1)
        nrf_delay_us ( (bit? t_long_on_us : t_short_on_us) );
        //blink off
        led_toggle(led); 
        //complete t_period
        nrf_delay_us ( (bit? t_long_off_us : t_short_off_us) );
    }
}


/**
 * writes a byte over GOC using new Manchester encoding
 */
void _goc_write_byte_manchester( const uint32_t led,  const float freq, const uint8_t byte)
{
    //calculate the total length of time to send a bit of goodput
    float t_period = 1.0 / freq;

    //calculate the duration of each Manchester encoded bit
    uint32_t t_halfbit_time = (uint32_t) (0.5 * t_period * 1E6);

    uint8_t bit;
    for (int32_t i = 0; i <= 7 ; i++){
        bit = (byte >> i) & 0x1; //get 1 bit of byte; LSB first

        if (bit) {
            // Manchester `1' is `01' (active low!)
            led_on(led);
            nrf_delay_us ( t_halfbit_time );
            led_off(led);
            nrf_delay_us ( t_halfbit_time );
        } else {
            // Manchester `0' is `10' (active low!)
            led_off(led);
            nrf_delay_us ( t_halfbit_time );
            led_on(led);
            nrf_delay_us ( t_halfbit_time );
        }
    }
}

