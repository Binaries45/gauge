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
    _ = samples;
    // todo : this
}