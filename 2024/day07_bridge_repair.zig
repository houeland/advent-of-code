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
        if (line.len == 0) continue;
        try lines.append(line);
    }
    return lines;
}

const Equation = struct {
    testValue: i64,
    numbers: std.ArrayList(i64),
};

const Input = struct {
    const Self = @This();
    equations: std.ArrayList(Equation),
    pub fn deinit(self: Self) void {
        for (self.equations.items) |equation| {
            equation.numbers.deinit();
        }
        self.equations.deinit();
    }
};

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var equations = std.ArrayList(Equation).init(allocator);
    for (lines) |line| {
        var parts = std.mem.tokenizeSequence(u8, line, ": ");
        const testValue = try parseInt(i64, parts.next().?, 10);
        var values = std.mem.tokenizeScalar(u8, parts.next().?, ' ');
        var numbers = std.ArrayList(i64).init(allocator);
        while (values.next()) |number| {
            const n = try parseInt(i64, number, 10);
            try numbers.append(n);
        }
        try equations.append(Equation{ .testValue = testValue, .numbers = numbers });
    }
    return Input{ .equations = equations };
}

const Part = enum {
    part1,
    part2,
};

fn concat(l: i64, r: i64, allocator: std.mem.Allocator) !i64 {
    _ = allocator;
    // const combined = try std.fmt.allocPrint(allocator, "{}{}", .{ l, r });
    // defer allocator.free(combined);
    // return try parseInt(i64, combined, 10);
    var mult: i64 = 1;
    while (mult <= r) mult *= 10;
    return l * mult + r;
}

fn solve(equation: Equation, allocator: std.mem.Allocator, part: Part) !i64 {
    std.debug.print("{}: {any}\n", .{ equation.testValue, equation.numbers.items });
    var values = std.AutoHashMap(i64, void).init(allocator);
    defer values.deinit();
    try values.put(0, {});
    for (equation.numbers.items) |number| {
        // std.debug.print("... number={}\n", .{number});
        var newValues = std.AutoHashMap(i64, void).init(allocator);
        defer newValues.deinit();
        var keys = values.keyIterator();
        while (keys.next()) |value| {
            // std.debug.print("value={} number={}\n", .{ value.*, number });
            if (value.* > equation.testValue) continue;
            try newValues.put(value.* + number, {});
            try newValues.put(value.* * number, {});
            if (part == .part2) {
                try newValues.put(try concat(value.*, number, allocator), {});
            }
        }
        std.mem.swap(std.AutoHashMap(i64, void), &values, &newValues);
    }
    if (values.get(equation.testValue) != null) {
        return equation.testValue;
    } else {
        return 0;
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const bytes = try readStdin(allocator);
    defer allocator.free(bytes);

    const lines = try splitLines(bytes, allocator);
    defer lines.deinit();

    const input = try parseInput(lines.items, allocator);
    defer input.deinit();

    var sumTestValues: i64 = 0;
    for (input.equations.items) |equation| {
        sumTestValues += try solve(equation, allocator, .part1);
    }
    var sumConcatTestValues: i64 = 0;
    for (input.equations.items) |equation| {
        sumConcatTestValues += try solve(equation, allocator, .part2);
    }
    std.debug.print("PART 1 TEST VALUES SUM: {}\n", .{sumTestValues});
    std.debug.print("PART 2 CONCAT TEST VALUES SUM: {}\n", .{sumConcatTestValues});
}
