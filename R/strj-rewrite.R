#' Rewrite Japanese text using normalization rules
#'
#' Rewrites Japanese text according to a set of normalization rules modeled
#' after Sudachi dictionary definitions.
#'
#' This function applies character-level rewrite rules to normalize variant
#' forms while optionally ignoring specified characters. The implementation
#' is a simplified and heuristic adaptation of Sudachi-style normalization.
#'
#' @details
#' The rewrite process is based on fixed replacement rules and does not aim
#' to fully reproduce Sudachi's normalization behavior.
#'
#' @param text A character vector containing Japanese text.
#' @param as A rewrite definition object as returned by
#'  `read_rewrite_def()`.
#' @returns
#' A character vector with rewritten and normalized text.
#' @export
#' @examples
#' strj_rewrite_as_def(
#'   paste0(
#'     "\u2015\u2015\u5357\u30a2\u30eb",
#'     "\u30d7\u30b9\u306e\u3000\u5929",
#'     "\u7136\u6c34-\u3000\uff33\uff50",
#'     "\uff41\uff52\uff4b\uff49\uff4e\uff47*",
#'     "\u3000\uff2c\uff45\uff4d\uff4f\uff4e+",
#'     "\u3000\u30ec\u30e2\u30f3\u4e00\u7d5e\u308a"
#'   )
#' )
#' strj_rewrite_as_def(
#'   "\u60e1\u3068\u5047\u9762\u306e\u30eb\u30fc\u30eb",
#'   read_rewrite_def(system.file("def/kyuji.def", package = "audubon"))
#' )
strj_rewrite_as_def <- function(text, as = read_rewrite_def()) {
  textloop <- stringi::stri_split_boundaries(text, type = "character")
  pattern <- unlist(
    lapply(as$replace, function(x) purrr::pluck(x, 1)),
    use.names = FALSE
  )
  rep <- unlist(
    lapply(as$replace, function(x) purrr::pluck(x, 2)),
    use.names = FALSE
  )
  unlist(
    lapply(textloop, function(chr) {
      flags <- chr %in% as$ignore
      purrr::reduce2(
        chr,
        flags,
        function(pre, nxt, is_ignored) {
          # NOTE: This should not be `paste0`
          stringi::stri_c(
            pre,
            ifelse(is_ignored, nxt, apply_rep_all(nxt, pattern, rep))
          )
        },
        .init = ""
      )
    }),
    use.names = FALSE
  )
}

#' Read rewrite definition file
#'
#' @description
#' Reads a rewrite definition file used for Japanese text normalization.
#'
#' This function parses a tab-delimited definition file and returns a list
#' of rewrite rules and ignored characters suitable for use with
#' `strj_rewrite_as_def()`.
#'
#' @param def_path A file path to a rewrite definition file.
#' @returns
#' A list containing rewrite rules and ignored characters.
#' @export
#' @examples
#' str(read_rewrite_def())
read_rewrite_def <- function(
  def_path = system.file("def/rewrite.def", package = "audubon")
) {
  lines <- def_path |>
    readr::read_lines() |>
    purrr::discard(~ stringi::stri_detect_fixed(., "#")) |>
    stringi::stri_split_fixed("\t")
  list(
    ignore = purrr::discard(lines, ~ length(.) > 1),
    replace = purrr::discard(lines, ~ length(.) < 2)
  )
}

#' @noRd
apply_rep_all <- function(text, pattern, rep) {
  res <- stringi::stri_replace_all_fixed(
    text,
    pattern = pattern,
    replacement = rep,
    vectorise_all = FALSE
  )
  stringi::stri_trans_nfkc(res)
}
