# Parse Japanese calendar dates

Parses Japanese calendar date strings into POSIXct objects.

This function parses date strings formatted with the Japanese calendar
system and converts them to POSIXct values using locale-aware ICU
parsing.

## Usage

``` r
strj_parse_date(date, format = default_format(), tz = NULL)
```

## Arguments

- date:

  A character vector containing Japanese calendar date strings.

- format:

  A date-time format string following ICU conventions.

- tz:

  A time zone used for the resulting POSIXct values.

## Value

A POSIXct vector representing the parsed dates.

## Details

Partial date specifications are interpreted according to ICU parsing
rules and may result in completion with the current date or time
components.

## Examples

``` r
if (FALSE) { # \dontrun{
strj_parse_date("\u4ee4\u548c2\u5e747\u67086\u65e5")
} # }
```
