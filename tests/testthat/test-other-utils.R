testdata <- readRDS(system.file("testdata/testdata.rda", package = "audubon"))

### pack ----
test_that("pack works", {
  res1 <- pack(testdata[[7]])
  res2 <- pack(testdata[[7]], n = 2L)
  expect_equal(nrow(res1), 50L)
  expect_equal(nrow(res2), 50L)
})

### prettify ----
test_that("prettify works", {
  expect_error(prettify(hiroba, col_select = c(1, 10)))
  expect_equal(ncol(prettify(hiroba)), 13L)
  expect_equal(ncol(prettify(hiroba, col_select = c(1, 2, 3))), 7L)
  expect_equal(ncol(prettify(hiroba, col_select = 1:3)), 7L)
  expect_equal(ncol(prettify(hiroba, col_select = c("POS1", "POS2", "POS3"))), 7L)
})

### get_dict_features ----
test_that("get_dict_features works", {
  expect_equal(length(get_dict_features()), 9L)
  expect_equal(length(get_dict_features("unidic17")), 17L)
  expect_equal(length(get_dict_features("unidic26")), 26L)
  expect_equal(length(get_dict_features("unidic29")), 29L)
  expect_equal(length(get_dict_features("cc-cedict")), 8L)
  expect_equal(length(get_dict_features("ko-dic")), 8L)
  expect_equal(length(get_dict_features("naist11")), 11L)
  expect_equal(length(get_dict_features("sudachi")), 9L)
})
