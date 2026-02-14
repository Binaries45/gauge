const std = @import("std");

pub const Options = struct {
    /// the time (in nanoseconds) that this benchmark will run. Defaults to 5 seconds
    time: u64 = 5e9,
};

pub const Bench = struct {
    name: []const u8,
    function: *const fn(*const anyopaque) void,
    context: *const anyopaque,

    pub fn run(self: *const Bench, opts: Options) void {
        std.debug.print("Running benchmark : {s}\n", .{self.name});
        const start = std.time.nanoTimestamp();
        var iterations: u64 = 0;

        // todo : save individual times so that we can plot them later
        while (std.time.nanoTimestamp() - start < opts.time) {
            self.function(self.context);
            iterations += 1;
        }

        const elapsed = std.time.nanoTimestamp() - start;

        std.debug.print(
            "Ran {d} iterations in {d} ns ({d:.2} ns/op)\n",
            .{
                iterations,
                elapsed,
                @divTrunc(elapsed, @as(i128, @max(iterations, 1))),
            },
        );
    }
};

/// construct a new benchmark from a function and some args
pub fn bench(name: []const u8, comptime func: anytype, args: anytype) Bench {
    const Wrapper = struct {
        fn call(ctx: *const anyopaque) void {
            const typed: *const @TypeOf(args) = @ptrCast(@alignCast(ctx));
            _ = @call(.auto, func, typed.*);
        }
    };

    return .{
        .name = name,
        .function = Wrapper.call,
        .context = &args,
    };
}