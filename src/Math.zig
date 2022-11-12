const rsdk = @import("RetroEngine.zig");

pub var sinMLookupTable: [512]i32 = undefined;
pub var cosMLookupTable: [512]i32 = undefined;

pub var sin512LookupTable: [512]i32 = undefined;
pub var cos512LookupTable: [512]i32 = undefined;

pub var sin256LookupTable: [256]i32 = undefined;
pub var cos256LookupTable: [256]i32 = undefined;

pub var arcTan256LookupTable: [0x100 * 0x100]u8 = undefined;

pub fn CalculateTrigAngles() void {
    var i: usize = 0;

    while (i < 0x200) : (i += 1) {
        sinMLookupTable[i] = @floatToInt(i32, @sin(((@intToFloat(f32, i) / 256.0) * rsdk.std.math.pi) * 4096.0));
        cosMLookupTable[i] = @floatToInt(i32, @cos(((@intToFloat(f32, i) / 256.0) * rsdk.std.math.pi) * 4096.0));
    }
}