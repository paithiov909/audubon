# Fill Japanese iteration marks

Replaces Japanese iteration marks in character strings with the
corresponding repeated characters.

This function scans each input string and expands iteration marks such
as odoriji by inferring the characters to be repeated from the
surrounding context. The implementation is heuristic and intended for
practical text normalization rather than complete linguistic accuracy.

## Usage

``` r
strj_fill_iter_mark(text)
```

## Arguments

- text:

  A character vector containing Japanese text.

## Value

A character vector in which iteration marks are replaced with the
inferred repeated characters.

## Details

The restoration is based on local character context and may be
incomplete for iteration marks that refer to longer or more complex
spans.

## Examples

``` r
strj_fill_iter_mark(c(
  "\u3042\u3044\u3046\u309d\u3003\u304b\u304d",
  "\u91d1\u5b50\u307f\u3059\u309e",
  "\u306e\u305f\u308a\u3033\u3035\u304b\u306a",
  "\u3057\u308d\uff0f\u2033\uff3c\u3068\u3057\u305f"
))
#> [1] "あいうううかき"  "金子みすすﾞ"     "のたりたりかな"  "しろしﾞろとした"
```
