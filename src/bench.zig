const std = @import("std");
const Data = @import("data.zig").Data;

pub const Options = struct {
    /// the time (in nanoseconds) that this benchmark will run. Defaults to 5 seconds
    time: u64 = 5e9,
};

fn Bench(
    comptime Context: type,
    comptime F: type,
) type {
    return struct {
        name: []const u8,
        setup: *const fn() Context,
        function: F,

        const Self = @This();

        // todo : batch calls to help reduce outliers
        pub fn run(self: *const Self, opts: Options) void {
            std.debug.print("Running benchmark : {s}\n", .{self.name});

            // todo : warmup phase for a few seconds to decide on benchmarking methods

            var samples = std.ArrayList(i128).initCapacity(
                std.heap.page_allocator, 1
            ) catch unreachable;
            defer samples.deinit(std.heap.page_allocator);

            const end = std.time.nanoTimestamp() + opts.time;

            while (std.time.nanoTimestamp() < end) {
                const ctx = self.setup();

                const call_start = std.time.nanoTimestamp();
                _ = @call(.auto, self.function, ctx);
                const call_end = std.time.nanoTimestamp();

                const delta = @max(call_end - call_start, 0);
                samples.append(std.heap.page_allocator, delta) catch unreachable;
            }

            const data = Data.analyse(samples);
            data.display();
        }
    };
}

// fixme : maybe find a way to clean up this ugly ass signature
pub fn bench(
    name: []const u8,
    comptime bench_fn: anytype,
    comptime setup_fn: anytype,
) Bench(@typeInfo(@TypeOf(setup_fn)).@"fn".return_type.?, @TypeOf(bench_fn)) {
    const SetupType = @TypeOf(setup_fn);
    const Context = @typeInfo(SetupType).@"fn".return_type.?;

    return Bench(Context, @TypeOf(bench_fn)) {
        .name = name,
        .setup = setup_fn,
        .function = bench_fn,
    };
}