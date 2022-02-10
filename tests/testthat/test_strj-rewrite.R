test_that("strj_rewrite works", {
  expect_equal(
    strj_rewrite_as_def(c(NA_character_, "\u2160\u2161\u2162", "123")),
    c(
      "NA", ## this is expected behavior.
      "\u2160\u2161\u2162",
      "123"
    )
  )
})
