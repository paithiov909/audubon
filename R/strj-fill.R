#' Fill Japanese iteration marks
#'
#' Fill Japanese iteration marks (Odoriji) with their previous chraracters.
#'
#' @param text Character vector.
#' @returns Character vector.
#' @export
strj_fill_iter_mark <- function(text) {
  v <- sapply(text, function(res) {
    if (nchar(res) >= 4) {
      res <- magrittr::freduce(res, list(fill_iter_mark_single2, fill_iter_mark_single))
    }
    return(res)
  }, USE.NAMES = FALSE)
  return(purrr::flatten_chr(v))
}

#' @noRd
fill_iter_mark_single <- function(text) {
  textloop <- tokenizers::tokenize_characters(text) %>%
    purrr::map(~ embed(., 2)[, 2:1]) %>%
    purrr::map(~ as.data.frame(.))
  lapply(textloop, function(df) {
    df$flags <- stringi::stri_detect_regex(df$V2, "[\u30fd\u309d\u3003\u3005]")
    df <- df %>%
      dplyr::mutate(
        V3 = dplyr::if_else(
          flags,
          V1,
          V2
        )
      )
    paste0(c(df[1, 1], df$V3), collapse = "")
  })
}

#' @noRd
fill_iter_mark_single2 <- function(text) {
  textloop <- tokenizers::tokenize_characters(text) %>%
    purrr::map(~ embed(., 2)[, 2:1]) %>%
    purrr::map(~ as.data.frame(.))
  lapply(textloop, function(df) {
    df$flags <- stringi::stri_detect_regex(df$V2, "[\u30fe\u309e]")
    df <- df %>%
      dplyr::mutate(
        V3 = dplyr::if_else(
          .data$flags,
          paste0(V1, enc2utf8("\uff9e")),
          paste0(V2)
        )
      )
    paste0(c(df[1, 1], df$V3), collapse = "")
  })
}
