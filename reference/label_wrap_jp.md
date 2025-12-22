# Japanese word-wrapping labeller for ggplot2

Wraps character strings using Japanese phrase boundaries and returns
labels suitable for use with ggplot2 scales.

## Usage

``` r
label_wrap_jp(labels, wrap = 16, width = 50, collapse = "\n")

label_wrap_jp_gen(wrap = 16, width = 50, collapse = "\n")
```

## Arguments

- labels:

  A character vector of labels to wrap.

- wrap:

  An integer giving the target number of characters per line.

- width:

  An integer giving the maximum total width of the wrapped label.

- collapse:

  A character string used to join wrapped lines.

## Value

- `label_wrap_jp()` returns a character vector of wrapped labels.

- `label_wrap_jp_gen()` returns a labeller function for use in ggplot2
  scales.

## Details

This labeller uses ICU-based Japanese phrase boundary detection to
insert line breaks at natural word boundaries. Long labels can be
truncated to a fixed display width with an ellipsis.

## Examples

``` r
label_wrap_jp(polano[4:6], width = 32)
#> [1] "宮沢賢治訳述"                                                 
#> [2] "そのころわたくしは、モリーオ市の\n博物局に勤めて居りました"   
#> [3] "十八等官でしたから役所のなかでも、\nずうっと下の方でしたし..."
if (FALSE) { # \dontrun{
if (requireNamespace("scales", quietly = TRUE)) {
  scales::demo_discrete(polano[4:6], labels = label_wrap_jp_gen())
}
} # }
```
