chartype <- function(x) {
  # nolint: start
  M <- grepl("[一二三四五六七八九十百千万億兆]", x, perl = TRUE)
  H <- grepl("[一-龠々〆ヵヶ]", x, perl = TRUE)
  I <- grepl("[ぁ-ん]", x, perl = TRUE)
  K <- grepl("[ァ-ヴーｱ-ﾝｰ]", x, perl = TRUE)
  A <- grepl("[a-zA-Zａ-ｚＡ-Ｚ]", x, perl = TRUE)
  N <- grepl("[0-9]", x, perl = TRUE)
  # nolint: end

  out <- character(length(x))
  for (i in seq_along(x)) {
    if (M[i]) {
      out[i] <- "M"
    } else if (H[i]) {
      out[i] <- "H"
    } else if (I[i]) {
      out[i] <- "I"
    } else if (K[i]) {
      out[i] <- "K"
    } else if (A[i]) {
      out[i] <- "A"
    } else if (N[i]) {
      out[i] <- "N"
    } else {
      out[i] <- "O"
    }
  }
  out
}

lookup <- function(htab, v) {
  found <- gethash(htab, v)
  if (!is.null(found)) found else 0
}

#' A tiny segmenter implementation
#'
#' @param x A character vector to segment.
#' @returns A list of character vectors.
#' @keywords internal
tiny_segment <- function(x) {
  if (!is.character(x)) {
    rlang::abort("Input must be a character vector.")
  }
  lapply(x, function(txt) {
    if (!nzchar(txt)) {
      return(txt)
    }
    txt <- stringi::stri_split_boundaries(txt, type = "character")[[1]]
    len <- length(txt)
    seg <- c("B3", "B2", "B1", txt, "E1", "E2", "E3")
    ctype <- c("O", "O", "O", chartype(txt), "O", "O", "O")

    result <- character(len)
    word <- seg[4]
    p1 <- p2 <- p3 <- "U"

    for (i in 5:(len + 3)) {
      wd <- seg[(i - 3):(i + 2)] # w1-w6
      ch <- ctype[(i - 3):(i + 2)] # c1-c6
      score <- sum(
        .BIAS,
        lookup(.UP1, p1),
        lookup(.UP2, p2),
        lookup(.UP3, p3),
        lookup(.BP1, paste0(p1, p2)),
        lookup(.BP2, paste0(p2, p3)),
        lookup(.UW1, wd[1]),
        lookup(.UW2, wd[2]),
        lookup(.UW3, wd[3]),
        lookup(.UW4, wd[4]),
        lookup(.UW5, wd[5]),
        lookup(.UW6, wd[6]),
        lookup(.BW1, paste0(wd[2], wd[3])),
        lookup(.BW2, paste0(wd[3], wd[4])),
        lookup(.BW3, paste0(wd[4], wd[5])),
        lookup(.TW1, paste0(wd[1], wd[2], wd[3])),
        lookup(.TW2, paste0(wd[2], wd[3], wd[4])),
        lookup(.TW3, paste0(wd[3], wd[4], wd[5])),
        lookup(.TW4, paste0(wd[4], wd[5], wd[6])),
        lookup(.UC1, ch[1]),
        lookup(.UC2, ch[2]),
        lookup(.UC3, ch[3]),
        lookup(.UC4, ch[4]),
        lookup(.UC5, ch[5]),
        lookup(.UC6, ch[6]),
        lookup(.BC1, paste0(ch[2], ch[3])),
        lookup(.BC2, paste0(ch[3], ch[4])),
        lookup(.BC3, paste0(ch[4], ch[5])),
        lookup(.TC1, paste0(ch[1], ch[2], ch[3])),
        lookup(.TC2, paste0(ch[2], ch[3], ch[4])),
        lookup(.TC3, paste0(ch[3], ch[4], ch[5])),
        lookup(.TC4, paste0(ch[4], ch[5], ch[6])),
        lookup(.UQ1, paste0(p1, ch[1])),
        lookup(.UQ2, paste0(p2, ch[2])),
        lookup(.UQ3, paste0(p3, ch[3])),
        lookup(.BQ1, paste0(p2, ch[2], ch[3])),
        lookup(.BQ2, paste0(p2, ch[3], ch[4])),
        lookup(.BQ3, paste0(p3, ch[2], ch[3])),
        lookup(.BQ4, paste0(p3, ch[3], ch[4])),
        lookup(.TQ1, paste0(p2, ch[1], ch[2], ch[3])),
        lookup(.TQ2, paste0(p2, ch[2], ch[3], ch[4])),
        lookup(.TQ3, paste0(p3, ch[1], ch[2], ch[3])),
        lookup(.TQ4, paste0(p3, ch[2], ch[3], ch[4]))
      )
      p <- "O"
      if (score > 0) {
        result[i] <- word
        word <- ""
        p <- "B"
      }
      p1 <- p2
      p2 <- p3
      p3 <- p
      word <- paste0(word, seg[i])
    }
    result <- c(result, word)
    result[!(stringi::stri_isempty(result) | is.na(result))]
  })
}
