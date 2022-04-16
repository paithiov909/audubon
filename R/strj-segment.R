#' Segment text into phrases
#'
#' Segment Japanese text into several phrases
#' using the 'google/budoux' JavaScript module.
#'
#' @param text Character vector to be tokenized.
#' @param format Output format. Choose `list` or `data.frame`.
#' @param split Logical. If true, the function splits vectors
#' into some sentences using \code{stringi::stri_split_boundaries(type = "sentence")}
#' before tokenizing.
#' @return List or data.frame.
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
strj_segment <- function(text, format = c("list", "data.frame"), split = FALSE) {
  stopifnot(!is.null(text))

  format <- rlang::arg_match(format)

  # keep names
  nm <- names(text)
  if (identical(nm, NULL)) {
    nm <- seq_along(text)
  }
  text <- stringi::stri_enc_toutf8(text) %>%
    purrr::set_names(nm)

  ctx <- rlang::env_get(.pkgenv, "ctx")

  if (identical(format, "list")) {
    purrr::imap(text, function(vec, doc_id) {
      if (identical(split, TRUE)) {
        vec <- stringi::stri_split_boundaries(vec, type = "sentence") %>%
          unlist()
      }
      unlist(lapply(vec, function(elem) {
        if (is.na(elem)) {
          return(NA_character_)
        }
        ctx$call("audubon.parser.parse", elem)
      }))
    })
  } else {
    purrr::imap_dfr(text, function(vec, doc_id) {
      if (identical(split, TRUE)) {
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
      dplyr::mutate(doc_id = as.factor(.data$doc_id))
  }
}
