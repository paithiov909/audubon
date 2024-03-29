% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/strj-normalize.R
\name{strj_normalize}
\alias{strj_normalize}
\title{Convert text following the rules of 'NEologd'}
\usage{
strj_normalize(text)
}
\arguments{
\item{text}{Character vector to be normalized.}
}
\value{
A character vector.
}
\description{
Converts characters into normalized style
following the rule that is recommended by the Neologism dictionary for 'MeCab'.
}
\examples{
strj_normalize(
  paste0(
    "\u2015\u2015\u5357\u30a2\u30eb\u30d7\u30b9",
    "\u306e\u3000\u5929\u7136\u6c34-\u3000\uff33",
    "\uff50\uff41\uff52\uff4b\uff49\uff4e\uff47*",
    "\u3000\uff2c\uff45\uff4d\uff4f\uff4e+",
    "\u3000\u30ec\u30e2\u30f3\u4e00\u7d5e\u308a"
  )
)
}
\seealso{
\url{https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja}
}
