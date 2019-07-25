/** 
 * GOC-IOS firmware
 *
 * Andrew Lukefahr
 * lukefahr@umich.edu
 *
 */

#include <stdbool.h>
#include <stdint.h>
#include "led.h"
#include "nrf.h"
#include "nrf_sdm.h"
#include "app_timer.h"
#include "softdevice_handler.h"

#include "uart.h"
#include "goc.h"

#include "qassert.h"


/**
 * data structure to help sub-command calls to return data
 */
struct  cmd_return_data
{
    uint8_t ack; //should we went an ACK (or NAK)
    uint8_t bytes; //how many additional bytes should be sent
    union {
        uint32_t data_32; // if bytes==4
        uint16_t data_16; // if bytes==2
        uint8_t data_8;   // if bytes==1
    };
};

/**
 *
 */
void cmd_return_data_init( struct cmd_return_data * d)
{
    d->ack=false;
    d->bytes = 0;
}

static void _process_cmd( struct uart_buffer * buf);

static void _process_cmd_f( struct uart_buffer * buf, struct cmd_return_data * ret);
static void _process_cmd_n( struct uart_buffer * buf, struct cmd_return_data * ret);
static void _process_cmd_O( struct uart_buffer * buf, struct cmd_return_data * ret);
static void _process_cmd_o( struct uart_buffer * buf, struct cmd_return_data * ret);
uint8_t _reverseBits( uint8_t v);


const uint32_t TIMER_LED = 13;

// Some constants about timers
#define BLINK_TIMER_PRESCALER              0  // Value of the RTC1 PRESCALER register.
#define BLINK_TIMER_OP_QUEUE_SIZE          4  // Size of timer operation queues.

// How long before the timer fires.
#define BLINK_RATE     APP_TIMER_TICKS(500, BLINK_TIMER_PRESCALER) // Blink every 0.5 seconds

// Timer data structure
APP_TIMER_DEF(blink_timer);


// Timer callback
static void timer_handler (void* p_context) {
    led_toggle(TIMER_LED);

    uart_timer_handler();
}

// Setup timer
static void timer_init(void)
{
    // Initialize.
    led_init(TIMER_LED);

    uint32_t err_code;

    // Initialize timer module.
    APP_TIMER_INIT(BLINK_TIMER_PRESCALER,
                   BLINK_TIMER_OP_QUEUE_SIZE,
                   false);

    // Create a timer
    err_code = app_timer_create(&blink_timer,
                                APP_TIMER_MODE_REPEATED,
                                timer_handler);
    APP_ERROR_CHECK(err_code);
}

// Start the timer
static void timer_start(void) {
    uint32_t err_code;

    // Start application timers.
    err_code = app_timer_start(blink_timer, BLINK_RATE, NULL);
    APP_ERROR_CHECK(err_code);
}

int main(void) {

    led_off(TIMER_LED);

    // Need to set the clock to something
    nrf_clock_lf_cfg_t clock_lf_cfg = {
        .source        = NRF_CLOCK_LF_SRC_RC,
        .rc_ctiv       = 16,
        .rc_temp_ctiv  = 2,
        .xtal_accuracy = NRF_CLOCK_LF_XTAL_ACCURACY_250_PPM};

    // Initialize the SoftDevice handler module.
    SOFTDEVICE_HANDLER_INIT(&clock_lf_cfg, NULL);

    timer_init();
    timer_start();

    //uart stuff
    volatile struct uart_buffer buf0;
    volatile struct uart_buffer buf1;
    uart_init();
    uart_add_buffer(&buf0);
    uart_add_buffer(&buf1);

    //goc init 
    goc_init();

    //main processing loop
    volatile struct uart_buffer * cmd_buf = &buf0;

    // Enter main loop.
    for (;;) {
        //spin until next command is ready
        if ( cmd_buf->ready == 1) {

            //process it
            if (cmd_buf->error == 0)
                _process_cmd((struct uart_buffer*) cmd_buf);
            
            uart_add_buffer(cmd_buf);

            cmd_buf = (cmd_buf == &buf0 ? &buf1 : &buf0 );

        } // if cmd_buf->ready
    }
}


//
//
// ICE
//
//

/*
 * process ICE protocol commands
 */
void _process_cmd( struct uart_buffer * buf) {
   
    struct cmd_return_data ret_val; 
    cmd_return_data_init(&ret_val);

    qassert( buf->length >= 3);
    uint8_t rx_cmd = buf->data[0];
    uint8_t rx_event_id = buf->data[1];

    if ( rx_cmd == 'V') {
        ret_val.ack = true;
        ret_val.bytes = 2;
        ret_val.data_16 = 0x0004; // version 0.4

    } else if ( rx_cmd == 'v') {
        qassert( buf->length >= 5);
        uint8_t major = buf->data[3];
        uint8_t minor = buf->data[4];
        //only agree to version 0.4
        if ( (major == 0) && (minor == 4)){
            ret_val.ack = true;
        //otherwise we NAK
        } else {
            ret_val.ack = false;
        }

    } else if (rx_cmd == '?') {
        //ugg, 
        //this one we just have to do by hand...
        uart_write(0x0);
        uart_write(rx_event_id);
        uart_write(0x5); //5 command types supported
        uart_write('?');
        uart_write('f');
        uart_write('n');
        uart_write('O');
        uart_write('o');
        return;

    } else if (rx_cmd == 'f') {
        _process_cmd_f(buf, &ret_val);

    } else if (rx_cmd == 'n') {
        _process_cmd_n(buf, &ret_val);

    } else if (rx_cmd == 'O') {
        _process_cmd_O(buf, &ret_val);

    } else if (rx_cmd == 'o') {
        _process_cmd_o(buf, &ret_val);
        if (ret_val.ack == false){
            ret_val.bytes = 1;
            ret_val.data_8 = 0x16; //EINVAL
        }

    } else {
        //if we don't understand the command, just NAK
        ret_val.ack = false;
    }

    //Now we send our response ICE packet over UART

    //send the ack/nak
    uart_write( (ret_val.ack? 0x0 : 0x1) );
    //and the event id
    uart_write(rx_event_id);
    //and the length
    uart_write( ret_val.bytes);
    //now add in the extra data (if any) 
    if (ret_val.bytes == 1){
        uart_write(ret_val.data_8);  
    } else if (ret_val.bytes == 2) {
        uart_write((uint8_t)((ret_val.data_16 & 0xff00    ) >> 8));
        uart_write((uint8_t)((ret_val.data_16 & 0x00ff    ) >> 0));
    } else if (ret_val.bytes == 4) {
        uart_write((uint8_t)((ret_val.data_32 & 0xff000000) >> 24));
        uart_write((uint8_t)((ret_val.data_32 & 0x00ff0000) >> 16));
        uart_write((uint8_t)((ret_val.data_32 & 0x0000ff00) >> 8 ));
        uart_write((uint8_t)((ret_val.data_32 & 0x000000ff) >> 0 ));
    }
}



/*
 * process the 'f' ICE command (GOC message)
 */
void _process_cmd_f( struct uart_buffer * buf,
                struct cmd_return_data * ret)
{
    uint8_t * data = &(buf->data[3]);
    const int32_t length = buf->data[2];
    qassert(length <= 255);

    //crap, ICE transmits the data LSB->MSB per byte, we need 
    //the reverse of that... MSB->LSB for the GOC library
    for (int i = 0; i < length; ++i){
        data[i] = _reverseBits(data[i]);
    }

    goc_write( data, length);

    ret->ack = true;
}

/*
 * process the 'n' ICE command (GOC message with Manchester encoding) 
 */
void _process_cmd_n( struct uart_buffer * buf,
                struct cmd_return_data * ret)
{
    uint8_t * data = &(buf->data[3]);
    const int32_t length = buf->data[2];
    qassert(length <= 255);

    goc_write_manchester(data, length);

    ret->ack = true;
}

/*
 * process the 'O' command
 * query configuration for GOC
 */
void _process_cmd_O( struct uart_buffer * buf,
                    struct cmd_return_data * ret)
{
    qassert( buf->length >= 5);
    const uint8_t subcmd = buf->data[3];

    if (subcmd == 'c'){ //clock divider
        const double clk_hz = goc_get_clk();
        const uint32_t clk_div = 4E6 / clk_hz;
        ret->ack = true;
        ret->bytes = 4;
        ret->data_32 = clk_div;

    } else if (subcmd == 'p'){ //GOC/EIN mode
        uint8_t code =  //1: WHITE 3:IR
            ( goc_get_active_led() == GOC_LED_WHITE? 0x1 : 0x3);

        ret->ack = true;
        ret->bytes = 1;
        ret->data_8 = code;

    } else if (subcmd == 'o') { //GOC on/off by default
       ret->ack = true;
       ret->bytes = 1;
       ret->data_8 = goc_get_default();

    } else { //NAK everything else
        ret->ack = false;
        ret->bytes = 1;
        ret->data_8 = 0x16; //EINVAL
    }
}

/*
 * process the 'o' command
 * set GOC variables
 */
void _process_cmd_o( struct uart_buffer * buf,
                    struct cmd_return_data * ret)
{
    ret->ack = false;
    qassert( buf->length >= 5);
    const uint8_t subcmd = buf->data[3];

    if (subcmd == 'c'){ // clock divider
        qassert(buf->length >= 8);

        //could probibally just cast the data as an uint32_t
        //but this is more precisely correct
        uint32_t clk_div =  (buf->data[4] << 24) |
                            (buf->data[5] << 16) |
                            (buf->data[6] << 8 ) | 
                            (buf->data[7] << 0 );

        //convert to HZ as specificied by the ICE Protocol
        double clk_speed_hz = 4.0E6 / (double)clk_div; 

        goc_set_clk( clk_speed_hz);

        ret->ack=true;

    } else if (subcmd == 'p'){ //set GOC/EIN mode
        uint8_t mode = buf->data[4];
        if (mode == 1){
            ret->ack=true; //GOC -white  led
            goc_set_active_led(GOC_LED_WHITE);
        } else if (mode == 3){
            ret->ack=true; //GOC - ir led
            goc_set_active_led(GOC_LED_IR);
        }

    } else if (subcmd == 'o') { // set GOC on/off by default
        uint8_t mode = buf->data[4];
        goc_set_default( mode);
        ret->ack = true;
    }
}

/** 
 * reverse the bits in a byte
 * shamelessly stolen from: 
 * https://medium.com/square-corner-blog/reversing-bits-in-c-48a772dc02d7
 */
uint8_t _reverseBits( uint8_t v)
{
    v = ((v >> 1) & 0x55) | ((v & 0x55) << 1);
    v = ((v >> 2) & 0x33) | ((v & 0x33) << 2);
    v = ((v >> 4) & 0x0F) | ((v & 0x0F) << 4);
    return v;
}






