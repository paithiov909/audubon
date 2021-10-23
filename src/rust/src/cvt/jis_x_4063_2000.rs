// This file is a part of yumetodo/romaji_kana_cvt_rust
// derived from https://github.com/yumetodo/romaji_kana_cvt_rust
// Copyright yumetodo <yume-wikijp at live.jp>

use std::collections::HashMap;

// We will follow the definition of JIS X 4063:2000 even though that was already obsolete.
const TABLE1: [(&str,  &str); 6] = [
//from JIS X 4063:2000: must
    ("a", "あ"), ("i", "い"), ("u", "う"), ("e", "え"), ("o", "お"),
    ("n", "ん")
];
const TABLE2: [(&str,  &str); 204] = [
//from JIS X 4063:2000: must
    ("ka", "か"), ("ki", "き"), ("ku", "く"), ("ke", "け"), ("ko", "こ"),
    ("ga", "が"), ("gi", "ぎ"), ("gu", "ぐ"), ("ge", "げ"), ("go", "ご"),
    ("sa", "さ"), ("si", "し"), ("su", "す"), ("se", "せ"), ("so", "そ"),
    ("shi", "し"),
    ("za", "ざ"), ("zi", "じ"), ("zu", "づ"), ("ze", "ぜ"), ("zo", "ぞ"),
    ("ji", "じ"),
    ("ta", "た"), ("ti", "ち"), ("tu", "つ"), ("te", "て"), ("to", "と"),
    ("chi", "ち"), ("tsu", "つ"),
    ("da", "だ"), ("di", "ぢ"), ("du", "づ"), ("de", "で"), ("do", "ど"),
    ("na", "な"), ("ni", "に"), ("nu", "ぬ"), ("ne", "ね"), ("no", "の"),
    ("ha", "は"), ("hi", "ひ"), ("hu", "ふ"), ("he", "へ"), ("ho", "ほ"),
    ("fu", "ふ"),
    ("ba", "ば"), ("bi", "び"), ("bu", "ぶ"), ("be", "べ"), ("bo", "ぼ"),
    ("pa", "ぱ"), ("pi", "ぴ"), ("pu", "ぷ"), ("pe", "ぺ"), ("po", "ぽ"),
    ("ma", "ま"), ("mi", "み"), ("mu", "む"), ("me", "め"), ("mo", "も"),
    ("ya", "や"),               ("yu", "ゆ"),               ("yo", "よ"),
    ("ra", "ら"), ("ri", "り"), ("ru", "る"), ("re", "れ"), ("ro", "ろ"),
    ("ra", "ら"), ("ri", "り"), ("ru", "る"), ("re", "れ"), ("ro", "ろ"),
    ("wa", "わ"), ("wyi", "ゐ"),              ("wye", "ゑ"), ("wo", "を"),
    ("nn", "ん"), ("n'", "ん"),
    ("kya", "きゃ"),            ("kyu", "きゅ"),            ("kyo", "きょ"),
    ("gya", "ぎゃ"),            ("gyu", "ぎゅ"),            ("gyo", "ぎょ"),
    ("sya", "しゃ"),            ("syu", "しゅ"),            ("syo", "しょ"),
    ("sha", "しゃ"),            ("shu", "しゅ"),            ("sho", "しょ"),
    ("zya", "じゃ"),            ("zyu", "じゅ"),            ("zyo", "じょ"),
    ("ja", "じゃ"),             ("ju", "じゅ"),             ("jo", "じょ"),
    ("tya", "ちゃ"),            ("tyu", "ちゅ"),            ("tyo", "ちょ"),
    ("cha", "ちゃ"),            ("chu", "ちゅ"),            ("cho", "ちょ"),
    ("dya", "ぢゃ"),            ("dyu", "ぢゅ"),            ("dyo", "ぢょ"),
    ("nya", "にゃ"),            ("nyu", "にゅ"),            ("nyo", "にょ"),
    ("hya", "ひゃ"),            ("hyu", "ひゅ"),            ("hyo", "ひょ"),
    ("bya", "びゃ"),            ("byu", "びゅ"),            ("byo", "びょ"),
    ("pya", "ぴゃ"),            ("pyu", "ぴゅ"),            ("pyo", "ぴょ"),
    ("mya", "みゃ"),            ("myu", "みゅ"),            ("myo", "みょ"),
    ("rya", "りゃ"),            ("ryu", "りゅ"),            ("ryo", "りょ"),
    ("kya", "きゃ"),            ("kyu", "きゅ"),            ("kyo", "きょ"),
    ("kya", "きゃ"),            ("kyu", "きゅ"),            ("kyo", "きょ"),
    ("sye", "しぇ"), ("she", "しぇ"),
    ("zye", "じぇ"), ("je", "じぇ"),
    ("tye", "ちぇ"), ("che", "ちぇ"),
    ("dye", "ぢぇ"),
    ("tsa", "つぁ"),                       ("tse", "つぇ"), ("tso", "つぉ"),
    ("thi", "てぃ"),
    ("dhi", "でぃ"), ("dhu", "でゅ"),
    ("fa", "ふぁ"), ("fi", "ふぃ"),          ("fe", "ふぇ"), ("fo", "ふぉ"),
    ("xa", "ぁ"), ("xi", "ぃ"), ("xu", "ぅ"), ("xe", "ぇ"), ("xo", "ぉ"),
    ("xka", "ヵ"), ("xke", "ヶ"),
    ("xtu", "っ"),
    ("xya", "ゃ"),              ("xyu", "ゅ"),              ("xyo", "ょ"),
    ("xwa", "ゎ"),
//from JIS X 4063:2000: optional
    ("ye", "いぇ"),
    ("whi", "うぃ"), ("whe", "うぇ"),
    ("wi", "うぃ"), ("we", "うぇ"),
    ("va", "ゔぁ"), ("vi", "ゔぃ"), ("vu", "ゔ"), ("ve", "ゔぇ"), ("vo", "ゔぉ"),
    ("vyu", "ゔゅ"),
    ("kwa", "くぁ"), ("kwi", "くぃ"),          ("kwe", "くぇ"), ("kwo", "くぉ"),
    ("qa", "くぁ"), ("qi", "くぃ"),            ("qe", "くぇ"),  ("qo", "くぉ"),
    ("gwa", "ぐぁ"),
    ("jya", "じゃ"),            ("jyu", "じゅ"),            ("jyo", "じょ"),
    ("cya", "ちゃ"),            ("cyu", "ちゅ"),            ("cyo", "ちょ"),
    ("tsi", "つぃ"),
    ("thi", "てぃ"), ("t'i", "てぃ"),
    ("dhi", "でぃ"), ("d'i", "でぃ"),
    ("thu", "てゅ"), ("t'yu", "てゅ"),
    ("d'yu", "でゅ"),
    ("twu", "とぅ"), ("t'u", "とぅ"),
    ("dwu", "どぅ"), ("d'u", "どぅ"),
    ("hwa", "ふぁ"), ("hwi", "ふぃ"),          ("hwe", "ふぇ"), ("hwo", "ふぉ"),
    ("fyu", "ふゅ"), ("hwyu", "ふゅ"),
    ("xtsu", "っ"),
    //("^", "ー"),
];

pub fn make_from_romaji_table() -> [HashMap<&'static str, &'static str>; 2]{
    [
        TABLE1.iter().cloned().collect(),
        TABLE2.iter().cloned().collect()
    ]
}

pub fn make_to_romaji_table() -> HashMap<&'static str, &'static str> {
    let mut t: Vec<_> = [
        TABLE2.iter().map(|(s1, s2)| (*s2, *s1)).collect::<Vec<_>>(),
        TABLE1.iter().map(|(s1, s2)| (*s2, *s1)).collect::<Vec<_>>(),
    ].concat();
    t.sort_by(|a, b| a.0.cmp(b.0));
    t.dedup_by(|a, b| a.0.eq(b.0));
    t.iter().cloned().collect()
}

pub fn make_ctab() -> String {
    let mut ctab = TABLE2.iter().map(|(s, _)| *s).map(|s| s.chars().next().unwrap()).collect::<Vec<_>>();
    ctab.sort_unstable();
    ctab.dedup();
    ctab.iter().cloned().collect()
}

pub fn make_two_glyph_second_list() -> String {
    let mut two_glyph_second_list = TABLE2.iter()
        .map(|(_, s)| *s)
        .filter(|s| s.chars().count() == 2)
        .map(|s| s.chars().nth(1).unwrap()).collect::<Vec<_>>();
    two_glyph_second_list.sort_unstable();
    two_glyph_second_list.dedup();
    two_glyph_second_list.iter().cloned().collect()
}
mod test {
    #[test]
    fn make_from_romaji_table() {
        let table = super::make_from_romaji_table();
        assert_eq!(Some("あ".to_string()), table[0].get("a").map(|s| s.to_string()));
        assert_eq!(Some("ちゃ".to_string()), table[1].get("tya").map(|s| s.to_string()));
        assert_eq!(Some("ちゃ".to_string()), table[1].get("cha").map(|s| s.to_string()));
    }
    #[test]
    fn make_to_romaji_table() {
        let table = super::make_to_romaji_table();
        assert_eq!(Some("a".to_string()), table.get("あ").map(|s| s.to_string()));
        assert_eq!(Some("tya".to_string()), table.get("ちゃ").map(|s| s.to_string()));
    }
    #[test]
    fn make_ctab() {
        let ctab_from_table = super::make_ctab();
        let mut ctab = "bcdfghjkmnpqrstvwxyz".chars().collect::<Vec<_>>();
        ctab.sort();
        ctab.dedup();
        assert_eq!(ctab.iter().cloned().collect::<String>(), ctab_from_table);
    }

    #[test]
    fn make_two_glyph_second_list() {
        let list = super::make_two_glyph_second_list();
        assert_eq!("ぁぃぅぇぉゃゅょ".to_string(), list);
    }
}
