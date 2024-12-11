const std = @import("std");
const parseInt = std.fmt.parseInt;

fn readStdin(allocator: std.mem.Allocator) ![]u8 {
    const stdin = std.io.getStdIn();
    const data = try stdin.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    return data;
}

const Input = struct {
    const Self = @This();
    stones: std.ArrayList(i64),
    pub fn deinit(self: Self) void {
        self.stones.deinit();
    }
};

fn parseInput(bytes: []const u8, allocator: std.mem.Allocator) !Input {
    var stones = std.ArrayList(i64).init(allocator);
    var tokens = std.mem.tokenizeAny(u8, bytes, " \n");
    while (tokens.next()) |number| {
        const n = try parseInt(i64, number, 10);
        try stones.append(n);
    }
    return Input{ .stones = stones };
}

const Part = enum {
    part1,
    part2,
};

fn countDigits(i: i64) i64 {
    var n: usize = @intCast(i);
    var count: i64 = 0;
    while (n > 0) : (n /= 10) {
        count += 1;
    }
    return count;
}

fn blinkDirect(stones: std.ArrayList(i64), allocator: std.mem.Allocator) !std.ArrayList(i64) {
    var newStones = std.ArrayList(i64).init(allocator);
    for (stones.items) |stone| {
        if (stone == 0) {
            // std.debug.print("{} ==> {}\n", .{ stone, 1 });
            try newStones.append(1);
        } else {
            const numDigits = countDigits(stone);
            if (@mod(numDigits, 2) == 0) {
                const div = std.math.pow(i64, 10, @divExact(numDigits, 2));
                const left = @divFloor(stone, div);
                const right = @mod(stone, div);
                // std.debug.print("{} div={}==> {} {}\n", .{ stone, div, left, right });
                try newStones.append(left);
                try newStones.append(right);
            } else {
                // std.debug.print("{} ==> {}\n", .{ stone, stone * 2024 });
                try newStones.append(stone * 2024);
            }
        }
    }
    return newStones;
}

fn blinkFaster(stones: std.AutoHashMap(i64, i64), allocator: std.mem.Allocator) !std.AutoHashMap(i64, i64) {
    var newStones = std.AutoHashMap(i64, i64).init(allocator);
    var iter = stones.iterator();
    while (iter.next()) |entry| {
        const stone = entry.key_ptr.*;
        const amount = entry.value_ptr.*;
        if (stone == 0) {
            // std.debug.print("{} ==> {}\n", .{ stone, 1 });
            const trg = try newStones.getOrPutValue(1, 0);
            trg.value_ptr.* += amount;
        } else {
            const numDigits = countDigits(stone);
            if (@mod(numDigits, 2) == 0) {
                const div = std.math.pow(i64, 10, @divExact(numDigits, 2));
                const left = @divFloor(stone, div);
                const right = @mod(stone, div);
                // std.debug.print("{} div={}==> {} {}\n", .{ stone, div, left, right });
                const trgLeft = try newStones.getOrPutValue(left, 0);
                trgLeft.value_ptr.* += amount;
                const trgRight = try newStones.getOrPutValue(right, 0);
                trgRight.value_ptr.* += amount;
            } else {
                // std.debug.print("{} ==> {}\n", .{ stone, stone * 2024 });
                const trg = try newStones.getOrPutValue(stone * 2024, 0);
                trg.value_ptr.* += amount;
            }
        }
    }
    return newStones;
}

fn solveDirect(input: *Input, numBlinks: i64, allocator: std.mem.Allocator) !i64 {
    var stones = std.ArrayList(i64).init(allocator);
    defer stones.deinit();
    std.mem.swap(std.ArrayList(i64), &input.stones, &stones);
    var blinks: i64 = 0;
    while (blinks < numBlinks) : (blinks += 1) {
        var newStones = try blinkDirect(stones, allocator);
        defer newStones.deinit();
        std.mem.swap(std.ArrayList(i64), &stones, &newStones);
        // std.debug.print("blinks={} stones={any}\n", .{ blinks, stones.items });
    }
    return @intCast(stones.items.len);
}

fn solveFaster(input: *Input, numBlinks: i64, allocator: std.mem.Allocator) !i64 {
    var stones = std.AutoHashMap(i64, i64).init(allocator);
    defer stones.deinit();
    for (input.stones.items) |stone| {
        try stones.put(stone, 1);
    }
    var blinks: i64 = 0;
    while (blinks < numBlinks) : (blinks += 1) {
        var newStones = try blinkFaster(stones, allocator);
        defer newStones.deinit();
        std.mem.swap(std.AutoHashMap(i64, i64), &stones, &newStones);
        // std.debug.print("blinks={} stones={any}\n", .{ blinks, stones.items });
    }
    var count: i64 = 0;
    var iter = stones.iterator();
    while (iter.next()) |entry| {
        count += entry.value_ptr.*;
    }
    return count;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const bytes = try readStdin(allocator);
    defer allocator.free(bytes);

    var input = try parseInput(bytes, allocator);
    defer input.deinit();

    // const numStones25 = try solveDirect(&input, 25, allocator);
    const numStones25 = try solveFaster(&input, 25, allocator);
    const numStones75 = try solveFaster(&input, 75, allocator);

    std.debug.print("PART 1 STONES AFTER 25 BLINKS: {}\n", .{numStones25});
    std.debug.print("PART 2 STONES AFTER 75 BLINKS: {}\n", .{numStones75});
}
