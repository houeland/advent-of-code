const std = @import("std");
const parseInt = std.fmt.parseInt;

fn readStdin(allocator: std.mem.Allocator) ![]u8 {
    const stdin = std.io.getStdIn();
    const data = try stdin.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    return data;
}

fn splitLines(input: []u8, allocator: std.mem.Allocator) !std.ArrayList([]const u8) {
    var lines = std.ArrayList([]const u8).init(allocator);
    var iter = std.mem.splitScalar(u8, input, '\n');
    while (iter.next()) |line| {
        try lines.append(line);
    }
    return lines;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        switch (gpa.deinit()) {
            std.heap.Check.ok => {},
            std.heap.Check.leak => {
                std.debug.print("Memory leak detected!\n", .{});
            },
        }
    }

    const bytes = try readStdin(allocator);
    defer allocator.free(bytes);

    const lines = try splitLines(bytes, allocator);
    defer lines.deinit();

    const stdout = std.io.getStdOut().writer();

    var as = std.ArrayList(i64).init(allocator);
    defer as.deinit();
    var bs = std.ArrayList(i64).init(allocator);
    defer bs.deinit();

    for (lines.items) |line| {
        if (line.len == 0) continue;

        var parts = std.mem.tokenize(u8, line, " ");
        const a = try std.fmt.parseInt(i64, parts.next().?, 10);
        const b = try std.fmt.parseInt(i64, parts.next().?, 10);

        try stdout.print("a: {d}, b: {d}\n", .{ a, b });
        try as.append(a);
        try bs.append(b);
    }

    std.mem.sort(i64, as.items, {}, comptime std.sort.asc(i64));
    std.mem.sort(i64, bs.items, {}, comptime std.sort.asc(i64));

    std.debug.print("Sorted a's: {any}\n", .{as.items});
    std.debug.print("Sorted b's: {any}\n", .{bs.items});

    var map = std.AutoHashMap(i64, i64).init(allocator);
    defer map.deinit();

    for (bs.items) |b| {
        const entry = try map.getOrPutValue(b, 0);
        entry.value_ptr.* += 1;
    }

    var total_1: u64 = 0;
    var total_2: i64 = 0;
    for (as.items, bs.items) |a, b| {
        const diff = @abs(a - b);
        const mult = map.get(a) orelse 0;

        total_1 += diff;
        total_2 += a * mult;
        std.debug.print("a={} b={} diff={} mult={} total_1={} total_2={}\n", .{ a, b, diff, mult, total_1, total_2 });
    }

    std.debug.print("PART 1 TOTAL: {any}\n", .{total_1});
    std.debug.print("PART 2 TOTAL: {any}\n", .{total_2});
}
