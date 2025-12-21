#' @noRd
consective_id_by_cumsum <- function(x, threshold) {
  acc <- purrr::accumulate(x, function(.x, .y) {
    dplyr::if_else(.x >= threshold, .y, .x + .y)
  })
  cumsum(dplyr::lag((acc >= threshold), default = FALSE)) + 1
}

#' Japanese word-wrapping labeller for ggplot2
#'
#' Wraps character strings using Japanese phrase boundaries and returns
#' labels suitable for use with ggplot2 scales.
#'
#' This labeller uses ICU-based Japanese phrase boundary detection to
#' insert line breaks at natural word boundaries. Long labels can be
#' truncated to a fixed display width with an ellipsis.
#'
#' @param labels A character vector of labels to wrap.
#' @param wrap An integer giving the target number of characters per line.
#' @param width An integer giving the maximum total width of the wrapped label.
#' @param collapse A character string used to join wrapped lines.
#'
#' @returns
#' * `label_wrap_jp()` returns a character vector of wrapped labels.
#' * `label_wrap_jp_gen()` returns a labeller function for use in ggplot2 scales.
#
#' @rdname label_wrap_jp
#' @export
#' @examples
#' label_wrap_jp(polano[4:6], width = 32)
#' if (requireNamespace("scales", quietly = TRUE)) {
#'   scales::demo_discrete(polano[4:6], labels = label_wrap_jp_gen())
#' }
label_wrap_jp <- function(labels, wrap = 16, width = 50, collapse = "\n") {
  labels <- as.character(labels)
  pos <-
    stringi::stri_locate_all_boundaries(
      labels,
      opts_brkiter = stringi::stri_opts_brkiter(locale = "ja@lw=phrase;ld=auto")
    ) |>
    lapply(function(x) {
      ret <-
        as.data.frame(x) |>
        dplyr::mutate(
          nchar = .data$end - .data$start + 1,
          id = consective_id_by_cumsum(nchar, wrap)
        )
      split(ret, ret[["id"]])
    })

  labels <- purrr::imap(pos, function(ids, i) {
    txt <-
      purrr::map(
        ids,
        ~ {
          stringi::stri_sub(
            labels[i],
            from = head(., n = 1)[["start"]],
            to = tail(., n = 1)[["end"]]
          )
        }
      ) |>
      unlist(use.names = FALSE) |>
      paste0(collapse = collapse)

    len <- stringi::stri_length(txt)
    is_too_long <- !is.na(txt) & (len > width)
    width <- width - 3
    if (width < 0) {
      rlang::abort(
        "`width` is shorter than the length of ellipsis (\"...\"). Try larger value.",
        call = rlang::caller_env(4)
      )
    }
    txt <-
      stringi::stri_sub(txt, from = 1, to = width) |>
      paste0(if (is_too_long) "..." else "")

    txt
  })
  unlist(labels, use.names = FALSE)
}

#' @rdname label_wrap_jp
#' @export
label_wrap_jp_gen <- function(wrap = 16, width = 50, collapse = "\n") {
  wrap_jp_labeller <- function(labels) {
    lapply(labels, function(x) {
      label_wrap_jp(x, wrap = wrap, width = width, collapse = collapse)
    })
  }
  structure(wrap_jp_labeller, class = "labeller")
}

#' Japanese date labeller for ggplot2
#'
#' Formats date labels using the Japanese calendar system and returns
#' labels suitable for use with ggplot2 scales.
#'
#' This labeller formats dates according to a locale-aware Japanese
#' calendar, allowing era-based representations such as Reiwa or Heisei.
#' The output is intended for discrete or continuous date scales in ggplot2.
#'
#' @param labels A vector of values coercible to Date objects.
#' @param format A date-time format string following ICU conventions.
#' @param tz A time zone used when coercing values to Date objects.
#'
#' @returns
#' * `label_date_jp()` returns a character vector of formatted date labels.
#' * `label_date_jp_gen()` returns a labeller function for use in ggplot2 scales.
#'
#' @rdname label_date_jp
#' @export
#' @examples
#' date_range <- function(start, days) {
#'   start <- as.POSIXct(start)
#'   c(start, start + days * 24 * 60 * 60)
#' }
#' two_months <- date_range("2025-12-31", 60)
#'
#' label_date_jp(two_months)
#' if (requireNamespace("scales", quietly = TRUE)) {
#'   scales::demo_datetime(two_months, labels = label_date_jp_gen())
#' }
label_date_jp <- function(
  labels,
  format = default_format(),
  tz = NULL
) {
  labels <- as.Date(labels, tz = if (is.null(tz)) "UTC" else tz)
  stringi::stri_datetime_format(
    labels,
    format = format,
    tz = tz,
    locale = "ja-u-ca-japanese"
  )
}

#' @rdname label_date_jp
#' @export
label_date_jp_gen <- function(
  format = default_format(),
  tz = NULL
) {
  date_jp_labeller <- function(labels) {
    lapply(labels, function(x) {
      label_date_jp(x, format = format, tz = tz)
    })
  }
  structure(date_jp_labeller, class = "labeller")
}
