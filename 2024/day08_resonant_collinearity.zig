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
};

const Input = struct {
    const Self = @This();
    antennas: std.AutoHashMap(u8, std.ArrayList(Point)),
    width: i64,
    height: i64,
    pub fn deinit(self: *Self) void {
        var iter = self.antennas.valueIterator();
        while (iter.next()) |points| {
            points.deinit();
        }
        self.antennas.deinit();
    }
};

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var antennas = std.AutoHashMap(u8, std.ArrayList(Point)).init(allocator);
    for (0.., lines) |y, line| {
        for (0.., line) |x, c| {
            if (c != '.') {
                var points = try antennas.getOrPut(c);
                if (!points.found_existing) {
                    points.value_ptr.* = std.ArrayList(Point).init(allocator);
                }
                try points.value_ptr.append(Point{ .x = @intCast(x), .y = @intCast(y) });
            }
        }
    }
    return Input{ .antennas = antennas, .width = @intCast(lines[0].len), .height = @intCast(lines.len) };
}

const Part = enum {
    part1,
    part2,
};

fn solve(input: Input, allocator: std.mem.Allocator, part: Part) !i64 {
    var antinodes = std.AutoHashMap(Point, void).init(allocator);
    defer antinodes.deinit();
    var iter = input.antennas.iterator();
    while (iter.next()) |entry| {
        for (0.., entry.value_ptr.items) |i, a| {
            for (0.., entry.value_ptr.items) |j, b| {
                if (i == j) continue;
                const dx = b.x - a.x;
                const dy = b.y - a.y;
                var x = a.x;
                var y = a.y;
                var steps: i64 = 0;
                while (x >= 0 and x < input.width and y >= 0 and y < input.height) {
                    const c = Point{ .x = x, .y = y };
                    switch (part) {
                        .part1 => {
                            if (steps == 2) {
                                try antinodes.put(c, {});
                            }
                        },
                        .part2 => {
                            try antinodes.put(c, {});
                        },
                    }
                    x += dx;
                    y += dy;
                    steps += 1;
                }
            }
        }
    }
    return antinodes.count();
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

    const twoFrequencyLocations = try solve(input, allocator, .part1);
    const resonantLocations = try solve(input, allocator, .part2);

    std.debug.print("PART 1 2-FREQUENCY ANTINODES: {}\n", .{twoFrequencyLocations});
    std.debug.print("PART 2 RESONANT ANTINODES: {}\n", .{resonantLocations});
}
