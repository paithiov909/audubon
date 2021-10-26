#' Rewrite text using rewrite.def
#'
#' @param text Character vector.
#' @param def_path Character scalar; path to the rewriting definition file.
#' @returns Character vector
#' @export
strj_rewrite_as_def <- function(text, def_path = system.file("rewrite.def", package = "audubon")) {
  textloop <- stringi::stri_split_boundaries(text, type = "character")
  rewrite <- read_rewrite_def(def_path)
  furrr::future_map_chr(textloop, function(chr) {
    flags <- chr %in% rewrite$ignore
    purrr::reduce2(chr, flags, function(pre, nxt, is_ignored) {
      paste0(
        pre,
        ifelse(is_ignored, nxt, apply_rep_all(nxt, rewrite$replace))
      )
    }, .init = "")
  })
}

#' @noRd
read_rewrite_def <- function(def_path) {
  cols <- def_path %>%
    readr::read_lines() %>%
    purrr::discard(~ stringi::stri_detect_fixed(., "#")) %>%
    stringi::stri_split_fixed("\t")
  return(
    list(
      ignore = purrr::discard(cols, ~ length(.) > 1),
      replace = purrr::discard(cols, ~ length(.) < 2)
    )
  )
}

#' @noRd
apply_rep_all <- function(text, def) {
  pattern <- purrr::map_chr(def, ~ purrr::pluck(., 1))
  rep <- purrr::map_chr(def, ~ purrr::pluck(., 2))
  res <- stringi::stri_replace_all_fixed(text, pattern = pattern, replace = rep)
  return(stringi::stri_trans_nfkc(res))
}
