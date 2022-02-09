## code to prepare `polano` dataset goes here

polano <- readr::read_lines("data-raw/poranono_hiroba.txt")
polano <- stringi::stri_trans_nfkc(polano)
polano <- stringr::str_remove_all(polano, "[[:blank:]|\\.]+") # 三点リーダは半角ピリオドになる

# hiroba <- gibasa::tokenize(polano)
# hiroba <- gibasa::prettify(hiroba)

usethis::use_data(polano, overwrite = TRUE)
# usethis::use_data(hiroba, overwrite = TRUE)
