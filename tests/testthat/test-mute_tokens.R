### mute_tokens ----
test_that("mute_tokens works", {
  df <- prettify(head(hiroba, 32L), col_select = "POS1")
  res <- collapse_tokens(df, POS1 %in% c("\u52a9\u8a5e", "\u52a9\u52d5\u8a5e"))
  expect_snapshot_value(res, style = "json2", cran = FALSE)
})
