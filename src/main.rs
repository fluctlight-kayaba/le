use std::fs;

use rusty_jsc::{JSContext, JSValue};
use rusty_jsc_macros::callback;

#[callback]
fn log(ctx: JSContext, _function: _, _this: _, args: &[JSValue]) -> Result<JSValue, JSValue> {
	for i in 0..args.len() {
		print!("{} ", args[i].to_string(&ctx).unwrap());
	}
	println!("");
	Ok(JSValue::undefined(&ctx))
}

#[callback]
fn set_timeout(
	ctx: JSContext,
	_function: _,
	_this: _,
	args: &[JSValue],
) -> Result<JSValue, JSValue> {
	let callback_function = args[0]
		.to_object(&ctx)
		.unwrap()
		.call(&ctx, None, &[JSValue::string(&ctx, "Tom")])
		.unwrap();

	Ok(callback_function)
}

#[tokio::main]
async fn main() {
	let js_source_code = fs::read_to_string("target/script/index.js")
		.expect("Could not read scripting source code, consider run [bun build] command generate!");

	let mut context = JSContext::default();
	let log_callback = JSValue::callback(&context, Some(log));
	let timeout_callback = JSValue::callback(&context, Some(set_timeout));
	let global = context.get_global_object();
	let console = global
		.get_property(&context, "console")
		.to_object(&context)
		.unwrap();

	global
		.set_property(&context, "setTimeout", timeout_callback)
		.unwrap();
	console.set_property(&context, "log", log_callback).unwrap();

	match context.evaluate_script(&js_source_code, 1) {
		Ok(value) => {
			println!("{}", value.to_string(&context).unwrap());
		}
		Err(e) => {
			println!("Uncaught: {}", e.to_string(&context).unwrap())
		}
	}
}
