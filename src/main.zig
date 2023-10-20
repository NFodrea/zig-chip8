const std = @import("std");
const vk = @import("vk.zig");

const BaseDispatch = vk.BaseWrapper(.{
    .createInstance = true,
});
pub fn main() !void {
    _ = vk;
}
