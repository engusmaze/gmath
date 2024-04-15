pub const vector_types: []const type = &.{ Vec2, Vec3, Vec4 };

pub const Vec2 = extern struct {
    vec: FVector,

    pub const FVector = @Vector(2, f32);
    pub const IVector = @Vector(2, f32);
    pub inline fn new(X: f32, Y: f32) Vec2 {
        return .{ .vec = .{ X, Y } };
    }
    pub inline fn splat(value: f32) Vec2 {
        return .{ .vec = .{ value, value } };
    }

    pub const zero = Vec2.splat(0);
    pub const one = Vec2.splat(1);

    pub inline fn x(self: Vec2) *f32 {
        return &self.vec[0];
    }

    pub inline fn y(self: Vec2) *f32 {
        return &self.vec[1];
    }

    pub inline fn add(self: Vec2, other: Vec2) Vec2 {
        return .{.vec{self.vec + other.vec}};
    }
    pub inline fn addScalar(self: Vec2, other: f32) Vec2 {
        return .{.vec{self.vec + @as(FVector, @splat(other))}};
    }
    pub inline fn addAssign(self: Vec2, other: Vec2) Vec2 {
        self.vec += other.vec;
    }

    pub inline fn sub(self: Vec2, other: Vec2) Vec2 {
        return .{.vec{self.vec - other.vec}};
    }
    pub inline fn subScalar(self: Vec2, other: f32) Vec2 {
        return .{.vec{self.vec - @as(FVector, @splat(other))}};
    }
    pub inline fn subAssign(self: Vec2, other: Vec2) Vec2 {
        self.vec -= other.vec;
    }

    pub inline fn mul(self: Vec2, other: Vec2) Vec2 {
        return .{.vec{self.vec * other.vec}};
    }
    pub inline fn mulScalar(self: Vec2, other: f32) Vec2 {
        return .{.vec{self.vec * @as(FVector, @splat(other))}};
    }
    pub inline fn mulAssign(self: Vec2, other: Vec2) Vec2 {
        self.vec *= other.vec;
    }

    pub inline fn div(self: Vec2, other: Vec2) Vec2 {
        return .{.vec{self.vec / other.vec}};
    }
    pub inline fn divScalar(self: Vec2, other: f32) Vec2 {
        return .{.vec{self.vec / @as(FVector, @splat(other))}};
    }
    pub inline fn divAssign(self: Vec2, other: Vec2) Vec2 {
        self.vec /= other.vec;
    }

    pub inline fn rem(self: Vec2, other: Vec2) Vec2 {
        return .{.vec{self.vec % other.vec}};
    }
    pub inline fn remScalar(self: Vec2, other: f32) Vec2 {
        return .{.vec{self.vec % @as(FVector, @splat(other))}};
    }
    pub inline fn remAssign(self: Vec2, other: Vec2) Vec2 {
        self.vec %= other.vec;
    }
    pub inline fn swizzle(self: Vec2, components: anytype) vector_types[@typeInfo(@TypeOf(components)).Struct.fields.len - 2] {
        return .{ .vec = @shuffle(f32, self.vec, undefined, @as(vector_types[@typeInfo(@TypeOf(components)).Struct.fields.len - 2].IVector, components)) };
    }
};

pub const Vec3 = extern struct {
    vec: FVector,

    pub const FVector = @Vector(3, f32);
    pub const IVector = @Vector(3, f32);
    pub inline fn new(X: f32, Y: f32, Z: f32) Vec3 {
        return .{ .vec = .{ X, Y, Z } };
    }
    pub inline fn splat(value: f32) Vec3 {
        return .{ .vec = .{ value, value, value } };
    }

    pub const zero = Vec3.splat(0);
    pub const one = Vec3.splat(1);

    pub inline fn x(self: Vec3) *f32 {
        return &self.vec[0];
    }

    pub inline fn y(self: Vec3) *f32 {
        return &self.vec[1];
    }

    pub inline fn z(self: Vec3) *f32 {
        return &self.vec[2];
    }

    pub inline fn add(self: Vec3, other: Vec3) Vec3 {
        return .{.vec{self.vec + other.vec}};
    }
    pub inline fn addScalar(self: Vec3, other: f32) Vec3 {
        return .{.vec{self.vec + @as(FVector, @splat(other))}};
    }
    pub inline fn addAssign(self: Vec3, other: Vec3) Vec3 {
        self.vec += other.vec;
    }

    pub inline fn sub(self: Vec3, other: Vec3) Vec3 {
        return .{.vec{self.vec - other.vec}};
    }
    pub inline fn subScalar(self: Vec3, other: f32) Vec3 {
        return .{.vec{self.vec - @as(FVector, @splat(other))}};
    }
    pub inline fn subAssign(self: Vec3, other: Vec3) Vec3 {
        self.vec -= other.vec;
    }

    pub inline fn mul(self: Vec3, other: Vec3) Vec3 {
        return .{.vec{self.vec * other.vec}};
    }
    pub inline fn mulScalar(self: Vec3, other: f32) Vec3 {
        return .{.vec{self.vec * @as(FVector, @splat(other))}};
    }
    pub inline fn mulAssign(self: Vec3, other: Vec3) Vec3 {
        self.vec *= other.vec;
    }

    pub inline fn div(self: Vec3, other: Vec3) Vec3 {
        return .{.vec{self.vec / other.vec}};
    }
    pub inline fn divScalar(self: Vec3, other: f32) Vec3 {
        return .{.vec{self.vec / @as(FVector, @splat(other))}};
    }
    pub inline fn divAssign(self: Vec3, other: Vec3) Vec3 {
        self.vec /= other.vec;
    }

    pub inline fn rem(self: Vec3, other: Vec3) Vec3 {
        return .{.vec{self.vec % other.vec}};
    }
    pub inline fn remScalar(self: Vec3, other: f32) Vec3 {
        return .{.vec{self.vec % @as(FVector, @splat(other))}};
    }
    pub inline fn remAssign(self: Vec3, other: Vec3) Vec3 {
        self.vec %= other.vec;
    }
    pub inline fn swizzle(self: Vec3, components: anytype) vector_types[@typeInfo(@TypeOf(components)).Struct.fields.len - 2] {
        return .{ .vec = @shuffle(f32, self.vec, undefined, @as(vector_types[@typeInfo(@TypeOf(components)).Struct.fields.len - 2].IVector, components)) };
    }
};

pub const Vec4 = extern struct {
    vec: FVector,

    pub const FVector = @Vector(4, f32);
    pub const IVector = @Vector(4, f32);
    pub inline fn new(X: f32, Y: f32, Z: f32, W: f32) Vec4 {
        return .{ .vec = .{ X, Y, Z, W } };
    }
    pub inline fn splat(value: f32) Vec4 {
        return .{ .vec = .{ value, value, value, value } };
    }

    pub const zero = Vec4.splat(0);
    pub const one = Vec4.splat(1);

    pub inline fn x(self: Vec4) *f32 {
        return &self.vec[0];
    }

    pub inline fn y(self: Vec4) *f32 {
        return &self.vec[1];
    }

    pub inline fn z(self: Vec4) *f32 {
        return &self.vec[2];
    }

    pub inline fn w(self: Vec4) *f32 {
        return &self.vec[3];
    }

    pub inline fn add(self: Vec4, other: Vec4) Vec4 {
        return .{.vec{self.vec + other.vec}};
    }
    pub inline fn addScalar(self: Vec4, other: f32) Vec4 {
        return .{.vec{self.vec + @as(FVector, @splat(other))}};
    }
    pub inline fn addAssign(self: Vec4, other: Vec4) Vec4 {
        self.vec += other.vec;
    }

    pub inline fn sub(self: Vec4, other: Vec4) Vec4 {
        return .{.vec{self.vec - other.vec}};
    }
    pub inline fn subScalar(self: Vec4, other: f32) Vec4 {
        return .{.vec{self.vec - @as(FVector, @splat(other))}};
    }
    pub inline fn subAssign(self: Vec4, other: Vec4) Vec4 {
        self.vec -= other.vec;
    }

    pub inline fn mul(self: Vec4, other: Vec4) Vec4 {
        return .{.vec{self.vec * other.vec}};
    }
    pub inline fn mulScalar(self: Vec4, other: f32) Vec4 {
        return .{.vec{self.vec * @as(FVector, @splat(other))}};
    }
    pub inline fn mulAssign(self: Vec4, other: Vec4) Vec4 {
        self.vec *= other.vec;
    }

    pub inline fn div(self: Vec4, other: Vec4) Vec4 {
        return .{.vec{self.vec / other.vec}};
    }
    pub inline fn divScalar(self: Vec4, other: f32) Vec4 {
        return .{.vec{self.vec / @as(FVector, @splat(other))}};
    }
    pub inline fn divAssign(self: Vec4, other: Vec4) Vec4 {
        self.vec /= other.vec;
    }

    pub inline fn rem(self: Vec4, other: Vec4) Vec4 {
        return .{.vec{self.vec % other.vec}};
    }
    pub inline fn remScalar(self: Vec4, other: f32) Vec4 {
        return .{.vec{self.vec % @as(FVector, @splat(other))}};
    }
    pub inline fn remAssign(self: Vec4, other: Vec4) Vec4 {
        self.vec %= other.vec;
    }
    pub inline fn swizzle(self: Vec4, components: anytype) vector_types[@typeInfo(@TypeOf(components)).Struct.fields.len - 2] {
        return .{ .vec = @shuffle(f32, self.vec, undefined, @as(vector_types[@typeInfo(@TypeOf(components)).Struct.fields.len - 2].IVector, components)) };
    }
};
