test_that("strj_fill works", {
  expect_equal(
    strj_fill_iter_mark(
      c(
        NA_character_, NULL, "", ## expected to be just skipped.
        "\u3042\u3044\u3046\u309d\u3003\u304b\u304d",
        "\u91d1\u5b50\u307f\u3059\u309e",
        "\u3057\u308d\uff0f\u2033\uff3c\u3068"
      )
    ),
    c(
      enc2utf8("\u3042\u3044\u3046\u3046\u3046\u304b\u304d"),
      enc2utf8("\u91d1\u5b50\u307f\u3059\u3059\uff9e"),
      enc2utf8("\u3057\u308d\u3057\uff9e\u308d\u3068")
    )
  )
})
