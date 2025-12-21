# Romanize Japanese text

Converts Japanese kana text to Latin script using a selectable
romanization system.

This function transliterates Japanese text into romaji according to the
specified convention. Non-kana characters are omitted from the output.

## Usage

``` r
strj_romanize(
  text,
  config = c("wikipedia", "traditional hepburn", "modified hepburn", "kunrei", "nihon")
)
```

## Arguments

- text:

  A character vector containing Japanese text.

- config:

  A string specifying the romanization system to use.

## Value

A character vector containing romanized text.

## Details

Supported romanization systems include variants of Hepburn as well as
Kunrei-shiki and Nihon-shiki conventions.

## Examples

``` r
strj_romanize(
  paste0(
    "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
    "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
    "\u3068\u304a\u3063\u305f\u98a8"
  )
)
#> [1] "anoīhatōvonosukitōtta"
```
