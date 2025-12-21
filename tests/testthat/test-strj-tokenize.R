### strj_segment ----
test_that("segment works", {
  li <- unname(strj_segment(polano[4:8]))
  expect_snapshot_value(li, style = "json2")
  df <- strj_segment(polano[4:8], format = "data.frame")
  expect_equal(nrow(df), sum(lengths(li)))
  expect_equal(nlevels(df[["doc_id"]]), length(polano[4:8]))
})

### strj_tinyseg ----
test_that("tinyseg works", {
  li <- unname(strj_tinyseg(polano[4:8]))
  expect_snapshot_value(li, style = "json2")
  df <- strj_tinyseg(polano[4:8], format = "data.frame")
  expect_equal(nrow(df), sum(lengths(li)))
  expect_equal(nlevels(df[["doc_id"]]), length(polano[4:8]))
})

### strj_tokenize ----
test_that("tokenize works", {
  li <- unname(strj_tokenize(polano[4:8]))
  expect_snapshot_value(li, style = "json2")
  df <- strj_tokenize(polano[4:8], format = "data.frame")
  expect_equal(nrow(df), sum(lengths(li)))
  expect_equal(nlevels(df[["doc_id"]]), length(polano[4:8]))
})
