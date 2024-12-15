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

const Move = enum {
    Up,
    Down,
    Left,
    Right,
};

const Input = struct {
    const Self = @This();
    boxes: std.AutoHashMap(Point, void),
    walls: std.AutoHashMap(Point, void),
    robot: Point,
    moves: std.ArrayList(Move),
    width: usize,
    height: usize,
    pub fn deinit(self: *Self) void {
        self.boxes.deinit();
        self.walls.deinit();
        self.moves.deinit();
    }
};

const ParseError = error{InvalidInput};
const SolveError = error{ UnhandledCase, CalculationError };

fn consume(str: []const u8, expected: []const u8) ParseError!void {
    if (!std.mem.eql(u8, str, expected)) {
        return ParseError.InvalidInput;
    }
}

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var boxes = std.AutoHashMap(Point, void).init(allocator);
    var walls = std.AutoHashMap(Point, void).init(allocator);
    var robot: ?Point = null;
    var moves = std.ArrayList(Move).init(allocator);
    var parsingMap = true;
    var width: usize = 0;
    var height: usize = 0;
    for (0.., lines) |y, line| {
        if (parsingMap) {
            if (line.len == 0) {
                parsingMap = false;
                continue;
            }
            height = @max(height, y + 1);
            for (0.., line) |x, c| {
                width = @max(width, x + 1);
                // std.debug.print("parse map: {c}\n", .{c});
                switch (c) {
                    '#' => try walls.put(Point{ .x = @intCast(x), .y = @intCast(y) }, {}),
                    '@' => robot = Point{ .x = @intCast(x), .y = @intCast(y) },
                    'O' => try boxes.put(Point{ .x = @intCast(x), .y = @intCast(y) }, {}),
                    '.' => {},
                    else => unreachable,
                }
            }
        } else {
            for (line) |c| {
                // std.debug.print("parse move: {c}\n", .{c});
                switch (c) {
                    '^' => try moves.append(.Up),
                    'v' => try moves.append(.Down),
                    '<' => try moves.append(.Left),
                    '>' => try moves.append(.Right),
                    else => unreachable,
                }
            }
        }
    }
    return Input{
        .boxes = boxes,
        .walls = walls,
        .robot = robot.?,
        .moves = moves,
        .width = width,
        .height = height,
    };
}

const Part = enum {
    part1,
    part2,
};

fn printout(input: Input, doubleSized: bool) void {
    for (0..input.height) |yy| {
        const y: i64 = @intCast(yy);
        for (0..input.width) |xx| {
            const x: i64 = @intCast(xx);
            var c: u8 = undefined;
            if (input.robot.x == x and input.robot.y == y) {
                c = '@';
            } else if (input.walls.contains(Point{ .x = x, .y = y })) {
                c = '#';
            } else if (!doubleSized and input.boxes.contains(Point{ .x = x, .y = y })) {
                c = 'O';
            } else if (doubleSized and input.boxes.contains(Point{ .x = x, .y = y })) {
                c = '[';
            } else if (doubleSized and input.boxes.contains(Point{ .x = x - 1, .y = y })) {
                c = ']';
            } else {
                c = '.';
            }
            std.debug.print("{c}", .{c});
        }
        std.debug.print("\n", .{});
    }
}

const CanMove = enum {
    Ok,
    Blocked,
};

fn nextPoint(p: Point, m: Move) Point {
    switch (m) {
        Move.Up => return Point{ .x = p.x, .y = p.y - 1 },
        Move.Down => return Point{ .x = p.x, .y = p.y + 1 },
        Move.Left => return Point{ .x = p.x - 1, .y = p.y },
        Move.Right => return Point{ .x = p.x + 1, .y = p.y },
    }
}

fn moveToSingle(walls: std.AutoHashMap(Point, void), boxes: *std.AutoHashMap(Point, void), p: Point, m: Move) !CanMove {
    if (walls.contains(p)) {
        return CanMove.Blocked;
    } else if (boxes.contains(p)) {
        const nextP = nextPoint(p, m);
        const ok = try moveToSingle(walls, boxes, nextP, m);
        switch (ok) {
            CanMove.Blocked => return CanMove.Blocked,
            CanMove.Ok => {
                if (!boxes.remove(p)) return SolveError.CalculationError;
                try boxes.put(nextP, {});
                return CanMove.Ok;
            },
        }
    } else {
        return CanMove.Ok;
    }
}

fn solveSingle(input: Input, allocator: std.mem.Allocator, part: Part) !i64 {
    _ = allocator;
    _ = part;
    var boxes = try input.boxes.clone();
    defer boxes.deinit();
    var robot = input.robot;
    printout(input, false);
    for (input.moves.items) |m| {
        // std.debug.print("\nmove: {}\n", .{m});
        const nextP = nextPoint(robot, m);
        const ok = try moveToSingle(input.walls, &boxes, nextP, m);
        switch (ok) {
            CanMove.Blocked => {},
            CanMove.Ok => robot = nextP,
        }
        // printout(Input{
        //     .boxes = boxes,
        //     .walls = input.walls,
        //     .robot = robot,
        //     .moves = input.moves,
        //     .width = input.width,
        //     .height = input.height,
        // });
    }
    var sum: i64 = 0;
    var iter = boxes.keyIterator();
    while (iter.next()) |p| {
        const gps = p.y * 100 + p.x;
        sum += gps;
    }
    return sum;
}

fn moveDoubleBox(walls: std.AutoHashMap(Point, void), boxes: *std.AutoHashMap(Point, void), p: Point, m: Move) !CanMove {
    // std.debug.print("p={} m={}\n", .{ p, m });
    const nextP = nextPoint(p, m);
    const nextL = Point{ .x = nextP.x - 1, .y = nextP.y };
    const nextR = Point{ .x = nextP.x + 1, .y = nextP.y };
    if (walls.contains(nextP) or walls.contains(nextR)) return CanMove.Blocked;
    var ok = true;
    switch (m) {
        Move.Up, Move.Down => {
            if (boxes.contains(nextL)) {
                ok = ok and (try moveDoubleBox(walls, boxes, nextL, m) == CanMove.Ok);
            }
            if (boxes.contains(nextP)) {
                ok = ok and (try moveDoubleBox(walls, boxes, nextP, m) == CanMove.Ok);
            }
            if (boxes.contains(nextR)) {
                ok = ok and (try moveDoubleBox(walls, boxes, nextR, m) == CanMove.Ok);
            }
        },
        Move.Left => {
            if (boxes.contains(nextL)) {
                ok = ok and (try moveDoubleBox(walls, boxes, nextL, m) == CanMove.Ok);
            }
        },
        Move.Right => {
            if (boxes.contains(nextR)) {
                ok = ok and (try moveDoubleBox(walls, boxes, nextR, m) == CanMove.Ok);
            }
        },
    }
    if (ok) {
        if (!boxes.remove(p)) return SolveError.CalculationError;
        try boxes.put(nextP, {});
        return CanMove.Ok;
    } else {
        return CanMove.Blocked;
    }
}

fn solveDouble(input: Input, allocator: std.mem.Allocator, part: Part) !i64 {
    _ = part;
    var walls = std.AutoHashMap(Point, void).init(allocator);
    defer walls.deinit();
    var wIter = input.walls.keyIterator();
    while (wIter.next()) |p| {
        try walls.put(Point{ .x = p.x * 2 + 0, .y = p.y }, {});
        try walls.put(Point{ .x = p.x * 2 + 1, .y = p.y }, {});
    }
    var boxes = std.AutoHashMap(Point, void).init(allocator);
    var bIter = input.boxes.keyIterator();
    while (bIter.next()) |p| {
        try boxes.put(Point{ .x = p.x * 2 + 0, .y = p.y }, {});
    }
    defer boxes.deinit();
    var robot = Point{ .x = input.robot.x * 2 + 0, .y = input.robot.y };
    printout(Input{
        .boxes = boxes,
        .walls = walls,
        .robot = robot,
        .moves = input.moves,
        .width = input.width * 2,
        .height = input.height,
    }, true);
    for (input.moves.items) |m| {
        // std.debug.print("\nrobot={} move={}\n", .{ robot, m });
        const nextP = nextPoint(robot, m);
        var boxCopy = try boxes.clone();
        defer boxCopy.deinit();
        var ok = true;
        if (walls.contains(nextP)) {
            ok = false;
        }
        if (boxes.contains(nextP)) {
            const isOk = try moveDoubleBox(walls, &boxes, nextP, m);
            ok = ok and isOk == CanMove.Ok;
        }
        const nextL = Point{ .x = nextP.x - 1, .y = nextP.y };
        if (boxes.contains(nextL)) {
            const isOk = try moveDoubleBox(walls, &boxes, nextL, m);
            ok = ok and isOk == CanMove.Ok;
        }
        if (ok) {
            robot = nextP;
        } else {
            std.mem.swap(std.AutoHashMap(Point, void), &boxes, &boxCopy);
        }
        // printout(Input{
        //     .boxes = boxes,
        //     .walls = walls,
        //     .robot = robot,
        //     .moves = input.moves,
        //     .width = input.width * 2,
        //     .height = input.height,
        // }, true);
    }
    var sum: i64 = 0;
    var iter = boxes.keyIterator();
    while (iter.next()) |p| {
        const gps = p.y * 100 + p.x;
        sum += gps;
    }
    return sum;
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

    const gpsCoordinateSum = try solveSingle(input, allocator, .part1);
    const doubleSum = try solveDouble(input, allocator, .part2);

    std.debug.print("PART 1 GPS COORDINATE SUM: {}\n", .{gpsCoordinateSum});
    std.debug.print("PART 2 SCALED-UP SUM: {}\n", .{doubleSum});
}
