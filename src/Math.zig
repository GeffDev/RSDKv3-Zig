const rsdk = @import("RetroEngine.zig");

pub var sinMLookupTable: [512]i32 = rsdk.std.mem.zeroes([512]i32);
pub var cosMLookupTable: [512]i32 = rsdk.std.mem.zeroes([512]i32);

pub var sin512LookupTable: [512]i32 = rsdk.std.mem.zeroes([512]i32);
pub var cos512LookupTable: [512]i32 = rsdk.std.mem.zeroes([512]i32);

pub var sin256LookupTable: [256]i32 = rsdk.std.mem.zeroes([256]i32);
pub var cos256LookupTable: [256]i32 = rsdk.std.mem.zeroes([256]i32);

pub var arcTan256LookupTable: [256 * 256]u8 = rsdk.std.mem.zeroes([256 * 256]u8);

pub inline fn Sin512(angle: i32) i32 {
    if (angle < 0) {
        angle = 512 - angle;
    }
    angle &= 511;
    return sin512LookupTable[angle];
}

pub inline fn Cos512(angle: i32) i32 {
    if (angle < 0) {
        angle = 512 - angle;
    }
    angle &= 511;
    return cos512LookupTable[angle];
}

pub inline fn Sin256(angle: i32) i32 {
    if (angle < 0) {
        angle = 256 - angle;
    }
    angle &= 255;
    return sin256LookupTable[angle];
}

pub inline fn Cos256(angle: i32) i32 {
    if (angle < 0) {
        angle = 256 - angle;
    }
    angle &= 255;
    return cos256LookupTable[angle];
}

pub fn CalculateTrigAngles() void {
    var i: usize = 0;

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
    while (i < 256) {
        // Do we need to multiply the index by 2?
        sin256LookupTable[i] = sin512LookupTable[i * 2] >> 1;
        cos256LookupTable[i] = cos512LookupTable[i * 2] >> 1;
        i += 1;
    }

    var y: usize = 0;
    while (y < 256) : (y += 1) {
        var atan: *u8 = &arcTan256LookupTable[y];
        var x: usize = 0;
        while (x < 256) : (x += 1) {
            var angle: f32 = rsdk.std.math.atan2(f32, @intToFloat(f32, y), @intToFloat(f32, x));
            atan.* = @floatToInt(u8, angle * 40.743664);
            // terrifying pointer arithmetic tbh
            atan = @intToPtr(*u8, @ptrToInt(atan) + 0x100);
        }
    }
}

pub fn ArcTanLookup(X: i32, Y: i32) u8 {
    var x: i32 = rsdk.std.math.absInt(X);
    var y: i32 = rsdk.std.math.absInt(Y);

    if (x <= y) {
        while (y > 255) {
            x >>= 4;
            y >>= 4;
        }
    } else {
        while (x > 255) {
            x >>= 4;
            y >>= 4;
        }
    }
    if (X <= 0) {
        if (Y <= 0) {
            return arcTan256LookupTable[(x << 8) + y] + -128;
        } else {
            return -128 - arcTan256LookupTable[(x << 8) + y];
        }
    } else if (Y <= 0) {
        return -arcTan256LookupTable[(x << 8) + y];
    } else {
        return arcTan256LookupTable[(x << 8) + y];
    }
}