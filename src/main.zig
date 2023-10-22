const std = @import("std");
const c = @import("c.zig");
const vk = @import("vk.zig");
// Zig lets you use files as structs, that's what I'm doing with chip8.zig
const chip8 = @import("chip8.zig");

const BaseDispatch = vk.BaseWrapper(.{
    .enumerateInstanceVersion = true,
});

var c8: *chip8 = undefined;

var window: ?*c.SDL_Window = null;
var renderer: ?*c.SDL_Renderer = null;
var texture: ?*c.SDL_Texture = null;

// pub fn println(msg: []const u8) void {
//     std.debug.print("{s}\n", .{msg});
// }

pub fn open_rom(path: []const u8) !void {
    const file = std.fs.cwd().openFile(
        path,
        .{ .mode = .read_only },
    ) catch |err| {
        std.log.err("Could not open file \"{s}\", error: {any}.\n", .{ path, err });
        std.process.exit(74);
    };
    defer file.close();

    const file_size = (try file.stat()).size;
    // hardcode max file size for now
    if (file_size > c8.ram.len - 512) {
        std.debug.print("File too large\n", .{});
        return error.FileTooLarge;
    }

    var reader = file.reader();
    var i: usize = 0;
    while (i < file_size) : (i += 1) {
        c8.ram[i + 512] = try reader.readByte();
        std.debug.print("{x}\n", .{c8.ram[i]});
    }
}

pub fn init() !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        std.debug.print("SDL Error {s}\n", .{c.SDL_GetError()});
        return error.FailedToInitSDL;
    }
    if (c.SDL_Vulkan_LoadLibrary(null) != 0) {
        std.debug.print("SDL Vulkan Error {s}\n", .{c.SDL_GetError()});
        return error.vulkan_init;
    }

    window = c.SDL_CreateWindow("CHIP8", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, 1024, 512, 0).?;

    renderer = c.SDL_CreateRenderer(window, -1, c.SDL_RENDERER_ACCELERATED);

    if (renderer == null) {
        var err = c.SDL_GetError();
        std.debug.print("{s}\n", .{err});
    }

    const get_instance_proc_addr: vk.PfnGetInstanceProcAddr = @ptrCast(c.SDL_Vulkan_GetVkGetInstanceProcAddr());
    const base_dispatch = try BaseDispatch.load(get_instance_proc_addr);
    const vulkan_version = try base_dispatch.enumerateInstanceVersion();
    std.debug.print("\n Vulkan Version {}.{}\n", .{ vk.apiVersionMajor(vulkan_version), vk.apiVersionMinor(vulkan_version) });

    texture = c.SDL_CreateTexture(renderer, c.SDL_PIXELFORMAT_RGBA8888, c.SDL_TEXTUREACCESS_STREAMING, 64, 32);
}

pub fn cleanUp() void {
    c.SDL_DestroyTexture(texture);
    c.SDL_DestroyRenderer(renderer);
    c.SDL_Vulkan_UnloadLibrary();
    c.SDL_DestroyWindow(window);
    c.SDL_Quit();
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    try init();
    defer cleanUp();

    c8 = try allocator.create(chip8);
    try c8.init();

    try open_rom("src/test-roms/test.txt");

    // try open_rom("C:\\Users\\Nathaniel\\Desktop\\chip-eight\\src\\test-roms\\test.txt");
    // try open_rom("C:\\Users\\Nathaniel\\Desktop\\chip-eight\\src\\test-roms\\IBM-Logo.ch8");

    var run: bool = true;
    while (run) {
        // TODO emulate chip8
        var event: c.SDL_Event = undefined;

        while (c.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                c.SDL_QUIT => run = false,
                // TODO key presses
                else => {},
            }
        }
        _ = c.SDL_RenderClear(renderer);
        _ = c.SDL_RenderCopy(renderer, texture, null, null);
        _ = c.SDL_RenderPresent(renderer);
        c.SDL_Delay(16); // approx 60hz
    }
}
