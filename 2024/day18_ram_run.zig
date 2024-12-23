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

const Input = struct {
    const Self = @This();
    width: i64,
    height: i64,
    positions: std.ArrayList(Point),
    numBytes: i64,
    pub fn deinit(self: *Self) void {
        self.positions.deinit();
    }
};

const ParseError = error{InvalidInput};
const SolveError = error{ UnhandledCase, CalculationError };

const Point = struct {
    x: i64,
    y: i64,
    pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        return writer.print("({},{})", .{ value.x, value.y });
    }
};

fn parsePosition(line: []const u8) !Point {
    var iter = std.mem.tokenizeScalar(u8, line, ',');
    const x = try std.fmt.parseInt(i64, iter.next().?, 10);
    const y = try std.fmt.parseInt(i64, iter.next().?, 10);
    return Point{ .x = x, .y = y };
}

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var positions = std.ArrayList(Point).init(allocator);
    for (lines) |line| {
        if (line.len == 0) continue;
        const p = try parsePosition(line);
        try positions.append(p);
    }
    if (lines.len == 26) {
        return Input{
            .width = 7,
            .height = 7,
            .positions = positions,
            .numBytes = 12,
        };
    } else {
        return Input{
            .width = 71,
            .height = 71,
            .positions = positions,
            .numBytes = 1024,
        };
    }
}

const Part = enum {
    part1,
    part2,
};

const Position = struct {
    point: Point,
    distance: i64,
};

fn lessThan(context: void, a: Position, b: Position) std.math.Order {
    _ = context;
    return std.math.order(a.distance, b.distance);
}

const steps: []const Point = &[_]Point{
    Point{ .x = 1, .y = 0 },
    Point{ .x = -1, .y = 0 },
    Point{ .x = 0, .y = 1 },
    Point{ .x = 0, .y = -1 },
};

fn canMove(input: Input, corrupted: std.AutoHashMap(Point, void), p: Point) bool {
    if (p.x >= 0 and p.x < input.width and p.y >= 0 and p.y < input.height) {
        return !corrupted.contains(p);
    } else {
        return false;
    }
}

fn solve(input: Input, allocator: std.mem.Allocator, part: Part) !?i64 {
    var seen = std.AutoHashMap(Point, i64).init(allocator);
    defer seen.deinit();
    var q = std.PriorityQueue(Position, void, lessThan).init(allocator, {});
    defer q.deinit();
    var corrupted = std.AutoHashMap(Point, void).init(allocator);
    defer corrupted.deinit();
    for (0.., input.positions.items) |idx, p| {
        if (idx > input.numBytes) break;
        try corrupted.put(p, {});
    }
    try q.add(Position{
        .point = Point{ .x = 0, .y = 0 },
        .distance = 0,
    });
    while (q.removeOrNull()) |pos| {
        if (seen.contains(pos.point)) continue;
        try seen.put(pos.point, pos.distance);
        // std.debug.print("best: {} = {}\n", .{ pos.point, pos.distance });
        for (steps) |s| {
            const next = Point{ .x = pos.point.x + s.x, .y = pos.point.y + s.y };
            if (canMove(input, corrupted, next)) {
                try q.add(Position{
                    .point = next,
                    .distance = pos.distance + 1,
                });
            }
        }
    }
    const target = Point{ .x = input.width - 1, .y = input.height - 1 };
    _ = part;
    return seen.get(target);
}

fn findFirstBlocking(input: Input, allocator: std.mem.Allocator) !Point {
    for (0..input.positions.items.len) |numBytes| {
        const isOk = try solve(Input{
            .width = input.width,
            .height = input.height,
            .positions = input.positions,
            .numBytes = @intCast(numBytes),
        }, allocator, .part2);
        if (isOk == null) {
            return input.positions.items[numBytes];
        }
    }
    return SolveError.CalculationError;
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

    const minSteps = (try solve(input, allocator, .part1)).?;
    const firstBlockingByte = try findFirstBlocking(input, allocator);

    std.debug.print("PART 1 MINIMUM STEPS: {}\n", .{minSteps});
    std.debug.print("PART 2 FIRST BLOCKING BYTE: {}\n", .{firstBlockingByte});
}
