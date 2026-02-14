const std = @import("std");
const gauge = @import("gauge");

pub fn fact(n: u64) u64 {
    if (n <= 1) return 1;
    return n *% fact(n - 1);
}

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
    const bench1 = gauge.bench("100!", fact, .{100});
    bench1.run(.{});

    const bench2 = gauge.bench("fib(100)", fib, .{100});
    bench2.run(.{});
}