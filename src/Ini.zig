const rsdk = @import("RetroEngine.zig");

pub const ItemType = enum {
    String,
    Int,
    Float,
    Bool,
    Comment,
};

pub const ItemConfig = struct {
    section: []u8,
    key: []u8,
    value: []u8,
    type: ItemType,
};

pub var iniItems = rsdk.std.ArrayList(ItemConfig).init(rsdk.allocator.allocator);

pub fn iniParser(fileName: []const u8) !void {
    var buf: [256]u8 = rsdk.std.mem.zeroes([256]u8);
    var section: [0x40]u8 = rsdk.std.mem.zeroes([0x40]u8);

    var file = rsdk.std.fs.cwd().openFile(fileName, .{}) catch {
        rsdk.std.log.err("couldn't open ini file {s}!", .{fileName});
        return;
    };
    defer file.close();

    var bufReader = rsdk.std.io.bufferedReader(file.Reader);
    var inStream = bufReader.reader();

    while (try inStream.readUntilDelimiterOrEof(&buf, '\n')) |line| : (buf = rsdk.std.mem.zeroes([256]u8)) {
        const lineTrimmed = rsdk.std.mem.trim(u8, line, " \n");
        var item: ItemConfig = rsdk.std.mem.zeroes(ItemConfig);

        if (lineTrimmed[0] == '#') {
            continue;
        }
        if (line.len == 0) {
            continue;
        }

        if (rsdk.std.mem.startsWith(u8, lineTrimmed, '[') and rsdk.std.mem.endsWith(u8, lineTrimmed, ']')) {
            section = rsdk.std.mem.zeroes([64]u8);
            section = lineTrimmed[1..lineTrimmed.len - 1];
        } else if (rsdk.std.mem.indexOfScalar(u8, lineTrimmed, '=')) |index| {
            item.key = lineTrimmed[0..index - 1];
            item.value = lineTrimmed[index + 1..];
            item.section = section;
            
            iniItems.append(item);
        }

    }
}