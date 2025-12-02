const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "aoc2025",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    b.installArtifact(exe);

    inline for (1..13) |day| {
        const day_str = comptime std.fmt.comptimePrint("day{:0>2}", .{day});
        const src_path = comptime std.fmt.comptimePrint("src/days/{s}.zig", .{day_str});

        const day_exe = b.addExecutable(.{
            .name = day_str,
            .root_module = b.createModule(.{
                .root_source_file = b.path(src_path),
                .target = target,
                .optimize = optimize,
            }),
        });

        const install_step = b.addInstallArtifact(day_exe, .{});

        const build_step = b.step(day_str, comptime std.fmt.comptimePrint("Build {s}", .{day_str}));
        build_step.dependOn(&install_step.step);
    }
}
