const std = @import("std");
const parseInt = std.fmt.parseInt;

fn readStdin(allocator: std.mem.Allocator) ![]u8 {
    const stdin = std.io.getStdIn();
    const data = try stdin.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    return data;
}

const File = struct {
    // -1 = free space
    id: i64,
    length: i64,
    startOffset: i64,
};

const Input = struct {
    const Self = @This();
    files: std.ArrayList(File),
    pub fn deinit(self: Self) void {
        self.files.deinit();
    }
};

fn parseInput(line: []const u8, allocator: std.mem.Allocator) !Input {
    var files = std.ArrayList(File).init(allocator);
    var nextIsFile = true;
    var nextFileIdx: i64 = 0;
    var offset: i64 = 0;
    for (line) |c| {
        if (c == '\n') continue;
        const length = try parseInt(i64, &[_]u8{c}, 10);
        if (nextIsFile) {
            try files.append(File{ .id = nextFileIdx, .length = length, .startOffset = offset });
            nextFileIdx += 1;
        } else {
            try files.append(File{ .id = -1, .length = length, .startOffset = offset });
        }
        offset += length;
        nextIsFile = !nextIsFile;
    }
    return Input{ .files = files };
}

fn solveBlocks(input: Input, allocator: std.mem.Allocator) !i64 {
    _ = allocator;
    const copy = try input.files.clone();
    defer copy.deinit();
    var toFillIdx: i64 = @intCast(copy.items.len - 1);
    var offset: i64 = 0;
    var checksum: i64 = 0;
    for (copy.items) |*file| {
        while (file.length > 0) : ({
            offset += 1;
            file.length -= 1;
        }) {
            if (file.id == -1) {
                while (toFillIdx >= 0) : (toFillIdx -= 1) {
                    var source = &copy.items[@intCast(toFillIdx)];
                    if (source.id == -1) continue;
                    if (source.length == 0) continue;
                    const add = offset * source.id;
                    std.debug.print("fill empty o={} s={} a={} tofillidx={} s.len={}\n", .{ offset, source.id, add, toFillIdx, source.length });
                    checksum += add;
                    source.length -= 1;
                    break;
                }
            } else {
                const add = offset * file.id;
                std.debug.print("file o={} s={} a={}\n", .{ offset, file.id, add });
                checksum += add;
            }
        }
    }
    return checksum;
}

fn solveFiles(input: Input, allocator: std.mem.Allocator) !i64 {
    _ = allocator;
    const copy = try input.files.clone();
    defer copy.deinit();
    var offset: i64 = 0;
    var checksum: i64 = 0;
    for (copy.items, 0..) |*file, idx| {
        _ = idx;
        while (file.length > 0) {
            // std.debug.print("trying idx={} file={any}\n", .{ idx, file });
            var toFillIdx: i64 = @intCast(copy.items.len - 1);
            if (file.id == -1) {
                while (toFillIdx >= 0) : (toFillIdx -= 1) {
                    var source = &copy.items[@intCast(toFillIdx)];
                    if (source.id == -1) continue;
                    if (source.length > file.length) continue;
                    const srcLen = source.length;
                    while (source.length > 0) : ({
                        source.length -= 1;
                        offset += 1;
                        file.length -= 1;
                    }) {
                        const add = offset * source.id;
                        std.debug.print("fill empty o={} s={} a={}\n", .{ offset, source.id, add });
                        checksum += add;
                    }
                    source.length = srcLen;
                    source.id = -1;
                    break;
                }
                if (toFillIdx == -1) {
                    while (file.length > 0) : ({
                        offset += 1;
                        file.length -= 1;
                    }) {
                        const add = 0;
                        std.debug.print("skip empty o={} s={} a={}\n", .{ offset, file.id, add });
                        checksum += add;
                    }
                }
            } else {
                while (file.length > 0) : ({
                    offset += 1;
                    file.length -= 1;
                }) {
                    const add = offset * file.id;
                    std.debug.print("file o={} s={} a={}\n", .{ offset, file.id, add });
                    checksum += add;
                }
            }
        }
    }
    return checksum;
}
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const bytes = try readStdin(allocator);
    defer allocator.free(bytes);

    var input = try parseInput(bytes, allocator);
    defer input.deinit();

    const blocksChecksum = try solveBlocks(input, allocator);
    const filesChecksum = try solveFiles(input, allocator);

    std.debug.print("PART 1 BLOCKS CHECKSUM: {}\n", .{blocksChecksum});
    std.debug.print("PART 2 FILES CHECKSUM: {}\n", .{filesChecksum});
}
