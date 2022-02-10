res1 <-
  strj_tokenize(polano[1:30], format = "data.frame")
res2 <-
  strj_segment(polano[1:30], format = "data.frame")

test_that("pack works", {
  expect_s3_class(pack(res1), "data.frame")
  expect_s3_class(pack(res2, n = 2L), "data.frame")
})
