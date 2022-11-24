const rsdk = @import("RetroEngine.zig");

pub const ItemType = enum {
    String,
    Int,
    Float,
    Bool,
    Comment,
};

pub const ItemFields = struct {
    section: []u8,
    hasSection: bool,
    key: []u8,
    value: []u8,
    type: ItemType,
};

pub var iniItems = rsdk.std.ArrayList(ItemFields).init(rsdk.allocator.allocator);

pub fn iniParser(fileName: []const u8) !void {
    _ = fileName;
}