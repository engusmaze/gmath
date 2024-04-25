const std = @import("std");

const vec = @import("./vec.zig");
const Vec2 = vec.Vec2;
const Vec3 = vec.Vec3;
const Vec4 = vec.Vec4;

fn factorial(n: comptime_int) comptime_int {
    var result: comptime_int = 1;
    for (1..n + 1) |i| {
        result *= i;
    }
    return result;
}

// Fastest parallelizable cosine
inline fn cos(value: f32) f32 {
    @setFloatMode(.optimized);

    const tau = std.math.tau;
    const pi = std.math.pi;
    const pi_1_2 = pi / 2.0;

    // var x = value - @as(f32, @floatFromInt(@as(i32, @intFromFloat(value / tau)))) * tau;
    var x = value - @trunc(value / tau) * tau;
    x *= if (x < 0.0) 1.0 else -1.0;
    x += pi_1_2;

    var current_power = x;
    var result: f32 = 0.0;

    inline for (0..4) |i| {
        const divisor = factorial(i * 2 + 1);
        result += current_power / @as(f32, @floatFromInt(if (i & 1 == 0) divisor else -divisor));
        current_power *= x * x;
    }

    return result;
}

pub const Mat2 = extern struct {
    vec: Vec4,

    /// The identity matrix.
    pub const identity = Mat2.new(1, 0, 0, 1);

    /// Constructs a new 2x2 matrix from the given values.
    ///
    /// Example:
    /// ```zig
    /// const m = Mat2.new(1, 2, 3, 4);
    /// ```
    pub inline fn new(v00: f32, v10: f32, v01: f32, v11: f32) Mat2 {
        return Mat2{ .vec = Vec4.new(v00, v10, v01, v11) };
    }

    /// Constructs a new 2x2 matrix from a scale vector.
    ///
    /// Example:
    /// ```zig
    /// const scale = Vec2{ 2, 3 };
    /// const m = Mat2.fromScale(scale);
    /// ```
    pub inline fn fromScale(scale: Vec2) Mat2 {
        return Mat2{ .vec = Vec4.new(scale.x(), 0, 0, scale.y()) };
    }

    /// Constructs a new 2x2 matrix from an angle (in radians).
    ///
    /// Example:
    /// ```zig
    /// const angle = 0.785398163; // 45 degrees
    /// const m = Mat2.fromAngle(angle);
    /// ```
    pub inline fn fromAngle(angle: f32) Mat2 {
        // const dir = Vec2.new(@cos(angle), @sin(angle));

        // TODO: Needs testing
        // return Mat2{ .vec = copysign(@shuffle(f32, dir, undefined, IVec4{ 0, 1, 1, 0 }), Vec4{ 1, 1, -1, 1 }) };
        // return Mat2{ .vec = dir.swizzle(.{ 0, 1, 1, 0 }).mul(Vec4.new(1, 1, -1, 1)) };

        const angles = Vec4.splat(angle).add(Vec4.new(0.0, std.math.pi / 2.0, -std.math.pi / 2.0, 0.0));

        return Mat2{ .vec = Vec4.new(cos(angles.x()), cos(angles.y()), cos(angles.z()), cos(angles.w())) };
    }

    /// Constructs a new 2x2 matrix from a scale vector and an angle (in radians).
    ///
    /// Example:
    /// ```zig
    /// const scale = Vec2{ 2, 3 };
    /// const angle = 0.785398163; // 45 degrees
    /// const m = Mat2.fromScaleAngle(scale, angle);
    /// ```
    pub inline fn fromScaleAngle(scale: Vec2, angle: f32) Mat2 {
        return Mat2{ .vec = Mat2.fromAngle(angle).vec.mul(scale.swizzle(.{ 0, 0, 1, 1 })) };
    }

    /// Applies the matrix to a 2D vector.
    ///
    /// Example:
    /// ```zig
    /// const m = Mat2.new(1, 2, 3, 4);
    /// const v = Vec2{ 10, 20 };
    /// const result = m.apply(v);
    /// // result = Vec2{ 70, 150 }
    /// ```
    pub inline fn apply(self: Mat2, vector: Vec2) Vec2 {
        const halves = self.vec.mul(vector.swizzle(.{ 0, 0, 1, 1 }));
        return halves.swizzle(.{ 0, 1 }).add(halves.swizzle(.{ 2, 3 }));
    }

    /// Multiplies two 2x2 matrices.
    ///
    /// Example:
    /// ```zig
    /// const m1 = Mat2.new(1, 2, 3, 4);
    /// const m2 = Mat2.new(5, 6, 7, 8);
    /// const result = m1.mul(m2);
    /// // result = Mat2{ ... } // the resulting 2x2 matrix
    /// ```
    pub inline fn mul(self: Mat2, other: Mat2) Mat2 {
        const a_xyxy = self.vec.swizzle(.{ 0, 1, 0, 1 });
        const b_xxzz = other.vec.swizzle(.{ 0, 2, 0, 2 });
        const a_zwzw = self.vec.swizzle(.{ 2, 3, 2, 3 });
        const b_yyww = other.vec.swizzle(.{ 1, 1, 3, 3 });
        return Mat2{ .vec = a_xyxy.mul(b_xxzz).add(a_zwzw.mul(b_yyww)) };
    }
};
