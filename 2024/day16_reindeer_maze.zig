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

const Input = struct {
    const Self = @This();
    start: Point,
    end: Point,
    walls: std.AutoHashMap(Point, void),
    width: usize,
    height: usize,
    pub fn deinit(self: *Self) void {
        self.walls.deinit();
    }
};

const ParseError = error{InvalidInput};
const SolveError = error{ UnhandledCase, CalculationError };

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var walls = std.AutoHashMap(Point, void).init(allocator);
    var width: usize = 0;
    var height: usize = 0;
    var start: ?Point = null;
    var end: ?Point = null;
    for (0.., lines) |y, line| {
        height = @max(height, y + 1);
        for (0.., line) |x, c| {
            width = @max(width, x + 1);
            switch (c) {
                '#' => try walls.put(Point{ .x = @intCast(x), .y = @intCast(y) }, {}),
                'S' => start = Point{ .x = @intCast(x), .y = @intCast(y) },
                'E' => end = Point{ .x = @intCast(x), .y = @intCast(y) },
                '.' => {},
                else => unreachable,
            }
        }
    }
    return Input{
        .walls = walls,
        .start = start.?,
        .end = end.?,
        .width = width,
        .height = height,
    };
}

const Part = enum {
    part1,
    part2,
};

const Facing = enum {
    North,
    West,
    East,
    South,
};

const Position = struct {
    point: Point,
    facing: Facing,
};

const Entry = struct {
    position: Position,
    from: ?Position,
    score: i64,
};

fn lessThan(context: void, a: Entry, b: Entry) std.math.Order {
    _ = context;
    return std.math.order(a.score, b.score);
}

fn nextPosition(p: Position) Position {
    switch (p.facing) {
        .North => return Position{ .point = Point{ .x = p.point.x, .y = p.point.y - 1 }, .facing = p.facing },
        .West => return Position{ .point = Point{ .x = p.point.x - 1, .y = p.point.y }, .facing = p.facing },
        .East => return Position{ .point = Point{ .x = p.point.x + 1, .y = p.point.y }, .facing = p.facing },
        .South => return Position{ .point = Point{ .x = p.point.x, .y = p.point.y + 1 }, .facing = p.facing },
    }
}

fn afterTurnLeft(p: Position) Position {
    switch (p.facing) {
        .North => return Position{ .point = p.point, .facing = .West },
        .West => return Position{ .point = p.point, .facing = .South },
        .South => return Position{ .point = p.point, .facing = .East },
        .East => return Position{ .point = p.point, .facing = .North },
    }
}

const Seen = struct {
    score: i64,
    predecessors: std.AutoHashMap(?Position, void),
};

fn solve(input: Input, allocator: std.mem.Allocator, part: Part) !i64 {
    var seen = std.AutoHashMap(Position, Seen).init(allocator);
    defer {
        var iter = seen.valueIterator();
        while (iter.next()) |value| {
            value.predecessors.deinit();
        }
        seen.deinit();
    }
    var q = std.PriorityQueue(Entry, void, lessThan).init(allocator, {});
    defer q.deinit();
    try q.add(Entry{ .position = Position{ .point = input.start, .facing = .East }, .from = null, .score = 0 });
    var best: ?i64 = null;
    while (q.removeOrNull()) |entry| {
        var tracking = try seen.getOrPut(entry.position);
        if (tracking.found_existing) {
            if (entry.score < tracking.value_ptr.score) {
                unreachable;
            } else if (entry.score == tracking.value_ptr.score) {
                try tracking.value_ptr.predecessors.put(entry.from, {});
                continue;
            } else if (entry.score > tracking.value_ptr.score) {
                continue;
            } else {
                unreachable;
            }
        } else {
            tracking.value_ptr.* = Seen{ .score = entry.score, .predecessors = std.AutoHashMap(?Position, void).init(allocator) };
            try tracking.value_ptr.predecessors.put(entry.from, {});
        }
        // std.debug.print("check: {any}\n", .{entry});
        if (entry.position.point.x == input.end.x and entry.position.point.y == input.end.y and best == null) {
            best = entry.score;
        }
        const moveForward = Entry{
            .position = nextPosition(entry.position),
            .from = entry.position,
            .score = entry.score + 1,
        };
        if (!input.walls.contains(moveForward.position.point)) {
            try q.add(moveForward);
        }
        const turnLeft = Entry{
            .position = afterTurnLeft(entry.position),
            .from = entry.position,
            .score = entry.score + 1000,
        };
        try q.add(turnLeft);
        const turnRight = Entry{
            .position = afterTurnLeft(afterTurnLeft(afterTurnLeft(entry.position))),
            .from = entry.position,
            .score = entry.score + 1000,
        };
        try q.add(turnRight);
    }
    switch (part) {
        .part1 => return best.?,
        .part2 => {
            var visited = std.AutoHashMap(Point, void).init(allocator);
            defer visited.deinit();
            var rev = std.AutoHashMap(?Position, void).init(allocator);
            defer rev.deinit();
            inline for (std.meta.fields(Facing)) |f| {
                const pos = Position{ .point = input.end, .facing = @field(Facing, f.name) };
                if (seen.contains(pos)) {
                    try rev.put(pos, {});
                }
            }
            while (rev.count() > 0) {
                var ki = rev.keyIterator();
                const pp = ki.next().?.*;
                // std.debug.print("backtracking: {any}\n", .{pp});
                if (pp) |p| {
                    try visited.put(p.point, {});
                    var iter = seen.get(p).?.predecessors.keyIterator();
                    while (iter.next()) |k| {
                        // std.debug.print("  adding: {any}\n", .{k.*});
                        try rev.put(k.*, {});
                    }
                }
                if (!rev.remove(pp)) unreachable;
            }
            for (0..input.height) |y| {
                for (0..input.width) |x| {
                    const p = Point{ .x = @intCast(x), .y = @intCast(y) };
                    if (input.walls.contains(p)) {
                        std.debug.print("#", .{});
                    } else if (visited.contains(p)) {
                        std.debug.print("{}", .{seen.get(Position{ .point = p, .facing = .East }).?.predecessors.count()});
                    } else {
                        std.debug.print(".", .{});
                    }
                }
                std.debug.print("\n", .{});
            }
            return visited.count();
        },
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

    var input = try parseInput(lines.items, allocator);
    defer input.deinit();

    const lowestScore = try solve(input, allocator, .part1);
    const numBestTiles = try solve(input, allocator, .part2);

    std.debug.print("PART 1 LOWEST SCORE: {}\n", .{lowestScore});
    std.debug.print("PART 1 BEST TILE COUNT: {}\n", .{numBestTiles});
}
