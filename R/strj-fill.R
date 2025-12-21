#' Fill Japanese iteration marks
#'
#' @description
#' Replaces Japanese iteration marks in character strings with the
#' corresponding repeated characters.
#'
#' This function scans each input string and expands iteration marks such as
#' odoriji by inferring the characters to be repeated from the surrounding
#' context. The implementation is heuristic and intended for practical text
#' normalization rather than complete linguistic accuracy.
#'
#' @details
#' The restoration is based on local character context and may be incomplete
#' for iteration marks that refer to longer or more complex spans.
#'
#' @param text A character vector containing Japanese text.
#' @returns
#' A character vector in which iteration marks are replaced with the inferred
#' repeated characters.
#' @export
#' @examples
#' strj_fill_iter_mark(c(
#'   "\u3042\u3044\u3046\u309d\u3003\u304b\u304d",
#'   "\u91d1\u5b50\u307f\u3059\u309e",
#'   "\u306e\u305f\u308a\u3033\u3035\u304b\u306a",
#'   "\u3057\u308d\uff0f\u2033\uff3c\u3068\u3057\u305f"
#' ))
strj_fill_iter_mark <- function(text) {
  text <- text |>
    stringi::stri_omit_empty_na() |>
    stringi::stri_replace_all_regex("(\uff0f\u2033\uff3c)", "\u3034\u3035") |>
    stringi::stri_replace_all_regex("(\uff0f\uff3c)", "\u3033\u3035")

  unlist(
    lapply(text, function(res) {
      if (nchar(res) > 4) {
        while (
          stringi::stri_detect_regex(
            res,
            "[\u30fd\u309d\u3003\u30fe\u309e\u3033\u3034\u3035]"
          )
        ) {
          res <- magrittr::freduce(
            res,
            list(
              fill_iter_mark_double2,
              fill_iter_mark_double,
              fill_iter_mark_single2,
              fill_iter_mark_single
            )
          )
        }
      }
      unlist(res, use.names = FALSE)
    }),
    use.names = FALSE
  )
}

#' @noRd
fill_iter_mark_single <- function(text) {
  if (stringi::stri_detect_regex(text, "[\u30fd\u309d\u3003]")) {
    textloop <- stringi::stri_split_boundaries(text, type = "character") |>
      lapply(function(x) {
        embed(x, 2)[, 2:1] |> as.data.frame()
      })
    lapply(textloop, function(df) {
      df <- df |>
        dplyr::mutate(
          V2 = dplyr::if_else(
            stringi::stri_detect_regex(df$V2, "[\u30fd\u309d\u3003]"),
            .data$V1,
            .data$V2
          )
        )
      paste0(c(df[1, 1], df$V2), collapse = "")
    })
  } else {
    text
  }
}

#' @noRd
fill_iter_mark_single2 <- function(text) {
  if (stringi::stri_detect_regex(text, "[\u30fe\u309e]")) {
    textloop <- stringi::stri_split_boundaries(text, type = "character") |>
      lapply(function(x) {
        embed(x, 2)[, 2:1] |> as.data.frame()
      })
    lapply(textloop, function(df) {
      df <- df |>
        dplyr::mutate(
          V2 = dplyr::if_else(
            stringi::stri_detect_regex(df$V2, "[\u30fe\u309e]"),
            paste0(.data$V1, enc2utf8("\uff9e")),
            .data$V2
          )
        )
      paste0(c(df[1, 1], df$V2), collapse = "")
    })
  } else {
    text
  }
}

#' @noRd
fill_iter_mark_double <- function(text) {
  if (stringi::stri_detect_regex(text, "(\u3033\u3035)")) {
    textloop <- stringi::stri_split_boundaries(text, type = "character") |>
      purrr::map(function(x) {
        embed(x, 4)[, 4:1]
      }) |>
      purrr::map(function(x) {
        as.data.frame(x)
      })
    purrr::map(textloop, function(df) {
      df <- df |>
        dplyr::mutate(
          V3 = dplyr::if_else(
            stringi::stri_detect_regex(df$V3, "[\u3033]"),
            .data$V1,
            .data$V3
          ),
          V4 = dplyr::if_else(
            stringi::stri_detect_regex(df$V4, "[\u3033]"),
            .data$V2,
            .data$V4
          )
        ) |>
        dplyr::mutate(
          V4 = dplyr::if_else(
            stringi::stri_detect_regex(df$V4, "[\u3035]"),
            .data$V2,
            .data$V4
          )
        )
      stringi::stri_join(c(df[1, 1:3], df$V4), collapse = "")
    })
  } else {
    text
  }
}

#' @noRd
fill_iter_mark_double2 <- function(text) {
  if (stringi::stri_detect_regex(text, "(\u3034\u3035)")) {
    textloop <- stringi::stri_split_boundaries(text, type = "character") |>
      purrr::map(function(x) {
        embed(x, 4)[, 4:1]
      }) |>
      purrr::map(function(x) {
        as.data.frame(x)
      })
    purrr::map(textloop, function(df) {
      df <- df |>
        dplyr::mutate(
          V3 = dplyr::if_else(
            stringi::stri_detect_regex(df$V3, "[\u3034]"),
            paste0(.data$V1, enc2utf8("\uff9e")),
            .data$V3
          ),
          V4 = dplyr::if_else(
            stringi::stri_detect_regex(df$V4, "[\u3034]"),
            paste0(.data$V2, enc2utf8("\uff9e")),
            .data$V4
          )
        ) |>
        dplyr::mutate(
          V4 = dplyr::if_else(
            stringi::stri_detect_regex(df$V4, "[\u3035]"),
            .data$V2,
            .data$V4
          )
        )
      stringi::stri_join(c(df[1, 1:3], df$V4), collapse = "")
    })
  } else {
    text
  }
}
