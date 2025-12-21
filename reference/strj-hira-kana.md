# Convert Japanese text between hiragana and katakana representations.

These functions transform kana characters while preserving non-kana
characters. The conversion is based on a JavaScript implementation and
handles certain historical or contracted kana forms that are not covered
by standard Unicode transliteration alone.

## Usage

``` r
strj_hiraganize(text)

strj_katakanize(text)
```

## Arguments

- text:

  A character vector containing Japanese text.

## Value

A character vector with kana characters converted to the target script.

## Details

The conversion behavior is largely compatible with ICU-based
transliteration, with additional support for selected combined or
historical kana characters.

## Examples

``` r
strj_hiraganize(
  c(
    paste0(
      "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
      "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
      "\u3068\u304a\u3063\u305f\u98a8"
    ),
    "\u677f\u57a3\u6b7b\u30b9\U0002a708"
  )
)
#> [1] "あのいーはとーゔぉのすきとおった風" "板垣死すとも"                      
strj_katakanize(
  c(
    paste0(
      "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
      "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
      "\u3068\u304a\u3063\u305f\u98a8"
    ),
    "\u672c\u65e5\u309f\u304b\u304d\u6c37\u89e3\u7981"
  )
)
#> [1] "アノイーハトーヴォノスキトオッタ風" "本日ヨリカキ氷解禁"                
```
