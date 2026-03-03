// const std = @import("std");
// const Io = std.Io;

// const zstats = @import("zstats");

// pub fn main(init: std.process.Init) !void {
//     // Prints to stderr, unbuffered, ignoring potential errors.
//     std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

//     // This is appropriate for anything that lives as long as the process.
//     const arena: std.mem.Allocator = init.arena.allocator();

//     // Accessing command line arguments:
//     const args = try init.minimal.args.toSlice(arena);
//     for (args) |arg| {
//         std.log.info("arg: {s}", .{arg});
//     }

//     // In order to do I/O operations need an `Io` instance.
//     const io = init.io;

//     // Stdout is for the actual output of your application, for example if you
//     // are implementing gzip, then only the compressed bytes should be sent to
//     // stdout, not any debugging messages.
//     var stdout_buffer: [1024]u8 = undefined;
//     var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
//     const stdout_writer = &stdout_file_writer.interface;

//     try zstats.printAnotherMessage(stdout_writer);

//     try stdout_writer.flush(); // Don't forget to flush!
// }

// test "simple test" {
//     const gpa = std.testing.allocator;
//     var list: std.ArrayList(i32) = .empty;
//     defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
//     try list.append(gpa, 42);
//     try std.testing.expectEqual(@as(i32, 42), list.pop());
// }

// test "fuzz example" {
//     try std.testing.fuzz({}, testOne, .{});
// }

// fn testOne(context: void, smith: *std.testing.Smith) !void {
//     _ = context;
//     // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!

//     const gpa = std.testing.allocator;
//     var list: std.ArrayList(u8) = .empty;
//     defer list.deinit(gpa);
//     while (!smith.eos()) switch (smith.value(enum { add_data, dup_data })) {
//         .add_data => {
//             const slice = try list.addManyAsSlice(gpa, smith.value(u4));
//             smith.bytes(slice);
//         },
//         .dup_data => {
//             if (list.items.len == 0) continue;
//             if (list.items.len > std.math.maxInt(u32)) return error.SkipZigTest;
//             const len = smith.valueRangeAtMost(u32, 1, @min(32, list.items.len));
//             const off = smith.valueRangeAtMost(u32, 0, @intCast(list.items.len - len));
//             try list.appendSlice(gpa, list.items[off..][0..len]);
//             try std.testing.expectEqualSlices(
//                 u8,
//                 list.items[off..][0..len],
//                 list.items[list.items.len - len ..],
//             );
//         },
//     };
// }

// -------MY CODE-----------------
//

// const std = @import("std");

// pub fn main(init: std.process.Init) !void {
//     // Read cli

//     //To read cli arguments
//     var args = init.minimal.args.iterate();

//     _ = args.skip(); // skip first file name

//     while (args.next()) |arg| {
//         std.debug.print("CLI arguments passed : {s}\n", .{arg});
//     }

//     // Slice iterator
//     // var args = try init.minimal.args.iterateAllocator(init.gpa);
//     // defer args.deinit();

//     // _ = args.skip();

//     // while (args.next()) |arg| {
//     //     // formatting slice = {s}
//     //     std.debug.print("see {s}\n", .{arg});
//     // }

//     // chuck memory
//     //

//     // READ FILE
//     const cwd = std.fs.cwd();
//     const file = try cwd.openFile("dummy.txt", .{});
//     defer file.close();
// }

// --------File handling------------
const std = @import("std");

// pub fn main(init: std.process.Init) !void {
//     const io = init.io;
//     const cwd = std.Io.Dir.cwd();

//     var file = try cwd.createFile(io, "example.txt", .{ .read = true });
//     defer file.close(io);

//     try file.writeStreamingAll(io, "Hello File!");

//     var read_buf: [100]u8 = undefined;
//     var file_reader = file.reader(io, &read_buf);
//     try file_reader.seekTo(0);

//     var out: [100]u8 = undefined;
//     const n = try file_reader.interface.readSliceShort(&out);
//     std.debug.print("{s}\n", .{out[0..n]});
// }

// // Read file
// fn readFile() void {
//     const io
// }

pub fn main(init: std.process.Init) !void {
    // Read CLI argument

    var args = try init.minimal.args.iterateAllocator(init.gpa);
    defer args.deinit();

    // std.debug.print("All arguments {}", .{args});

    _ = args.skip(); // skip first filename

    // / without ORELSE cli parsing
    // while (args.next()) |arg| {
    //     std.debug.print("All arguments {s} \n", .{arg});
    // }

    // ORELSE OPTIONAL HANDLING
    const path = args.next() orelse {
        std.debug.print("<Missing : File not found!> \n", .{});
        return;
    };

    std.debug.print("File Path {s} \n", .{path});

    // then open file
    const io = init.io;
    const cwd = std.Io.Dir.cwd();
    // const gpa = init.gpa;

    const file = try cwd.openFile(io, path, .{});
    defer file.close(io);

    // 4kb OS MEMORY PAGE
    var file_buf: [4096]u8 = undefined;
    // var reader = file.reader(io, &file_buf);
    const reader = file.reader(io, &file_buf);

    var lineCount: i32 = 0;

    while (true) {}

    std.debug.print("{}\n", .{reader});

    // const data = try reader.interface.readAlloc(gpa, 12);
    // const data = try reader.interface.readAlloc(gpa, 44);
    // defer gpa.free(data);

    // std.debug.print("{s}\n", .{data});
}

diff --git a//home/keshav-g15/projects/linux-dellg15/2026/zig/zstats/src/main.zig b//home/keshav-g15/projects/linux-dellg15/2026/zig/zstats/src/main.zig
new file mode 100644
--- /dev/null
+++ b//home/keshav-g15/projects/linux-dellg15/2026/zig/zstats/src/main.zig
@@ -0,0 +1,81 @@
+const std = @import("std");
+
+pub fn main(init: std.process.Init) !void {
+    var args = try init.minimal.args.iterateAllocator(init.gpa);
+    defer args.deinit();
+
+    _ = args.skip();
+
+    const path = args.next() orelse {
+        std.debug.print("usage: zstats <file>\n", .{});
+        return;
+    };
+
+    const line_count = try countLinesInFile(init.io, path);
+    std.debug.print("{s}: {} lines\n", .{ path, line_count });
+}
+
+fn countLinesInFile(io: std.Io, path: []const u8) !usize {
+    const cwd = std.Io.Dir.cwd();
+
+    var file = try cwd.openFile(io, path, .{});
+    defer file.close(io);
+
+    // Internal buffer owned by the file reader.
+    var file_buf: [4096]u8 = undefined;
+    var reader = file.readerStreaming(io, &file_buf);
+
+    // Application-level chunk buffer. We process one chunk at a time.
+    var chunk: [1024]u8 = undefined;
+
+    var line_count: usize = 0;
+    var saw_any_bytes = false;
+    var last_byte_was_newline = false;
+
+    while (true) {
+        const n = try reader.interface.readSliceShort(&chunk);
+        if (n == 0) break;
+
+        saw_any_bytes = true;
+        for (chunk[0..n]) |byte| {
+            if (byte == '\n') line_count += 1;
+        }
+        last_byte_was_newline = chunk[n - 1] == '\n';
+    }
+
+    if (saw_any_bytes and !last_byte_was_newline) {
+        line_count += 1;
+    }
+
+    return line_count;
+}
+
+test "counts lines in empty text" {
+    try std.testing.expectEqual(@as(usize, 0), countLinesFromSlice(""));
+}
+
+test "counts newline terminated lines" {
+    try std.testing.expectEqual(@as(usize, 3), countLinesFromSlice("a\nb\nc\n"));
+}
+
+test "counts final line without trailing newline" {
+    try std.testing.expectEqual(@as(usize, 3), countLinesFromSlice("a\nb\nc"));
+}
+
+fn countLinesFromSlice(data: []const u8) usize {
+    var line_count: usize = 0;
+    var saw_any_bytes = false;
+    var last_byte_was_newline = false;
+
+    for (data) |byte| {
+        saw_any_bytes = true;
+        if (byte == '\n') line_count += 1;
+        last_byte_was_newline = byte == '\n';
+    }
+
+    if (saw_any_bytes and !last_byte_was_newline) {
+        line_count += 1;
+    }
+
+    return line_count;
+}
