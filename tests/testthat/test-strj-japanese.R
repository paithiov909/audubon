### strj_hiraganize, katakanize, romanize, and transcribe_num ----
test_that("strj-japanese works", {
  expect_true(
    !stringi::stri_detect_charclass(
      strj_hiraganize("\u30a2\u30a2"),
      "[:Katakana:]"
    )
  )
  expect_true(
    !stringi::stri_detect_charclass(
      strj_katakanize("\u3042\u3042"),
      "[:Hiragana:]"
    )
  )
  expect_equal(
    stringi::stri_trans_general(
      strj_romanize("\u30a4\u30fc\u30cf\u30c8\u30fc\u30d6"),
      "latin-ascii"
    ),
    "ihatobu"
  )
  expect_equal(
    strj_transcribe_num(1111L),
    "\u5343\u767e\u5341\u4e00"
  )
})
