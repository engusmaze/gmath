# GMath - Geometry Math Library

GMath is a Zig-based linear algebra library that provides a set of vector and matrix types and operations for 2D and 3D graphics. It is designed to be fast, efficient, and easy to use.

## Features

- 2D and 3D vector types (`Vec2`, `Vec3`, `Vec4`) with various operations (add, subtract, multiply, divide, etc.)
- 2x2 matrix type (`Mat2`) with operations like applying a matrix to a vector and matrix multiplication
- 2D affine transformation type (`Affine2`) for representing and manipulating 2D transformations

## Installation Steps:

### 1. Adding the Library URL:

Use `zig fetch` command to save the library's URL and its hash to a file called `build.zig.zon`.

```sh
zig fetch --save https://github.com/engusmaze/gmath/archive/f09f0bedbf06ebc6f2dce1b8cd983a051d743596.tar.gz
```

### 2. Adding the Dependency:

After saving the library's URL, you need to make it importable by your code in the build.zig file. This involves specifying the dependency and adding it to an executable or library.

```zig
pub fn build(b: *std.Build) void {
    // ...
    const gmath = b.dependency("gmath", .{
        .target = target,
        .optimize = optimize,
    });

    // Add the module to an executable or library
    exe.root_module.addImport("gmath", gmath.module("gmath"));
}
```

### 3. Importing the Library:

Once the dependency is specified in the `build.zig` file, you can import the library into your Zig code using the `@import` directive.

```zig
const gmath = @import("gmath");
```

## Usage

First, import the library:

```zig
const vec = @import("gmath").vec;
const mat = @import("gmath").mat;

const Vec2 = vec.Vec2;
const Vec3 = vec.Vec3;
const Vec4 = vec.Vec4;

const Mat2 = mat.Mat2;
const Affine2 = mat.Affine2;
```

Now you can use the various types and functions provided by the library. For example:

```zig
// Vector operations
const v1 = Vec2.new(1, 2);
const v2 = Vec2.new(3, 4);
const sum = v1.add(v2); // sum = Vec2{ 4, 6 }

// Matrix operations
const m1 = Mat2.new(1, 2, 3, 4);
const v = Vec2.new(10, 20);
const result = m1.apply(v); // result = Vec2{ 70, 150 }

// Affine transformations
const transform = Affine2.fromScaleAngleOffset(Vec2.new(2, 3), 0.785398163, Vec2.new(10, 20));
const point = Vec2.new(5, 5);
const transformed = transform.apply(point); // transformed = Vec2{ 20, 35 }
```
