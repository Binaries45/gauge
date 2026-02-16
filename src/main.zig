const std = @import("std");
const gauge = @import("gauge");

/// returns the nth fibonacci number
fn fib(n: u64) u64 {
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

fn fib_setup() u64 {
    // return random u64 between 0 and 100
    return std.crypto.random.int(u64) % 100;
}

pub fn main() !void {
    const bench_fibonacci = gauge.bench("nth fibonacci number", fib, fib_setup);
    bench_fibonacci.run(.{.time = 5e9});
}