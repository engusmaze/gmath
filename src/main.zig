const std = @import("std");
const gmath = @import("gmath");
const Vec4 = gmath.vec.Vec4;
const Mat2 = gmath.mat.Mat2;

export fn baller(angle: f32) Mat2 {
    return Mat2.fromAngle(angle);
}

pub fn main() !void {
    // std.builtin.Type
    // @compileLog(@typeInfo([5]u8));
    const boner = Vec4.new(0, 2, 4, 6).swizzle(.{ 3, 2 });
    std.debug.print("{any}\n", .{boner});
}
