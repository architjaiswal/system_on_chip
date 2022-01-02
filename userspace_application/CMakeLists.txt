cmake_minimum_required(VERSION 3.19)
project(library_code C)

set(CMAKE_C_STANDARD 90)

add_executable(library_code main.c uart.c uart.h address_map.h uart_regs.h driver.c)