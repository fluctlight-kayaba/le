use rusty_v8 as v8;
use std::fs;

fn main() {
	let platform = v8::new_default_platform(0, false).make_shared();
	v8::V8::initialize_platform(platform);
	v8::V8::initialize();

	{
		let isolate = &mut v8::Isolate::new(v8::CreateParams::default());
		let handle_scope = &mut v8::HandleScope::new(isolate);
		let context = v8::Context::new(handle_scope);
		let scope = &mut v8::ContextScope::new(handle_scope, context);

		let object_template = v8::ObjectTemplate::new(scope);
		let function_template = v8::FunctionTemplate::new(scope, print);
		let name = v8::String::new(scope, "print").unwrap();

		object_template.set(name.into(), function_template.into());
		let context = v8::Context::new_from_template(scope, object_template);
		let scope = &mut v8::ContextScope::new(scope, context);

		let source =
			fs::read_to_string("target/script/index.js").expect("Could not scripting read source code");
		let code = v8::String::new(scope, &source).unwrap();

		let script = v8::Script::compile(scope, code, None).unwrap();
		let result = script.run(scope).unwrap();
		let result = result.to_string(scope).unwrap();

		println!("{}", result.to_rust_string_lossy(scope));
	}

	unsafe {
		v8::V8::dispose();
	}

	v8::V8::shutdown_platform();
}

fn print(
	scope: &mut v8::HandleScope,
	args: v8::FunctionCallbackArguments,
	mut _rv: v8::ReturnValue,
) {
	let result = args
		.get(0)
		.to_string(scope)
		.unwrap()
		.to_rust_string_lossy(scope);

	println!("print: {}", result);
}
