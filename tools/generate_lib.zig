const std = @import("std");
const ascii = std.ascii;
const File = std.fs.File;
const allocPrint = std.fmt.allocPrint;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const AnyWriter = std.io.AnyWriter;

const coordinates = "xyzw";

fn vector(allocator: std.mem.Allocator, output: *AnyWriter, len: usize) !void {
    const type_name = try allocPrint(allocator, "Vec{d}", .{len});

    var fields = ArrayList(u8).init(allocator);
    defer fields.deinit();
    var typed_fields = ArrayList(u8).init(allocator);
    defer typed_fields.deinit();
    for (coordinates[0..len]) |field| {
        try fields.writer().print("{c},", .{ascii.toUpper(field)});
        try typed_fields.writer().print("{c}: f32,", .{ascii.toUpper(field)});
    }
    _ = fields.pop();
    _ = typed_fields.pop();

    try output.print(
        \\
        \\
        \\pub const {s} = extern struct {{
        \\  vec: FVector,
        \\
        \\  pub const FVector = @Vector({d}, f32);
        \\  pub const IVector = @Vector({d}, f32);
        \\  pub inline fn new({s}) {s} {{
        \\      return .{{.vec = .{{ {s} }}}};
        \\  }}
    , .{ type_name, len, len, typed_fields.items, type_name, fields.items });

    try output.print(
        \\
        \\  pub inline fn splat(value: f32) {s} {{
        \\      return .{{.vec = .{{
    , .{type_name});
    for (0..len) |i| {
        try output.writeAll("value");
        if (i < len - 1)
            try output.writeAll(", ");
    }
    try output.writeAll("}};}");

    try output.print(
        \\
        \\
        \\pub const zero = {s}.splat(0);
        \\pub const one = {s}.splat(1);
    , .{ type_name, type_name });

    for (coordinates[0..len], 0..) |field, i| {
        try output.print(
            \\
            \\
            \\pub inline fn {c}(self: {s}) *f32 {{
            \\  return &self.vec[{d}];
            \\}}
        , .{ field, type_name, i });
    }

    for ("+-*/%", [_][]const u8{ "add", "sub", "mul", "div", "rem" }) |op, function| {
        try output.print(
            \\
            \\
            \\pub inline fn {s}(self: {s}, other: {s}) {s} {{
            \\  return .{{.vec = self.vec {c} other.vec}};
            \\}}
        , .{ function, type_name, type_name, type_name, op });
        try output.print(
            \\
            \\pub inline fn {s}Scalar(self: {s}, other: f32) {s} {{
            \\  return .{{.vec = self.vec {c} @as(FVector, @splat(other))}};
            \\}}
        , .{ function, type_name, type_name, op });
        try output.print(
            \\
            \\pub inline fn {s}Assign(self: {s}, other: {s}) {s} {{
            \\  self.vec {c}= other.vec;
            \\}}
        , .{ function, type_name, type_name, type_name, op });
    }

    try output.print(
        \\pub inline fn swizzle(self: {s}, components: anytype) vector_types[@typeInfo(@TypeOf(components)).Struct.fields.len - 2] {{
        \\  return .{{.vec = @shuffle(f32, self.vec, undefined, @as(vector_types[@typeInfo(@TypeOf(components)).Struct.fields.len - 2].IVector, components))}};
        \\}}
    , .{type_name});

    try output.writeAll("};");
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(allocator);
    if (args.len != 2) fatal("wrong number of arguments", .{});
    const output_file_path = args[1];
    var output_file = std.fs.cwd().createFile(output_file_path, .{}) catch |err| {
        fatal("unable to open '{s}': {s}", .{ output_file_path, @errorName(err) });
    };
    defer output_file.close();

    var writer = output_file.writer().any();

    try writer.writeAll("pub const vector_types: []const type = &.{");
    for (2..5) |len| {
        try writer.print("Vec{d}", .{len});
        if (len < 4) try writer.writeAll(", ");
    }
    try writer.writeAll("};");

    for (2..5) |len| {
        try vector(allocator, &writer, len);
    }

    return std.process.cleanExit();
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.debug.print(format, args);
    std.process.exit(1);
}
