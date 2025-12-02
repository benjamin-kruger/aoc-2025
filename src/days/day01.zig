const std = @import("std");

pub fn main() !void {
    var buffer: [512]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&buffer);
    const stdout = &stdout_writer.interface;

    try stdout.writeAll("Part 1: TBD\n");
    try stdout.writeAll("Part 2: TBD\n");

    try stdout.flush();
}
