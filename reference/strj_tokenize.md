# Tokenize Japanese text

Tokenizes Japanese character strings using a selectable segmentation
engine and returns the result as a list or a data frame.

This function provides a unified interface to multiple Japanese text
segmentation backends. External command-based engines were removed in
v0.6.0, and all tokenization is performed using in-process
implementations.

`strj_segment()` and `strj_tinyseg()` are aliases for `strj_tokenize()`
with the `"budoux"` and `"tinyseg"` engines, respectively.

## Usage

``` r
strj_tokenize(
  text,
  format = c("list", "data.frame"),
  engine = c("stringi", "budoux", "tinyseg"),
  split = FALSE,
  ...
)

strj_segment(text, format = c("list", "data.frame"), split = FALSE)

strj_tinyseg(text, format = c("list", "data.frame"), split = FALSE)
```

## Arguments

- text:

  A character vector of Japanese text to tokenize.

- format:

  A string specifying the output format.

- engine:

  A string specifying the tokenization engine to use.

- split:

  A logical value indicating whether `text` should be split into
  individual sentences before tokenization.

- ...:

  Additional arguments passed to the underlying engine.

## Value

If `format = "list"`, a named list of character vectors, one per input
element. If `format = "data.frame"`, a data frame containing document
identifiers and tokenized text.

## Details

The following engines are supported:

- `"stringi"`: Uses ICU-based boundary analysis via stringi.

- `"budoux"`: Uses a rule-based Japanese phrase segmentation algorithm.

- `"tinyseg"`: Uses a TinySegmenter-compatible statistical model.

The legacy `"mecab"` and `"sudachipy"` engines were removed in v0.6.0.

## Examples

``` r
strj_tokenize(
  paste0(
    "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
    "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
    "\u3068\u304a\u3063\u305f\u98a8"
  )
)
#> $`1`
#> [1] "あの"           "イーハトーヴォ" "の"             "すき"          
#> [5] "と"             "おっ"           "た"             "風"            
#> 
strj_tokenize(
  paste0(
    "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
    "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
    "\u3068\u304a\u3063\u305f\u98a8"
  ),
  format = "data.frame"
)
#>   doc_id          token
#> 1      1           あの
#> 2      1 イーハトーヴォ
#> 3      1             の
#> 4      1           すき
#> 5      1             と
#> 6      1           おっ
#> 7      1             た
#> 8      1             風
```
