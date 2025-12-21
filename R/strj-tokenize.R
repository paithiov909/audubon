#' Split text into tokens
#'
#' Splits text into several tokens using specified tokenizer.
#'
#' @param text Character vector to be tokenized.
#' @param format Output format. Choose `list` or `data.frame`.
#' @param engine Tokenizer name. One of "stringi", "budoux", "tinyseg".
#' @param split Logical. If `TRUE`, the function splits vectors
#' @returns A list or a data.frame.
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
      "The tokenizer `mecab` and `sudachipy` were removed in v0.6.0."
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

#' Segment text into tokens
#'
#' An alias of `strj_tokenize(engine = "budoux")`.
#'
#' @param text Character vector to be tokenized.
#' @param format Output format. Choose `list` or `data.frame`.
#' @param split Logical. If passed as, the function splits the vector
#' into some sentences using \code{stringi::stri_split_boundaries(type = "sentence")}
#' before tokenizing.
#' @returns A List or a data.frame.
#' @export
#' @examples
#' strj_segment(
#'   paste0(
#'     "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
#'     "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
#'     "\u3068\u304a\u3063\u305f\u98a8"
#'   )
#' )
#' strj_segment(
#'   paste0(
#'     "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
#'     "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
#'     "\u3068\u304a\u3063\u305f\u98a8"
#'   ),
#'   format = "data.frame"
#' )
strj_segment <- function(
  text,
  format = c("list", "data.frame"),
  split = FALSE
) {
  format <- rlang::arg_match(format)
  strj_tokenize(text, format, engine = "budoux", split)
}

#' Segment text into phrases
#'
#' An alias of `strj_tokenize(engine = "tinyseg")`.
#'
#' @param text Character vector to be tokenized.
#' @param format Output format. Choose `list` or `data.frame`.
#' @param split Logical. If passed as `TRUE`, the function splits vectors
#' into some sentences using \code{stringi::stri_split_boundaries(type = "sentence")}
#' before tokenizing.
#' @returns A list or a data.frame.
#' @export
#' @examples
#' strj_tinyseg(
#'   paste0(
#'     "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
#'     "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
#'     "\u3068\u304a\u3063\u305f\u98a8"
#'   )
#' )
#' strj_tinyseg(
#'   paste0(
#'     "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
#'     "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
#'     "\u3068\u304a\u3063\u305f\u98a8"
#'   ),
#'   format = "data.frame"
#' )
strj_tinyseg <- function(
  text,
  format = c("list", "data.frame"),
  split = FALSE
) {
  format <- rlang::arg_match(format)
  strj_tokenize(text, format, engine = "tinyseg", split)
}
