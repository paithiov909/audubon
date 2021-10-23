#' @export
invert_kana <- function(str) {
  sapply(stringi::stri_enc_toutf8(str), function(elem) {
    res <- convert(str)
    Encoding(res) <- "UTF-8"
    return(res)
  }, USE.NAMES = FALSE)
}
