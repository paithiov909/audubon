
<!-- README.md is generated from README.Rmd. Please edit that file -->

# audubon <a href='https://paithiov909.github.io/audubon/'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![audubon status
badge](https://paithiov909.r-universe.dev/badges/audubon)](https://paithiov909.r-universe.dev)
[![R-CMD-check](https://github.com/paithiov909/audubon/workflows/R-CMD-check/badge.svg)](https://github.com/paithiov909/audubon/actions)
[![codecov](https://codecov.io/gh/paithiov909/audubon/branch/master/graph/badge.svg?token=LWH2AFDEMY)](https://app.codecov.io/gh/paithiov909/audubon)
[![CRAN logs
badge](https://cranlogs.r-pkg.org/badges/audubon)](https://cran.r-project.org/package=audubon)
<!-- badges: end -->

audubon is Japanese text processing tools for:

- filling Japanese iteration marks
- hiraganization, katakanization and romanization using
  [hakatashi/japanese.js](https://github.com/hakatashi/japanese.js)
- segmentation by phrase using
  [google/budoux](https://github.com/google/budoux) and
  ‘TinySegmenter.js’
- text normalization which is based on rules for the ‘Sudachi’
  morphological analyzer and the ‘NEologd’ (Neologism dictionary for
  ‘MeCab’).

Some features above are not implemented in ‘ICU’ (i.e., the stringi
package), and the goal of the audubon package is to provide these
additional features.

## Installation

``` r
remotes::install_github("paithiov909/audubon")
```

## Usage

### Fill Japanese iteration marks (Odori-ji)

`strj_fill_iter_mark` repeats the previous character and replaces the
iteration marks if the element has more than 5 characters. You can use
this feature with `strj_normalize` or `strj_rewrite_as_def`.

``` r
strj_fill_iter_mark(c(
  "あいうゝ〃かき",
  "金子みすゞ",
  "のたり〳〵かな",
  "しろ／″＼とした"
))
#> [1] "あいうううかき"  "金子みすすﾞ"     "のたりたりかな"  "しろしﾞろとした"

strj_fill_iter_mark("いすゞエルフトラック") |>
  strj_normalize()
#> [1] "いすずエルフトラック"
```

### Character class conversion

Character class conversion uses
[hakatashi/japanese.js](https://github.com/hakatashi/japanese.js).

``` r
strj_hiraganize("あのイーハトーヴォのすきとおった風")
#> [1] "あのいーはとーゔぉのすきとおった風"
strj_katakanize("あのイーハトーヴォのすきとおった風")
#> [1] "アノイーハトーヴォノスキトオッタ風"
strj_romanize("あのイーハトーヴォのすきとおった風")
#> [1] "anoīhatōvonosukitōtta"
```

### Segmentation by phrase

`strj_tokenize` splits Japanese text into some phrases using
[google/budoux](https://github.com/google/budoux), TinySegmenter, or
other tokenizers.

``` r
strj_tokenize("あのイーハトーヴォのすきとおった風", engine = "budoux")
#> $`1`
#> [1] "あの"             "イーハトーヴォの" "すきとおった"     "風"
```

### Japanese text normalization

`strj_normalize` normalizes text following the rule based on
[NEologd](https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja)
style.

``` r
strj_normalize("――南アルプスの　天然水-　Ｓｐａｒｋｉｎｇ*　Ｌｅｍｏｎ+　レモン一絞り")
#> [1] "ー南アルプスの天然水-Sparking* Lemon+レモン一絞り"
```

`strj_rewrite_as_def` is an R port of
[SudachiCharNormalizer](https://gist.github.com/sorami/bde9d441a147e0fc2e6e5fdd83f4f770)
that typically normalizes characters following a ’\*.def’ file.

audubon package contains several ’\*.def’ files, so you can use them or
write a ‘rewrite.def’ file by yourself as follows.

    # single characters will **never** be normalized.
    …
    # if two characters are separated with a tab,
    # left side forms are always rewritten to right side forms
    # before normalized.
    斎   斉
    齋   斉
    齊   斉
    # supports rewriting a single character to a single character,
    # i.e., this cannot work.
    ｱｯ  ア

This feature is more powerful than `stringi::stri_trans_*` because it
allows users to control which characters are normalized. For instance,
this function can be used to convert *kyuji-tai* characters to
*shinji-tai* characters.

``` r
stringi::stri_trans_nfkc("Ⅹⅳ")
#> [1] "Xiv"
strj_rewrite_as_def("Ⅹⅳ")
#> [1] "Ⅹⅳ"
strj_rewrite_as_def("惡と假面のルール", read_rewrite_def(system.file("def/kyuji.def", package = "audubon")))
#> [1] "悪と仮面のルール"
```

## License

© 2024 Akiru Kato

Licensed under the [Apache License, Version
2.0](https://www.apache.org/licenses/LICENSE-2.0.html).

Icons made by iconixar from flaticon.
