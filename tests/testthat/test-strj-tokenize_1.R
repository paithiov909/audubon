str <- paste0(
  c(
    "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
    "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
    "\u3068\u304a\u3063\u305f\u98a8"
  ),
  collapse = ""
)

### strj_segment ----
test_that("segment works", {
  li <- unname(strj_segment(str))
  df <- strj_segment(str, format = "data.frame")
  expect_equal(li[[1]][4], enc2utf8("\u98a8"))
  expect_equal(df[4, 2], enc2utf8("\u98a8"))
})

### strj_tinyseg ----
test_that("tinyseg works", {
  li <- unname(strj_tinyseg(str))
  df <- strj_tinyseg(str, format = "data.frame")
  expect_equal(li[[1]][3], enc2utf8("\u30a4\u30fc\u30cf\u30c8\u30fc\u30f4\u30a9"))
  expect_equal(df[3, 2], enc2utf8("\u30a4\u30fc\u30cf\u30c8\u30fc\u30f4\u30a9"))
})

### strj_tokenize ----
test_that("tokenize works", {
  li <- unname(strj_tokenize(str))
  df <- strj_tokenize(str, format = "data.frame")
  expect_equal(li[[1]][1], enc2utf8("\u3042\u306e"))
  expect_equal(df[1, 2], enc2utf8("\u3042\u306e"))
})
