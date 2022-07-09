#' Segment text into phrases
#'
#' Segments Japanese text into several phrases
#' using the 'google/budoux' JavaScript module or 'TinySegmenter.js'.
#'
#' @param text Character vector to be tokenized.
#' @param format Output format. Choose `list` or `data.frame`.
#' @param engine Splitting engine to be used.
#' @param split Logical. If true, the function splits the vector
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
strj_segment <- function(text,
                         format = c("list", "data.frame"),
                         engine = c("budoux", "tinyseg"),
                         split = FALSE) {
  stopifnot(!is.null(text))

  format <- rlang::arg_match(format)
  engine <- rlang::arg_match(engine, c("budoux", "tinyseg"))

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
        if (identical(engine, "budoux")) {
          ctx$call("audubon.parser.parse", elem)
        } else {
          ctx$call("audubon.tinysegmenter.segment", elem)
        }
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
          if (identical(engine, "budoux")) {
            ctx$call("audubon.parser.parse", elem)
          } else {
            ctx$call("audubon.tinysegmenter.segment", elem)
          }
        }))
      )
    }) %>%
      dplyr::mutate(doc_id = as.factor(.data$doc_id))
  }
}

#' Segment text into phrases
#'
#' An alias of `strj_segment(engine = "tinyseg")`.
#'
#' @param text Character vector to be tokenized.
#' @param format Output format. Choose `list` or `data.frame`.
#' @param split Logical. If true, the function splits vectors
#' into some sentences using \code{stringi::stri_split_boundaries(type = "sentence")}
#' before tokenizing.
#' @return A list or data.frame.
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
  strj_segment(text, format, engine = "tinyseg", split)
}
