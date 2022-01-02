//
// by Malinowski, Henry Robert
// by Jaiswal, Archit Kalpeshkumar
//

#ifndef LIBRARY_CODE_UART_REGS_H
#define LIBRARY_CODE_UART_REGS_H

/* Register offsets from UART_BASE_OFFSET */
#define UART_DR_R       0
#define UART_IS_R       1
#define UART_CTL_R      2
#define UART_BRD_R      3

#define UART_SPAN_IN_BYTES  32

#define UART_DR_DATA_M      (0x000000FF)

/* Status register masks */
#define UART_IS_RXFO        (0x00000001)
#define UART_IS_RXFF        (0x00000002)
#define UART_IS_RXFE        (0x00000004)
#define UART_IS_TXFO        (0x00000008)
#define UART_IS_TXFF        (0x00000010)
#define UART_IS_TXFE        (0x00000020)
#define UART_IS_FE          (0x00000040)
#define UART_IS_PE          (0x00000080)
#define UART_IS_DEBUG_IN_M  (0xFFFF0000)

/* Control register maks  */
#define UART_CTL_WLEN_7         (0x00000000)
#define UART_CTL_WLEN_8         (0x00000001)
#define UART_CTL_WLEN_M         (0x00000001)
#define UART_CTL_PAR_OFF        (0x00000000)
#define UART_CTL_PAR_UD8        (0x00000002)
#define UART_CTL_PAR_EVEN       (0x00000004)
#define UART_CTL_PAR_ODD        (0x00000006)
#define UART_CTL_PAR_M          (0x00000006)
#define UART_CTL_EN             (0x00000008)
#define UART_CTL_TEST_EN        (0x00000010)
#define UART_CTL_DEBUG_OUT_M    (0xFFFF0000)

/* Baud-rate divider makes */
#define UART_BRD_IBRD_M     (0xFFFFFFC0)
#define UART_BRD_FBRD_M     (0x0000003F)

#endif //LIBRARY_CODE_UART_REGS_H
