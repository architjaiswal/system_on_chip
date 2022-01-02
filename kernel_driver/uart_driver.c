//
// by Malinowski, Henry Robert
// by Jaiswal, Archit Kalpeshkumar
//

#include <linux/kernel.h>     // kstrtouint, sprintf
#include <linux/module.h>     // MODULE_ macros
#include <linux/init.h>       // __init
#include <linux/kobject.h>    // kobject, kobject_atribute,
                              // kobject_create_and_add, kobject_put
#include <asm/io.h>           // iowrite, ioread, ioremap_nocache (platform specific)
#include "address_map.h"      // overall memory map
#include "uart_regs.h"        // register offset in UART IP

/*
 * Kernel module information
 */

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Henry & Archit");
MODULE_DESCRIPTION("UART IP Driver");

/*
 * Global variables
 */
unsigned int *base = NULL;

const unsigned int BASE_CLOCK = 50000000;

/*
 * Subroutines
 */
void uart_set_baud_rate(unsigned int ibrd, unsigned int fbrd)
{
iowrite32((ibrd << 6u) | fbrd, base + UART_BRD_R);
}

void uart_set_word_size(unsigned int ws)
{
    unsigned int status = ioread32(base + UART_CTL_R); // store current control register
    status &= ~UART_CTL_WLEN_M;
    switch (ws)
    {
        case 7: status |= UART_CTL_WLEN_7; // unset len (revert to default of 7)
                break;
        case 8: status |= UART_CTL_WLEN_8; // set to 8-bit mode
                break;
        default:
                break; // ignore other values
    }

    iowrite32(status, base + UART_CTL_R); // commit changed
}

void uart_set_parity_mode(unsigned int mode)
{
   unsigned int status = ioread32(base + UART_CTL_R);
   status &= ~UART_CTL_PAR_M; // clear the current value
   status |= mode; // write the desired mode
   iowrite32(status, base + UART_CTL_R);
}

void uart_put_char(unsigned int c)
{
    while (ioread32(base + UART_IS_R) & UART_IS_TXFF); // block while Tx FIFO is full
    iowrite32(c & 0x1FF, base + UART_DR_R);
}

int uart_get_char(void)
{
    unsigned int status = ioread32(base + UART_IS_R); // read status to check if empty
    if (status & UART_IS_RXFE) // return -1 when Rx FIFO empty
        return -1;
    else
        return ioread32(base + UART_DR_R) & UART_DR_DATA_M;
}

/*
 * Kernel Objects
 */
// /sys/class/uart/baud_rate
static unsigned int baud_rate = 9600;
module_param(baud_rate, uint, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(baud_rate, " Read/Write Uart baud rate");

static ssize_t uart_baud_rate_read(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    return sprintf(buffer, "%u\n", baud_rate);
}

static ssize_t uart_baud_rate_write(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t size)
{
    // TODO add range checking
    unsigned int divisorTimes128, ibrd, fbrd;
    int status = kstrtouint(buffer, 0, &baud_rate);
	
    if (status == 0)
    {
        divisorTimes128 = (BASE_CLOCK * 8) / baud_rate;
        ibrd = divisorTimes128 >> 7;
        fbrd = (((divisorTimes128 + 1)) >> 1) & 63;
        uart_set_baud_rate(ibrd, fbrd);
    }

    return status;
}

static struct kobj_attribute uart_baud_attr = __ATTR(baud_rate, 0664, uart_baud_rate_read, uart_baud_rate_write);

/////
// /sys/class/uart/word_size
/////
static unsigned int word_size = 8;
module_param(word_size, uint, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(word_size, " Read/Write Uart word size (7 or 8)");

static ssize_t uart_word_size_read(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    return sprintf(buffer, "%u\n", word_size);
}

static ssize_t uart_word_size_write(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "7", count-1) == 0)
    {
        uart_set_word_size(UART_CTL_WLEN_7);
    } else if (strncmp(buffer, "8", count-1) == 0)
	{
        uart_set_word_size(UART_CTL_WLEN_8);
    } // else; do nothing

    return count;
}

static struct kobj_attribute uart_word_size_attr = __ATTR(word_size, 0664, uart_word_size_read, uart_word_size_write);

/////
// /sys/class/uart/parity_mode
/////
static unsigned int parity_mode = UART_CTL_PAR_OFF;
module_param(parity_mode, uint, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(word_size, " Read/Write Parity mode (off, even, odd, 9bit)");

static ssize_t uart_parity_mode_read(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    switch (parity_mode)
    {
        case UART_CTL_PAR_OFF:
            strcpy(buffer, "off\n");
        case UART_CTL_PAR_UD8:
            strcpy(buffer, "9bit\n");
        case UART_CTL_PAR_EVEN:
            strcpy(buffer, "even\n");
        case UART_CTL_PAR_ODD:
            strcpy(buffer, "odd\n");
        default:
            strcpy(buffer, "ERROR: parity mode");
    }
	
	return strlen(buffer);
}

static ssize_t uart_parity_mode_write(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "off", count-1) == 0)
        uart_set_parity_mode(UART_CTL_PAR_OFF);
    else if (strncmp(buffer, "even", count-1) == 0)
        uart_set_parity_mode(UART_CTL_PAR_EVEN);
    else if (strncmp(buffer, "odd", count-1) == 0)
        uart_set_parity_mode(UART_CTL_PAR_ODD);
    else if (strncmp(buffer, "9bit", count-1) == 0)
        uart_set_parity_mode(UART_CTL_PAR_UD8);
    // implicit else; do nothing

    return count;
}

static struct kobj_attribute uart_parity_mode_attr = __ATTR(parity_mode, 0664, uart_parity_mode_read, uart_parity_mode_write);

/////
// /sys/class/uart/tx_data
/////
static unsigned int tx_data = 0;
module_param(tx_data, uint, S_IRUGO); // read-only
MODULE_PARM_DESC(tx_data, "UART Tx (Write)");

static ssize_t uart_tx_data_write(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    int result = kstrtouint(buffer, 0, &tx_data);
    if (result == 0) // write to uart_data_r from uart_tx_data
    {
        uart_put_char(tx_data);
    }
    return count;
}

static struct kobj_attribute uart_tx_data_attr = __ATTR(tx_data, 0644, NULL, uart_tx_data_write);

/////
// sys/class/uart/rx_data
/////
static unsigned int rx_data = 0;
module_param(rx_data, uint, S_IWUSR); // write only
MODULE_PARM_DESC(rx_data, "UART Rx (Read)");
static ssize_t uart_rx_data_read(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
	rx_data = uart_get_char();
    return sprintf(buffer, "%u", rx_data);
}
static struct kobj_attribute uart_rx_data_attr = __ATTR(rx_data, 0664, uart_rx_data_read, NULL);

static struct attribute *attrs0[] =
{
    &uart_baud_attr.attr,
    &uart_word_size_attr.attr,
    &uart_parity_mode_attr.attr,
    &uart_tx_data_attr.attr,
    &uart_rx_data_attr.attr,
    NULL
};

static struct attribute_group group0 =
{
    .name = "uart",
    .attrs = attrs0
};

static struct kobject *kobj;

//--------
// Init and Exit
//--------

static int __init initialize_module(void)
{
    int result;

    printk(KERN_INFO "UART driver: starting\n");

    // Create uart directory under /sys/kernel
    kobj = kobject_create_and_add("uart", kernel_kobj);
    if (!kobj)
    {
        printk(KERN_ALERT "UART driver: failed to create and add kobj\n");
        return -ENOENT;
    }

    // create groups
    result = sysfs_create_group(kobj, &group0);
    if (result != 0) return result;
    
    // Physical to virtual memory map to access uart registers
    base = (unsigned int*)ioremap_nocache(LW_BRIDGE_BASE + UART_BASE_OFFSET,
                                          UART_SPAN_IN_BYTES);
    if (base == NULL)
        return -ENODEV;

    printk(KERN_INFO "UART driver: initialized\n");

    return 0;
}

static void __exit exit_module(void)
{
    kobject_put(kobj);
    printk(KERN_INFO "UART driver: exit\n");
}

module_init(initialize_module);
module_exit(exit_module);
