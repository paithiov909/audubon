#' Rewrite text using rewrite.def
#'
#' Rewrites text using a 'rewrite.def' file.
#'
#' @param text Character vector to be normalized.
#' @param as List.
#' @returns A character vector.
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

#' Read a rewrite.def file
#'
#' @param def_path Character scalar; path to the rewriting definition file.
#' @return A list.
#' @export
#' @examples
#' str(read_rewrite_def())
read_rewrite_def <- function(
  def_path = system.file("def/rewrite.def", package = "audubon")
) {
  cols <- def_path |>
    readr::read_lines() |>
    purrr::discard(~ stringi::stri_detect_fixed(., "#")) |>
    stringi::stri_split_fixed("\t")
  list(
    ignore = purrr::discard(cols, ~ length(.) > 1),
    replace = purrr::discard(cols, ~ length(.) < 2)
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
