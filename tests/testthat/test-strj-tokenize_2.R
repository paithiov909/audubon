str <- paste0(
  c(
    "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
    "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
    "\u3068\u304a\u3063\u305f\u98a8"
  ),
  collapse = ""
)

### tokenize_mecab ----
test_that("tokenize_mecab works", {
  skip_on_cran()
  skip_if(unname(Sys.which("mecab")) == "")
  df <- strj_tokenize(str, format = "data.frame", engine = "mecab")
  expect_equal(df[1, 2], enc2utf8("\u3042\u306e"))
})

### tokenize_sudachipy ----
test_that("tokenize_sudachipy works", {
  skip_on_cran()
  skip_if(unname(Sys.which("sudachipy")) == "")
  df <- strj_tokenize(str, format = "data.frame", engine = "sudachipy")
  expect_equal(df[1, 2], enc2utf8("\u3042\u306e"))
  df <- prettify(df, into = get_dict_features("sudachi"), col_select = "POS1")
  expect_equal(df[1, 4], enc2utf8("\u9023\u4f53\u8a5e"))
})
