library(usethis)
library(pkgdown)
library(hexSticker)

img <- file.path(getwd(),
    "man",
    "figures",
    "scarecrow.png"
)

hexSticker::sticker(
    img,
    s_x = 1,
    s_width = .5,
    s_height = .5,
    p_size = 18,
    package = "audubon",
    p_color = "#090904",
    h_size = 2.4,
    h_fill = "#FFFFFF",
    h_color = "#ac4c4c",
    filename = "man/figures/logo-origin.png"
)

use_logo("man/figures/logo-origin.png")
build_favicons(overwrite = TRUE)
