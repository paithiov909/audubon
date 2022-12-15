### collapse_tokens ----
test_that("collapse_tokens works", {
  res <- prettify(head(hiroba, 32L), col_select = "POS1") |>
    collapse_tokens(POS1 == "\u540d\u8a5e")
  expect_snapshot_value(res, style = "json2", cran = FALSE)
})
