const std = @import("std");
const spec_uri = "https://raw.githubusercontent.com/KhronosGroup/Vulkan-Headers/main/registry/vk.xml";

fn download_file(client: *std.http.Client, url: []const u8, output_path: []const u8) !void {
    var request = try client.request(.GET, try std.Uri.parse(url), .{ .allocator = client.allocator }, .{});
    defer request.deinit();

    try request.start();
    try request.wait();
    if (request.response.status != .ok) {
        return error.unexpectedError;
    }
    const file = try std.fs.cwd().createFile(output_path, .{});
    defer file.close();

    var fifo = std.fifo.LinearFifo(u8, .{ .Static = std.mem.page_size }).init();
    try fifo.pump(request.reader(), file.writer());
}

pub fn main() !void {
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(general_purpose_allocator.deinit() == .ok);

    var arena_allocator = std.heap.ArenaAllocator.init(general_purpose_allocator.allocator());
    defer arena_allocator.deinit();
    const allocator = arena_allocator.allocator();

    var client = std.http.Client{ .allocator = allocator };
    try download_file(&client, spec_uri, "vk.xml");
}
