// const std = @import("std");
// const cstd = @cImport(@cInclude("stdlib.h"));
// const time = @cImport(@cInclude("time.h"));

// opcode: u16,
// memory: [4096]u8,
// graphics: [64 * 32]u8,
// registers: [16]u8,
// index: u16,
// program_counter: u16,

// delay_timer: u8,
// sound_timer: u8,

// stack: [16]u16,
// stack_pointer: u4,

// keys: [16]u8,

const chip8_font = [_]u8{
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

const Self = @This();
pub fn init(self: *Self) !void {
    _ = self;
    //     cstd.srand(@as(u32, @intCast(time.time(0))));

    //     self.program_counter = 0x200;
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

    //     for (chip8_font, 0..) |c, i| {
    //         self.memory[i] = c;
    //     }
    // }

    // fn increment_program_counter(self: *Self) void {
    //     self.program_counter += 2; // every instruction is 2 bytes
    // }

    // pub fn cycle(self: *Self) void {
    //     self.opcode = self.memory[self.program_counter] << 8 | self.memory[self.program_counter + 1];
}
