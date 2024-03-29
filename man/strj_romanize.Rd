% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/strj-japanese.R
\name{strj_romanize}
\alias{strj_romanize}
\title{Romanize Japanese Hiragana and Katakana}
\usage{
strj_romanize(
  text,
  config = c("wikipedia", "traditional hepburn", "modified hepburn", "kunrei", "nihon")
)
}
\arguments{
\item{text}{Character vector.
If elements are composed of except but hiragana and katakana letters,
those letters are dropped from the return value.}

\item{config}{Configuration used to romanize. Default is \code{wikipedia}.}
}
\value{
A character vector.
}
\description{
Romanize Japanese Hiragana and Katakana
}
\details{
There are several ways to romanize Japanese.
Using this implementation, you can convert hiragana and katakana as 5 different styles;
the \code{wikipedia} style, the \verb{traditional hepburn} style, the \verb{modified hepburn} style,
the \code{kunrei} style, and the \code{nihon} style.

Note that all of these styles return a slightly different form of
\code{stringi::stri_trans_general(text, "Any-latn")}.
}
\examples{
strj_romanize(
  paste0(
    "\u3042\u306e\u30a4\u30fc\u30cf\u30c8",
    "\u30fc\u30f4\u30a9\u306e\u3059\u304d",
    "\u3068\u304a\u3063\u305f\u98a8"
  )
)
}
\seealso{
\url{https://github.com/hakatashi/japanese.js#japaneseromanizetext-config}
}
