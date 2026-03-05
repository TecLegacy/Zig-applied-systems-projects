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
// const std = @import("std");

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

// pub fn main(init: std.process.Init) !void {
//     // Read CLI argument

//     var args = try init.minimal.args.iterateAllocator(init.gpa);
//     defer args.deinit();

//     // std.debug.print("All arguments {}", .{args});

//     _ = args.skip(); // skip first filename

//     // / without ORELSE cli parsing
//     // while (args.next()) |arg| {
//     //     std.debug.print("All arguments {s} \n", .{arg});
//     // }

//     // ORELSE OPTIONAL HANDLING
//     const path = args.next() orelse {
//         std.debug.print("<Missing : File not found!> \n", .{});
//         return;
//     };

//     std.debug.print("File Path {s} \n", .{path});

//     // then open file
//     const io = init.io;
//     const cwd = std.Io.Dir.cwd();
//     // const gpa = init.gpa;

//     const file = try cwd.openFile(io, path, .{});
//     defer file.close(io);

//     // 4kb OS MEMORY PAGE
//     var file_buf: [4096]u8 = undefined;
//     // var reader = file.reader(io, &file_buf);
//     const reader = file.reader(io, &file_buf);

//     var lineCount: i32 = 0;

//     while (true) {}

//     std.debug.print("{}\n", .{reader});

//     // const data = try reader.interface.readAlloc(gpa, 12);
//     // const data = try reader.interface.readAlloc(gpa, 44);
//     // defer gpa.free(data);

//     // std.debug.print("{s}\n", .{data});
// }

// ================
// --- ZSTATS API ---

const std = @import("std");

// pub fn main(init: std.process.Init) !void {
//     var args = try init.minimal.args.iterateAllocator(init.gpa);
//     defer args.deinit();

//     _ = args.skip(); // skip executable name

//     const path = args.next() orelse {
//         std.debug.print("Usage: zstats <file>\n", .{});
//         return;
//     };

//     const io = init.io;
//     const cwd = std.Io.Dir.cwd();

//     var file = try cwd.openFile(io, path, .{});
//     defer file.close(io);

//     var file_buf: [4096]u8 = undefined;
//     var reader = file.readerStreaming(io, &file_buf);

//     var buffer: [1024]u8 = undefined;
//     var line_count: usize = 0;
//     var saw_any_bytes = false;
//     // var last_byte_was_newline = false;

//     while (true) {
//         const bytes_read = try reader.interface.readSliceShort(&buffer);
//         if (bytes_read == 0) break;

//         saw_any_bytes = true;
//         for (buffer[0..bytes_read]) |byte| {
//             if (byte == '\n') line_count += 1;
//         }
//         // last_byte_was_newline = buffer[bytes_read - 1] == '\n';
//     }

//     // if (saw_any_bytes and !last_byte_was_newline) {
//     //     line_count += 1;
//     // }

//     std.debug.print("Lines: {}\n", .{line_count});
// }

pub fn ver1(init: std.process.Init) !void {
    const io = init.io;
    const gpa = init.gpa;
    const cwd = std.Io.Dir.cwd();

    var file = try cwd.openFile(io, "example.txt", .{});
    defer file.close(io);

    // why doe we need a reader
    // what does file reader do ?
    //
    var file_buf: [1024]u8 = undefined;
    var reader = file.reader(io, &file_buf);

    // Reads whole file ( to heap)
    const data = try reader.interface.readAlloc(gpa, 12);
    defer gpa.free(data);
    std.debug.print("{s}\n", .{data});

    // Reads into a fixed size buffer ( stack )
    var out: [256]u8 = undefined;
    // this is bytes reading from file
    const n = try reader.interface.readSliceShort(&out);

    std.debug.print("{s}\n", .{out[0..n]});
}
