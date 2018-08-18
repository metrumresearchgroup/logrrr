#' format fields
#' @param fields list or vector with names
#' @param color_func function to provide color to names
#' @param sep separator between name value
#' @param collapse separator between elements
#' @examples
#' format_entry_fields(list(pid = 123, result = "success"), color_func = crayon::blue)
#' @export
format_entry_fields <- function(fields, color_func = NULL, sep = "=", collapse = " ") {
  if (is.null(color_func) || !is.function(color_func)) {
    paste(names(fields), fields, sep = "=", collapse = collapse)
  } else {
    paste(color_func(names(fields)), fields, sep = sep, collapse = collapse)
  }
}


