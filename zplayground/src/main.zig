const std = @import("std");

pub fn main() !void {
    // _ = try printNameToCLI();

    // _ = try errorHandler();
    const basic1Result = try basic1();
    std.debug.print("{}", .{basic1Result});
}

//---------------CLI----
// Read Name from cli and print
// input zig build run --keshav
// output Hello Keshav
fn printNameToCLI() !void {
    const args = std.process.args();

    std.debug.print("Re {}", .{args});
}

//---------------CLI----

// -------------------------------------------
// custom Error creating
const customErrorName = error{
    OneError,
};

// Error Handling
// with try
// catch with optionals
// catch switch
fn errorHandler() !void {
    // CHANGE THESE VALUE TO CHECK YOUR ERROR
    // MAKE 0 -> 20 to trigger result A
    // MAKE 1 -> 20 to trigger result B
    // MAKE Y -> 0 or 1 to trigger result c
    const zeroErr: i32 = 0;
    const oneErr: i32 = 1;

    var y: i32 = 20;

    // Error bubble up when using try
    const a = try someError(zeroErr);
    std.debug.print("AAA Value when result is not zero {} \n", .{a});

    // Catch and handel
    const b = someError(oneErr) catch |err| {
        std.debug.print("BBB Error's when value is One {} \n", .{err});
        return;
    };
    std.debug.print("BBB Result b when value is not 1 or 0 {} \n", .{b});

    // Catch switch, Handling multiple error state at once
    y = 30;
    const c = someError(y) catch |err| switch (err) {
        customErrorName.OneError => {
            std.debug.print("CCC value sent was 1 {} \n", .{err});
            return;
        },
        error.DivideByZero => {
            std.debug.print("CCC value sent was 0 {} \n", .{err});
            return;
        },
    };
    std.debug.print("CCC Catch switch when value is not 1 or 0 {} \n", .{c});
}

// Error generator
fn someError(a: i32) !i32 {
    if (a == 0) return error.DivideByZero;
    if (a == 1) return customErrorName.OneError;

    return a;
}

// ----------------------
// Explicit literal type
// const (immutable,✅ compTime_int)  vs var (mutable ,comptime_int ❌)
// var needs to have explicit type as it cannot be "compTime_integer"
// error union type , either T (type) or error
// formatting {} (parameter) vs .{} (arguments)
// ";" -> control over value flow

fn basic1() !i32 {
    const x = 20;
    var y: i32 = 30; // var cannot be "comptime_int" at runtime so explicitly set its TYPE
    y += x; // var is mutable so we do y = y + x NOT x = y + x

    std.debug.print("Result from basic1 {} \n", .{y});

    return y;
}
