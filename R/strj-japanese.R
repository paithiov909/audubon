#' Hiraganize Japanese characters
#'
#' @param text Character vector.
#' @returns Character vector.
#' @export
strj_hiranganize <- function(text) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  sapply(stringi::stri_trans_nfkc(text), function(elem) {
    ctx$call("audubon.japanese.hiraganize", text)
  }, USE.NAMES = FALSE)
}

#' Katakanize Japanese characters
#'
#' @param text Character vector.
#' @returns Character vector.
#' @export
strj_katakanize <- function(text) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  sapply(stringi::stri_trans_nfkc(text), function(elem) {
    ctx$call("audubon.japanese.katakanize", text)
  }, USE.NAMES = FALSE)
}

#' Romanize Japanse Hiragana and Katakana
#'
#' @param text Character vector.
#' @param config Config used to romanize.
#' @returns Character vector.
#'
#' @export
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
#' @param config Config used to romanize.
#' @returns Character vector.
#'
#' @export
strj_transcribe_num <- function(int) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  sapply(as.integer(int), function(elem) {
    ctx$call("audubon.japanese.transcribeNumber", elem)
  }, USE.NAMES = FALSE)
}
