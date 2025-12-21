# Default Japanese date format

Returns the default date format string used for Japanese calendar date
parsing and formatting.

This helper function exists to provide a UTF-8 encoded format string
without embedding non-ASCII characters directly in function defaults.

## Usage

``` r
default_format()
```

## Value

A character string representing a Japanese calendar date format.

## Examples

``` r
default_format()
#> [1] "Gy年M月d日"
```
