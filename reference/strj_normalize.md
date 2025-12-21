# Convert text following the rules of 'NEologd'

Converts characters into normalized style following the rule that is
recommended by the Neologism dictionary for 'MeCab'.

## Usage

``` r
strj_normalize(text)
```

## Arguments

- text:

  A character vector containing Japanese text.

## Value

A character vector with normalized text.

## See also

<https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja>

## Examples

``` r
strj_normalize(
  paste0(
    "\u2015\u2015\u5357\u30a2\u30eb\u30d7\u30b9",
    "\u306e\u3000\u5929\u7136\u6c34-\u3000\uff33",
    "\uff50\uff41\uff52\uff4b\uff49\uff4e\uff47*",
    "\u3000\uff2c\uff45\uff4d\uff4f\uff4e+",
    "\u3000\u30ec\u30e2\u30f3\u4e00\u7d5e\u308a"
  )
)
#> [1] "ー南アルプスの天然水-Sparking* Lemon+レモン一絞り"
```
