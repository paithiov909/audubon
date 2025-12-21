#' Convert Japanese kana characters
#'
#' @description
#' Converts Japanese text between hiragana and katakana representations.
#'
#' These functions transform kana characters while preserving non-kana
#' characters. The conversion is based on a JavaScript implementation and
#' handles certain historical or contracted kana forms that are not covered
#' by standard Unicode transliteration alone.
#'
#' @details
#' The conversion behavior is largely compatible with ICU-based
#' transliteration, with additional support for selected combined or
#' historical kana characters.
#'
#' @param text A character vector containing Japanese text.
#' @returns
#' A character vector with kana characters converted to the target script.
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
#' @rdname strj-hira-kana
#' @name strj-hira-kana
NULL

#' @rdname strj-hira-kana
#' @export
strj_hiraganize <- function(text) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  unlist(
    lapply(stringi::stri_trans_nfkc(text), function(elem) {
      ctx$call("window.audubon.japanese.hiraganize", elem)
    }),
    use.names = FALSE
  )
}

#' @rdname strj-hira-kana
#' @export
strj_katakanize <- function(text) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  unlist(
    lapply(stringi::stri_trans_nfkc(text), function(elem) {
      ctx$call("window.audubon.japanese.katakanize", elem)
    }),
    use.names = FALSE
  )
}

#' Romanize Japanese text
#'
#' @description
#' Converts Japanese kana text to Latin script using a selectable romanization
#' system.
#'
#' This function transliterates Japanese text into romaji according to the
#' specified convention. Non-kana characters are omitted from the output.
#'
#' @details
#' Supported romanization systems include variants of Hepburn as well as
#' Kunrei-shiki and Nihon-shiki conventions.
#'
#' @param text A character vector containing Japanese text.
#' @param config A string specifying the romanization system to use.
#' @returns
#' A character vector containing romanized text.
#' @export
#' @examples
#' strj_romanize(
#'   paste0(
#'     "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
#'     "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
#'     "\u3068\u304a\u3063\u305f\u98a8"
#'   )
#' )
strj_romanize <- function(
  text,
  config = c(
    "wikipedia",
    "traditional hepburn",
    "modified hepburn",
    "kunrei",
    "nihon"
  )
) {
  config <- rlang::arg_match(config)
  ctx <- rlang::env_get(.pkgenv, "ctx")
  unlist(
    lapply(stringi::stri_trans_nfkc(text), function(elem) {
      ctx$call("window.audubon.japanese.romanize", elem, config)
    }),
    use.names = FALSE
  )
}

#' Transcribe integers into Japanese kanji numerals
#'
#' @description
#' Converts integer values to their Japanese kanji numeral representations.
#'
#' This function transcribes integers up to the trillions place into kanji
#' numerals. For larger numbers or more comprehensive numeral support, consider
#' using the CRAN package arabic2kansuji.
#'
#' @param int An integer vector to transcribe.
#' @returns
#' A character vector containing kanji numeral representations.
#' @export
#' @examples
#' strj_transcribe_num(c(10L, 31415L))
strj_transcribe_num <- function(int) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  unlist(
    lapply(as.integer(int), function(elem) {
      ctx$call("window.audubon.japanese.transcribeNumber", elem)
    }),
    use.names = FALSE
  )
}
