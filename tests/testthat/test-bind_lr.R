### bind_lr ----
test_that("bind_lr works", {
  res <-
    prettify(head(hiroba, 32L), col_select = "POS1") |>
    dplyr::add_count(doc_id, token) |>
    mute_tokens(POS1 != "\u540d\u8a5e") |>
    bind_lr() |>
    dplyr::mutate(lr = dplyr::percent_rank(n * lr))
  expect_snapshot_value(res, style = "json2", cran = FALSE)
})
