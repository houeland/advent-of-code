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

fn lookup(input: [][]const u8, xx: i64, yy: i64) ?u8 {
    if (yy < 0 or yy >= input.len) {
        return null;
    }
    const y: usize = @intCast(yy);
    if (xx < 0 or xx >= input[y].len) {
        return null;
    }
    const x: usize = @intCast(xx);
    return input[y][x];
}

fn consume(input: [][]const u8, x: i64, y: i64, char: u8) ?void {
    const c = lookup(input, x, y) orelse return null;
    if (c == char) {
        return;
    } else {
        return null;
    }
}

fn tryXmas(input: [][]const u8, x: i64, y: i64, dx: i64, dy: i64) i64 {
    consume(input, x + dx * 0, y + dy * 0, 'X') orelse return 0;
    consume(input, x + dx * 1, y + dy * 1, 'M') orelse return 0;
    consume(input, x + dx * 2, y + dy * 2, 'A') orelse return 0;
    consume(input, x + dx * 3, y + dy * 3, 'S') orelse return 0;
    return 1;
}

fn tryMas(input: [][]const u8, x: i64, y: i64, dx: i64, dy: i64) i64 {
    consume(input, x + dx * 0, y + dy * 0, 'M') orelse return 0;
    consume(input, x + dx * 1, y + dy * 1, 'A') orelse return 0;
    consume(input, x + dx * 2, y + dy * 2, 'S') orelse return 0;
    return 1;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const bytes = try readStdin(allocator);
    defer allocator.free(bytes);

    const lines = try splitLines(bytes, allocator);
    defer lines.deinit();
    const foo = lines.items;

    var numXmas: i64 = 0;
    for (0.., lines.items) |y, line| {
        for (0.., line) |x, _| {
            numXmas += tryXmas(foo, @intCast(x), @intCast(y), -1, -1);
            numXmas += tryXmas(foo, @intCast(x), @intCast(y), -1, 0);
            numXmas += tryXmas(foo, @intCast(x), @intCast(y), -1, 1);
            numXmas += tryXmas(foo, @intCast(x), @intCast(y), 0, -1);
            numXmas += tryXmas(foo, @intCast(x), @intCast(y), 0, 1);
            numXmas += tryXmas(foo, @intCast(x), @intCast(y), 1, -1);
            numXmas += tryXmas(foo, @intCast(x), @intCast(y), 1, 0);
            numXmas += tryXmas(foo, @intCast(x), @intCast(y), 1, 1);
        }
    }

    var numCrossMas: i64 = 0;
    for (0.., lines.items) |y, line| {
        for (0.., line) |x, _| {
            const left = tryMas(foo, @intCast(x), @intCast(y), 1, 1) + tryMas(foo, @intCast(x + 2), @intCast(y + 2), -1, -1);
            const right = tryMas(foo, @intCast(x + 2), @intCast(y), -1, 1) + tryMas(foo, @intCast(x), @intCast(y + 2), 1, -1);
            if (left > 0 and right > 0) {
                numCrossMas += 1;
            }
        }
    }

    std.debug.print("PART 1 XMAS COUNT: {}\n", .{numXmas});
    std.debug.print("PART 2 X-MAS COUNT: {}\n", .{numCrossMas});
}
