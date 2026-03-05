const std = @import("std");

// Program to count lines
pub fn main(init: std.process.Init) !void {

    // Get file Path from cli
    var args = try init.minimal.args.iterateAllocator(init.gpa);
    defer args.deinit();

    _ = args.skip(); // skip fileName

    // Get file name
    const FileName = args.next() orelse {
        std.debug.print("Please provide a file name \n", .{});
        return;
    };

    var it = std.mem.splitScalar(u8, FileName, '=');

    const key = it.next().?;
    const value = it.next().?;
    std.debug.print("File {s}: {s} \n", .{ key, value });

    // Extract path -- dummy.txt
    const path = args.next() orelse {
        std.debug.print("File not found: <file> \n", .{});
        return;
    };

    // File handler
    const io = init.io;
    const cwd = std.Io.Dir.cwd();

    // Open file and handle exception
    // File in not the "content itself"
    // file is OS file handle
    // OS handles read/write -> we just borrow an interface via sys call ("Descriptor") to do IO on file, kernel does the real work (A tracks the position of read bytes,etc)
    // our program cant directly write on DISK(ssd,hdd)
    const file = cwd.openFile(io, path, .{}) catch |err| {
        std.debug.print("Failed to open file ERR:<{}> \n", .{err});
        return;
    };
    defer file.close(io);

    // allocate 4kb for "OS Memory Page"
    // why is 1byte slower than 4kb ?
    var buffOSBucket: [4096]u8 = undefined;

    // read file (content into buffer in chunks)
    var reader = file.reader(io, &buffOSBucket);
    // var reader = file.readStreaming(io, &buffOSBucket);

    // operation to check "\n" ASCII = 10
    // And count lines in fie
    // new buffer to find \n
    // chunk read
    var buffGlass: [4096]u8 = undefined;
    var lineCount: usize = 0;

    // Last line then + 1
    var sawAnyBytes = false;
    var lastByteWasNewLine = false;
    var totalBytes: usize = 0;

    // Total bytes read (Get it from OS METADATA)
    const stat = try file.stat(io);
    const total_bytes = stat.size;

    std.debug.print("stats of file Meta data {}\n", .{stat});

    while (true) {
        // Read bytes into glass
        // return how much bytes were read into glass
        const bytesRead = try reader.interface.readSliceShort(&buffGlass);
        totalBytes += bytesRead;
        if (bytesRead == 0) break;

        sawAnyBytes = true;

        for (buffGlass[0..bytesRead]) |byte| {
            if (byte == '\n') {
                lineCount += 1;
            }
        }

        lastByteWasNewLine = buffGlass[bytesRead - 1] == '\n';
    }

    if (sawAnyBytes and !lastByteWasNewLine) {
        lineCount += 1;
    }

    std.debug.print("Total bytes from OS meta data  : {} \n", .{total_bytes});

    std.debug.print("total bytes in file : {} \n", .{totalBytes});

    std.debug.print("Line in file : {} \n", .{lineCount});
}
