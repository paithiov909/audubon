#' Prettify tokenized output
#'
#' @param df A data.frame that has feature column to be prettified.
#' @param into Character vector that is used as column names of
#' features.
#' @param col_select Character or integer vector that will be kept
#' in prettified result.
#'
#' @return A data.frame.
#' @export
prettify <- function(df,
                     into = get_dict_features("ipa"),
                     col_select = seq_along(into)) {
  if (is.numeric(col_select) && max(col_select) <= length(into)) {
    col_select <- which(seq_along(into) %in% col_select, arr.ind = TRUE)
  } else {
    col_select <- which(into %in% col_select, arr.ind = TRUE)
  }
  if (rlang::is_empty(col_select)) {
    rlang::abort("Invalid columns have been selected.")
  }
  suppressWarnings({
    ## ignore warnings when there are missing columns.
    features <-
      c(
        stringi::stri_c(into, collapse = ","),
        dplyr::pull(df, "feature")
      ) %>%
      stringi::stri_c(collapse = "\n") %>%
      I() %>%
      readr::read_csv(
        col_types = stringi::stri_c(rep("c", length(into)), collapse = ""),
        col_select = tidyselect::all_of(col_select),
        na = c("*"),
        progress = FALSE,
        show_col_types = FALSE
      )
  })
  dplyr::bind_cols(dplyr::select(df, !.data$feature), features)
}

#' Get dictionary's features
#'
#' Returns dictionary's features.
#' Currently supports "unidic17" (2.1.2 src schema), "unidic26" (2.1.2 bin schema),
#' "unidic29" (schema used in 2.2.0, 2.3.0), "cc-cedict", "ko-dic" (mecab-ko-dic),
#' "naist11", "sudachi", and "ipa".
#'
#' @seealso See also
#' \href{https://github.com/ueda-keisuke/CC-CEDICT-MeCab}{'CC-CEDICT-MeCab'},
#' and \href{https://bitbucket.org/eunjeon/mecab-ko-dic/src/master/}{'mecab-ko-dic'}.
#' @param dict Character scalar; one of "ipa", "unidic17", "unidic26", "unidic29",
#' "cc-cedict", "ko-dic", "naist11", or "sudachi".
#' @return A character vector.
#' @export
#' @examples
#' get_dict_features("ipa")
get_dict_features <- function(dict = c(
                                "ipa",
                                "unidic17",
                                "unidic26",
                                "unidic29",
                                "cc-cedict",
                                "ko-dic",
                                "naist11",
                                "sudachi"
                              )) {
  dict <- rlang::arg_match(dict)
  feat <- dplyr::case_when(
    dict == "unidic17" ~ list(c(
      "POS1", "POS2", "POS3", "POS4", "cType", "cForm", "lForm",
      "lemma", "orth", "pron",
      "orthBase", "pronBase", "goshu", "iType", "iForm", "fType", "fForm"
    )),
    dict == "unidic26" ~ list(c(
      "POS1", "POS2", "POS3", "POS4", "cType", "cForm", "lForm", "lemma", "orth", "pron",
      "orthBase", "pronBase", "goshu", "iType", "iForm", "fType", "fForm",
      "kana", "kanaBase", "form", "formBase", "iConType", "fConType", "aType",
      "aConType", "aModeType"
    )),
    dict == "unidic29" ~ list(c(
      "POS1", "POS2", "POS3", "POS4", "cType",
      "cForm", "lForm", "lemma", "orth", "pron", "orthBase", "pronBase", "goshu", "iType", "iForm", "fType",
      "fForm", "iConType", "fConType", "type", "kana", "kanaBase", "form", "formBase", "aType", "aConType",
      "aModType", "lid", "lemma_id"
    )),
    dict == "cc-cedict" ~ list(c(
      "POS1", "POS2", "POS3", "POS4",
      "pinyin_pron", "traditional_char_form", "simplified_char_form",
      "definition"
    )),
    dict == "ko-dic" ~ list(c(
      "POS", "meaning", "presence", "reading", "type", "first_pos", "last_pos", "expression"
    )),
    dict == "naist11" ~ list(c(
      "POS1", "POS2", "POS3", "POS4", "X5StageUse1", "X5StageUse2", "Original", "Yomi1", "Yomi2", "Info", "Misc"
    )),
    dict == "sudachi" ~ list(c(
      "POS1", "POS2", "POS3", "POS4", "X5StageUse1", "X5StageUse2"
    )),
    TRUE ~ list(c("POS1", "POS2", "POS3", "POS4", "X5StageUse1", "X5StageUse2", "Original", "Yomi1", "Yomi2"))
  )
  unlist(feat)
}
