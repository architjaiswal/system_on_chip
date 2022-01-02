//
// by Malinowski, Henry Robert
// by Jaiswal, Archit Kalpeshkumar
//

#include "uart.h"

#include <fcntl.h>      // open()
#include <sys/mman.h>   // mmap()
#include <unistd.h>     // close()

#include "address_map.h"
#include "uart_regs.h"

uint32_t *base = NULL;
volatile uint32_t *uart_data_r;
volatile uint32_t *uart_is_r;
volatile uint32_t *uart_ctl_r;
volatile uint32_t *uart_bdr_r;

bool uart_open(void)
{
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) return false;

    base = mmap(NULL, UART_SPAN_IN_BYTES, PROT_READ | PROT_WRITE, MAP_SHARED,
                fd, LW_BRIDGE_BASE + UART_BASE_OFFSET);
    close(fd);
    if (base != MAP_FAILED)
    {
        uart_data_r = base + UART_DR_R;
        uart_is_r   = base + UART_IS_R;
        uart_ctl_r  = base + UART_CTL_R;
        uart_bdr_r  = base + UART_BRD_R;
    }

    return (base != MAP_FAILED);
}

void uart_close(void)
{
    munmap(base, UART_SPAN_IN_BYTES);
    base = NULL;
    uart_data_r = NULL;
    uart_is_r   = NULL;
    uart_ctl_r  = NULL;
    uart_bdr_r  = NULL;
}

void uart_ctl(uint32_t uart_size, uint32_t parity_mode, uint32_t test_enable)
{

    *(uart_ctl_r) = uart_size | parity_mode | test_enable;
}

void uart_ctl_en(bool enable)
{
    if (enable) *(uart_ctl_r) |= UART_CTL_EN;
    else *(uart_ctl_r) &= ~UART_CTL_EN;
}

void uart_brd_set(uint32_t ibrd, uint16_t fbrd)
{
    *uart_bdr_r = (ibrd << 6u) | fbrd;
}

uint32_t uart_ibrd_get(void)
{
    uint32_t val = *uart_bdr_r & UART_BRD_IBRD_M;
    return val >> 6u;
}

uint16_t uart_fbrd_get(void)
{
    return *uart_bdr_r & UART_BRD_FBRD_M;
}

unsigned char uart_get_char(void)
{
    while (*(uart_is_r) & UART_IS_RXFE);
    return *(uart_data_r) & UART_DR_DATA_M;
}

void uart_clear_tx_ov(void)
{
    *uart_is_r = UART_IS_TXFO;
}

void uart_clear_rx_ov(void)
{
    *uart_is_r = UART_IS_RXFO;
}

void uart_put_char(unsigned char c)
{
    while (*(uart_is_r) & UART_IS_TXFF);
    *uart_data_r = c & UART_DR_DATA_M;
}

void uart_put_str(const unsigned char* str)
{
    while (*str) uart_put_char(*str++);
}

void uart_get_bytes(unsigned count, uint8_t dest[])
{
    size_t i;
    for (i = 0; i < count; ++i)
    {
        dest[i] = uart_get_char();
    }
}