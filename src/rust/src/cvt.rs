// This file is a part of yumetodo/romaji_kana_cvt_rust
// derived from https://github.com/yumetodo/romaji_kana_cvt_rust
// Copyright yumetodo <yume-wikijp at live.jp>

mod jis_x_4063_2000;
extern crate unicode_normalization;
use log::info;
// use unicode_normalization::char::compose;
use unicode_normalization::UnicodeNormalization;
use std::collections::HashMap;
use std::iter;

#[derive(Debug)]
pub struct RomajiCvt {
    from_romaji_table: [HashMap<&'static str, &'static str>; 2],
    to_romaji_table: HashMap<&'static str, &'static str>,
    ctab: String,
    two_glyph_second_list: String
}
impl RomajiCvt {
    const VOWEL: &'static str = "aiueo";
    pub fn new() -> Self {
        Self {
            from_romaji_table: jis_x_4063_2000::make_from_romaji_table(),
            to_romaji_table: jis_x_4063_2000::make_to_romaji_table(),
            ctab: jis_x_4063_2000::make_ctab(),
            two_glyph_second_list: jis_x_4063_2000::make_two_glyph_second_list()
        }
    }

    fn is_consonant(&self, c: char) -> bool {
        self.ctab.contains(c)
    }
    fn convert_sokuonn_and_the_sound_of_the_kana_n(&self, s: &str) -> Option<(String, usize)> {
        info!("convert_sokuonn_and_the_sound_of_the_kana_n:: s: {}", s);
        let mut it = s.chars();
        let c1 = it.next()?;
        let cnt = it.take_while(|c| c1 == *c).count();
        if 'n' == c1 {
            info!("convert_sokuonn_and_the_sound_of_the_kana_n:: n detected");
            let kana_cnt = (cnt + 1) / 2;
            if 0 == kana_cnt {
                if '\'' == s.chars().nth(1)? {
                    info!("convert_sokuonn_and_the_sound_of_the_kana_n:: n' detected");
                    Some(('ん'.to_string(), 2))
                } else if self.is_consonant(s.chars().nth(1)?) {
                    info!("convert_sokuonn_and_the_sound_of_the_kana_n:: n{} detected", s.chars().nth(1)?);
                    Some(('ん'.to_string(), 1))
                } else {
                    None
                }
            } else {
                info!("convert_sokuonn_and_the_sound_of_the_kana_n:: nn detected ({})", kana_cnt);
                Some((iter::repeat('ん').take(kana_cnt).collect::<String>(), kana_cnt * 2))
            }
        } else if 0 == cnt {
            None
        } else if self.is_consonant(c1) {
            info!("convert_sokuonn_and_the_sound_of_the_kana_n:: {} detected ({})", c1, cnt);
            Some((iter::repeat('っ').take(cnt).collect::<String>(), cnt))
        } else {
            None
        }
    }
    fn from_romaji_impl(&self, s: &str) -> Option<String> {
        info!("from_romaji_impl:: s: {}", s);
        match s.len() {
            3 | 4 => {
                if let Some(converted) = self.from_romaji_table[1].get(s) {
                    Some(converted.to_string())
                } else {
                    let (converted, cnt) = self.convert_sokuonn_and_the_sound_of_the_kana_n(s)?;
                    Some(converted + &self.from_romaji_impl(&s.chars().skip(cnt).collect::<String>())?)
                }
            },
            2 => {
                self.from_romaji_table[1].get(s).map(|converted| converted.to_string())
            },
            1 => {
                self.from_romaji_table[0].get(s).map(|converted| converted.to_string())
            }
            _ => {
                let (converted, cnt) = self.convert_sokuonn_and_the_sound_of_the_kana_n(s)?;
                Some(converted + &self.from_romaji_impl(&s.chars().skip(cnt).collect::<String>())?)
            }
        }
    }
    pub fn from_romaji(&self, input: String) -> Option<String> {
        let mut re = String::with_capacity(input.len() * 2);
        let mut prev_i = 0;
        for (index, _) in input.match_indices(|c| Self::VOWEL.contains(c)) {
            let s = self.from_romaji_impl(&input[prev_i..=index])?;
            re += &s;
            prev_i = index + 1;
        }
        if prev_i != input.len() {
            let s = self.from_romaji_impl(&input[prev_i..])?;
            re += &s;
        }
        Some(re)
    }
    pub fn to_romaji(&self, input: String) -> Option<String> {
        //apply NFC uniform.
        //ex.) で(U+3066, U+3099) => で(U+3067)
        let s = input.nfc().collect::<String>();
        let mut re = String::with_capacity(input.len() * 3);
        let mut prev_c = '\0';
        let mut prev_sokuonn_count = 0;
        for c in s.chars() {
            info!("to_romaji:: c: {}", c);
            if '\0' == prev_c {
                info!("to_romaji:: prev_c is empty. store {}", c);
                prev_c = c;
                continue;
            }
            if 'っ' == prev_c {
                prev_c = c;
                prev_sokuonn_count += 1;
                info!("to_romaji:: `っ` found. prev_c: {}, prev_sokuonn_count: {}", prev_c, prev_sokuonn_count);
                continue;
            }
            let (key, next_c) = if self.two_glyph_second_list.contains(c) {
                (format!("{}{}", prev_c, c), '\0')
            } else {
                (prev_c.to_string(), c)
            };
            let key_str: &str = &key;
            let append = self.to_romaji_table.get(key_str)?;
            info!("to_romaji:: key: {}, append: {}, next_c: {}", key, append, next_c);
            if 0 != prev_sokuonn_count {
                let sokuonn = iter::repeat(append.chars().next()?).take(prev_sokuonn_count).collect::<String>();
                info!("to_romaji:: prev_sokuonn_count: {}, create sokuonn => {}", prev_sokuonn_count, sokuonn);
                re += &sokuonn;
                prev_sokuonn_count = 0;
            }
            re += append;
            prev_c = next_c;
        }
        info!("to_romaji:: prev_sokuonn_count: {}, prev_c: {}", prev_sokuonn_count, prev_c);
        if '\0' != prev_c {
            let key: &str = &prev_c.to_string();
            let append = self.to_romaji_table.get(key)?;
            if 0 != prev_sokuonn_count {
                let sokuonn = iter::repeat(append.chars().next()?).take(prev_sokuonn_count).collect::<String>();
                info!("to_romaji:: prev_sokuonn_count: {}, create sokuonn => {}", prev_sokuonn_count, sokuonn);
                re += &sokuonn;
            }
            re += append
        }
        Some(re)
    }
}

mod test {
    // use log::LevelFilter;
    #[test]
    fn convert_sokuonn_and_the_sound_of_the_kana_n() {
        let cvt = super::RomajiCvt::new();
        assert_eq!(Some(("ん".to_string(), 2)), cvt.convert_sokuonn_and_the_sound_of_the_kana_n("nnna"));
        assert_eq!(Some(("っっ".to_string(), 2)), cvt.convert_sokuonn_and_the_sound_of_the_kana_n("kkkoro"));
    }
    #[test]
    fn from_romaji() {
        let cvt = super::RomajiCvt::new();
        assert_eq!(Some("ありきたり".to_string()), cvt.from_romaji("arikitari".to_string()));
        assert_eq!(Some("んなばかな".to_string()), cvt.from_romaji("nnnabakana".to_string()));
        assert_eq!(Some("なんてこったい".to_string()), cvt.from_romaji("nanntekottai".to_string()));
        assert_eq!(Some("しったこっちゃない".to_string()), cvt.from_romaji("sittakottyanai".to_string()));
        assert_eq!(Some("むっ".to_string()), cvt.from_romaji("muxtu".to_string()));
        assert_eq!(Some("くっっころ".to_string()), cvt.from_romaji("kukkkoro".to_string()));
        assert_eq!(Some("さんばし".to_string()), cvt.from_romaji("san'basi".to_string()));
        assert_eq!(Some("なんでやねん".to_string()), cvt.from_romaji("nandeyanen".to_string()));
    }
    #[test]
    fn to_romaji() {
        // simple_logging::log_to_stderr(LevelFilter::Info);
        let cvt = super::RomajiCvt::new();
        assert_eq!(Some("arikitari".to_string()), cvt.to_romaji("ありきたり".to_string()));
        assert_eq!(Some("nnnabakana".to_string()), cvt.to_romaji("んなばかな".to_string()));
        assert_eq!(Some("nanntekottai".to_string()), cvt.to_romaji("なんてこったい".to_string()));
        assert_eq!(Some("sittakottyanai".to_string()), cvt.to_romaji("しったこっちゃない".to_string()));
        assert_eq!(Some("muxtu".to_string()), cvt.to_romaji("むっ".to_string()));
        assert_eq!(Some("muxxtu".to_string()), cvt.to_romaji("むっっ".to_string()));
        assert_eq!(Some("kukkkoro".to_string()), cvt.to_romaji("くっっころ".to_string()));
    }
}
