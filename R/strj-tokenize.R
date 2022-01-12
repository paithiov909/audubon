#' Simply tokenize sentence
#'
#' Split the given sentence into tokens
#' using \code{stringi::stri_split_boundaries(type = "word")}.
#'
#' @param sentence Character vector to be tokenized.
#' @return data.frame.
#' @export
#' @examples
#' strj_tokenize("\u3042\u306e\u30a4\u30fc\u30cf\u30c8\u30fc\u30f4\u30a9\u306e\u3059\u304d\u3068\u304a\u3063\u305f\u98a8")
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
