const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    const file = try std.fs.cwd().openFile("src/days/input/day02.txt", .{});
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

fn part1(input: []const u8) !u64 {
    var sum: u64 = 0;
    var iter = std.mem.splitScalar(u8, input, ',');

    while (iter.next()) |item| {
        const range = std.mem.trim(u8, item, " \t\r\n");
        const dash_pos = std.mem.indexOfScalar(u8, range, '-') orelse continue;

        const low = try std.fmt.parseInt(u64, range[0..dash_pos], 10);
        const high = try std.fmt.parseInt(u64, range[dash_pos + 1 ..], 10);

        var num: u64 = low;
        while (num <= high) : (num += 1) {
            var buf: [32]u8 = undefined;
            const num_str = try std.fmt.bufPrint(&buf, "{d}", .{num});

            const len = num_str.len;
            if (len % 2 != 0) {
                continue;
            }

            const mid = len / 2;
            const left = num_str[0..mid];
            const right = num_str[mid..];

            if (std.mem.eql(u8, left, right)) {
                sum += num;
            }
        }
    }

    return sum;
}

fn part2(input: []const u8) !u64 {
    var sum: u64 = 0;
    var iter = std.mem.splitScalar(u8, input, ',');

    while (iter.next()) |item| {
        const range = std.mem.trim(u8, item, " \t\r\n");
        const dash_pos = std.mem.indexOfScalar(u8, range, '-') orelse continue;

        const low = try std.fmt.parseInt(u64, range[0..dash_pos], 10);
        const high = try std.fmt.parseInt(u64, range[dash_pos + 1 ..], 10);

        var num: u64 = low;
        while (num <= high) : (num += 1) {
            var buf: [32]u8 = undefined;
            const s = try std.fmt.bufPrint(&buf, "{d}", .{num});
            const len = s.len;

            var unit_len: usize = 1;
            while (unit_len <= len / 2) : (unit_len += 1) {
                if (len % unit_len != 0) continue;
                const unit = s[0..unit_len];
                var is_repeating = true;
                var pos: usize = unit_len;
                while (pos < len) : (pos += unit_len) {
                    if (!std.mem.eql(u8, unit, s[pos .. pos + unit_len])) {
                        is_repeating = false;
                        break;
                    }
                }
                if (is_repeating) {
                    sum += num;
                    break;
                }
            }
        }
    }
    return sum;
}

test "day01 test" {
    const input = @embedFile("input/day02_test.txt");

    const p1 = try part1(input);
    const p2 = try part2(input);

    try std.testing.expectEqual(@as(u64, 1227775554), p1);
    try std.testing.expectEqual(@as(u64, 4174379265), p2);
}
