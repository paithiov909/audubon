#' Segment text into phrases
#'
#' Segment Japanese text into several phrases
#' using the 'google/budoux' JavaScript module.
#'
#' @param text Character vector.
#' @return List.
#' @export
#' @examples
#' strj_segment("\u3042\u306e\u30a4\u30fc\u30cf\u30c8\u30fc\u30f4\u30a9\u306e\u3059\u304d\u3068\u304a\u3063\u305f\u98a8")
strj_segment <- function(text) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  lapply(stringi::stri_trans_nfkc(text), function(elem) {
    ctx$call("audubon.parser.parse", elem)
  })
}
