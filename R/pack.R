#' Pack prettified data.frame of tokens
#'
#' Packs a prettified data.frame of tokens into a new data.frame of corpus,
#' which is compatible with the Text Interchange Formats.
#'
#' @section Text Interchange Formats (TIF):
#'
#' The Text Interchange Formats (TIF) is a set of standards
#' that allows R text analysis packages to target defined inputs and outputs
#' for corpora, tokens, and document-term matrices.
#'
#' @section Valid data.frame of tokens:
#'
#' The prettified data.frame of tokens here is a data.frame object
#' compatible with the TIF.
#'
#' A TIF valid data.frame of tokens are expected to have one unique key column (named `doc_id`)
#' of each text and several feature columns of each tokens.
#' The feature columns must contain at least `token` itself.
#'
#' @seealso \url{https://github.com/ropensci/tif}
#'
#' @param tbl A prettified data.frame of tokens.
#' @param pull Column to be packed into text or ngrams body. Default value is `token`.
#' @param n Integer internally passed to ngrams tokenizer function
#' created of \code{audubon::ngram_tokenizer()}
#' @param sep Character scalar internally used as the concatenator of ngrams.
#' @param .collapse This argument is passed to \code{stringi::stri_join()}.
#' @return A data.frame.
#' @export
#' @examples
#' pack(strj_tokenize(polano[1:5], format = "data.frame"))
pack <- function(tbl, pull = "token", n = 1L, sep = "-", .collapse = " ") {
  pull <- rlang::enquo(pull)
  if (n < 2L) {
    tbl %>%
      dplyr::group_by(.data$doc_id) %>%
      dplyr::group_map(
        ~ dplyr::pull(.x, {{ pull }}) %>%
          stringi::stri_omit_empty_na() %>%
          stringi::stri_join(collapse = .collapse) %>%
          purrr::set_names(.y$doc_id)
      ) %>%
      purrr::flatten_chr() %>%
      purrr::imap_dfr(~ data.frame(doc_id = .y, text = .x))
  } else {
    make_ngram <- ngram_tokenizer(n)
    tbl %>%
      dplyr::group_by(.data$doc_id) %>%
      dplyr::group_map(
        ~ dplyr::pull(.x, {{ pull }}) %>%
          stringi::stri_remove_empty_na() %>%
          make_ngram(sep = sep) %>%
          stringi::stri_join(collapse = .collapse) %>%
          purrr::set_names(.y$doc_id)
      ) %>%
      purrr::flatten_chr() %>%
      purrr::imap_dfr(~ data.frame(doc_id = .y, text = .x))
  }
}

#' Ngrams tokenizer
#'
#' Make an ngram tokenizer function.
#'
#' @param n Integer.
#' @return ngram tokenizer function
#' @export
ngram_tokenizer <- function(n = 1L) {
  stopifnot(is.numeric(n), is.finite(n), n > 0)
  function(tokens, sep = " ") {
    stopifnot(is.character(tokens))
    len <- length(tokens)
    if (all(is.na(tokens)) || len < n) {
      character(0)
    } else {
      sapply(1:max(1, len - n + 1), function(i) {
        stringi::stri_join(tokens[i:min(len, i + n - 1)], collapse = sep)
      })
    }
  }
}
