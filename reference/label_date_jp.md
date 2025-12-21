# Japanese date labeller for ggplot2

Formats date labels using the Japanese calendar system and returns
labels suitable for use with ggplot2 scales.

## Usage

``` r
label_date_jp(labels, format = default_format(), tz = NULL)

label_date_jp_gen(format = default_format(), tz = NULL)
```

## Arguments

- labels:

  A vector of values coercible to Date objects.

- format:

  A date-time format string following ICU conventions.

- tz:

  A time zone used when coercing values to Date objects.

## Value

- `label_date_jp()` returns a character vector of formatted date labels.

- `label_date_jp_gen()` returns a labeller function for use in ggplot2
  scales.

## Details

This labeller formats dates according to a locale-aware Japanese
calendar, allowing era-based representations such as Reiwa or Heisei.
The output is intended for discrete or continuous date scales in
ggplot2.

## Examples

``` r
date_range <- function(start, days) {
  start <- as.POSIXct(start)
  c(start, start + days * 24 * 60 * 60)
}
two_months <- date_range("2025-12-31", 60)

label_date_jp(two_months)
#> [1] "令和7年12月31日" "令和8年3月1日"  
if (requireNamespace("scales", quietly = TRUE)) {
  scales::demo_datetime(two_months, labels = label_date_jp_gen())
}
#> scale_x_datetime(labels = label_date_jp_gen())
#> Skipping; ggplot2 not installed
```
