const rsdk = @import("RetroEngine.zig");

pub var blendLookupTable: [256 * 32]u16 = rsdk.std.mem.zeroes([256 * 32]u16);
pub var subtractLookupTable: [256 * 32]u16 = rsdk.std.mem.zeroes([256 * 32]u16);
pub var tintLookupTable: [65536]u16 = rsdk.std.mem.zeroes([65536]u16);

pub fn GenerateBlendLookupTable() void {
    var y: usize = 0;
    while (y < 256) {
        var x: usize = 0;
        while (x < 32) {
            blendLookupTable[x + (32 * y)] = y * x >> 8;
            subtractLookupTable[x + (32 * y)] = y * (31 - x) >> 8;
            x += 1;
        }
        y += 1;
    }

    var i: usize = 0;
    while (i < 65536) {
        var tintValue: i32 = (i & 31) + ((i & 2016) >> 6) + ((i & 63488) >> 11);
        tintLookupTable[i] = 2113 * rsdk.std.math.min(tintValue, 31);
        i += 1;
    }
}