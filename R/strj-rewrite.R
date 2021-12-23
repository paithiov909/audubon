#' Rewrite text using rewrite.def
#'
#' @param text Character vector.
#' @param as List.
#' @returns Character vector
#' @export
strj_rewrite_as_def <- function(text, as = read_rewrite_def()) {
  textloop <- stringi::stri_split_boundaries(text, type = "character")
  pattern <- purrr::map_chr(as$replace, ~ purrr::pluck(., 1))
  rep <- purrr::map_chr(as$replace, ~ purrr::pluck(., 2))
  purrr::map_chr(textloop, function(chr) {
    flags <- chr %in% as$ignore
    purrr::reduce2(chr, flags, function(pre, nxt, is_ignored) {
      paste0(
        pre,
        ifelse(is_ignored, nxt, apply_rep_all(nxt, pattern, rep))
      )
    }, .init = "")
  })
}

#' Read rewrite.def file
#'
#' @param def_path Character scalar; path to the rewriting definition file.
#' @returns List.
#' @export
read_rewrite_def <- function(def_path = system.file("def/rewrite.def", package = "rjavacmecab")) {
  res <-
    rlang::env_get(.pkgenv, "read_def", default = read_rewrite_def_impl())(def_path)
  return(res)
}

#' @noRd
read_rewrite_def_impl <- function() {
  function(def_path) {
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
}

#' @noRd
apply_rep_all <- function(text, pattern, rep) {
  res <- stringi::stri_replace_all_fixed(text, pattern = pattern, replace = rep, vectorise_all = FALSE)
  return(stringi::stri_trans_nfkc(res))
}
