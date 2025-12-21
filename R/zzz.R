#' @noRd
.pkgenv <- rlang::env(
  ctx = NULL
)

#' @noRd
.onLoad <- function(libname, pkgname) {
  ctx <- V8::v8()
  # the JS functions won't access actual window object,
  # but that needs to exist.
  ctx$eval("window = {}")
  ctx$source(system.file("packer/audubon.bundle.js", package = pkgname))
}
