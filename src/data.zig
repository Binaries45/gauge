const std = @import("std");

pub const Data = @This();

/// the maximum time taken for a single iteration
max_time: u64,
/// the minimum time taken for a single iteration
min_time: u64,
/// the average time take for a single iteration
avg_time: u64,

/// analyse timing samples, and compare against previous results if the exist
pub fn analyse(samples: std.ArrayList(i128)) void {
    var min: i128 = std.math.maxInt(i128);
    var max: i128 = 0;
    var avg: i128 = 0;

    for (samples.items) |sample| {
        min = @min(sample, min);
        max = @max(sample, max);
        // saturates at max value, might rework later.
        // but surely nobody's code would cause an overflow :)
        avg +|= sample;
    }
    avg = @divTrunc(avg, samples.items.len);
    fmtNanos(min);
    std.debug.print(" | ", .{});
    fmtNanos(avg);
    std.debug.print(" | ", .{});
    fmtNanos(max);
}

/// format some time in nanoseconds 
pub fn fmtNanos(n: i128) void {
    const float_n = @as(f64, @floatFromInt(n));
    switch (n) {
        0...999 => std.debug.print("{d}ns", .{n}),
        1000...999_999 => std.debug.print("{d:.2}{c}s", .{float_n / 1000, 230}),
        1_000_000...999_999_999 => std.debug.print("{d:.2}ms", .{float_n / 1_000_000}),
        else => std.debug.print("{d:.2}s", .{float_n / 1_000_000_000}),
    }
}

/// write data on the given benchmark to zig-out/benchmarks.zon
pub fn save(self: Data) !void {
    _ = self;
    return error.NotImplemented;
}