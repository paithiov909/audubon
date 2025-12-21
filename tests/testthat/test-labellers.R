test_that("label_wrap_jp works", {
  expect_error(
    label_wrap_jp(
      polano[4:8],
      width = 2
    )
  )
  expect_snapshot_value(
    label_wrap_jp(
      polano[4:8],
      width = 32
    ),
    style = "json2"
  )
})

test_that("label_date_jp works", {
  # This test seems to be locale-sensitive.
  skip_on_cran()
  skip_on_ci()

  date_range <- function(start, days) {
    start <- as.POSIXct(start)
    c(start, start + days * 24 * 60 * 60)
  }
  two_months <- date_range("2025-12-31", 90)
  expect_snapshot_value(
    label_date_jp(two_months),
    style = "json2"
  )
})
