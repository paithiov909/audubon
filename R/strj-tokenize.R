#' Simply tokenize sentence
#'
#' Split the given sentence into tokens
#' using \code{stringi::stri_split_boundaries(type = "word")}.
#'
#' @param sentence Character vector to be tokenized.
#' @return data.frame.
#'
#' @export
strj_tokenize <- function(sentence) {
  # keep names
  nm <- names(sentence)
  if (identical(nm, NULL)) {
    nm <- seq_along(sentence)
  }
  sentence <- enc2utf8(sentence) %>%
    purrr::set_names(nm)

  result <-
    purrr::imap_dfr(sentence, function(vec, doc_id) {
      if (identical(split, TRUE)) {
        vec <- stringi::stri_split_boundaries(vec, type = "sentence") %>%
          unlist()
      }
      data.frame(
        doc_id = doc_id,
        token = unlist(stringi::stri_split_boundaries(vec, type = "word"))
      )
    }) %>%
    dplyr::mutate(
      doc_id = as.factor(.data$doc_id),
    )
  return(result)
}
