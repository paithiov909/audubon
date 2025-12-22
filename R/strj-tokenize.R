#' Tokenize Japanese text
#'
#' @description
#' Tokenizes Japanese character strings using a selectable segmentation
#' engine and returns the result as a list or a data frame.
#'
#' This function provides a unified interface to multiple Japanese text
#' segmentation backends. External command-based engines were removed in
#' v0.6.0, and all tokenization is performed using in-process
#' implementations.
#'
#' `strj_segment()` and `strj_tinyseg()` are aliases for `strj_tokenize()`
#' with the `"budoux"` and `"tinyseg"` engines, respectively.
#'
#' @details
#' The following engines are supported:
#'
#' * `"stringi"`: Uses ICU-based boundary analysis via stringi.
#' * `"budoux"`: Uses a rule-based Japanese phrase segmentation algorithm.
#' * `"tinyseg"`: Uses a TinySegmenter-compatible statistical model.
#'
#' The legacy `"mecab"` and `"sudachipy"` engines were removed in v0.6.0.
#'
#' @param text A character vector of Japanese text to tokenize.
#' @param format A string specifying the output format.
#' @param engine A string specifying the tokenization engine to use.
#' @param split A logical value indicating whether `text` should be split
#'  into individual sentences before tokenization.
#' @param ... Additional arguments passed to the underlying engine.
#' @returns
#' If `format = "list"`, a named list of character vectors, one per input
#' element.
#' If `format = "data.frame"`, a data frame containing document identifiers
#' and tokenized text.
#' @export
#' @examples
#' strj_tokenize(
#'   paste0(
#'     "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
#'     "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
#'     "\u3068\u304a\u3063\u305f\u98a8"
#'   )
#' )
#' strj_tokenize(
#'   paste0(
#'     "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
#'     "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
#'     "\u3068\u304a\u3063\u305f\u98a8"
#'   ),
#'   format = "data.frame"
#' )
strj_tokenize <- function(
  text,
  format = c("list", "data.frame"),
  engine = c("stringi", "budoux", "tinyseg"),
  split = FALSE,
  ...
) {
  if (any(engine %in% c("mecab", "sudachipy"))) {
    rlang::abort(
      "The `mecab` and `sudachipy` engines were removed in v0.6.0."
    )
  }
  format <- rlang::arg_match(format)
  engine <- rlang::arg_match(
    engine,
    c("stringi", "budoux", "tinyseg")
  )

  nm <- names(text)
  if (is.null(nm)) {
    nm <- seq_along(text)
  }
  text <- stringi::stri_enc_toutf8(text) |>
    rlang::set_names(nm)

  res <-
    switch(
      engine,
      stringi = tokenize_stringi(text, split),
      budoux = tokenize_budoux(text, split),
      tinyseg = tokenize_tinyseg(text, split)
    )

  if (identical(format, "data.frame")) {
    return(res)
  }
  dplyr::group_by(res, .data$doc_id) |>
    dplyr::group_map(~ .x$token) |>
    rlang::set_names(nm)
}

#' @rdname strj_tokenize
#' @export
strj_segment <- function(
  text,
  format = c("list", "data.frame"),
  split = FALSE
) {
  format <- rlang::arg_match(format)
  strj_tokenize(text, format, engine = "budoux", split)
}

#' @rdname strj_tokenize
#' @export
strj_tinyseg <- function(
  text,
  format = c("list", "data.frame"),
  split = FALSE
) {
  format <- rlang::arg_match(format)
  strj_tokenize(text, format, engine = "tinyseg", split)
}
