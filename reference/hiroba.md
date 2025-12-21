# Whole tokens of 'Porano no Hiroba' written by Miyazawa Kenji from Aozora Bunko

A tidy text data of
[`audubon::polano`](https://paithiov909.github.io/audubon/reference/polano.md)
that tokenized with 'MeCab'.

## Usage

``` r
hiroba
```

## Format

An object of class `data.frame` with 26849 rows and 5 columns.

## Examples

``` r
head(hiroba)
#>   doc_id sentence_id token_id    token
#> 1      1           1        1 ポラーノ
#> 2      1           1        2       の
#> 3      1           1        3     広場
#> 4      2           2        1     宮沢
#> 5      2           2        2     賢治
#> 6      3           3        1       前
#>                                            feature
#> 1                              名詞,一般,*,*,*,*,*
#> 2                     助詞,連体化,*,*,*,*,の,ノ,ノ
#> 3             名詞,一般,*,*,*,*,広場,ヒロバ,ヒロバ
#> 4 名詞,固有名詞,人名,姓,*,*,宮沢,ミヤザワ,ミヤザワ
#> 5     名詞,固有名詞,人名,名,*,*,賢治,ケンジ,ケンジ
#> 6             接頭詞,名詞接続,*,*,*,*,前,ゼン,ゼン
```
