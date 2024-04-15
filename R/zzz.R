#' @noRd
.pkgenv <- rlang::env(
  ctx = NULL,
  read_def = NULL
)

#' @noRd
.onLoad <- function(libname, pkgname) {
  ctx <- V8::v8()
  # the JS functions won't access actual window object,
  # but that needs to exist.
  ctx$eval("window = {}")
  ctx$source(system.file("packer/audubon.bundle.js", package = pkgname))
  rlang::env_bind(.pkgenv, ctx = ctx, read_def = memoise::memoise(read_rewrite_def_impl()))
}
