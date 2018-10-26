#' trace the call to file/line
#' @param .m distinguishing message
#' @export
tracef <- function(.m) {
  sf <- sys.frames()
  if (is.null(sf[[1]]$srcref)) {
    return(NULL)
  }
  srcfile <- attributes(sf[[1]]$srcref)$srcfile$filename
  linenum <- grep(sf[[1]]$lines, pattern = sf[[1]]$srcref, fixed = TRUE)
  glue::glue("{srcfile}#{linenum}")
}
