const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const hermes = b.addStaticLibrary(.{
        .name = "hermes",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    hermes.addIncludePath(.{ .path = "modules/hermes/include/" });
    hermes.addIncludePath(.{ .path = "modules/hermes/public/" });
    hermes.addIncludePath(.{ .path = "modules/hermes/external/llvh/include/" });
    hermes.addIncludePath(.{ .path = "modules/hermes/API/jsi/" });
    hermes.linkLibCpp();
    hermes.addCSourceFiles(&.{"modules/hermes/API/hermes/hermes.cpp"}, &.{});

    const exe = b.addExecutable(.{
        .name = "le",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.addIncludePath(.{ .path = "modules/hermes/include/" });
    exe.addIncludePath(.{ .path = "modules/hermes/public/" });
    exe.addIncludePath(.{ .path = "modules/hermes/external/llvh/include/" });
    exe.addIncludePath(.{ .path = "modules/hermes/API/jsi/" });
    exe.linkLibCpp();
    exe.linkLibrary(hermes);
    exe.addCSourceFiles(&.{"modules/hermes/API/hermes/hermes.cpp"}, &.{});

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
