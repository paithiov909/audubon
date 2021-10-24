use extendr_api::prelude::*;
mod cvt;
use cvt::RomajiCvt;

#[extendr]
fn to_kana(input: String) -> Option<String> {
    let converter = RomajiCvt::new();
    converter.from_romaji(input)
}

#[extendr]
fn to_roman(input: String) -> Option<String> {
    let converter = RomajiCvt::new();
    converter.to_romaji(input)
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod audubon;
    fn to_kana;
    fn to_roman;
}
