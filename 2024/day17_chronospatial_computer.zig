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

const Input = struct {
    const Self = @This();
    a: i64,
    b: i64,
    c: i64,
    program: std.ArrayList(i64),
    pub fn deinit(self: *Self) void {
        self.program.deinit();
    }
};

const ParseError = error{InvalidInput};
const SolveError = error{ UnhandledCase, CalculationError };

fn consume(str: []const u8, expected: []const u8) ParseError!void {
    if (!std.mem.eql(u8, str, expected)) {
        return ParseError.InvalidInput;
    }
}

fn parseRegister(line: []const u8, label: u8) !i64 {
    var iter = std.mem.tokenizeAny(u8, line, " :");
    try consume(iter.next().?, "Register");
    try consume(iter.next().?, &[_]u8{label});
    const value = try parseInt(i64, iter.next().?, 10);
    return value;
}

fn parseProgram(line: []const u8, allocator: std.mem.Allocator) !std.ArrayList(i64) {
    var output = std.ArrayList(i64).init(allocator);
    var iter = std.mem.tokenizeSequence(u8, line, ": ");
    try consume(iter.next().?, "Program");
    var nums = std.mem.splitScalar(u8, iter.next().?, ',');
    while (nums.next()) |num| {
        try output.append(try parseInt(i64, num, 10));
    }
    return output;
}
fn parseInput(lines: [][]const u8, allocator: std.mem.Allocator) !Input {
    const a = try parseRegister(lines[0], 'A');
    const b = try parseRegister(lines[1], 'B');
    const c = try parseRegister(lines[2], 'C');
    try consume(lines[3], "");
    const program = try parseProgram(lines[4], allocator);

    return Input{
        .a = a,
        .b = b,
        .c = c,
        .program = program,
    };
}

const Part = enum {
    part1,
    part2,
};

const ADV = 0; // division
const BXL = 1; // bitwise XOR
const BST = 2; // mod8
const JNZ = 3; // jump-not-zero
const BXC = 4; // bitwise XOR
const OUT = 5; // combo output
const BDV = 6; // division
const CDV = 7; // division

fn evalCombo(operand: i64, a: i64, b: i64, c: i64) !i64 {
    return switch (operand) {
        0, 1, 2, 3 => operand,
        4 => a,
        5 => b,
        6 => c,
        7 => SolveError.UnhandledCase,
        else => SolveError.UnhandledCase,
    };
}

fn solve(input: Input, allocator: std.mem.Allocator, part: Part) !std.ArrayList(i64) {
    var output = std.ArrayList(i64).init(allocator);
    var ip: usize = 0;
    var a: i64 = input.a;
    var b: i64 = input.b;
    var c: i64 = input.c;
    while (ip < input.program.items.len) {
        const instruction = input.program.items[ip];
        // std.debug.print("ip={} instruction={} operand={}: a={d} b={d} c={d}\n", .{ ip, instruction, input.program.items[ip + 1], a, b, c });
        switch (instruction) {
            ADV => {
                const numerator = a;
                const combo = try evalCombo(input.program.items[ip + 1], a, b, c);
                const denominator = std.math.pow(i64, 2, combo);
                a = @divTrunc(numerator, denominator);
                ip += 2;
            },
            BXL => {
                const literal = input.program.items[ip + 1];
                b = b ^ literal;
                ip += 2;
            },
            BST => {
                const combo = try evalCombo(input.program.items[ip + 1], a, b, c);
                b = @mod(combo, 8);
                ip += 2;
            },
            JNZ => {
                if (a == 0) {
                    ip += 2;
                } else {
                    const literal = input.program.items[ip + 1];
                    ip = @intCast(literal);
                }
            },
            BXC => {
                b = b ^ c;
                ip += 2;
            },
            OUT => {
                const combo = try evalCombo(input.program.items[ip + 1], a, b, c);
                const value = @mod(combo, 8);
                try output.append(value);
                ip += 2;
            },
            BDV => {
                const numerator = a;
                const combo = try evalCombo(input.program.items[ip + 1], a, b, c);
                const denominator = std.math.pow(i64, 2, combo);
                b = @divTrunc(numerator, denominator);
                ip += 2;
            },
            CDV => {
                const numerator = a;
                const combo = try evalCombo(input.program.items[ip + 1], a, b, c);
                const denominator = std.math.pow(i64, 2, combo);
                c = @divTrunc(numerator, denominator);
                ip += 2;
            },
            else => return SolveError.UnhandledCase,
        }
    }
    _ = part;
    return output;
}

fn printoutput(output: []i64) void {
    for (0.., output) |idx, o| {
        if (idx == 0) {
            std.debug.print("{d}", .{o});
        } else {
            std.debug.print(",{d}", .{o});
        }
    }
}

// 162_700_000_000_000 < A < 176_000_000_000_000
// 164_514_000_000_000 < A < 164_584_000_000_000
// 164_541_200_000_000 < A < 164_542_400_000_000
// 164_542_109_000_000 < A < 164_542_127_000_000
// 164_542_122_290_000 < A < 164_542_126_490_000

fn findA(input: Input, allocator: std.mem.Allocator) !i64 {
    var a: i64 = 164_542_122_290_000;
    while (a < 164_542_126_490_000) : (a += 1) {
        std.debug.print("TRYING a={d}:\n", .{a});
        // printoutput(input.program.items);
        // std.debug.print("\n", .{});
        const output = try solve(Input{ .a = a, .b = input.b, .c = input.c, .program = input.program }, allocator, .part2);
        defer output.deinit();
        // printoutput(output.items);
        // std.debug.print("\n", .{});
        if (output.items.len == input.program.items.len) {
            var allOk = true;
            for (output.items, input.program.items) |o, p| {
                if (o != p) {
                    allOk = false;
                }
            }
            if (allOk) {
                return a;
            }
        }
    }
    return SolveError.CalculationError;
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

    const output = try solve(input, allocator, .part1);
    defer output.deinit();

    std.debug.print("PART 1 OUTPUT: ", .{});
    printoutput(output.items);
    std.debug.print("\n", .{});

    const aValue = try findA(input, allocator);
    std.debug.print("PART 2 LOWEST A VALUE: {}\n", .{aValue});
}
