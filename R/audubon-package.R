#' @importFrom rlang enquo enquos ensym sym .data := as_name as_label
#' @importFrom stats embed
#' @keywords internal
"_PACKAGE"

#' Whole text of 'Porano no Hiroba' written by Miyazawa Kenji
#' from Aozora Bunko
#'
#' @details
#' A dataset containing the text of Miyazawa Kenji's novel
#' "Porano no Hiroba" which was published in 1934, the year after Kenji's death.
#' Copyright of this work has expired since more than 70 years have passed after the author's death.
#'
#' The UTF-8 plain text is sourced from \url{https://www.aozora.gr.jp/cards/000081/card1935.html} and is cleaned of meta data.
#'
#' @source \url{https://www.aozora.gr.jp/cards/000081/files/1935_ruby_19924.zip}
#' @examples
#' head(polano)
"polano"

#' Whole tokens of 'Porano no Hiroba' written by Miyazawa Kenji
#' from Aozora Bunko
#'
#' A tidy text data of \code{audubon::polano} that tokenized with 'MeCab'.
#'
#' @examples
#' head(hiroba)
"hiroba"

#' Default Japanese date format
#'
#' @description
#' Returns the default date format string used for Japanese calendar
#' date parsing and formatting.
#'
#' This helper function exists to provide a UTF-8 encoded format string
#' without embedding non-ASCII characters directly in function defaults.
#'
#' @returns
#' A character string representing a Japanese calendar date format.
#' @export
#' @examples
#' default_format()
default_format <- function() {
  enc2utf8("Gy\u5e74M\u6708d\u65e5")
}
