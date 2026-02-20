const std = @import("std");

pub const Data = @This();

/// the minimum time taken for a single iteration
min_time: i128,
/// the average time take for a single iteration
avg_time: i128,
/// the maximum time taken for a single iteration
max_time: i128,

/// analyse timing samples, and compare against previous results if the exist
pub fn analyse(samples: std.ArrayList(i128)) Data {
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

    return .{
        .min_time = min,
        .avg_time = avg,
        .max_time = max,
    };
}

pub fn display(current: Data) void {
    fmtNanos(current.min_time);
    std.debug.print(" | ", .{});
    fmtNanos(current.avg_time);
    std.debug.print(" | ", .{});
    fmtNanos(current.max_time);
    std.debug.print("\n", .{});
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

