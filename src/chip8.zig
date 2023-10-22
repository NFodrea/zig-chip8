const std = @import("std");
// const cstd = @cImport(@cInclude("stdlib.h"));
// const time = @cImport(@cInclude("time.h"));

const Self = @This();

// storing these as seperate arrays instead of pointers in RAM like the original chip8 to make it easier to work with
/// 00E0 - CLS
opcode: u16,
ram: [4096]u8,
// graphics: [64 * 32]u8, // later dynamic note: display = &ram[0xF00..0xFFF]; offset x,y display[10]
graphics: [64 * 32]bool, // not sure if I want a pointer or to loop and turn pixels on and off with a bool

/// 16 general purpose 8-bit registers V0-VF.
/// VF is used for carry flag in math operations
/// except subtraction when it's a NOT borrow flag
/// VF is also used for collision detection
registers: [16]u8,
/// special register used to store memory addresses originally 12 bits
index: u16,
/// special register points to and retrieves the current instruction (currently executing opcode)
program_counter: u16,

/// decrements at 60hz when > 0
delay_timer: u8,
/// decrements at 60hz when > 0 and plays a tone
sound_timer: u8,
/// original was 48 bytes with up to 12 levels of nesting modern implementations usually have more
/// could be a u4 to save space
stack: [16]u16,
/// current item on the stack
stack_pointer: u4,

/// 16 keys 0x0-0xF bool for on/off state  Chip8 has a hex keyboard
// keys: [16]u8,
keys: [16]bool,

rom_name: []u8, // I may not keep this

/// bitmapped font ON = foreground color OFF = background color.
/// 5 cols x 16 rows 80 bytes
const font = [_]u8{
    0xF0, 0x90, 0x90, 0x90, 0xF0, // 0
    0x20, 0x60, 0x20, 0x20, 0x70, // 1
    0xF0, 0x10, 0xF0, 0x80, 0xF0, // 2
    0xF0, 0x10, 0xF0, 0x10, 0xF0, // 3
    0x90, 0x90, 0xF0, 0x10, 0x10, // 4
    0xF0, 0x80, 0xF0, 0x10, 0xF0, // 5
    0xF0, 0x80, 0xF0, 0x90, 0xF0, // 6
    0xF0, 0x10, 0x20, 0x40, 0x40, // 7
    0xF0, 0x90, 0xF0, 0x90, 0xF0, // 8
    0xF0, 0x90, 0xF0, 0x10, 0xF0, // 9
    0xF0, 0x90, 0xF0, 0x90, 0x90, // A
    0xE0, 0x90, 0xE0, 0x90, 0xE0, // B
    0xF0, 0x80, 0x80, 0x80, 0xF0, // C
    0xE0, 0x90, 0x90, 0x90, 0xE0, // D
    0xF0, 0x80, 0xF0, 0x80, 0xF0, // E
    0xF0, 0x80, 0xF0, 0x80, 0x80, // F
};

pub fn init(self: *Self) !void {
    // start at 0x200 (512) because the first 512 bytes are reserved for the interpreter
    const entry_point = 0x200;
    //     cstd.srand(@as(u32, @intCast(time.time(0))));

    self.program_counter = entry_point;
    // load font into the first 80 bytes of memory

    // self.ram[0] = @memcpy(font, self.ram[0..font.len]);
    for (font, 0..) |el, i| {
        self.ram[i] = el;
    }

    //     self.opcode = 0;
    //     self.index = 0;
    //     self.stack_pointer = 0;
    //     self.delay_timer = 0;
    //     self.sound_timer = 0;

    //     // Clear display
    //     for (self.graphics) |*g| {
    //         g.* = 0;
    //     }

    //     for (self.memory) |*el| {
    //         el.* = 0;
    //     }
    //     for (self.stack) |*el| {
    //         el.* = 0;
    //     }
    //     for (self.registers) |*el| {
    //         el.* = 0;
    //     }
    //     for (self.keys) |*el| {
    //         el.* = 0;
    //     }

    // }

    // pub fn cycle(self: *Self) void {
    //     self.opcode = self.memory[self.program_counter] << 8 | self.memory[self.program_counter + 1];
}

/// increment the program counter by 2 bytes (1 instruction)
fn increment_program_counter(self: *Self) void {
    self.program_counter += 2;
}

pub fn cycle(self: *Self) void {
    self.opcode = self.ram[self.program_counter] << 8 | self.ram[self.program_counter + 1];
}
