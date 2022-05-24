str <- paste0(
  c(
    "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
    "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
    "\u3068\u304a\u3063\u305f\u98a8"
  ),
  collapse = ""
)

test_that("tokenize works", {
  li <- unname(strj_tokenize(str))
  expect_equal(li[[1]][1], enc2utf8("\u3042\u306e"))
})

test_that("segment works", {
  li <- unname(strj_segment(str))
  expect_equal(li[[1]][4], enc2utf8("\u98a8"))
})

test_that("tinyseg works", {
  li <- unname(strj_tinyseg(str))
  expect_equal(li[[1]][3], enc2utf8("\u30a4\u30fc\u30cf\u30c8\u30fc\u30f4\u30a9"))
})
