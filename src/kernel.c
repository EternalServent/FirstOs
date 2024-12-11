#include "kernel.h"
#include<stddef.h>
#include<stdint.h>

uint16_t* video_mem = 0;
uint16_t terminal_row = 0 , terminal_col = 0;
uint16_t terminal_make_char(char c , char color) {
    return (color << 8) | c;
}

void terminal_putchar(int x , int y , char c , char color) {

    video_mem[(y*VGA_WIDTH)+x] = terminal_make_char('h',0);    
}

void terminal_writechar(char c , char color) {

    terminal_putchar(terminal_col,terminal_row,c,color);
    terminal_col+=1;
    if (terminal_col>=VGA_WIDTH) {
        terminal_col = 0;
        terminal_row+=1;
    }

}

void terminal_init() {
    video_mem = (uint16_t*) 0xb8000;
    terminal_col = terminal_row = 0;
    for (int y=0; y<VGA_HEIGHT; ++y) 
        for (int x=0; x<VGA_WIDTH; ++x)
            terminal_putchar(x,y,' ', 0);
}

size_t strlen(const char* str) {
    size_t len = 0;
    while (str[len++]);
    return len-1;
}



void kernel_main() {
    terminal_init();
    uint16_t* video_mem = (uint16_t*) 0xb8000;
    const char* buf = "WELLCOME TO FIRSTOS, CREATED BY SAROWER & SUDIP.\n This is a very simple os.\n I pray to God so that we can build this os successfully.";
    int i=0;
    while (buf[i]) {
        video_mem[i] = terminal_make_char(buf[i],2);
        i++;
    }

}