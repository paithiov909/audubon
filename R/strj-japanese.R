#' Hiraganize Japanese characters
#'
#' Converts Japanese katakana to hiragana.
#' It is almost similar to \code{stringi::stri_trans_general(text, "kana-hira")},
#' however, this implementation can also handle some additional symbols
#' such as Japanese kana ligature (aka. goryaku-gana).
#'
#' @param text Character vector.
#' @return A character vector.
#' @export
#' @examples
#' strj_hiraganize(
#'   c(
#'     paste0(
#'       "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
#'       "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
#'       "\u3068\u304a\u3063\u305f\u98a8"
#'     ),
#'     "\u677f\u57a3\u6b7b\u30b9\U0002a708"
#'   )
#' )
strj_hiraganize <- function(text) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  sapply(stringi::stri_trans_nfkc(text), function(elem) {
    ctx$call("audubon.japanese.hiraganize", elem)
  }, USE.NAMES = FALSE)
}

#' Katakanize Japanese characters
#'
#' Converts Japanese hiragana to katakana.
#' It is almost similar to \code{stringi::stri_trans_general(text, "hira-kana")},
#' however, this implementation can also handle some additional symbols
#' such as Japanese kana ligature (aka. goryaku-gana).
#'
#' @param text Character vector.
#' @return A character vector.
#' @export
#' @examples
#' strj_katakanize(
#'   c(
#'     paste0(
#'       "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
#'       "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
#'       "\u3068\u304a\u3063\u305f\u98a8"
#'     ),
#'     "\u672c\u65e5\u309f\u304b\u304d\u6c37\u89e3\u7981"
#'   )
#' )
strj_katakanize <- function(text) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  sapply(stringi::stri_trans_nfkc(text), function(elem) {
    ctx$call("audubon.japanese.katakanize", elem)
  }, USE.NAMES = FALSE)
}

#' Romanize Japanese Hiragana and Katakana
#'
#' @details
#' There are several ways to romanize Japanese.
#' Using this implementation, you can convert hiragana and katakana as 5 different styles;
#' the `wikipedia` style, the `traditional hepburn` style, the `modified hepburn` style,
#' the `kunrei` style, and the `nihon` style.
#'
#' Note that all of these styles return a slightly different form of
#' \code{stringi::stri_trans_general(text, "Any-latn")}.
#'
#' @seealso \url{https://github.com/hakatashi/japanese.js#japaneseromanizetext-config}
#'
#' @param text Character vector.
#' If elements are composed of except but hiragana and katakana letters,
#' those letters are dropped from the return value.
#' @param config Configuration used to romanize. Default is `wikipedia`.
#' @return A character vector.
#' @export
#' @examples
#' strj_romanize(
#'   paste0(
#'     "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
#'     "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
#'     "\u3068\u304a\u3063\u305f\u98a8"
#'   )
#' )
strj_romanize <- function(text,
                          config = c(
                            "wikipedia",
                            "traditional hepburn",
                            "modified hepburn",
                            "kunrei",
                            "nihon"
                          )) {
  config <- rlang::arg_match(config)
  ctx <- rlang::env_get(.pkgenv, "ctx")
  sapply(stringi::stri_trans_nfkc(text), function(elem) {
    ctx$call("audubon.japanese.romanize", elem, config)
  }, USE.NAMES = FALSE)
}

#' Transcribe Arabic to Kansuji
#'
#' Transcribes Arabic integers to Kansuji with auxiliary numerals.
#'
#' As its implementation is limited, this function can only transcribe
#' numbers up to trillions.
#' In case you convert much bigger numbers, try to use the 'arabic2kansuji' package.
#'
#' @param int Integers.
#' @return A character vector.
#' @export
#' @examples
#' strj_transcribe_num(c(10L, 31415L))
strj_transcribe_num <- function(int) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  sapply(as.integer(int), function(elem) {
    ctx$call("audubon.japanese.transcribeNumber", elem)
  }, USE.NAMES = FALSE)
}
