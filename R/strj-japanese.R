#' Hiraganize Japanese characters
#'
#' @param text Character vector.
#' @return Character vector.
#' @export
#' @examples
#' strj_hiraganize("\u3042\u306e\u30a4\u30fc\u30cf\u30c8\u30fc\u30f4\u30a9\u306e\u3059\u304d\u3068\u304a\u3063\u305f\u98a8")
strj_hiraganize <- function(text) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  sapply(stringi::stri_trans_nfkc(text), function(elem) {
    ctx$call("audubon.japanese.hiraganize", elem)
  }, USE.NAMES = FALSE)
}

#' Katakanize Japanese characters
#'
#' @param text Character vector.
#' @return Character vector.
#' @export
#' @examples
#' strj_katakanize("\u3042\u306e\u30a4\u30fc\u30cf\u30c8\u30fc\u30f4\u30a9\u306e\u3059\u304d\u3068\u304a\u3063\u305f\u98a8")
strj_katakanize <- function(text) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  sapply(stringi::stri_trans_nfkc(text), function(elem) {
    ctx$call("audubon.japanese.katakanize", elem)
  }, USE.NAMES = FALSE)
}

#' Romanize Japanese Hiragana and Katakana
#'
#' @param text Character vector.
#' @param config Config used to romanize.
#' @return Character vector.
#' @export
#' @examples
#' strj_romanize("\u3042\u306e\u30a4\u30fc\u30cf\u30c8\u30fc\u30f4\u30a9\u306e\u3059\u304d\u3068\u304a\u3063\u305f\u98a8")
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
#' Transcribe Arabic integers to Kansuji.
#'
#' @param int Integers.
#' @return Character vector.
#' @export
#' @examples
#' strj_transcribe_num(c(10L, 31415L))
strj_transcribe_num <- function(int) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  sapply(as.integer(int), function(elem) {
    ctx$call("audubon.japanese.transcribeNumber", elem)
  }, USE.NAMES = FALSE)
}
