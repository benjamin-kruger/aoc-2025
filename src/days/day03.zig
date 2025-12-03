const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    const file = try std.fs.cwd().openFile("src/days/input/day03.txt", .{});
    defer file.close();

    const stat = try file.stat();
    var buffer: [2048]u8 = undefined;
    var reader = file.reader(&buffer);
    const body = try reader.interface.readAlloc(alloc, stat.size);
    defer alloc.free(body);

    const p1 = try part1(body);
    const p2 = try part2(body);

    std.debug.print("Part 1: {}\n", .{p1});
    std.debug.print("Part 2: {}\n", .{p2});
}

pub fn part1(input: []const u8) !u64 {
    var total: u64 = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');

    while (lines.next()) |line| {
        if (line.len < 2) continue;

        var best: u8 = 0;
        for (line, 0..) |_, i| {
            const tens = try std.fmt.charToDigit(line[i], 10);

            for (line[i + 1 ..]) |c| {
                const units = try std.fmt.charToDigit(c, 10);
                const value = tens * 10 + units;
                if (value > best) best = value;
            }
        }
        total += best;
    }
    return total;
}

pub fn part2(input: []const u8) !u64 {
    var sum: u64 = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const n: usize = line.len;
        var result: u64 = 0;
        var pos: usize = 0;
        var remaining: usize = 12;

        while (remaining > 0) : (remaining -= 1) {
            const farthest: usize = n - remaining;

            var best_digit: u8 = 0;
            var best_index: usize = pos;

            for (pos..farthest + 1) |i| {
                const d = try std.fmt.charToDigit(line[i], 10);
                if (d > best_digit) {
                    best_digit = d;
                    best_index = i;
                }
            }

            result = result * 10 + @as(u64, best_digit);
            pos = best_index + 1;
        }

        sum += result;
    }
    return sum;
}

test "day03 test" {
    const input = @embedFile("input/day03_test.txt");

    const p1 = try part1(input);
    const p2 = try part2(input);

    try std.testing.expectEqual(@as(u64, 357), p1);
    try std.testing.expectEqual(@as(u64, 3121910778619), p2);
}
