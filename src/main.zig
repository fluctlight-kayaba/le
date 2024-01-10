const std = @import("std");
const js = @import("./JavascriptCore.zig");

var allocator = std.heap.c_allocator;

fn logFromJavascript(
    ctx: js.JSContextRef,
    function: js.JSObjectRef,
    this: js.JSObjectRef,
    argument_count: usize,
    _arguments: [*c]const js.JSValueRef,
    except: [*c]js.JSValueRef,
) callconv(.C) js.JSValueRef {
    _ = except;
    _ = this;
    _ = function;
    const args = _arguments[0..argument_count];
    var input: js.JSStringRef = js.JSValueToStringCopy(ctx, args[0], null);

    var buffer = allocator.alloc(u8, js.JSStringGetMaximumUTF8CStringSize(input)) catch unreachable;
    defer allocator.free(buffer);

    const string_length = js.JSStringGetUTF8CString(input, buffer.ptr, buffer.len);
    const string = buffer[0..string_length];

    var stdout = std.io.getStdOut();

    stdout.writeAll(string) catch {};

    return js.JSValueMakeUndefined(ctx);
}

export fn sayHello() void {
    var context_group: js.JSContextGroupRef = js.JSContextGroupCreate();
    var global_context: js.JSGlobalContextRef = js.JSGlobalContextCreateInGroup(context_group, null);
    var global_object: js.JSObjectRef = js.JSContextGetGlobalObject(global_context);
    var log_function_name: js.JSStringRef = js.JSStringCreateWithUTF8CString("log"[0.. :0]);
    var function: js.JSObjectRef = js.JSObjectMakeFunctionWithCallback(global_context, log_function_name, logFromJavascript);
    var log_call_statement: js.JSStringRef = js.JSStringCreateWithUTF8CString("log('Hello ' + 5 * 2 + ' from JavaScript inside Zig');"[0.. :0]);
    js.JSObjectSetProperty(global_context, global_object, log_function_name, function, js.kJSPropertyAttributeNone, null);
    const ret = js.JSEvaluateScript(global_context, log_call_statement, null, null, 1, null);
    _ = ret;

    js.JSGlobalContextRelease(global_context);
    js.JSContextGroupRelease(context_group);
    js.JSStringRelease(log_function_name);
    js.JSStringRelease(log_call_statement);
}

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    sayHello();

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
