#ifndef __GOC_H__
#define __GOC_H__

/**
 * GOC-IOS firmeware
 * 
 * Andrew Lukefahr
 * lukefahr@umich.edu
 *
 */

extern const uint32_t GOC_LED_IR;
extern const uint32_t GOC_LED_WHITE; 

void goc_init();

int  goc_set_active_led(uint32_t led);
uint32_t goc_get_active_led(); 

void goc_set_default( const uint8_t on_by_default);
uint8_t goc_get_default();

void goc_set_clk( const float clk);
float goc_get_clk();

void goc_write( const uint8_t * data, const uint32_t size);
void goc_write_manchester( const uint8_t * data, const uint32_t size);


#endif
