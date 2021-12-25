#' Segment text into phrases
#'
#' Segment Japanese text into several phrases
#' using the 'google/budoux' JavaScript module.
#'
#' @param text Character vector.
#' @return List.
#'
#' @export
strj_segment <- function(text) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  lapply(stringi::stri_trans_nfkc(text), function(elem) {
    ctx$call("audubon.parser.parse", elem)
  })
}
