### lex_density ----
test_that("lex_density works", {
  res <-
    prettify(head(hiroba, 32L), col_select = "POS1") |>
    dplyr::summarise(
      noun_ratio = lex_density(POS1,
        "\u540d\u8a5e",
        c("\u52a9\u8a5e", "\u52a9\u52d5\u8a5e"),
        negate = c(FALSE, TRUE)
      ),
      .by = "doc_id"
    )
  expect_snapshot_value(res, style = "json2", cran = FALSE)
})
