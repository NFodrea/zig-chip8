# CHIP-8 emulator
## Project Notes
- ignore `setup.zig` it was used to pull some dependencies that I'm leaving checked into the repo for now at least.
- Vulkan is setup incase I want it later and is working, but it is currently only used to print the major and minor version of Vulkan that is being used
## CHIP-8 Notes
- 4,096 bytes of RAM
- 0x000 (0) - 0xFFF (4095)
- the first 512 bytes are reserved for the interpreter and should not be used by the program
- user programs start at 0x200 (512) and end at 0xFFF (4095)
- don't use the VF register it is used as a flag
- the program counter is a 16 bit register that holds the address of the current instruction
- display is 64x32 pixels in monochrome
- sprite size is up to 15 bytes
- 36 total instructions
- [ROMS for testing](https://github.com/kripod/chip8-roms)
- [BC_test rom](https://github.com/cj1128/chip8-emulator/tree/master/rom)
- [test_opcode](https://github.com/corax89/chip8-test-rom)
- [Chip-8 Technical Ref](http://devernay.free.fr/hacks/chip8/C8TECH10.HTM)

