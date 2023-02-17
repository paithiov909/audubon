#' Split text into tokens
#'
#' Splits text into several tokens using specified tokenizer.
#'
#' @param text Character vector to be tokenized.
#' @param format Output format. Choose `list` or `data.frame`.
#' @param engine Tokenizer name. Choose one of 'stringi', 'budoux',
#' 'tinyseg', 'mecab', or 'sudachipy'.
#' Note that the specified tokenizer is installed and available when you use
#' 'mecab' or 'sudachipy'.
#' @param rcpath Path to a setting file for 'MeCab' or 'sudachipy' if any.
#' @param mode Splitting mode for 'sudachipy'.
#' @param split Logical. If passed as `TRUE`, the function splits the vector
#' into some sentences using \code{stringi::stri_split_boundaries(type = "sentence")}
#' before tokenizing.
#' @return A list or a data.frame.
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
strj_tokenize <- function(text,
                          format = c("list", "data.frame"),
                          engine = c("stringi", "budoux", "tinyseg", "mecab", "sudachipy"),
                          rcpath = NULL,
                          mode = c("C", "B", "A"),
                          split = FALSE) {
  stopifnot(is.character(text))
  format <- rlang::arg_match(format)
  engine <- rlang::arg_match(
    engine,
    c("stringi", "budoux", "tinyseg", "mecab", "sudachipy")
  )
  mode <- rlang::arg_match(mode, c("C", "B", "A"))

  # keep names
  nm <- names(text)
  if (identical(nm, NULL)) {
    nm <- seq_along(text)
  }
  text <- stringi::stri_enc_toutf8(text) %>%
    purrr::set_names(nm)

  res <-
    switch(engine,
      stringi = tokenize_stringi(text, split),
      budoux = tokenize_budoux(text, split),
      tinyseg = tokenize_tinyseg(text, split),
      mecab = tokenize_mecab(text, split, rcpath),
      sudachipy = tokenize_sudachipy(text, split, rcpath, mode)
    )

  if (identical(format, "data.frame")) {
    return(res)
  }
  dplyr::group_by(res, .data$doc_id) %>%
    dplyr::group_map(~ .x$token) %>%
    purrr::set_names(nm)
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
#' @return A List or a data.frame.
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
strj_segment <- function(text,
                         format = c("list", "data.frame"),
                         split = FALSE) {
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
#' @return A list or a data.frame.
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
strj_tinyseg <- function(text,
                         format = c("list", "data.frame"),
                         split = FALSE) {
  format <- rlang::arg_match(format)
  strj_tokenize(text, format, engine = "tinyseg", split)
}
