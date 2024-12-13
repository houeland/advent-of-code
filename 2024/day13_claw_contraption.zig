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

const Point = struct {
    x: i64,
    y: i64,
    pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        return writer.print("({},{})", .{ value.x, value.y });
    }
};

const Machine = struct {
    prize: Point,
    dA: Point,
    dB: Point,
};

const Input = struct {
    const Self = @This();
    machines: std.ArrayList(Machine),
    pub fn deinit(self: Self) void {
        self.machines.deinit();
    }
};

const ParseError = error{InvalidInput};
const SolveError = error{ UnhandledCase, CalculationError };

fn consume(str: []const u8, expected: []const u8) ParseError!void {
    if (!std.mem.eql(u8, str, expected)) {
        return ParseError.InvalidInput;
    }
}

fn parseDir(str: []const u8, label: u8, delim: u8) !i64 {
    var iter = std.mem.tokenizeScalar(u8, str, delim);
    try consume(iter.next().?, &[_]u8{label});
    const val = try parseInt(i64, iter.next().?, 10);
    return val;
}

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var machines = std.ArrayList(Machine).init(allocator);
    var dA: Point = undefined;
    var dB: Point = undefined;
    for (0.., lines) |y, line| {
        std.debug.print("Processing line: {s} mod={}\n", .{ line, @mod(y, 4) });
        switch (@mod(y, 4)) {
            0 => {
                var iter = std.mem.tokenizeAny(u8, line, ": ,");
                try consume(iter.next().?, "Button");
                try consume(iter.next().?, "A");
                const X = try parseDir(iter.next().?, 'X', '+');
                const Y = try parseDir(iter.next().?, 'Y', '+');
                std.debug.print("Button A {} {}\n", .{ X, Y });
                dA = Point{ .x = X, .y = Y };
            },
            1 => {
                var iter = std.mem.tokenizeAny(u8, line, ": ,");
                try consume(iter.next().?, "Button");
                try consume(iter.next().?, "B");
                const X = try parseDir(iter.next().?, 'X', '+');
                const Y = try parseDir(iter.next().?, 'Y', '+');
                std.debug.print("Button B {} {}\n", .{ X, Y });
                dB = Point{ .x = X, .y = Y };
            },
            2 => {
                var iter = std.mem.tokenizeAny(u8, line, ": ,");
                try consume(iter.next().?, "Prize");
                const X = try parseDir(iter.next().?, 'X', '=');
                const Y = try parseDir(iter.next().?, 'Y', '=');
                std.debug.print("Prize {} {}\n", .{ X, Y });
                const prize = Point{ .x = X, .y = Y };
                const machine = Machine{ .prize = prize, .dA = dA, .dB = dB };
                try machines.append(machine);
            },
            3 => {
                if (line.len != 0) return ParseError.InvalidInput;
                dA = undefined;
                dB = undefined;
            },
            else => unreachable,
        }
    }
    return Input{ .machines = machines };
}

const Part = enum {
    part1,
    part2,
};

fn debugEm(a: f128, b: f128, dAx: f128, dAy: f128, dBx: f128, dBy: f128, Px: f128, Py: f128) void {
    //   a * dAx + b * dBx = Px
    //   a * dAy + b * dBy = Py
    std.debug.print("a:{} * dAx:{} + b:{} * dBx:{} = Px:{}\n", .{ a, dAx, b, dBx, Px });
    std.debug.print("{} = {}\n", .{ a * dAx + b * dBx, Px });
    std.debug.print("a:{} * dAy:{} + b:{} * dBy:{} = Py:{}\n", .{ a, dAy, b, dBy, Py });
    std.debug.print("{} = {}\n", .{ a * dAy + b * dBy, Py });

    //   a = (Px - b * dBx) / dAx
    //   (Px - b * dBx) / dAx * dAy + b * dBy = Py
    std.debug.print("a:{} = (Px:{} - b:{} * dBx:{}) / dAx:{}\n", .{ a, Px, b, dBx, dAx });
    std.debug.print("{} = {}\n", .{ (Px - b * dBx) / dAx, a });
    std.debug.print("(Py:{} - b:{} * dBy:{}) / dAy:{} = Py:{}\n", .{ Py, b, dBy, dAy, Py });
    std.debug.print("{} = {}\n", .{ (Py - b * dBy) / dAy, a });

    //   b*dBy - b*dBx/dAx*dAy = Py - Px/dAx * dAy
    std.debug.print("b:{} * dBy:{} - b:{} * dBx:{} / dAx:{} * dAy:{} = Py:{} - Px:{} / dAx:{} * dAy:{}\n", .{ b, dBy, b, dBx, dAx, dAy, Py, Px, dAx, dAy });
    std.debug.print("{} = {}\n", .{ b * dBy - b * dBx / dAx * dAy, Py - Px / dAx * dAy });

    //   b*[dBy - dBx/dAx*dAy] = Py - Px/dAx * dAy
    std.debug.print("b:{} * [dBy:{} - dBx:{} / dAx:{} * dAy:{}] = Py:{} - Px:{} / dAx:{} * dAy:{}\n", .{ b, dBy, dBx, dAx, dAy, Py, Px, dAx, dAy });
    std.debug.print("{} = {}\n", .{ b * (dBy - dBx / dAx * dAy), Py - Px / dAx * dAy });

    //   b = (Py - Px/dAx*dAy) / [dBy - dBx/dAx * dAy]
    std.debug.print("b:{} = (Py:{} - Px:{} / dAx:{} * dAy:{}) / [dBy:{} - dBx:{} / dAx:{} * dAy:{}]\n", .{ b, Py, Px, dAx, dAy, dBy, dBx, dAx, dAy });
    std.debug.print("{} = {}\n", .{ (Py - Px / dAx * dAy) / (dBy - dBx / dAx * dAy), b });

    //   b = (Py - Px/dAx*dAy) / [dBy * dAx/dAx - dBx*dAy/dAx]
    std.debug.print("b:{} = (Py:{} - Px:{} / dAx:{} * dAy:{}) / [dBy:{} * dAx:{} / dAx:{} - dBx:{} * dAy:{} / dAx:{}]\n", .{ b, Py, Px, dAx, dAy, dBy, dAx, dAx, dBx, dAy, dAx });
    std.debug.print("{} = {}\n", .{ (Py - Px / dAx * dAy) / (dBy * dAx / dAx - dBx * dAy / dAx), b });

    //   b = (Py*dAx - Px*dAy) / [dBy * dAx - dBx*dAy]
    std.debug.print("b:{} = (Py:{} * dAx:{} - Px:{} * dAy:{}) / [dBy:{} * dAx:{} - dBx:{} * dAy:{}]\n", .{ b, Py, dAx, Px, dAy, dBy, dAx, dBx, dAy });
    std.debug.print("{} = {}\n", .{ (Py * dAx - Px * dAy) / (dBy * dAx - dBx * dAy), b });
}

fn solveDirect(input: *Input, allocator: std.mem.Allocator, part: Part) !i64 {
    var tokens: i64 = 0;
    for (input.machines.items) |machine| {
        var best: ?i64 = null;
        for (0..100) |a_| {
            const a: i64 = @intCast(a_);
            for (0..100) |b_| {
                const b: i64 = @intCast(b_);
                const p = Point{
                    .x = a * machine.dA.x + b * machine.dB.x,
                    .y = a * machine.dA.y + b * machine.dB.y,
                };
                if (p.x == machine.prize.x and p.y == machine.prize.y) {
                    const cost = a * 3 + b;
                    if (best == null or cost < best.?) {
                        std.debug.print("cost={} a={} b={}\n", .{ cost, a, b });
                        best = cost;
                        // const a_f: f128 = @floatFromInt(a);
                        // const b_f: f128 = @floatFromInt(b);
                        // const dAx: f128 = @floatFromInt(machine.dA.x);
                        // const dAy: f128 = @floatFromInt(machine.dA.y);
                        // const dBx: f128 = @floatFromInt(machine.dB.x);
                        // const dBy: f128 = @floatFromInt(machine.dB.y);
                        // const Px: f128 = @floatFromInt(machine.prize.x);
                        // const Py: f128 = @floatFromInt(machine.prize.y);
                        // debugEm(a_f, b_f, dAx, dAy, dBx, dBy, Px, Py);
                    }
                }
            }
        }
        std.debug.print("best: {any}\n", .{best});
        if (best != null) {
            tokens += best.?;
        }
    }
    _ = allocator;
    _ = part;
    return tokens;
}

fn solveLarge(input: *Input, allocator: std.mem.Allocator, part: Part, offset: i64) !i64 {
    // basis A, basis B
    // is point P on it?
    // should be unique unless {A,B} are multiples
    var tokens: i64 = 0;
    for (input.machines.items) |machine| {
        if (@mod(machine.dA.x, machine.dB.x) == 0 and @mod(machine.dA.y, machine.dB.y) == 0) {
            std.debug.print("SCARY machine: {any}\n", .{machine});
            return SolveError.UnhandledCase;
        } else if (@mod(machine.dB.x, machine.dA.x) == 0 and @mod(machine.dB.y, machine.dA.y) == 0) {
            std.debug.print("SCARY machine: {any}\n", .{machine});
            return SolveError.UnhandledCase;
        }
        const dAx = machine.dA.x;
        const dAy = machine.dA.y;
        const dBx = machine.dB.x;
        const dBy = machine.dB.y;
        const Px = machine.prize.x + offset;
        const Py = machine.prize.y + offset;

        // b = (Py*dAx - Px*dAy) / [dBy*dAx - dBx*dAy]

        const bTop = Py * dAx - Px * dAy;
        const bBottom = dBy * dAx - dBx * dAy;

        // std.debug.print("best: top={} bottom={}\n", .{ bTop, bBottom });
        const div = @divFloor(bTop, bBottom);
        const rem = @rem(bTop, bBottom);
        // std.debug.print("div={} rem={}\n", .{ div, rem });
        var best: ?i64 = null;
        if (rem == 0) {
            const b = div;
            // a = [Px - b * dBx] / dAx
            const a = @divExact(Px - b * dBx, dAx);
            const cost = a * 3 + b;
            best = cost;
        }
        std.debug.print("best: {any}\n", .{best});
        if (best != null) {
            tokens += best.?;
        }
    }
    _ = allocator;
    _ = part;
    return tokens;
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

    const fewestTokens = try solveDirect(&input, allocator, .part1);
    const fewestTokensLarge = try solveLarge(&input, allocator, .part2, 10000000000000);

    std.debug.print("PART 1 FEWEST TOKENS TO WIN ALL: {}\n", .{fewestTokens});
    std.debug.print("PART 2 FEWEST TOKENS TO WIN ALL WITH OFFSET: {}\n", .{fewestTokensLarge});
}
