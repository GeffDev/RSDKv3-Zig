const rsdk = @import("RetroEngine.zig");

var buffer: [1000]u8 = undefined;
var fba = rsdk.std.heap.FixedBufferAllocator.init(&buffer);
pub const allocator = fba.allocator();