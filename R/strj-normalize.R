#' Convert text following the rules of 'NEologd'
#'
#' Convert characters into normalized style
#' basing on rules that is recommended by the Neologism dictionary for MeCab.
#'
#' @seealso \url{https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja}
#' @param text Character vector.
#' @returns Character vector.
#' @export
strj_normalize <- function(text) {
  res <-
    stringi::stri_trans_nfkc(text) %>%
    stringr::str_replace_all(
      c(
        "\u2019" = "\'",
        "\u201d" = "\""
      )
    ) %>%
    stringr::str_replace_all(
      "[\\-\u02d7\u058a\u2010\u2011\u2012\u2013\u2043\u207b\u208b\u2212]+", "-"
    ) %>%
    stringr::str_replace_all(
      "[\ufe63\uff0d\uff70\u2014\u2015\u2500\u2501\u30fc]+", enc2utf8("\u30fc")
    ) %>%
    stringr::str_replace_all(
      "([:blank:]){2,}", " "
    ) %>%
    stringr::str_replace_all(
      "([\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]+)[[:blank:]]*([\u0021-\u007e[:punct:]]+)",
      "\\1\\2"
    ) %>%
    stringr::str_replace_all(
      "([\u0021-\u007e\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]*)[[:blank:]]*([\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]+)",
      "\\1\\2"
    ) %>%
    stringr::str_remove_all("[~\u223c\u223e\u301c\u3030\uff5e]+") %>%
    stringr::str_trim() %>%
    stringr::str_remove_all("[[:cntrl:]]+")
  return(res)
}
