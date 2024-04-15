const vec = @import("./vec.zig");
const mat = @import("./mat.zig");

const Vec2 = vec.Vec2;
const Vec3 = vec.Vec3;
const Vec4 = vec.Vec4;

const Mat2 = mat.Mat2;

pub const Affine2 = extern struct {
    matrix: Mat2,
    offset: Vec2,

    /// Constructs a new 2D affine transformation from a scale vector.
    ///
    /// Example:
    /// ```zig
    /// const scale = Vec2{ 2.0, 3.0 };
    /// const transform = Affine2.fromScale(scale);
    /// ```
    pub inline fn fromScale(scale: Vec2) Affine2 {
        return Affine2{
            .matrix = Mat2.fromScale(scale),
            .offset = Vec2.zero,
        };
    }

    /// Constructs a new 2D affine transformation from an angle (in radians).
    ///
    /// Example:
    /// ```zig
    /// const angle = 0.785398163; // 45 degrees
    /// const transform = Affine2.fromAngle(angle);
    /// ```
    pub inline fn fromAngle(angle: f32) Affine2 {
        return Affine2{
            .matrix = Mat2.fromAngle(angle),
            .offset = Vec2.zero,
        };
    }

    /// Constructs a new 2D affine transformation from an offset vector.
    ///
    /// Example:
    /// ```zig
    /// const offset = Vec2{ 10.0, 20.0 };
    /// const transform = Affine2.fromOffset(offset);
    /// ```
    pub inline fn fromOffset(offset: Vec2) Affine2 {
        return Affine2{
            .matrix = Mat2.identity,
            .offset = offset,
        };
    }

    /// Constructs a new 2D affine transformation from a scale vector and an angle (in radians).
    ///
    /// Example:
    /// ```zig
    /// const scale = Vec2{ 2.0, 3.0 };
    /// const angle = 0.785398163; // 45 degrees
    /// const transform = Affine2.fromScaleAngle(scale, angle);
    /// ```
    pub inline fn fromScaleAngle(scale: Vec2, angle: f32) Affine2 {
        return Affine2{
            .matrix = Mat2.fromScaleAngle(scale, angle),
            .offset = Vec2.zero,
        };
    }

    /// Constructs a new 2D affine transformation from a scale vector and an offset vector.
    ///
    /// Example:
    /// ```zig
    /// const scale = Vec2{ 2.0, 3.0 };
    /// const offset = Vec2{ 10.0, 20.0 };
    /// const transform = Affine2.fromScaleOffset(scale, offset);
    /// ```
    pub inline fn fromScaleOffset(scale: Vec2, angle: f32, offset: Vec2) Affine2 {
        return Affine2{
            .matrix = Mat2.fromScale(scale, angle),
            .offset = offset,
        };
    }

    /// Constructs a new 2D affine transformation from an angle (in radians) and an offset vector.
    ///
    /// Example:
    /// ```zig
    /// const angle = 0.785398163; // 45 degrees
    /// const offset = Vec2{ 10.0, 20.0 };
    /// const transform = Affine2.fromAngleOffset(angle, offset);
    /// ```
    pub inline fn fromAngleOffset(angle: f32, offset: Vec2) Affine2 {
        return Affine2{
            .matrix = Mat2.fromAngle(angle),
            .offset = offset,
        };
    }

    /// Constructs a new 2D affine transformation from a scale vector, an angle (in radians), and an offset vector.
    ///
    /// Example:
    /// ```zig
    /// const scale = Vec2{ 2.0, 3.0 };
    /// const angle = 0.785398163; // 45 degrees
    /// const offset = Vec2{ 10.0, 20.0 };
    /// const transform = Affine2.fromScaleAngleOffset(scale, angle, offset);
    /// ```
    pub inline fn fromScaleAngleOffset(scale: Vec2, angle: f32, offset: Vec2) Affine2 {
        return Affine2{
            .matrix = Mat2.fromScaleAngle(scale, angle),
            .offset = offset,
        };
    }

    /// Applies the affine transformation to a 2D vector.
    ///
    /// Example:
    /// ```zig
    /// const transform = Affine2.fromScaleAngleOffset(Vec2{ 2.0, 3.0 }, 0.785398163, Vec2{ 10.0, 20.0 });
    /// const v = Vec2{ 5.0, 5.0 };
    /// const result = transform.apply(v);
    /// // result = Vec2{ 20.0, 35.0 }
    /// ```
    pub inline fn apply(self: Affine2, vector: Vec2) Vec2 {
        return self.matrix.apply(vector).add(self.offset);
    }

    /// Multiplies two 2D affine transformations.
    ///
    /// Example:
    /// ```zig
    /// const t1 = Affine2.fromScaleAngleOffset(Vec2{ 2.0, 3.0 }, 0.785398163, Vec2{ 10.0, 20.0 });
    /// const t2 = Affine2.fromScaleAngleOffset(Vec2{ 0.5, 0.5 }, 0.392699082, Vec2{ 5.0, 5.0 });
    /// const result = t1.mul(t2);
    /// // result = Affine2{ ... } // the resulting affine transformation
    /// ```
    pub inline fn mul(self: Affine2, other: Affine2) Affine2 {
        return Affine2{
            .matrix = self.matrix.mul(other.matrix),
            .offset = self.apply(other.offset),
        };
    }
};
