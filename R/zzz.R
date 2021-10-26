#' @noRd
.pkgenv <- rlang::env(ctx = NULL)

#' @noRd
.onLoad <- function(libname, pkgname) {
  ctx <- V8::v8()
  ctx$source(system.file("packer/audubon.bundle.js", package = pkgname))
  rlang::env_bind(.pkgenv, ctx = ctx)
}
