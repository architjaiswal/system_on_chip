//
// by Malinowski, Henry Robert
// by Jaiswal, Archit Kalpeshkumar
//

#ifndef LIBRARY_CODE_UART_H
#define LIBRARY_CODE_UART_H

#include <stdint.h>
#include <stdbool.h>
#include "uart_regs.h"

bool uart_open(void);
void uart_close(void);
void uart_ctl(uint32_t uart_size, uint32_t parity_mode, uint32_t test_enable);
void uart_ctl_en(bool enable);
void uart_brd_set(uint32_t ibrd, uint16_t fbrd);
uint32_t uart_ibrd_get(void);
uint16_t uart_fbrd_get(void);
unsigned char uart_get_char(void);
void uart_put_char(unsigned char c);
void uart_put_str(const unsigned char* str);
void uart_get_bytes(unsigned count, uint8_t dest[]); // blocking
void uart_clear_tx_ov(void);
void uart_clear_rx_ov(void);
#endif //LIBRARY_CODE_UART_H
