.lvls <- list(
  "TRACE" = 1,
  "DEBUG" = 2,
  "INFO" = 3,
  "WARN" = 4,
  "ERROR" = 5,
  "FATAL" = 6
)

should_log <- function(lvl, log_level_num) {
  if (.lvls[[lvl]] >= log_level_num) {
    return(TRUE)
  }
  return(FALSE)
}

sanitize_level <- function(level) {
  lvl_set <- NULL
  if (is.numeric(level)) {
    lvl_set <- .lvls[[level]]
  } else if (is.character(level)) {
    lvl_set <- .lvls[[toupper(level)]]
  }
  if (is.null(lvl_set)) {
    lvl_names <-
      glue::glue_collapse(glue::glue("{names(.lvls)} or {.lvls}\n\n"))
    stop(
      glue::glue(
        "incompatible level: {level}, should be one of:\n {lvl_names}"
      )
    )
  }
  lvl_set
}


color_trace <- crayon::silver
color_debug <- crayon::make_style("purple")
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

trim_level <- function(lvl, end = 4) {
  substr(lvl, 1, end)
}

level_color <- function(lvl) {
  switch(toupper(lvl),
         TRACE = color_trace,
         DEBUG = color_debug,
         INFO = color_info,
         WARN = color_warn,
         ERROR = color_error,
         FATAL = color_fatal
         )
}


#' text formatter factory function
#' @param format_string glue format string
#' @param field_map rename internal fields not exposed to user
#' @param no_color suppress colored output
#' @param no_truncate stop truncation of levels to 4 characters
#' @param no_space no additional spacing for message fields
#' @param ... additional fields passed to glue
#' @details
#' TODO: add details
#' @export
TextFormatter <-
  function(format_string = "{level}: {message} {extras}",
           field_map = NULL,
           no_color = FALSE,
           no_truncate = FALSE,
           no_space = FALSE,
           ...) {
    return(function(entry) {
      color_func <- NULL
      .level <- entry$level
      if (!no_truncate) {
        entry$level <- trim_level(entry$level)
      }
      if (!no_color) {
        color_func <- level_color(.level)
        entry$level <- color_func(entry$level)
      }
      if (!no_space) {
        entry$message <- sprintf("%-35s", entry$message)
      }
      extras <-
        format_entry_fields(entry[-which(names(entry) %in% c("message", "level"))],
                            color_func = color_func)
      entry <- rename_entry_fields(entry, field_map)

      with(entry, {
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
