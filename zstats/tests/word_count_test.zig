const std = @import("std");
const app = @import("../src/main.zig");

// Unit testing
// test behavior, not implementation
// be deterministic
test "Counting words in a file" {
    const fileContent = "Hello word";
    var in_word: bool = false;
    var word_count: usize = 0;

    app.countWordsInChunk(fileContent, &in_word, &word_count);

    try std.testing.expectEqual(@as(usize, 2), word_count);
}
