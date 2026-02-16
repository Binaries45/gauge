const std = @import("std");
const gauge = @import("gauge");

pub fn fib(n: u64) u64 {
    if (n < 2) return n;
    var a: u64 = 0;
    var b: u64 = 1;
    for (2..n + 1) |_| {
        const next = a +% b;
        a = b;
        b = next;
    }
    return b;
}

pub fn main() !void {
    const bench_fibonacci = gauge.bench("fib(100)", fib, .{52});
    bench_fibonacci.run(.{});
}