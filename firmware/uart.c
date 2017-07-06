/**
 * GOC-IOS firmeware
 * 
 * Andrew Lukefahr
 * lukefahr@umich.edu
 *
 */



#include <stdbool.h>
#include <stdint.h>

#include "app_uart.h"
#include "uart.h"

#define RX_PIN_NUMBER       28
#define TX_PIN_NUMBER       29
#define UART_RX_BUF_SIZE    512
#define UART_TX_BUF_SIZE    512

volatile struct uart_buffer * uart_rx_buf = NULL;
volatile struct uart_buffer * uart_rx_next_buf = NULL;

void _uart_event_handle(app_uart_evt_t * p_event);

void _uart_process_char( const char cr );
void _uart_advance_buf(uint8_t error);

void uart_init(void)
{
    uint32_t err_code;
    const app_uart_comm_params_t comm_params = {
          RX_PIN_NUMBER,
          TX_PIN_NUMBER,
          0,
          0,
          APP_UART_FLOW_CONTROL_DISABLED,
          false,
          UART_BAUDRATE_BAUDRATE_Baud115200
      };

    APP_UART_FIFO_INIT(&comm_params,
                         UART_RX_BUF_SIZE,
                         UART_TX_BUF_SIZE,
                         _uart_event_handle,
                         APP_IRQ_PRIORITY_LOW,
                         err_code);
    APP_ERROR_CHECK(err_code);


}

void uart_init_buffer( volatile struct uart_buffer * buf)
{
    buf->length = 0;
    buf->ready = 0;
    buf->error = 0;
}

/**
 * @ return >=0: added buffer, -1: error
 */
int32_t uart_add_buffer( volatile struct uart_buffer * buf)
{
    uart_init_buffer(buf);

    if (uart_rx_buf == NULL){
        uart_rx_buf = buf;
        return 0;
    } else if (uart_rx_next_buf == NULL) {
        uart_rx_next_buf = buf;
        return 1;
    } else {
        return -1;
    }
}

/**
 *
 */
void uart_write(uint8_t byte)
{
    app_uart_put(byte);
}

/**
 * callback function for uart events
 */
void _uart_event_handle(app_uart_evt_t * p_event) {
    if (p_event->evt_type == APP_UART_COMMUNICATION_ERROR) {
        // ignore
    } else if (p_event->evt_type == APP_UART_FIFO_ERROR) {
        // ignore
    //} else if (p_event->evt_type == APP_UART_DATA) {
    } else if (p_event->evt_type == APP_UART_DATA_READY) {

        // Read the UART character
        char cr;
        app_uart_get((uint8_t*) &cr);
        //app_uart_put(cr);

        _uart_process_char(cr);

    }
}


/**
 * process an individual character over UART
 */
void _uart_process_char( const char cr )
{
    //how many bytes are we still expecting
    static int32_t pending = 3;

    //append the data
    uart_rx_buf->data[ uart_rx_buf->length] = cr;
    uart_rx_buf->length += 1;
    --pending;

    //the length of the remaining packet is specified here
    if (uart_rx_buf->length == 3) {
        pending = cr;
    }

    //we've hit the end of the packet
    if (pending ==  0){
        _uart_advance_buf(0);
        pending = 3;
    }
}

/**
 * advances to the next buffer if possible
 */
void _uart_advance_buf(uint8_t error)
{
    //if we have a new buffer use it
    if (uart_rx_next_buf != NULL){
        uart_rx_buf->ready = 1;
        uart_rx_buf->error = error;

        volatile struct uart_buffer * tbuf = uart_rx_next_buf;
        uart_rx_next_buf = NULL; //set this first
        uart_rx_buf = tbuf; // for possible timing issues

    //otherwise re-use this one
    } else {
        uart_init_buffer(  uart_rx_buf);
    }
}
