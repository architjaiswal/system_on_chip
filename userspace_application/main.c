#include <stdio.h>
#include <inttypes.h>
#include "uart.h"

int main(int argc, char *argv[argc])
{
    uint8_t bytes[3]; // three msg bytes from mouse peripheral
    unsigned i;

    uart_open(); // open Avalon memmap
    uart_ctl(UART_CTL_WLEN_7, UART_CTL_PAR_OFF, !UART_CTL_TEST_EN); // configure the uart
    uart_brd_set(2604, 10); // set baud: dividers for 1200 baud from 50MHz
    uart_ctl_en(true); // finally, enable properly

    // display mouse output 64 times, then exit
    for (i = 0; i < 64; ++i)
    {
        uart_get_bytes(3, bytes);
        printf("%" PRIx8 " %" PRIx8 "%" PRIx8 "\n", bytes[0], bytes[1], bytes[2]); // print collected bytes
    }

    uart_ctl_en(false); // disable uart clocking
    uart_close(); // clock Avalon memmap
    return 0;
}
