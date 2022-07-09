skip_on_cran()

str <- paste0(
  c(
    "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
    "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
    "\u3068\u304a\u3063\u305f\u98a8"
  ),
  collapse = ""
)

test_that("segment works", {
  li <- unname(strj_segment(str))
  df <- strj_segment(str, format = "data.frame")
  expect_equal(li[[1]][4], enc2utf8("\u98a8"))
  expect_equal(df[4, 2], enc2utf8("\u98a8"))
})

test_that("tinyseg works", {
  li <- unname(strj_tinyseg(str))
  df <- strj_tinyseg(str, format = "data.frame")
  expect_equal(li[[1]][3], enc2utf8("\u30a4\u30fc\u30cf\u30c8\u30fc\u30f4\u30a9"))
  expect_equal(df[3, 2], enc2utf8("\u30a4\u30fc\u30cf\u30c8\u30fc\u30f4\u30a9"))
})

test_that("get_dict_features works", {
  expect_equal(length(get_dict_features()), 9L)
  expect_equal(length(get_dict_features("unidic17")), 17L)
  expect_equal(length(get_dict_features("unidic26")), 26L)
  expect_equal(length(get_dict_features("unidic29")), 29L)
  expect_equal(length(get_dict_features("cc-cedict")), 8L)
  expect_equal(length(get_dict_features("ko-dic")), 8L)
  expect_equal(length(get_dict_features("naist11")), 11L)
  expect_equal(length(get_dict_features("sudachi")), 6L)
})

test_that("tokenize works", {
  li <- unname(strj_tokenize(str))
  df <- strj_tokenize(str, format = "data.frame")
  expect_equal(li[[1]][1], enc2utf8("\u3042\u306e"))
  expect_equal(df[1, 2], enc2utf8("\u3042\u306e"))
})

test_that("tokenize_mecab works", {
  skip_if(unname(Sys.which("mecab")) == "")
  df <- strj_tokenize(str, format = "data.frame", engine = "mecab")
  expect_equal(df[1, 2], enc2utf8("\u3042\u306e"))
})

test_that("tokenize_sudachipy works", {
  skip_if(unname(Sys.which("sudachipy")) == "")
  df <- strj_tokenize(str, format = "data.frame", engine = "sudachipy")
  expect_equal(df[1, 2], enc2utf8("\u3042\u306e"))
  df <- prettify(df, get_dict_features("sudachi"), col_select = "POS1")
  expect_equal(df[1, 4], enc2utf8("\u9023\u4f53\u8a5e"))
})
