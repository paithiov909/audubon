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
    dplyr::mutate(doc_id = factor(.data$doc_id, unique(.data$doc_id)))
}

#' @keywords internal
tokenize_budoux <- function(text, split) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  purrr::imap_dfr(text, function(vec, doc_id) {
    if (split) {
      vec <- stringi::stri_split_boundaries(vec, type = "sentence") %>%
        unlist()
    }
    data.frame(
      doc_id = doc_id,
      token = unlist(lapply(vec, function(elem) {
        if (is.na(elem)) {
          return(NA_character_)
        }
        ctx$call("audubon.parser.parse", elem)
      }))
    )
  }) %>%
    dplyr::mutate(doc_id = factor(.data$doc_id, unique(.data$doc_id)))
}

tokenize_tinyseg <- function(text, split) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  purrr::imap_dfr(text, function(vec, doc_id) {
    if (split) {
      vec <- stringi::stri_split_boundaries(vec, type = "sentence") %>%
        unlist()
    }
    data.frame(
      doc_id = doc_id,
      token = unlist(lapply(vec, function(elem) {
        if (is.na(elem)) {
          return(NA_character_)
        }
        ctx$call("audubon.tinysegmenter.segment", elem)
      }))
    )
  }) %>%
    dplyr::mutate(doc_id = factor(.data$doc_id, unique(.data$doc_id)))
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
    dplyr::mutate(doc_id = factor(.data$doc_id, unique(.data$doc_id))) %>%
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
    dplyr::mutate(doc_id = factor(.data$doc_id, unique(.data$doc_id))) %>%
    dplyr::relocate("doc_id", "token", "normalized", "feature")
}
