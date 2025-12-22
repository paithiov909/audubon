#' @noRd
tokenize_stringi <- function(text, split) {
  purrr::imap_dfr(text, function(vec, doc_id) {
    if (split) {
      vec <- stringi::stri_split_boundaries(vec, type = "sentence") |>
        unlist(use.names = FALSE)
    }
    data.frame(
      doc_id = doc_id,
      token = unlist(
        stringi::stri_split_boundaries(vec, type = "word"),
        use.names = FALSE
      )
    )
  }) |>
    dplyr::mutate(doc_id = factor(.data$doc_id, unique(.data$doc_id)))
}

#' @noRd
tokenize_budoux <- function(text, split) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  purrr::imap_dfr(text, function(vec, doc_id) {
    if (split) {
      vec <- stringi::stri_split_boundaries(vec, type = "sentence") |>
        unlist(use.names = FALSE)
    }
    data.frame(
      doc_id = doc_id,
      token = unlist(
        lapply(vec, function(elem) {
          if (is.na(elem)) {
            return(NA_character_)
          }
          ctx$call("window.audubon.parser.parse", elem)
        }),
        use.names = FALSE
      )
    )
  }) |>
    dplyr::mutate(doc_id = factor(.data$doc_id, unique(.data$doc_id)))
}

#' @noRd
tokenize_tinyseg <- function(text, split) {
  ctx <- rlang::env_get(.pkgenv, "ctx")
  purrr::imap_dfr(text, function(vec, doc_id) {
    if (split) {
      vec <- stringi::stri_split_boundaries(vec, type = "sentence") |>
        unlist(use.names = FALSE)
    }
    data.frame(
      doc_id = doc_id,
      token = unlist(lapply(vec, function(elem) {
        if (is.na(elem)) {
          return(NA_character_)
        }
        ctx$call("window.audubon.tinysegmenter.segment", elem)
      }))
    )
  }) |>
    dplyr::mutate(doc_id = factor(.data$doc_id, unique(.data$doc_id)))
}
