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

fn nextChar(idx: *usize, bytes: []const u8) ?u8 {
    if (idx.* >= bytes.len) {
        return null;
    } else {
        const c = bytes[idx.*];
        idx.* += 1;
        return c;
    }
}

fn consume(idx: *usize, bytes: []const u8, char: u8) ?void {
    const c = nextChar(idx, bytes) orelse return null;
    if (c == char) {
        std.debug.print("char {c} OK\n", .{char});
        return;
    } else {
        std.debug.print("char {c} bad got {c}\n", .{ char, c });
        return null;
    }
}

fn readNumber(idx: *usize, bytes: []const u8, endChar: u8) ?i64 {
    const a8 = nextChar(idx, bytes) orelse return null;
    const a = std.fmt.parseInt(i64, &[_]u8{a8}, 10) catch {
        return null;
    };
    const b8 = nextChar(idx, bytes) orelse return null;
    if (b8 == endChar) {
        return a;
    }
    const b = std.fmt.parseInt(i64, &[_]u8{b8}, 10) catch {
        return null;
    };
    const c8 = nextChar(idx, bytes) orelse return null;
    if (c8 == endChar) {
        return a * 10 + b;
    }
    const c = std.fmt.parseInt(i64, &[_]u8{c8}, 10) catch {
        return null;
    };
    consume(idx, bytes, endChar) orelse return null;
    return a * 100 + b * 10 + c;
}

fn tryMul(bytes: []const u8, startIdx: usize) ?i64 {
    // std.debug.print("TRY CONSUMING: {s}\n", .{bytes[startIdx..(startIdx + 20)]});
    var idx = startIdx;
    consume(&idx, bytes, 'm') orelse return null;
    consume(&idx, bytes, 'u') orelse return null;
    consume(&idx, bytes, 'l') orelse return null;
    consume(&idx, bytes, '(') orelse return null;
    const l = readNumber(&idx, bytes, ',') orelse return null;
    const r = readNumber(&idx, bytes, ')') orelse return null;
    return l * r;
}

fn tryDo(bytes: []const u8, startIdx: usize) ?void {
    var idx = startIdx;
    consume(&idx, bytes, 'd') orelse return null;
    consume(&idx, bytes, 'o') orelse return null;
    consume(&idx, bytes, '(') orelse return null;
    consume(&idx, bytes, ')') orelse return null;
    return;
}

fn tryDont(bytes: []const u8, startIdx: usize) ?void {
    var idx = startIdx;
    consume(&idx, bytes, 'd') orelse return null;
    consume(&idx, bytes, 'o') orelse return null;
    consume(&idx, bytes, 'n') orelse return null;
    consume(&idx, bytes, '\'') orelse return null;
    consume(&idx, bytes, 't') orelse return null;
    consume(&idx, bytes, '(') orelse return null;
    consume(&idx, bytes, ')') orelse return null;
    return;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        switch (gpa.deinit()) {
            std.heap.Check.ok => {},
            std.heap.Check.leak => {
                std.debug.print("Memory leak detected!\n", .{});
            },
        }
    }

    const bytes = try readStdin(allocator);
    defer allocator.free(bytes);

    var sumMul: i64 = 0;
    var mulEnabled = true;
    var sumConditionalMul: i64 = 0;
    for (0..bytes.len) |startIdx| {
        if (tryMul(bytes, startIdx)) |mul| {
            std.debug.print("tryMul output: {}\n", .{mul});
            sumMul += mul;
            if (mulEnabled) {
                sumConditionalMul += mul;
            }
        } else if (tryDo(bytes, startIdx) != null) {
            mulEnabled = true;
        } else if (tryDont(bytes, startIdx) != null) {
            mulEnabled = false;
        }
    }
    std.debug.print("PART 1 MUL SUM: {}\n", .{sumMul});
    std.debug.print("PART 2 CONDITIONAL MUL SUM: {}\n", .{sumConditionalMul});
}
