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

const Region = struct {
    label: u8,
    plots: std.AutoArrayHashMap(Point, void),
};

const Input = struct {
    const Self = @This();
    regions: std.ArrayList(Region),
    pub fn deinit(self: Self) void {
        for (self.regions.items) |*region| {
            region.plots.deinit();
        }
        self.regions.deinit();
    }
};

const steps: []const Point = &[_]Point{
    Point{ .x = 1, .y = 0 },
    Point{ .x = -1, .y = 0 },
    Point{ .x = 0, .y = 1 },
    Point{ .x = 0, .y = -1 },
};

const prevCheck: []const Point = &[_]Point{
    Point{ .x = 0, .y = -1 },
    Point{ .x = 0, .y = -1 },
    Point{ .x = -1, .y = 0 },
    Point{ .x = -1, .y = 0 },
};

fn lookup(lines: [][]const u8, x: i64, y: i64) ?u8 {
    if (x < 0 or x >= lines[0].len or y < 0 or y >= lines.len) return null;
    return lines[@intCast(y)][@intCast(x)];
}

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    var seen = std.AutoArrayHashMap(Point, void).init(allocator);
    defer seen.deinit();
    var regions = std.ArrayList(Region).init(allocator);
    for (0.., lines) |y, line| {
        for (0.., line) |x, c| {
            const p = Point{ .x = @intCast(x), .y = @intCast(y) };
            if (seen.contains(p)) continue;
            var region = Region{ .label = c, .plots = std.AutoArrayHashMap(Point, void).init(allocator) };
            var q = std.ArrayList(Point).init(allocator);
            defer q.deinit();
            try q.append(p);
            while (q.items.len > 0) {
                const at = q.pop();
                if (seen.contains(at)) continue;
                try seen.put(at, {});
                try region.plots.put(at, {});
                for (steps) |step| {
                    const to = Point{ .x = at.x + step.x, .y = at.y + step.y };
                    if (lookup(lines, to.x, to.y) != region.label) continue;
                    try q.append(to);
                }
            }
            try regions.append(region);
        }
    }
    return Input{ .regions = regions };
}

const Part = enum {
    part1,
    part2,
};

fn solve(input: *Input, allocator: std.mem.Allocator, part: Part) !i64 {
    _ = allocator;
    var total: i64 = 0;
    var bulkTotal: i64 = 0;
    for (input.regions.items) |region| {
        const area = region.plots.keys().len;
        var perimeter: i64 = 0;
        for (region.plots.keys()) |p| {
            for (steps) |step| {
                const to = Point{ .x = p.x + step.x, .y = p.y + step.y };
                if (!region.plots.contains(to)) {
                    perimeter += 1;
                }
            }
        }
        var sides: i64 = 0;
        for (region.plots.keys()) |p| {
            for (0.., steps) |i, step| {
                const to = Point{ .x = p.x + step.x, .y = p.y + step.y };
                if (!region.plots.contains(to)) {
                    const prev = Point{ .x = p.x + prevCheck[i].x, .y = p.y + prevCheck[i].y };
                    const prevTo = Point{ .x = prev.x + step.x, .y = prev.y + step.y };
                    const isContinuation = region.plots.contains(prev) and !region.plots.contains(prevTo);
                    if (!isContinuation) {
                        sides += 1;
                    }
                }
            }
        }
        const price = perimeter * @as(i64, @intCast(area));
        const bulkPrice = sides * @as(i64, @intCast(area));
        std.debug.print("region {c} area={} perimeter={} sides={} price={} bulkPrice={}: {any}\n", .{ region.label, area, perimeter, sides, price, bulkPrice, region.plots.keys() });
        total += price;
        bulkTotal += bulkPrice;
    }
    return switch (part) {
        .part1 => total,
        .part2 => bulkTotal,
    };
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

    const totalPrice = try solve(&input, allocator, .part1);
    const bulkPrice = try solve(&input, allocator, .part2);

    std.debug.print("PART 1 FENCING TOTAL PRICE: {}\n", .{totalPrice});
    std.debug.print("PART 1 FENCING BULK PRICE: {}\n", .{bulkPrice});
}
