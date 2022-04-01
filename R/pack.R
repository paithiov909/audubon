#' Pack prettified data.frame of tokens
#'
#' Pack a prettified data.frame of tokens into a new data.frame of corpus,
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
    res <- tbl %>%
      dplyr::group_by(.data$doc_id) %>%
      dplyr::group_map(
        ~ dplyr::pull(.x, {{ pull }}) %>%
          stringi::stri_join(collapse = .collapse) %>%
          purrr::set_names(.y$doc_id)
      ) %>%
      purrr::flatten_chr() %>%
      purrr::imap_dfr(~ data.frame(doc_id = .y, text = .x))
  } else {
    make_ngram <- ngram_tokenizer(n)
    res <- tbl %>%
      dplyr::group_by(.data$doc_id) %>%
      dplyr::group_map(
        ~ make_ngram(dplyr::pull(.x, {{ pull }}), sep = sep) %>%
          stringi::stri_join(collapse = .collapse) %>%
          purrr::set_names(.y$doc_id)
      ) %>%
      purrr::flatten_chr() %>%
      purrr::imap_dfr(~ data.frame(doc_id = .y, text = .x))
  }
  return(dplyr::mutate_if(res, is.character, ~ dplyr::na_if(., "*")))
}

#' Ngrams tokenizer
#'
#' Make an ngram tokenizer function.
#'
#' @param n Integer.
#' @param skip_word_none Logical.
#' @param locale Character scalar. Pass a `NULL` or an empty string for default locale.
#' @return ngram tokenizer function
#' @export
ngram_tokenizer <- function(n = 1L, skip_word_none = FALSE, locale = NULL) {
  stopifnot(is.numeric(n), is.finite(n), n > 0)

  options <- stringi::stri_opts_brkiter(
    type = "word",
    locale = locale,
    skip_word_none = skip_word_none
  )

  func <- function(x, sep = " ") {
    stopifnot(is.character(x))

    ## Split into word tokens
    tokens <- unlist(stringi::stri_split_boundaries(x, opts_brkiter = options))
    len <- length(tokens)

    if (all(is.na(tokens)) || len < n) {
      ## If we didn't detect any words or number of tokens
      ## is less than n return empty vector
      character(0)
    } else {
      sapply(1:max(1, len - n + 1), function(i) {
        stringi::stri_join(tokens[i:min(len, i + n - 1)], collapse = sep)
      })
    }
  }
  return(func)
}
