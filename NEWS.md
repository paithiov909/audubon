# audubon 0.6.2

* Modified some examples to address addtional issues on CRAN. There are no user-facing changes.

# audubon 0.6.1

## New features

* Added `label_wrap_jp()` and `label_wrap_jp_gen()` for Japanese word wrapping in ggplot2 labellers.
* Added `label_date_jp()` and `label_date_jp_gen()` for Japanese calendar date labels in ggplot2.
* Added `strj_parse_date()` to parse Japanese calendar date strings into POSIXct values.

## Changes

* Removed `mecab` and `sudachipy` engines and related arguments from `strj_tokenize()`.
* Removed functions overlapping with those provided by the gibasa package. Users requiring morphological analysis or related features should use gibasa.

## Other

* Performed internal refactoring and maintenance improvements.

# audubon 0.5.2

* Corrected probabilistic IDF calculation by `global_idf3`.
* Refactored `bind_tf_idf2`.
  * Changed behavior when `norm=TRUE`. Cosine nomalization is now performed on `tf_idf` values as in the RMeCab package.
  * Added `tf="itf"` and `idf="df"` options.
* Refactored `pack` for performance.

# audubon 0.5.1

* Refactored `tokenize_mecab` and `tokenize_sudachipy`.

# audubon 0.5.0

* Added `bind_lr` function which can calculate the 'LR' value of bigrams.
* `pack` now always returns a tibble, not a data.frame.

# audubon 0.4.0

* Added some new functions.
  * `bind_tf_idf2` can calculate and bind the term frequency, inverse document frequency, and tf-idf of the tidy text dataset.
  * `collapse_tokens`, `mute_tokens`, and `lexical_density` can be used for handling a tidy text dataset of tokens.
* `strj_tokenize` now preserves the original order of text names.
* `prettify` now can get `delim` argument.

# audubon 0.3.0

* Updated `strj_fill_iter_mark` function.
  * `strj_fill_iter_mark` now replaces a sequence of iteration marks recursively.
* Updated `strj_tokenize` function.
  * `strj_tokenize` now can retrieve `engine` argument to switch tokenizers for splitting text into tokens.

# audubon 0.2.0

* Updated `ngram_tokenizer` function.
* Added a wrapper function of the 'TinySegmenter' written by Taku Kudo.

# audubon 0.1.2

* Updated `pack` function.
  * Switched arguments order of `pack` function. `pack` now accepts `pull` as its second argument and `n` as its third argument.
  * `pull` now can accept a symbol.

# audubon 0.1.1

* Updated documentation.

# audubon 0.1.0

* Relicensed as Apache License, Version 2.0.
* Added a `NEWS.md` file to track changes to the package.
