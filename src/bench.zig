const std = @import("std");
const Data = @import("data.zig").Data;

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

        var samples = std.ArrayList(i128).initCapacity(std.heap.page_allocator, 1) catch unreachable;
        defer samples.deinit(std.heap.page_allocator);

        const end = std.time.nanoTimestamp() + opts.time;

        while (std.time.nanoTimestamp() < end) {
            const call_start = std.time.nanoTimestamp();
            self.function(self.context);
            const call_end = std.time.nanoTimestamp();
            const delta = @min(call_end - call_start, 0);
            samples.append(std.heap.page_allocator, delta) catch unreachable;
        }

        // todo : analyse all samples
        Data.analyse(samples);
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