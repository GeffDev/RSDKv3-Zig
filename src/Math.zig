const rsdk = @import("RetroEngine.zig");

pub var sinMLookupTable: [512]i32 = rsdk.std.mem.zeroes([512]i32);
pub var cosMLookupTable: [512]i32 = rsdk.std.mem.zeroes([512]i32);

pub var sin512LookupTable: [512]i32 = rsdk.std.mem.zeroes([512]i32);
pub var cos512LookupTable: [512]i32 = rsdk.std.mem.zeroes([512]i32);

pub var sin256LookupTable: [256]i32 = rsdk.std.mem.zeroes([256]i32);
pub var cos256LookupTable: [256]i32 = rsdk.std.mem.zeroes([256]i32);

pub var arcTan256LookupTable: [256 * 256]u8 = rsdk.std.mem.zeroes([256 * 256]u8);

pub fn CalculateTrigAngles() void {
    var i: usize = 0;

    // Do we need to increment the index at the end of the loop or at the start?
    while (i < 512) : (i += 1) {
        sinMLookupTable[i] = @floatToInt(i32, @sin(((@intToFloat(f32, i) / 256.0) * rsdk.std.math.pi) * 4096.0));
        cosMLookupTable[i] = @floatToInt(i32, @cos(((@intToFloat(f32, i) / 256.0) * rsdk.std.math.pi) * 4096.0));
    }

    cosMLookupTable[0] = 4096;
    cosMLookupTable[128] = 0;
    cosMLookupTable[256] = -4096;
    cosMLookupTable[384] = 0;

    sinMLookupTable[0] = 0;
    sinMLookupTable[128] = 4096;
    sinMLookupTable[256] = 0;
    sinMLookupTable[384] = -4096;

    i = 0;
    while (i < 512) : (i += 1) {
        sin512LookupTable[i] = @floatToInt(i32, @sin((@intToFloat(f32, i) / 256.0) * rsdk.std.math.pi) * 512.0);
        cos512LookupTable[i] = @floatToInt(i32, @sin((@intToFloat(f32, i) / 256.0) * rsdk.std.math.pi) * 512.0);
    }

    cos512LookupTable[0] = 512;
    cos512LookupTable[128] = 0;
    cos512LookupTable[256] = -512;
    cos512LookupTable[384] = 0;

    sin512LookupTable[0] = 0;
    sin512LookupTable[128] = 512;
    sin512LookupTable[256] = 0;
    sin512LookupTable[384] = -512;

    i = 0;
    while (i < 256) : (i += 1) {
        // Do we need to multiply the index by 2?
        sin256LookupTable[i] = sin512LookupTable[i * 2] >> 1;
        cos256LookupTable[i] = cos512LookupTable[i * 2] >> 1;
    }

    var y: usize = 0;
    while (y < 256) : (i += 1) {
        var atan: *u8 = &arcTan256LookupTable[y];
        var x: usize = 0;
        while (x < 256) : (x += 1) {
            var angle: f32 = rsdk.std.math.atan2(f32, @intToFloat(f32, y), @intToFloat(f32, x));
            atan.* = @floatToInt(u8, angle * 40.743664);
            // 256 doesn't fit into u8?
            atan += @intCast(u8, 256);
        }
    }
}
