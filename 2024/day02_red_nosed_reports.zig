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

fn isSafe(report: []i64) bool {
    var allIncreasing = true;
    var allDecreasing = true;
    var safeDistance = true;
    for (1..report.len) |idx| {
        const prev = report[idx - 1];
        const curr = report[idx];
        if (curr > prev) {
            allDecreasing = false;
        } else {
            allIncreasing = false;
        }
        const diff = @abs(curr - prev);
        if ((diff < 1) or (diff > 3)) {
            safeDistance = false;
        }
    }
    const safe = (allIncreasing or allDecreasing) and safeDistance;
    return safe;
}

fn isDampenedSafe(report: []i64, allocator: std.mem.Allocator) !bool {
    if (isSafe(report)) {
        return true;
    }
    for (0..report.len) |skipIdx| {
        var adjusted = std.ArrayList(i64).init(allocator);
        defer adjusted.deinit();
        for (0..report.len) |idx| {
            if (idx != skipIdx) {
                try adjusted.append(report[idx]);
            }
        }
        if (isSafe(adjusted.items)) {
            return true;
        }
    }
    return false;
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

    var numSafeReports: i64 = 0;
    var numDampenedSafeReports: i64 = 0;
    for (lines.items) |line| {
        if (line.len == 0) continue;

        var nums = std.ArrayList(i64).init(allocator);
        defer nums.deinit();

        var parts = std.mem.tokenize(u8, line, " ");
        while (parts.next()) |part| {
            const num = try std.fmt.parseInt(i64, part, 10);
            try nums.append(num);
        }
        const safe = isSafe(nums.items);
        const dampenedSafe = try isDampenedSafe(nums.items, allocator);
        std.debug.print("{any}: safe={} dampenedSafe={}\n", .{ nums.items, safe, dampenedSafe });
        if (safe) {
            numSafeReports += 1;
        }
        if (dampenedSafe) {
            numDampenedSafeReports += 1;
        }
    }
    std.debug.print("PART 1 SAFE REPORT COUNT: {}\n", .{numSafeReports});
    std.debug.print("PART 2 DAMPENED SAFE REPORT COUNT: {}\n", .{numDampenedSafeReports});
}
