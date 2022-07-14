#' Split text into tokens
#'
#' Splits text into several tokens using specified tokenizer.
#'
#' @param text Character vector to be tokenized.
#' @param format Output format. Choose `list` or `data.frame`.
#' @param engine Tokenizer name. Choose one of 'stringi', 'mecab', or 'sudachipy'.
#' Note that the specified tokenizer is installed and available when you use
#' 'mecab' or 'sudachipy'.
#' @param rcpath Path to a setting file for 'MeCab' or 'sudachipy' if any.
#' @param mode Splitting mode for 'sudachipy'.
#' @param split Logical. If true, the function splits the vector
#' into some sentences using \code{stringi::stri_split_boundaries(type = "sentence")}
#' before tokenizing.
#' @return A list or data.frame.
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
                          engine = c("stringi", "mecab", "sudachipy"),
                          rcpath = NULL,
                          mode = c("C", "B", "A"),
                          split = FALSE) {
  stopifnot(!is.null(text))
  format <- rlang::arg_match(format)
  engine <- rlang::arg_match(engine, c("stringi", "mecab", "sudachipy"))
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

#' @keywords internal
tokenize_stringi <- function(text, split) {
  purrr::imap_dfr(text, function(vec, doc_id) {
    if (split) {
      vec <- stringi::stri_split_boundaries(vec, type = "sentence") %>%
        unlist()
    }
    data.frame(
      doc_id = doc_id,
      token = unlist(stringi::stri_split_boundaries(vec, type = "word"))
    )
  }) %>%
    dplyr::mutate(doc_id = as.factor(.data$doc_id))
}

#' @keywords internal
tokenize_mecab <- function(text, split, rcpath = NULL) {
  tmp_file_txt <- tempfile(fileext = ".txt")
  files <-
    purrr::imap_chr(text, function(elem, doc_id) {
      out <- tempfile(fileext = ".txt")
      if (split) {
        elem <- stringi::stri_split_boundaries(elem, type = "sentence") %>%
          unlist()
      }
      readr::write_lines(elem, tmp_file_txt, append = FALSE)
      if (!is.null(rcpath)) {
        system2(
          "mecab",
          args = c(
            "-o",
            out,
            "-r",
            file.path(rcpath),
            file.path(tmp_file_txt)
          )
        )
      } else {
        system2(
          "mecab",
          args = c(
            "-o",
            out,
            file.path(tmp_file_txt)
          )
        )
      }
      purrr::set_names(file.path(out), doc_id)
    })
  purrr::imap_dfr(files, function(path, doc_id) {
    data.frame(
      doc_id = doc_id,
      readr::read_lines(path) %>%
        purrr::discard(~ .x == "EOS") %>%
        I() |>
        readr::read_tsv(
          col_names = c("token", "feature"),
          progress = FALSE,
          show_col_types = FALSE
        )
    )
  }) %>%
    dplyr::mutate(doc_id = as.factor(.data$doc_id)) %>%
    dplyr::relocate("doc_id", "token", "feature")
}

#' @keywords internal
tokenize_sudachipy <- function(text, split, rcpath, mode) {
  tmp_file_txt <- tempfile(fileext = ".txt")
  files <-
    purrr::imap_chr(text, function(elem, doc_id) {
      out <- tempfile(fileext = ".txt")
      if (split) {
        elem <- stringi::stri_split_boundaries(elem, type = "sentence") %>%
          unlist()
      }
      readr::write_lines(elem, tmp_file_txt, append = FALSE)
      if (!is.null(rcpath)) {
        system2(
          "sudachipy",
          args = c(
            "-m",
            mode,
            "-o",
            out,
            "-r",
            file.path(rcpath),
            file.path(tmp_file_txt)
          )
        )
      } else {
        system2(
          "sudachipy",
          args = c(
            "-m",
            mode,
            "-o",
            out,
            file.path(tmp_file_txt)
          )
        )
      }
      purrr::set_names(file.path(out), doc_id)
    })
  purrr::imap_dfr(files, function(path, doc_id) {
    data.frame(
      doc_id = doc_id,
      readr::read_lines(path) %>%
        purrr::discard(~ .x == "EOS") %>%
        I() |>
        readr::read_tsv(
          col_names = c("token", "feature", "normalized"),
          progress = FALSE,
          show_col_types = FALSE
        )
    )
  }) %>%
    dplyr::mutate(doc_id = as.factor(.data$doc_id)) %>%
    dplyr::relocate("doc_id", "token", "normalized", "feature")
}
