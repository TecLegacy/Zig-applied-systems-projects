# Zig Plan Incremental Learning

## Week 1: Build a Strong `zstats`

### Day 1

- [ ] Accept one file path from CLI.
- [ ] Stream file in chunks (no full-file read).
- [ ] Print line count.
- [ ] Handle missing argument with usage message.

### Day 2

- [ ] Add byte count.
- [ ] Add word count (space/newline/tab separated).
- [ ] Keep all counts in one streaming pass.

### Day 3

- [ ] Support multiple file arguments.
- [ ] Print per-file counts.
- [ ] Print totals at end.

### Day 4

- [ ] Add flags: `-l`, `-w`, `-c`.
- [ ] Default behavior: print all three if no flags.
- [ ] Validate unknown flags with clear error.

### Day 5

- [ ] Refactor into functions: `parseArgs`, `countFile`, `printRow`.
- [ ] Use a `struct` for counts.
- [ ] Remove dead/commented code.

### Day 6

- [ ] Unit tests for counting logic (slice-based).
- [ ] Cover edge cases:
- [ ] empty file.
- [ ] trailing newline vs no trailing newline.
- [ ] multiple spaces/tabs/newlines.

### Day 7

- [ ] Integration check with real files in repo.
- [ ] Write README usage examples.
- [ ] Tag milestone `week1-zstats`.

## Week 2: More CLI Tools

### Day 8

- [ ] Create `zhead` project skeleton.
- [ ] Implement `zhead <file>` default 10 lines.

### Day 9

- [ ] Add `-n <count>` for `zhead`.
- [ ] Handle invalid `-n` values.

### Day 10

- [ ] Add tests for `zhead` line logic.
- [ ] Ensure streaming approach.

### Day 11

- [ ] Create `ztail` project skeleton.
- [ ] Implement last 10 lines.

### Day 12

- [ ] Add `-n <count>` for `ztail`.
- [ ] Handle large-file behavior without full load if possible.

### Day 13

- [ ] Add tests for `ztail` edge cases.
- [ ] Compare outputs with system `tail` on sample files.

### Day 14

- [ ] README updates for `zhead` and `ztail`.
- [ ] Cleanup naming/style.
- [ ] Tag milestone `week2-cli-tools`.

## Week 3: Build `zgrep`

### Day 15

- [ ] Create `zgrep` skeleton.
- [ ] Implement `zgrep <pattern> <file>` basic match print.

### Day 16

- [ ] Add line number output (`-n`).
- [ ] Keep line-buffered streaming.

### Day 17

- [ ] Add case-insensitive mode (`-i`).
- [ ] Add count-only mode (`-c`).

### Day 18

- [ ] Better argument parser and usage/help text.
- [ ] Clear error messages for bad invocation.

### Day 19

- [ ] Tests for pattern matching and flags.
- [ ] Validate no regressions in existing tools.

### Day 20

- [ ] README examples and quick benchmark notes.
- [ ] Tag milestone `week3-zgrep`.

## Week 4: Networking + Interop + Capstone

### Day 21

- [ ] Start tiny HTTP server project.
- [ ] Accept TCP connection, send static response.

### Day 22

- [ ] Parse request line (method/path/version).
- [ ] Route `/` and `/health`.

### Day 23

- [ ] Add structured logging per request.
- [ ] Improve error handling and status codes.

### Day 24

- [ ] Concurrency: handle multiple clients safely.
- [ ] Add graceful shutdown behavior.

### Day 25

- [ ] Add server tests for parser and routes.
- [ ] Document run instructions.

### Day 26

- [ ] C interop mini-task (`@cImport`) in separate folder.
- [ ] Wrap one tiny C call with Zig function.

### Day 27

- [ ] Capstone planning: one binary with subcommands.
- [ ] Define command layout and shared utilities.

### Day 28

- [ ] Implement shared CLI parser and common output formatting.
- [ ] Integrate at least two tools as subcommands.

### Day 29

- [ ] Final testing pass across all tools.
- [ ] Fix rough edges and naming inconsistencies.

### Day 30

- [ ] Final README + usage examples + lessons learned.
- [ ] Tag `v0.1.0`.
- [ ] Write retrospective: what improved, what next.

## Daily Notes Template

Use this at end of each day:

```md
### Day X Notes

- Built:
- Bugs found/fixed:
- Zig concept learned:
- What was hard:
- Next day focus:
```

## Minimum Quality Bar

- Every feature path has at least one success test.
- Every user-facing failure has a readable error message.
- No hidden allocations unless intentional.
- Close/free resources with `defer`.
- Keep functions small and explicit.
