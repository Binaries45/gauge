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

    std.debug.print("{d} | {d} | {d}", .{min, avg, max});
}