const std = @import("std");

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

const Point = struct {
    x: i64,
    y: i64,
    pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        return writer.print("({},{})", .{ value.x, value.y });
    }
};

const steps: []const Point = &[_]Point{
    Point{ .x = 1, .y = 0 },
    Point{ .x = -1, .y = 0 },
    Point{ .x = 0, .y = 1 },
    Point{ .x = 0, .y = -1 },
};

const ParseError = error{InvalidInput};
const SolveError = error{ UnhandledCase, CalculationError };

const Part = enum {
    part1,
    part2,
};

const Code = struct {
    const Self = @This();
    numbers: std.ArrayList(i64),
    value: i64,
    pub fn deinit(self: *Self) void {
        self.numbers.deinit();
    }
};

const Input = struct {
    const Self = @This();
    codes: std.ArrayList(Code),
    pub fn deinit(self: *Self) void {
        for (self.codes.items) |*code| {
            code.deinit();
        }
        self.codes.deinit();
    }
};

const aButtonValue = -1000;

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var codes = std.ArrayList(Code).init(allocator);
    for (lines) |line| {
        if (line.len == 0) continue;
        var code = std.ArrayList(i64).init(allocator);
        for (line) |c| {
            switch (c) {
                '0'...'9' => {
                    const value = try std.fmt.parseInt(i64, &[_]u8{c}, 10);
                    try code.append(value);
                },
                'A' => {
                    try code.append(aButtonValue);
                },
                else => return ParseError.InvalidInput,
            }
        }
        var value: i64 = 0;
        for (code.items) |v| {
            switch (v) {
                0...9 => {
                    value = value * 10 + v;
                },
                aButtonValue => {
                    continue;
                },
                else => return ParseError.InvalidInput,
            }
        }
        try codes.append(Code{ .numbers = code, .value = value });
    }
    return Input{ .codes = codes };
}

const Position = struct {
    numericPanel: Point,
    secondPanel: Point,
    thirdPanel: Point,
    done: i64,
    cost: i64,
};

fn lessThan(context: void, a: Position, b: Position) std.math.Order {
    _ = context;
    if (a.done != b.done) {
        return std.math.order(b.done, a.done);
    } else {
        return std.math.order(a.cost, b.cost);
    }
}

const DirectionalKeypadButton = enum {
    UP,
    DOWN,
    LEFT,
    RIGHT,
    A,
};

fn getDirectionalKeypadButton(p: Point) ?DirectionalKeypadButton {
    //     +---+---+
    //     | ^ | A |
    // +---+---+---+
    // | < | v | > |
    // +---+---+---+
    if (p.x == 1 and p.y == 0) return DirectionalKeypadButton.UP;
    if (p.x == 2 and p.y == 0) return DirectionalKeypadButton.A;
    if (p.x == 0 and p.y == 1) return DirectionalKeypadButton.LEFT;
    if (p.x == 1 and p.y == 1) return DirectionalKeypadButton.DOWN;
    if (p.x == 2 and p.y == 1) return DirectionalKeypadButton.RIGHT;
    return null;
}

fn getNumericKeypadButton(p: Point) ?i64 {
    // +---+---+---+
    // | 7 | 8 | 9 |
    // +---+---+---+
    // | 4 | 5 | 6 |
    // +---+---+---+
    // | 1 | 2 | 3 |
    // +---+---+---+
    //     | 0 | A |
    //     +---+---+
    if (p.x == 0 and p.y == 0) return 7;
    if (p.x == 1 and p.y == 0) return 8;
    if (p.x == 2 and p.y == 0) return 9;
    if (p.x == 0 and p.y == 1) return 4;
    if (p.x == 1 and p.y == 1) return 5;
    if (p.x == 2 and p.y == 1) return 6;
    if (p.x == 0 and p.y == 2) return 1;
    if (p.x == 1 and p.y == 2) return 2;
    if (p.x == 2 and p.y == 2) return 3;
    if (p.x == 1 and p.y == 3) return 0;
    if (p.x == 2 and p.y == 3) return aButtonValue;
    return null;
}

fn dxdyFromButton(button: DirectionalKeypadButton) Point {
    switch (button) {
        .UP => return Point{ .x = 0, .y = -1 },
        .DOWN => return Point{ .x = 0, .y = 1 },
        .LEFT => return Point{ .x = -1, .y = 0 },
        .RIGHT => return Point{ .x = 1, .y = 0 },
        .A => unreachable,
    }
}

fn actuateNumericPanel(code: []i64, p: Position) ?Position {
    const button = getNumericKeypadButton(p.numericPanel).?;
    const expected = code[@intCast(p.done)];
    // std.debug.print("actuateNumericPanel button={} expected={} pos={any}\n", .{ button, expected, p });
    if (button == expected) {
        return Position{
            .numericPanel = p.numericPanel,
            .secondPanel = p.secondPanel,
            .thirdPanel = p.thirdPanel,
            .done = p.done + 1,
            .cost = p.cost + 1,
        };
    } else {
        return null;
    }
}

fn actuateSecondPanel(code: []i64, p: Position) ?Position {
    const button = getDirectionalKeypadButton(p.secondPanel).?;
    switch (button) {
        .A => return actuateNumericPanel(code, p),
        else => {
            const dxdy = dxdyFromButton(button);
            const newP = Point{ .x = p.numericPanel.x + dxdy.x, .y = p.numericPanel.y + dxdy.y };
            if (getNumericKeypadButton(newP) != null) {
                return Position{
                    .numericPanel = newP,
                    .secondPanel = p.secondPanel,
                    .thirdPanel = p.thirdPanel,
                    .done = p.done,
                    .cost = p.cost + 1,
                };
            } else {
                return null;
            }
        },
    }
}

fn actuateThirdPanel(code: []i64, p: Position) ?Position {
    const button = getDirectionalKeypadButton(p.thirdPanel).?;
    switch (button) {
        .A => return actuateSecondPanel(code, p),
        else => {
            const dxdy = dxdyFromButton(button);
            const newP = Point{ .x = p.secondPanel.x + dxdy.x, .y = p.secondPanel.y + dxdy.y };
            if (getDirectionalKeypadButton(newP) != null) {
                return Position{
                    .numericPanel = p.numericPanel,
                    .secondPanel = newP,
                    .thirdPanel = p.thirdPanel,
                    .done = p.done,
                    .cost = p.cost + 1,
                };
            } else {
                return null;
            }
        },
    }
}

fn solveCode(code: Code, allocator: std.mem.Allocator) !i64 {
    var seen = std.AutoHashMap(Position, void).init(allocator);
    defer seen.deinit();
    var q = std.PriorityQueue(Position, void, lessThan).init(allocator, {});
    defer q.deinit();
    try q.add(Position{
        .numericPanel = Point{ .x = 2, .y = 3 },
        .secondPanel = Point{ .x = 2, .y = 0 },
        .thirdPanel = Point{ .x = 2, .y = 0 },
        .done = 0,
        .cost = 0,
    });
    while (q.removeOrNull()) |pos| {
        if (pos.done == code.numbers.items.len) {
            return pos.cost;
        }
        if (seen.contains(pos)) continue;
        try seen.put(pos, {});
        // std.debug.print("code={any} done={} numPos={}\n", .{ code, pos.done, q.count() });
        for (steps) |s| {
            const newP = Point{ .x = pos.thirdPanel.x + s.x, .y = pos.thirdPanel.y + s.y };
            if (getDirectionalKeypadButton(newP) != null) {
                try q.add(Position{
                    .numericPanel = pos.numericPanel,
                    .secondPanel = pos.secondPanel,
                    .thirdPanel = newP,
                    .done = pos.done,
                    .cost = pos.cost + 1,
                });
            }
            if (actuateThirdPanel(code.numbers.items, pos)) |a| {
                try q.add(a);
            }
        }
    }
    return SolveError.CalculationError;
}

fn solve(input: Input, allocator: std.mem.Allocator, part: Part) !i64 {
    _ = part;
    var sumComplexities: i64 = 0;
    for (input.codes.items) |code| {
        const cost = try solveCode(code, allocator);
        const complexity = cost * code.value;
        std.debug.print("code={any} cost={} numeric={} complexity={}\n", .{ code.numbers.items, cost, code.value, complexity });
        sumComplexities += complexity;
    }
    return sumComplexities;
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

    const sumComplexities = try solve(input, allocator, .part1);

    std.debug.print("PART 1 SUM OF COMPLEXITIES: {}\n", .{sumComplexities});
}
