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

const Point = struct {
    x: i64,
    y: i64,
    pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        return writer.print("({},{})", .{ value.x, value.y });
    }
};

const Robot = struct {
    p: Point,
    v: Point,
};

const Input = struct {
    const Self = @This();
    width: i64,
    height: i64,
    robots: std.ArrayList(Robot),
    pub fn deinit(self: Self) void {
        self.robots.deinit();
    }
};

const ParseError = error{InvalidInput};
const SolveError = error{ UnhandledCase, CalculationError };

fn consume(str: []const u8, expected: []const u8) ParseError!void {
    if (!std.mem.eql(u8, str, expected)) {
        return ParseError.InvalidInput;
    }
}

fn parseXy(str: []const u8, label: u8, delim: u8) !Point {
    std.debug.print("parseXY: str={s} label={c} delim={c}\n", .{ str, label, delim });
    var iter = std.mem.tokenizeScalar(u8, str, delim);
    try consume(iter.next().?, &[_]u8{label});
    var nums = std.mem.splitScalar(u8, iter.next().?, ',');
    const x = try parseInt(i64, nums.next().?, 10);
    const y = try parseInt(i64, nums.next().?, 10);
    return Point{ .x = x, .y = y };
}

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var robots = std.ArrayList(Robot).init(allocator);
    for (lines) |line| {
        std.debug.print("line: {s}\n", .{line});
        var parts = std.mem.splitScalar(u8, line, ' ');
        const p = try parseXy(parts.next().?, 'p', '=');
        const v = try parseXy(parts.next().?, 'v', '=');
        try robots.append(Robot{ .p = p, .v = v });
    }
    if (lines.len == 12) {
        // Sample input.
        return Input{ .robots = robots, .width = 11, .height = 7 };
    } else {
        return Input{ .robots = robots, .width = 101, .height = 103 };
    }
}

const Part = enum {
    part1,
    part2,
};

const WestEast = enum {
    west,
    middle,
    east,
};

const NorthSouth = enum {
    north,
    middle,
    south,
};

fn printout(robots: std.ArrayList(Robot), step: i64, score: i64) void {
    std.debug.print("step=#{} score={}\n", .{ step, score });
    for (0..101) |y| {
        for (0..103) |x| {
            var num: i64 = 0;
            for (robots.items) |robot| {
                if (robot.p.x == x and robot.p.y == y) {
                    num += 1;
                }
            }
            if (num > 0) {
                std.debug.print("{d}", .{num});
            } else {
                std.debug.print(".", .{});
            }
        }
        std.debug.print("\n", .{});
    }
}

fn maybePrintout(robots: std.ArrayList(Robot), step: i64) void {
    var clusterscore: i64 = 0;
    for (robots.items) |robot| {
        if (robot.p.x > 30 and robot.p.x < 70) {
            clusterscore += 1;
        }
        if (robot.p.y > 30 and robot.p.y < 70) {
            clusterscore += 1;
        }
    }
    if (clusterscore > 600) {
        printout(robots, step, clusterscore);
    }
}

fn solve(input: *const Input, allocator: std.mem.Allocator, part: Part, steps: i64) !i64 {
    var robots = try input.robots.clone();
    defer robots.deinit();
    var s: i64 = 1;
    while (s <= steps) : (s += 1) {
        // std.debug.print("step: #{}\n", .{s});
        var nextRobots = std.ArrayList(Robot).init(allocator);
        defer nextRobots.deinit();
        for (robots.items) |robot| {
            const p = Point{
                .x = @mod(robot.p.x + robot.v.x, input.width),
                .y = @mod(robot.p.y + robot.v.y, input.height),
            };
            try nextRobots.append(Robot{ .p = p, .v = robot.v });
        }
        std.mem.swap(std.ArrayList(Robot), &robots, &nextRobots);
        if (part == .part2) {
            maybePrintout(robots, s);
        }
    }
    var nw: i64 = 0;
    var ne: i64 = 0;
    var sw: i64 = 0;
    var se: i64 = 0;
    for (0..@intCast(input.height)) |y| {
        for (0..@intCast(input.width)) |x| {
            var we: WestEast = undefined;
            if (x * 2 + 1 < input.width) {
                we = WestEast.west;
            } else if (x * 2 + 1 > input.width) {
                we = WestEast.east;
            } else {
                we = WestEast.middle;
            }

            var ns: NorthSouth = undefined;
            if (y * 2 + 1 < input.height) {
                ns = NorthSouth.north;
            } else if (y * 2 + 1 > input.height) {
                ns = NorthSouth.south;
            } else {
                ns = NorthSouth.middle;
            }

            var num: i64 = 0;
            for (input.robots.items) |robot| {
                if (robot.p.x == x and robot.p.y == y) {
                    num += 1;
                }
            }
            if (num > 0) {
                std.debug.print("{d}", .{num});
            } else {
                const c: u8 = switch (ns) {
                    .north => switch (we) {
                        .west => 'q',
                        .middle => '.',
                        .east => 'e',
                    },
                    .middle => '.',
                    .south => switch (we) {
                        .west => 'z',
                        .middle => '.',
                        .east => 'c',
                    },
                };
                std.debug.print("{c}", .{c});
            }
            switch (ns) {
                .north => switch (we) {
                    .west => {
                        nw += num;
                    },
                    .middle => {},
                    .east => {
                        ne += num;
                    },
                },
                .middle => {},
                .south => switch (we) {
                    .west => {
                        sw += num;
                    },
                    .middle => {},
                    .east => {
                        se += num;
                    },
                },
            }
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("quadrants: {},{},{},{}\n", .{ nw, ne, sw, se });
    return nw * ne * sw * se;
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

    const safetyFactor = try solve(&input, allocator, .part1, 100);

    std.debug.print("PART 1 SAFETY FACTOR: {}\n", .{safetyFactor});

    _ = try solve(&input, allocator, .part2, 10_000);
}
