#' Convert text following the rules of 'NEologd'
#'
#' Convert characters into normalized style
#' following the rule that is recommended by the Neologism dictionary for 'MeCab'.
#'
#' @seealso \url{https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja}
#' @param text Character vector to be normalized.
#' @return Character vector.
#' @export
#' @examples
#' strj_normalize(
#'   paste0(
#'     "\u2015\u2015\u5357\u30a2\u30eb\u30d7\u30b9",
#'     "\u306e\u3000\u5929\u7136\u6c34-\u3000\uff33",
#'     "\uff50\uff41\uff52\uff4b\uff49\uff4e\uff47*",
#'     "\u3000\uff2c\uff45\uff4d\uff4f\uff4e+",
#'     "\u3000\u30ec\u30e2\u30f3\u4e00\u7d5e\u308a"
#'   )
#' )
strj_normalize <- function(text) {
  text %>%
    stringi::stri_trans_nfkc() %>%
    stringi::stri_replace_all_regex("\u2019", "\'") %>%
    stringi::stri_replace_all_regex("\u201d", "\"") %>%
    stringi::stri_replace_all_regex(
      "[\\-\u02d7\u058a\u2010\u2011\u2012\u2013\u2043\u207b\u208b\u2212]+", "-"
    ) %>%
    stringi::stri_replace_all_regex(
      "[\ufe63\uff0d\uff70\u2014\u2015\u2500\u2501\u30fc]+", enc2utf8("\u30fc")
    ) %>%
    stringi::stri_replace_all_regex(
      "([:blank:]){2,}", " "
    ) %>%
    stringi::stri_replace_all_regex(
      "([\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]+)[[:blank:]]*([\u0021-\u007e[:punct:]]+)",
      "$1$2"
    ) %>%
    stringi::stri_replace_all_regex(
      "([\u0021-\u007e\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]*)[[:blank:]]*([\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]+)",
      "$1$2"
    ) %>%
    stringi::stri_replace_all_regex("[~\u223c\u223e\u301c\u3030\uff5e]+", "") %>%
    stringi::stri_trim() %>%
    stringi::stri_replace_all_regex("[[:cntrl:]]+", "")
}
