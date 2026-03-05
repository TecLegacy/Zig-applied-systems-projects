const std = @import("std");

pub fn main(init: std.process.Init) !void {

    // Get file Path from cli
    var args = try init.minimal.args.iterateAllocator(init.gpa);
    defer args.deinit();

    _ = args.skip(); // skip fileName

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
    // chunk read
    var buffOSBucket: [4096]u8 = undefined;

    // read file (content into buffer in chunks)
    var reader = file.reader(io, &buffOSBucket);
    // var reader = file.readStreaming(io, &buffOSBucket);

    // operation to check "\n" ASCII = 10
    // And count lines in fie
    // new buffer to find \n
    var buffGlass: [64]u8 = undefined;
    var lineCount: usize = 0;

    // Last line then + 1
    var sawAnyBytes = false;
    var lastByteWasNewLine = false;

    while (true) {
        const bytes_read = try reader.interface.readSliceShort(&buffGlass);
        if (bytes_read == 0) break;

        sawAnyBytes = true;

        for (buffGlass[0..bytes_read]) |byte| {
            if (byte == '\n') {
                lineCount += 1;
            }
        }

        lastByteWasNewLine = buffGlass[bytes_read - 1] == '\n';
    }

    if (sawAnyBytes and !lastByteWasNewLine) {
        lineCount += 1;
    }

    std.debug.print("Line in file : {} \n", .{lineCount});
}

// Read file From CLI
// fn filePath(args) !void {}
