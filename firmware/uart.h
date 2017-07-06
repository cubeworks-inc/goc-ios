/**
 * GOC-IOS firmeware
 * 
 * Andrew Lukefahr
 * lukefahr@umich.edu
 *
 */
#ifndef __UART_H__
#define __UART_H__

#define UART_BUF_LEN 512

struct uart_buffer
{
    uint32_t length;
    uint8_t ready;
    uint8_t error;
    uint8_t data[ UART_BUF_LEN ];
};

void uart_init(void);

void uart_write(uint8_t byte);

void uart_init_buffer( volatile struct uart_buffer * buf);
int32_t uart_add_buffer( volatile struct uart_buffer * buf);


#endif
