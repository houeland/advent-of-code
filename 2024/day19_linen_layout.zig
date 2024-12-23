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

fn consume(str: []const u8, expected: []const u8) ParseError!void {
    if (!std.mem.eql(u8, str, expected)) {
        return ParseError.InvalidInput;
    }
}

const Input = struct {
    const Self = @This();
    towels: std.ArrayList([]const u8),
    designs: std.ArrayList([]const u8),
    pub fn deinit(self: *Self) void {
        self.towels.deinit();
        self.designs.deinit();
    }
};

const ParseError = error{InvalidInput};
const SolveError = error{ UnhandledCase, CalculationError };

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var towels = std.ArrayList([]const u8).init(allocator);
    var designs = std.ArrayList([]const u8).init(allocator);
    for (0.., lines) |idx, line| {
        switch (idx) {
            0 => {
                var iter = std.mem.tokenizeSequence(u8, line, ", ");
                while (iter.next()) |towel| {
                    try towels.append(towel);
                }
            },
            1 => {
                try consume(line, "");
            },
            else => {
                if (line.len == 0) continue;
                try designs.append(line);
            },
        }
    }
    return Input{ .towels = towels, .designs = designs };
}

const Part = enum {
    part1,
    part2,
};

fn lessThan(context: void, a: i64, b: i64) std.math.Order {
    _ = context;
    return std.math.order(a, b);
}

fn solve(input: Input, allocator: std.mem.Allocator, part: Part) !i64 {
    var numPossible: i64 = 0;
    var numWays: i64 = 0;
    for (input.designs.items) |design| {
        var ways = std.AutoHashMap(i64, i64).init(allocator);
        defer ways.deinit();
        try ways.put(0, 1);
        for (0..design.len) |offset| {
            if (ways.get(@intCast(offset))) |inbound| {
                for (input.towels.items) |towel| {
                    const remaining: i64 = @intCast(design.len - offset);
                    if (towel.len <= remaining) {
                        const match = std.mem.eql(u8, design[@intCast(offset)..(@as(usize, @intCast(offset)) + towel.len)], towel);
                        if (match) {
                            const target: i64 = @intCast(offset + towel.len);
                            const entry = try ways.getOrPutValue(target, 0);
                            entry.value_ptr.* += inbound;
                        }
                    }
                }
            }
        }
        if (ways.get(@intCast(design.len))) |found| {
            std.debug.print("possible: {s} in {} ways\n", .{ design, found });
            numPossible += 1;
            numWays += found;
        } else {
            std.debug.print("impossible: {s}\n", .{design});
        }
    }
    return switch (part) {
        .part1 => numPossible,
        .part2 => numWays,
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const bytes = try readStdin(allocator);
    defer allocator.free(bytes);

    const lines = try splitLines(bytes, allocator);
    defer lines.deinit();

    var input = try parseInput(lines.items, allocator);
    defer input.deinit();

    const numPossible = try solve(input, allocator, .part1);
    const numWays = try solve(input, allocator, .part2);

    std.debug.print("PART 1 POSSIBLE DESIGNS: {}\n", .{numPossible});
    std.debug.print("PART 2 DIFFERENT WAYS: {}\n", .{numWays});
}
