# Transcribe integers into Japanese kanji numerals

Converts integer values to their Japanese kanji numeral representations.

This function transcribes integers up to the trillions place into kanji
numerals. For larger numbers or more comprehensive numeral support,
consider using the CRAN package arabic2kansuji.

## Usage

``` r
strj_transcribe_num(int)
```

## Arguments

- int:

  An integer vector to transcribe.

## Value

A character vector containing kanji numeral representations.

## Examples

``` r
strj_transcribe_num(c(10L, 31415L))
#> [1] "十"             "三万千四百十五"
```
