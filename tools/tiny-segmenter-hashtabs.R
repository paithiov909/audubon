# nolint: start
.BIAS <- -332
.BC1 <- hashtab("identical", length(bc1))
.BC2 <- hashtab("identical", length(bc2))
.BC3 <- hashtab("identical", length(bc3))
.BP1 <- hashtab("identical", length(bp1))
.BP2 <- hashtab("identical", length(bp2))
.BQ1 <- hashtab("identical", length(bq1))
.BQ2 <- hashtab("identical", length(bq2))
.BQ3 <- hashtab("identical", length(bq3))
.BQ4 <- hashtab("identical", length(bq4))
.BW1 <- hashtab("identical", length(bw1))
.BW2 <- hashtab("identical", length(bw2))
.BW3 <- hashtab("identical", length(bw3))
.TC1 <- hashtab("identical", length(tc1))
.TC2 <- hashtab("identical", length(tc2))
.TC3 <- hashtab("identical", length(tc3))
.TC4 <- hashtab("identical", length(tc4))
.TQ1 <- hashtab("identical", length(tq1))
.TQ2 <- hashtab("identical", length(tq2))
.TQ3 <- hashtab("identical", length(tq3))
.TQ4 <- hashtab("identical", length(tq4))
.TW1 <- hashtab("identical", length(tw1))
.TW2 <- hashtab("identical", length(tw2))
.TW3 <- hashtab("identical", length(tw3))
.TW4 <- hashtab("identical", length(tw4))
.UC1 <- hashtab("identical", length(uc1))
.UC2 <- hashtab("identical", length(uc2))
.UC3 <- hashtab("identical", length(uc3))
.UC4 <- hashtab("identical", length(uc4))
.UC5 <- hashtab("identical", length(uc5))
.UC6 <- hashtab("identical", length(uc6))
.UP1 <- hashtab("identical", length(up1))
.UP2 <- hashtab("identical", length(up2))
.UP3 <- hashtab("identical", length(up3))
.UQ1 <- hashtab("identical", length(uq1))
.UQ2 <- hashtab("identical", length(uq2))
.UQ3 <- hashtab("identical", length(uq3))
.UW1 <- hashtab("identical", length(uw1))
.UW2 <- hashtab("identical", length(uw2))
.UW3 <- hashtab("identical", length(uw3))
.UW4 <- hashtab("identical", length(uw4))
.UW5 <- hashtab("identical", length(uw5))
.UW6 <- hashtab("identical", length(uw6))
# nolint: end

#' @importFrom utils hashtab gethash sethash
setup_hashtabs <- function() {
  rlang::try_fetch(
    {
      for (i in seq_along(bc1)) {
        sethash(.BC1, names(bc1)[i], bc1[i])
      }
      for (i in seq_along(bc2)) {
        sethash(.BC2, names(bc2)[i], bc2[i])
      }
      for (i in seq_along(bc3)) {
        sethash(.BC3, names(bc3)[i], bc3[i])
      }
      for (i in seq_along(bp1)) {
        sethash(.BP1, names(bp1)[i], bp1[i])
      }
      for (i in seq_along(bp2)) {
        sethash(.BP2, names(bp2)[i], bp2[i])
      }
      for (i in seq_along(bq1)) {
        sethash(.BQ1, names(bq1)[i], bq1[i])
      }
      for (i in seq_along(bq2)) {
        sethash(.BQ2, names(bq2)[i], bq2[i])
      }
      for (i in seq_along(bq3)) {
        sethash(.BQ3, names(bq3)[i], bq3[i])
      }
      for (i in seq_along(bq4)) {
        sethash(.BQ4, names(bq4)[i], bq4[i])
      }
      for (i in seq_along(bw1)) {
        sethash(.BW1, names(bw1)[i], bw1[i])
      }
      for (i in seq_along(bw2)) {
        sethash(.BW2, names(bw2)[i], bw2[i])
      }
      for (i in seq_along(bw3)) {
        sethash(.BW3, names(bw3)[i], bw3[i])
      }
      for (i in seq_along(tc1)) {
        sethash(.TC1, names(tc1)[i], tc1[i])
      }
      for (i in seq_along(tc2)) {
        sethash(.TC2, names(tc2)[i], tc2[i])
      }
      for (i in seq_along(tc3)) {
        sethash(.TC3, names(tc3)[i], tc3[i])
      }
      for (i in seq_along(tc4)) {
        sethash(.TC4, names(tc4)[i], tc4[i])
      }
      for (i in seq_along(tq1)) {
        sethash(.TQ1, names(tq1)[i], tq1[i])
      }
      for (i in seq_along(tq2)) {
        sethash(.TQ2, names(tq2)[i], tq2[i])
      }
      for (i in seq_along(tq3)) {
        sethash(.TQ3, names(tq3)[i], tq3[i])
      }
      for (i in seq_along(tq4)) {
        sethash(.TQ4, names(tq4)[i], tq4[i])
      }
      for (i in seq_along(tw1)) {
        sethash(.TW1, names(tw1)[i], tw1[i])
      }
      for (i in seq_along(tw2)) {
        sethash(.TW2, names(tw2)[i], tw2[i])
      }
      for (i in seq_along(tw3)) {
        sethash(.TW3, names(tw3)[i], tw3[i])
      }
      for (i in seq_along(tw4)) {
        sethash(.TW4, names(tw4)[i], tw4[i])
      }
      for (i in seq_along(uc1)) {
        sethash(.UC1, names(uc1)[i], uc1[i])
      }
      for (i in seq_along(uc2)) {
        sethash(.UC2, names(uc2)[i], uc2[i])
      }
      for (i in seq_along(uc3)) {
        sethash(.UC3, names(uc3)[i], uc3[i])
      }
      for (i in seq_along(uc4)) {
        sethash(.UC4, names(uc4)[i], uc4[i])
      }
      for (i in seq_along(uc5)) {
        sethash(.UC5, names(uc5)[i], uc5[i])
      }
      for (i in seq_along(uc6)) {
        sethash(.UC6, names(uc6)[i], uc6[i])
      }
      for (i in seq_along(up1)) {
        sethash(.UP1, names(up1)[i], up1[i])
      }
      for (i in seq_along(up2)) {
        sethash(.UP2, names(up2)[i], up2[i])
      }
      for (i in seq_along(up3)) {
        sethash(.UP3, names(up3)[i], up3[i])
      }
      for (i in seq_along(uq1)) {
        sethash(.UQ1, names(uq1)[i], uq1[i])
      }
      for (i in seq_along(uq2)) {
        sethash(.UQ2, names(uq2)[i], uq2[i])
      }
      for (i in seq_along(uq3)) {
        sethash(.UQ3, names(uq3)[i], uq3[i])
      }
      for (i in seq_along(uw1)) {
        sethash(.UW1, names(uw1)[i], uw1[i])
      }
      for (i in seq_along(uw2)) {
        sethash(.UW2, names(uw2)[i], uw2[i])
      }
      for (i in seq_along(uw3)) {
        sethash(.UW3, names(uw3)[i], uw3[i])
      }
      for (i in seq_along(uw4)) {
        sethash(.UW4, names(uw4)[i], uw4[i])
      }
      for (i in seq_along(uw5)) {
        sethash(.UW5, names(uw5)[i], uw5[i])
      }
      for (i in seq_along(uw6)) {
        sethash(.UW6, names(uw6)[i], uw6[i])
      }
      TRUE
    },
    error = function(e) {
      FALSE
    }
  )
}
