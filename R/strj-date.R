#' Parse Japanese calendar dates
#'
#' @description
#' Parses Japanese calendar date strings into POSIXct objects.
#'
#' This function parses date strings formatted with the Japanese calendar
#' system and converts them to POSIXct values using locale-aware ICU parsing.
#'
#' @details
#' Partial date specifications are interpreted according to ICU parsing
#' rules and may result in completion with the current date or time
#' components.
#'
#' @param date A character vector containing Japanese calendar date strings.
#' @param format A date-time format string following ICU conventions.
#' @param tz A time zone used for the resulting POSIXct values.
#' @returns
#' A POSIXct vector representing the parsed dates.
#' @export
#' @examples
#' strj_parse_date("\u4ee4\u548c2\u5e747\u67086\u65e5")
strj_parse_date <- function(
  date,
  format = default_format(),
  tz = NULL
) {
  stringi::stri_datetime_parse(
    date,
    format = format,
    tz = tz,
    locale = "ja-u-ca-japanese"
  )
}
