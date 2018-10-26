#' trace the call to file/line
#' @param .m distinguishing message
#' @export
shinytrace <- function(.m) {
  sc <- rev(sys.calls()) # start with closest call
  scc <- as.character(sys.call()) # should be the function/message
  linenum <- 0
  srcfile <- "NOSHINY"
  # tracef("hello") --> "tracef" "hello"
  scall <- glue::glue("{fn}({msg})", fn = scc[1], msg = glue::double_quote(scc[2]))
  for (s in sc) {
    sa <- attr(s, "srcref")
    if (!is.null(sa)) {
      if (any(grepl(pattern = scall, fixed = TRUE, x = as.character(sa)))) {
        if (!is.null(sa[1])) {
          srcfile <- attr(sa, "srcfile")$filename
          linenum <- sa[1]
          break
        }
      }
    }
  }
  glue::glue("{srcfile}#{linenum}")
}

