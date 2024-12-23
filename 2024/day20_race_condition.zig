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

const Input = struct {
    const Self = @This();
    width: i64,
    height: i64,
    walls: std.AutoHashMap(Point, void),
    start: Point,
    end: Point,
    pub fn deinit(self: *Self) void {
        self.walls.deinit();
    }
};

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var start: ?Point = null;
    var end: ?Point = null;
    var walls = std.AutoHashMap(Point, void).init(allocator);
    for (0.., lines) |y, line| {
        for (0.., line) |x, c| {
            const p = Point{ .x = @intCast(x), .y = @intCast(y) };
            switch (c) {
                'S' => start = p,
                'E' => end = p,
                '#' => try walls.put(p, {}),
                '.' => {},
                else => return ParseError.InvalidInput,
            }
        }
    }
    return Input{ .width = @intCast(lines[0].len), .height = @intCast(lines.len), .walls = walls, .start = start.?, .end = end.? };
}

const Position = struct {
    point: Point,
    cost: i64,
};

fn lessThan(context: void, a: Position, b: Position) std.math.Order {
    _ = context;
    return std.math.order(a.cost, b.cost);
}

fn isWithinBounds(input: Input, p: Point) bool {
    return (p.x >= 0 and p.x < input.width and p.y >= 0 and p.y < input.height);
}

fn buildDistanceMap(input: Input, start: Point, allocator: std.mem.Allocator) !std.AutoHashMap(Point, i64) {
    var cost = std.AutoHashMap(Point, i64).init(allocator);
    var q = std.PriorityQueue(Position, void, lessThan).init(allocator, {});
    defer q.deinit();
    try q.add(Position{ .point = start, .cost = 0 });
    while (q.removeOrNull()) |pos| {
        if (cost.contains(pos.point)) continue;
        try cost.put(pos.point, pos.cost);
        for (steps) |s| {
            const p = Point{ .x = pos.point.x + s.x, .y = pos.point.y + s.y };
            if (isWithinBounds(input, p) and !input.walls.contains(p)) {
                try q.add(Position{ .point = p, .cost = pos.cost + 1 });
            }
        }
    }
    return cost;
}

fn solve(input: Input, allocator: std.mem.Allocator, part: Part) !i64 {
    const maxDist: i64 = switch (part) {
        .part1 => 2,
        .part2 => 20,
    };
    var costTo = try buildDistanceMap(input, input.start, allocator);
    defer costTo.deinit();
    var costFrom = try buildDistanceMap(input, input.end, allocator);
    defer costFrom.deinit();
    const best = costFrom.get(input.start).?;
    std.debug.print("S-E distance: {}\n", .{best});
    var saving100: i64 = 0;
    var countSaves = std.AutoArrayHashMap(i64, i64).init(allocator);
    defer countSaves.deinit();
    for (0..@intCast(input.height)) |sy| {
        for (0..@intCast(input.width)) |sx| {
            const start = Point{ .x = @intCast(sx), .y = @intCast(sy) };
            for (0..@intCast(input.height)) |ey| {
                for (0..@intCast(input.width)) |ex| {
                    const end = Point{ .x = @intCast(ex), .y = @intCast(ey) };
                    const dist: i64 = @intCast(@abs(end.x - start.x) + @abs(end.y - start.y));
                    if (dist <= maxDist and isWithinBounds(input, end) and !input.walls.contains(end)) {
                        if (costTo.get(start)) |c1| {
                            if (costFrom.get(end)) |c2| {
                                const cost = c1 + c2 + dist;
                                if (cost < best) {
                                    const save = best - cost;
                                    const cnt = try countSaves.getOrPutValue(save, 0);
                                    cnt.value_ptr.* += 1;
                                    // std.debug.print("save {}\n", .{save});
                                    if (save >= 100) {
                                        saving100 += 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    var iter = countSaves.iterator();
    while (iter.next()) |entry| {
        std.debug.print("saving {}: {}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    }
    return saving100;
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

    const num2Cheats = try solve(input, allocator, .part1);
    const num20Cheats = try solve(input, allocator, .part2);

    std.debug.print("PART 1 2-CHEATS SAVING 100+: {}\n", .{num2Cheats});
    std.debug.print("PART 1 20-CHEATS SAVING 100+: {}\n", .{num20Cheats});
}
