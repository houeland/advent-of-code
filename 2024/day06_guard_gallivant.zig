const std = @import("std");
const parseInt = std.fmt.parseInt;

fn readStdin(allocator: std.mem.Allocator) ![]u8 {
    const stdin = std.io.getStdIn();
    const data = try stdin.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    return data;
}

fn splitLines(input: []u8, allocator: std.mem.Allocator) !std.ArrayList([]u8) {
    var lines = std.ArrayList([]u8).init(allocator);
    var iter = std.mem.splitScalar(u8, input, '\n');
    while (iter.next()) |line| {
        if (line.len == 0) continue;
        // TODO: Can we do this without constCast?
        try lines.append(@constCast(line));
    }
    return lines;
}

fn inBounds(map: std.ArrayList([]u8), x: i64, y: i64) bool {
    return (x >= 0 and x < map.items[0].len and y >= 0 and y < map.items.len);
}

fn doMove(map: std.ArrayList([]u8), gX: *i64, gY: *i64, dir: *u8, place: u8) void {
    switch (dir.*) {
        '^' => {
            if (inBounds(map, gX.*, gY.* - 1) and map.items[@intCast(gY.* - 1)][@intCast(gX.*)] == '#') {
                dir.* = '>';
            } else {
                map.items[@intCast(gY.*)][@intCast(gX.*)] = place;
                gY.* -= 1;
            }
        },
        '>' => {
            if (inBounds(map, gX.* + 1, gY.*) and map.items[@intCast(gY.*)][@intCast(gX.* + 1)] == '#') {
                dir.* = 'v';
            } else {
                map.items[@intCast(gY.*)][@intCast(gX.*)] = place;
                gX.* += 1;
            }
        },
        'v' => {
            if (inBounds(map, gX.*, gY.* + 1) and map.items[@intCast(gY.* + 1)][@intCast(gX.*)] == '#') {
                dir.* = '<';
            } else {
                map.items[@intCast(gY.*)][@intCast(gX.*)] = place;
                gY.* += 1;
            }
        },
        '<' => {
            if (inBounds(map, gX.* - 1, gY.*) and map.items[@intCast(gY.*)][@intCast(gX.* - 1)] == '#') {
                dir.* = '^';
            } else {
                map.items[@intCast(gY.*)][@intCast(gX.*)] = place;
                gX.* -= 1;
            }
        },
        else => unreachable,
    }
}

fn tryWithObstacle(bytes: []u8, igX: i64, igY: i64, idir: u8, oX: i64, oY: i64, allocator: std.mem.Allocator) !bool {
    const lines = try splitLines(bytes, allocator);
    defer lines.deinit();
    lines.items[@intCast(oY)][@intCast(oX)] = '#';

    var gX = igX;
    var gY = igY;
    var dir = idir;
    while (inBounds(lines, gX, gY)) {
        const cX: usize = @intCast(gX);
        const cY: usize = @intCast(gY);
        const before = lines.items[cY][cX];
        const beforeDir = dir;
        doMove(lines, &gX, &gY, &dir, dir);
        if (!inBounds(lines, gX, gY)) {
            return false;
        }
        const after = lines.items[cY][cX];
        if (before == after and beforeDir == dir and (cX != igX or cY != igY)) {
            std.debug.print("oX={} oY={} gX={} gY={} beforeDir={c} dir={c} before={c} after={c}\n", .{ oX, oY, gX, gY, beforeDir, dir, before, after });
            // for (lines.items) |line| {
            //     std.debug.print("map: {s}\n", .{line});
            // }
            return true;
        }
    }
    return false;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const originalBytes = try readStdin(allocator);
    defer allocator.free(originalBytes);
    const bytes = try allocator.alloc(u8, originalBytes.len);
    defer allocator.free(bytes);
    @memcpy(bytes, originalBytes);

    const lines = try splitLines(bytes, allocator);
    defer lines.deinit();

    var igX: i64 = undefined;
    var igY: i64 = undefined;
    var idir: u8 = undefined;
    for (0.., lines.items) |y, line| {
        for (0.., line) |x, _| {
            if (line[x] == '^') {
                igX = @intCast(x);
                igY = @intCast(y);
                idir = '^';
            }
        }
    }

    var gX = igX;
    var gY = igY;
    var dir = idir;
    while (inBounds(lines, gX, gY)) {
        doMove(lines, &gX, &gY, &dir, 'X');
    }
    var numDistinctPositions: i64 = 0;
    for (lines.items) |line| {
        for (line) |c| {
            if (c == 'X') {
                numDistinctPositions += 1;
            }
        }
    }

    var numObstructionPositions: i64 = 0;
    for (0.., lines.items) |y, line| {
        for (0.., line) |x, _| {
            if (x == igX and y == igY) continue;
            if (line[x] != 'X') continue;
            // TODO: Only need to check parts of original walk.
            // std.debug.print("PART 2 x={} y={}\n", .{ x, y });
            const copy = try allocator.alloc(u8, originalBytes.len);
            defer allocator.free(copy);
            @memcpy(copy, originalBytes);
            const blocking = try tryWithObstacle(copy, igX, igY, idir, @intCast(x), @intCast(y), allocator);
            if (blocking) {
                numObstructionPositions += 1;
            }
        }
    }

    std.debug.print("PART 1 DISTINCT POSITIONS: {}\n", .{numDistinctPositions});
    std.debug.print("PART 1 OBSTRUCTION POSITIONS: {}\n", .{numObstructionPositions});
}
