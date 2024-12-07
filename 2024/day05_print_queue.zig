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

fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !struct { rules: std.AutoHashMap(i64, std.ArrayList(i64)), updates: std.ArrayList(std.ArrayList(i64)) } {
    // When reading a page <key>, then any pages in <values> must not already be seen.
    var rules = std.AutoHashMap(i64, std.ArrayList(i64)).init(allocator);
    var readingRules = true;
    var updates = std.ArrayList(std.ArrayList(i64)).init(allocator);
    for (lines) |line| {
        if (line.len == 0) {
            readingRules = false;
            continue;
        }
        if (readingRules) {
            var parts = std.mem.tokenize(u8, line, "|");
            const a = try std.fmt.parseInt(i64, parts.next().?, 10);
            const b = try std.fmt.parseInt(i64, parts.next().?, 10);
            var list = rules.get(a) orelse std.ArrayList(i64).init(allocator);
            try list.append(b);
            try rules.put(a, list);
            std.debug.print("RULE: {s}: a={} b={}\n", .{ line, a, b });
        } else {
            var parts = std.mem.tokenize(u8, line, ",");
            var pages = std.ArrayList(i64).init(allocator);
            while (parts.next()) |part| {
                const page = try std.fmt.parseInt(i64, part, 10);
                try pages.append(page);
            }
            try updates.append(pages);
            std.debug.print("PAGES: {s}: {any}\n", .{ line, pages.items });
        }
    }
    return .{ .rules = rules, .updates = updates };
}

fn isCorrectlyOrdered(update: []i64, rules: std.AutoHashMap(i64, std.ArrayList(i64)), allocator: std.mem.Allocator) !bool {
    var isOk = true;
    var seen = std.AutoHashMap(i64, void).init(allocator);
    defer seen.deinit();
    for (update) |page| {
        if (rules.get(page)) |toCheck| {
            for (toCheck.items) |check| {
                if (seen.contains(check)) {
                    isOk = false;
                }
            }
        }
        try seen.put(page, {});
    }
    return isOk;
}

fn fixOrder(update: []i64, rules: std.AutoHashMap(i64, std.ArrayList(i64)), allocator: std.mem.Allocator) !std.ArrayList(i64) {
    std.debug.print("SORTING: {any}\n", .{update});
    var sorted = std.ArrayList(i64).init(allocator);
    var added = std.AutoHashMap(i64, void).init(allocator);
    defer added.deinit();
    while (sorted.items.len < update.len) {
        // Can we insert this page?
        for (update) |page| {
            var isOk = added.get(page) == null;
            for (update) |check| {
                if (added.get(check) != null) continue;
                if (rules.get(check)) |toCheck| {
                    // check needs to be before toCheck[...]
                    for (toCheck.items) |toCheckPage| {
                        if (toCheckPage == page) {
                            isOk = false;
                        }
                    }
                }
            }
            if (isOk) {
                std.debug.print("INSERTING: {any}\n", .{page});
                try sorted.append(page);
                try added.put(page, {});
            }
        }
    }
    return sorted;
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
    defer {
        var iter = input.rules.valueIterator();
        while (iter.next()) |list| {
            list.deinit();
        }
        input.rules.deinit();
        for (input.updates.items) |update| {
            update.deinit();
        }
        input.updates.deinit();
    }

    var sumCorrectMiddleNumbers: i64 = 0;
    var sumFixedMiddleNumbers: i64 = 0;
    for (input.updates.items) |update| {
        const isOk = try isCorrectlyOrdered(update.items, input.rules, allocator);
        if (isOk) {
            const middle = update.items[(update.items.len - 1) / 2];
            sumCorrectMiddleNumbers += middle;
        } else {
            var sorted = try fixOrder(update.items, input.rules, allocator);
            defer sorted.deinit();
            std.debug.print("fixed: {any}\n", .{sorted.items});
            const middle = sorted.items[(sorted.items.len - 1) / 2];
            sumFixedMiddleNumbers += middle;
        }
    }
    std.debug.print("PART 1 CORRECT UPDATES MIDDLE NUMBER SUM: {}\n", .{sumCorrectMiddleNumbers});
    std.debug.print("PART 2 FIXED UPDATES MIDDLE NUMBER SUM: {}\n", .{sumFixedMiddleNumbers});
}
