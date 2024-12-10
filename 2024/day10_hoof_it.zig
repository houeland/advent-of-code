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

const Input = struct {
    const Self = @This();
    map: std.ArrayList(std.ArrayList(i64)),
    pub fn deinit(self: Self) void {
        for (self.map.items) |line| {
            line.deinit();
        }
        self.map.deinit();
    }
};

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var map = std.ArrayList(std.ArrayList(i64)).init(allocator);
    for (lines) |line| {
        var row = std.ArrayList(i64).init(allocator);
        for (line) |c| {
            const height = try parseInt(i64, &[_]u8{c}, 10);
            try row.append(height);
        }
        try map.append(row);
    }
    return Input{ .map = map };
}

const Part = enum {
    part1,
    part2,
};

const Point = struct {
    x: i64,
    y: i64,
};

fn lookup(input: Input, x: i64, y: i64) ?i64 {
    if (x < 0 or x >= input.map.items[0].items.len or y < 0 or y >= input.map.items.len) return null;
    return input.map.items[@intCast(y)].items[@intCast(x)];
}

const steps: []const Point = &[_]Point{
    Point{ .x = 1, .y = 0 },
    Point{ .x = -1, .y = 0 },
    Point{ .x = 0, .y = 1 },
    Point{ .x = 0, .y = -1 },
};

fn solve(input: Input, allocator: std.mem.Allocator, part: Part) !i64 {
    var sum: i64 = 0;
    for (0.., input.map.items) |y, row| {
        for (0.., row.items) |x, ch| {
            if (ch != 0) continue;
            var places = std.AutoHashMap(Point, i64).init(allocator);
            defer places.deinit();
            try places.put(Point{ .x = @intCast(x), .y = @intCast(y) }, 1);
            var fromHeight: i64 = 0;
            while (fromHeight < 9) : (fromHeight += 1) {
                var keys = std.ArrayList(Point).init(allocator);
                defer keys.deinit();
                var iterK = places.keyIterator();
                while (iterK.next()) |p| {
                    try keys.append(p.*);
                }
                std.debug.print("fromHeight={}: {any}\n", .{ fromHeight, keys.items });
                var nextPlaces = std.AutoHashMap(Point, i64).init(allocator);
                defer nextPlaces.deinit();
                var iter = places.iterator();
                while (iter.next()) |entry| {
                    const p = entry.key_ptr.*;
                    for (steps) |step| {
                        const h = lookup(input, p.x + step.x, p.y + step.y) orelse continue;
                        if (h == fromHeight + 1) {
                            const trg = try nextPlaces.getOrPutValue(Point{ .x = p.x + step.x, .y = p.y + step.y }, 0);
                            trg.value_ptr.* += entry.value_ptr.*;
                        }
                    }
                }
                std.mem.swap(std.AutoHashMap(Point, i64), &places, &nextPlaces);
            }
            const score = places.count();
            var rating: i64 = 0;
            var iter = places.iterator();
            while (iter.next()) |entry| {
                rating += entry.value_ptr.*;
            }
            std.debug.print("score: {} rating={}\n", .{ score, rating });
            switch (part) {
                .part1 => {
                    sum += score;
                },
                .part2 => {
                    sum += rating;
                },
            }
        }
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

    const sumScores = try solve(input, allocator, .part1);
    const sumRatings = try solve(input, allocator, .part2);

    std.debug.print("PART 1 SUM OF TRAILHEAD SCORES: {}\n", .{sumScores});
    std.debug.print("PART 2 SUM OF TRAILHEAD RATINGS: {}\n", .{sumRatings});
}
