use extendr_api::prelude::*;
mod cvt;
use cvt::RomajiCvt;

#[extendr]
fn convert(input: String) -> Option<String> {
    let converter = RomajiCvt::new();
    if input.chars().all(|c| c.is_ascii_alphabetic() || c == '\'') {
        converter.from_romaji(input)
    } else {
        converter.to_romaji(input)
    }
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod audubon;
    fn convert;
}
