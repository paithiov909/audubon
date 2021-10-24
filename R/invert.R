#' Invert Roman to Hiragana
#'
#' @details
#' It is much stricter than the character class translation of ICU
#' such that this inversion fails and returns an `NA_character`
#' when the element of vector contains any non-Latin strings.
#'
#' @param chr Character vector.
#' @returns A named character vector.
#' @export
invert_to_kana <- function(chr) {
  sapply(chr, function(elem) {
    res <- to_kana(enc2utf8(elem))
    Encoding(res) <- "UTF-8"
    return(res)
  })
}

#' Invert Hiragana to Roman
#'
#' @details
#' It is much stricter than the character class translation of ICU
#' such that this inversion fails and returns an `NA_character`
#' when the element of vector contains any non-Hiragana strings.
#'
#' @param chr Character vector.
#' @returns A named character vector.
#' @export
invert_to_roman <- function(chr) {
  sapply(chr, function(elem) {
    res <- to_roman(enc2utf8(elem))
    Encoding(res) <- "UTF-8"
    return(res)
  })
}
