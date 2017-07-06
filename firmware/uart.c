

#include <stdbool.h>
#include <stdint.h>

#include "app_uart.h"
#include "uart.h"

#define RX_PIN_NUMBER       28
#define TX_PIN_NUMBER       29
#define UART_RX_BUF_SIZE    512
#define UART_TX_BUF_SIZE    512

void _uart_event_handle(app_uart_evt_t * p_event);
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


void _uart_event_handle(app_uart_evt_t * p_event) {
    if (p_event->evt_type == APP_UART_COMMUNICATION_ERROR) {
        // ignore
    } else if (p_event->evt_type == APP_UART_FIFO_ERROR) {
        // ignore
    } else if (p_event->evt_type == APP_UART_DATA) {

        // Read the UART character
        char cr;
        app_uart_get((uint8_t*) &cr);
        app_uart_put(cr);

    }
}
