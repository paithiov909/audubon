#' Invert Roman to Hiragana
#'
#' Invert Japanese Roman to Hiragana
#' following JIS X 4063:2000 (deprecated in 2010/01/20).
#'
#' @details
#' It is much stricter than the character class translation of ICU
#' such that this inversion fails and returns an `NA_character_`
#' when the element of vector contains any non-Latin strings.
#'
#' @param text Character vector.
#' @returns A named character vector.
#' @export
strj_invert_to_kana <- function(text) {
  furrr::future_map_chr(text, function(elem) {
    res <- to_kana(enc2utf8(elem))
    Encoding(res) <- "UTF-8"
    return(res)
  })
}

#' Invert Hiragana to Roman
#'
#' Invert Japanese Hiragana to Roman
#' following JIS X 4063:2000 (deprecated in 2010/01/20).
#'
#' @details
#' It is much stricter than the character class translation of ICU
#' such that this inversion fails and returns an `NA_character_`
#' when the element of vector contains any non-Hiragana strings.
#'
#' @section Limitations:
#' In case you use this function under Windows with Japanese locale,
#' some romanization would not work properly due to its default encoding.
#'
#' @param text Character vector.
#' @returns A named character vector.
#' @export
strj_invert_to_roman <- function(text) {
  furrr::future_map_chr(text, function(elem) {
    res <- to_roman(enc2utf8(elem))
    Encoding(res) <- "UTF-8"
    return(res)
  })
}
