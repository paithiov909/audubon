#' Fill Japanese iteration marks
#'
#' Fill Japanese iteration marks (Odoriji) with their previous characters.
#'
#' @param text Character vector.
#' @return Character vector.
#' @export
strj_fill_iter_mark <- function(text) {
  text <- text %>%
    stringi::stri_omit_empty_na() %>%
    stringi::stri_replace_all_regex("(\uff0f\u2033\uff3c)", "\u3034\u3035") %>%
    stringi::stri_replace_all_regex("(\uff0f\uff3c)", "\u3033\u3035")
  purrr::map_chr(text, function(res) {
    if (nchar(res) > 4) {
      res <- magrittr::freduce(
        res,
        list(fill_iter_mark_double2, fill_iter_mark_double, fill_iter_mark_single2, fill_iter_mark_single)
      )
    }
    return(unlist(res))
  })
}

#' @noRd
fill_iter_mark_single <- function(text) {
  if (stringi::stri_detect_regex(text, "[\u30fd\u309d\u3003]")) {
    textloop <- stringi::stri_split_boundaries(text, type = "character") %>%
      purrr::map(~ embed(., 2)[, 2:1]) %>%
      purrr::map(~ as.data.frame(.))
    purrr::map(textloop, function(df) {
      df <- df %>%
        dplyr::mutate(
          V2 = dplyr::if_else(
            stringi::stri_detect_regex(df$V2, "[\u30fd\u309d\u3003]"),
            V1,
            V2
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
    textloop <- stringi::stri_split_boundaries(text, type = "character") %>%
      purrr::map(~ embed(., 2)[, 2:1]) %>%
      purrr::map(~ as.data.frame(.))
    purrr::map(textloop, function(df) {
      df <- df %>%
        dplyr::mutate(
          V2 = dplyr::if_else(
            stringi::stri_detect_regex(df$V2, "[\u30fe\u309e]"),
            paste0(V1, enc2utf8("\uff9e")),
            V2
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
    textloop <- stringi::stri_split_boundaries(text, type = "character") %>%
      purrr::map(~ embed(., 4)[, 4:1]) %>%
      purrr::map(~ as.data.frame(.))
    purrr::map(textloop, function(df) {
      df <- df %>%
        dplyr::mutate(
          V3 = dplyr::if_else(
            stringi::stri_detect_regex(V3, "[\u3033]"),
            V1,
            V3
          ),
          V4 = dplyr::if_else(
            stringi::stri_detect_regex(V4, "[\u3033]"),
            V2,
            V4
          )
        ) %>%
        dplyr::mutate(
          V4 = dplyr::if_else(
            stringi::stri_detect_regex(V4, "[\u3035]"),
            V2,
            V4
          )
        )
      paste0(c(df[1, 1:3], df$V4), collapse = "")
    })
  } else {
    text
  }
}

#' @noRd
fill_iter_mark_double2 <- function(text) {
  if (stringi::stri_detect_regex(text, "(\u3034\u3035)")) {
    textloop <- stringi::stri_split_boundaries(text, type = "character") %>%
      purrr::map(~ embed(., 4)[, 4:1]) %>%
      purrr::map(~ as.data.frame(.))
    purrr::map(textloop, function(df) {
      df <- df %>%
        dplyr::mutate(
          V3 = dplyr::if_else(
            stringi::stri_detect_regex(V3, "[\u3034]"),
            paste0(V1, enc2utf8("\uff9e")),
            V3
          ),
          V4 = dplyr::if_else(
            stringi::stri_detect_regex(V4, "[\u3034]"),
            paste0(V2, enc2utf8("\uff9e")),
            V4
          )
        ) %>%
        dplyr::mutate(
          V4 = dplyr::if_else(
            stringi::stri_detect_regex(V4, "[\u3035]"),
            V2,
            V4
          )
        )
      paste0(c(df[1, 1:3], df$V4), collapse = "")
    })
  } else {
    text
  }
}
