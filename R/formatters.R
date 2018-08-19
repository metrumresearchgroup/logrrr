color_debug <- crayon::green
color_info <- crayon::blue
color_warn <- crayon::yellow
color_error <- crayon::red
color_fatal <- crayon::red

rename_entry_fields <- function(entry, field_map) {
  if (!is.null(field_map)) {
    names(entry)[which(names(entry) %in% names(field_map))] <-
      field_map
  }
  return(entry)
}

level_color <- function(lvl) {
  switch(tolower(lvl),
         debug = col_debug,
         info = col_info,
         warn = col_warn,
         error = col_error,
         fatal = col_fatal
         )
}


#' text formatter factory function
#' @export format_string glue format string
#' @param no_color suppress colored output
#' @param field_map rename internal fields not exposed to user
#' @param ... additional fields passed to glue
#' @details
#' TODO: add details
#' @export
TextFormatter <- function(format_string = "[{level}] {message} {extras}",
                          no_color = FALSE,
                          field_map = NULL) {
  return(function(entry) {
    .level <- entry$level
    extras <-
      format_entry_fields(entry[-which(names(entry) %in% c("message", "level"))],
                          color_func = color_func)
    entry <- rename_entry_fields(entry, field_map)

    with(entry, {
      color_func <- NULL
      if (!self$no_color) {
        color_func <- level_color(.level)
        level <- color_func(.level)
      }
      glue::glue(format_string, ...)
    })
  })
}

#' json formatter factory function
#' @param auto_unbox pass to jsonlite
#' @param field_map rename internal fields not exposed to user
#' @param ... additional fields passed to jsonlite and glue
#' @details
#' TODO: add details
#' @export
JSONFormatter <- function(auto_unbox = TRUE,
                          field_map = NULL,
                          ...) {
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("JSON formatter requires the jsonlite package")
  }
  return(function(entry) {
    entry <- rename_entry_fields(entry, field_map)
    # expose all the entry values directly so the glue template can pick them up
    jsonlite::toJSON(entry, auto_unbox = auto_unbox, ...)
  })
}
