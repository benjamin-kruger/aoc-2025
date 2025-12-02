const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    // TODO: This filepath is relative to where the executable is run from
    // is there a more idiomatic choice here?
    const file = try std.fs.cwd().openFile("src/days/input/day01.txt", .{});
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

fn part1(input: []const u8) !i64 {
    var current_pos: i64 = 50;
    var counter: i64 = 0;

    var iter = std.mem.splitScalar(u8, input, '\n');

    while (iter.next()) |line| {
        if (line.len == 0 or line.len < 2) continue;

        const raw_move: i64 = try std.fmt.parseInt(i64, line[1..], 10);
        const move = if (line[0] == 'L') -raw_move else raw_move;

        const next_pos: i64 = @mod(move + current_pos, 100);

        if (next_pos == 0) counter += 1;

        current_pos = next_pos;
    }

    return counter;
}

fn part2(input: []const u8) !i64 {
    var current_pos: i64 = 50;
    var counter: i64 = 0;

    var iter = std.mem.splitScalar(u8, input, '\n');

    while (iter.next()) |line| {
        if (line.len == 0 or line.len < 2) continue;

        const raw_move = try std.fmt.parseInt(i64, line[1..], 10);
        counter += @divFloor(raw_move, 100);
        const remaining_move: i64 = @mod(raw_move, 100);

        switch (line[0]) {
            'L' => {
                const next_pos: i64 = current_pos - remaining_move;
                if (current_pos != 0 and next_pos <= 0) counter += 1;
                current_pos = @mod(next_pos, 100);
            },
            'R' => {
                const next_pos: i64 = current_pos + remaining_move;
                if (next_pos >= 100) counter += 1;
                current_pos = @mod(next_pos, 100);
            },
            else => unreachable,
        }
    }
    return counter;
}

test "day01 test" {
    // This is a bit sad - because of how I wrote build.zig, input/ must live under
    // the project root for each day (i.e. src/days/input/)
    const input = @embedFile("input/day01_test.txt");

    const p1 = try part1(input);
    const p2 = try part2(input);

    try std.testing.expectEqual(@as(i64, 3), p1);
    try std.testing.expectEqual(@as(i64, 6), p2);
}
