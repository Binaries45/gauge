const std = @import("std");
const gauge = @import("gauge");

fn calculate(a: u64, b: u64) u64 {
    return (a | b) ^ (a & b);
}

fn setup() struct {u64, u64} {
    return .{
        std.crypto.random.int(u64) % 1_000_000,
        std.crypto.random.int(u64) % 1_000_000,
    };
}

pub fn main() !void {
    std.debug.print("hello world", .{});
}

// you can run a benchmark in a test :)
test "calculate" {
    const bench_calculate = gauge.bench("name", calculate, setup);
    bench_calculate.run(.{.time = 5e9});
}