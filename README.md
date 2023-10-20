4,096 bytes of RAM
0x000 (0) - 0xFFF (4095)
the first 512 bytes are reserved for the interpreter and should not be used by the program
start at 0x200 (512) and end at 0xFFF (4095)
do not use the VF register it is used as a flag
a program counter is a 16 bit register that holds the address of the current instruction
Display is 64x32 pixels in monochrome
sprite size is up to 15 bytes
36 total instructions
[Chip-8 Ref](http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.2)