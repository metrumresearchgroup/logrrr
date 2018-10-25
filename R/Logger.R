build_entry <- function(level, .x, fields, entry_fields) {
  entry <- list(
    level = level,
    msg = .x,
    time = format(Sys.time(),
                  format = "%Y-%m-%d %H:%M:%S.%OS",
                  tz = "UTC")

  )
  if (!is.null(fields)) {
    entry <- modifyList(entry, eval_fields(fields))
  }
  if (!is.null(entry_fields))  {
    entry <- modifyList(entry, eval_fields(entry_fields))
  }
  return(entry)
}

#' Create a Logrrr
#' @importFrom R6 R6Class
#' @importFrom utils modifyList
#' @name Logrrr
#' @export
Logrrr <- R6Class(
  "Logrrr",
  public = list(
    fields = NULL,
    entry_fields = NULL,
    outputs = NULL,
    log_level = NULL,
    initialize = function(log_level = "INFO", outputs = LogOutput$new(TextFormatter(), stdout())) {
      # output can be a file or connection
      self$log_level <- sanitize_level(log_level)
      self$set_outputs(outputs)
    },
    set_outputs = function(outputs, append = FALSE) {
      if (rlang::is_list(outputs)) {
        lapply(outputs, function(.x) {
          stopifnot(is_log_output(.x))
        })
        self$outputs <- if (append) c(outputs, self$outputs) else outputs
      } else {
        stopifnot(is_log_output(outputs))
        self$outputs <- if (append) c(list(outputs), self$outputs) else list(outputs)
      }
      return(invisible(self))
    },
    set_fields = function(...) {
      self$fields <- user_fields(...)
      return(invisible(self))
    },
    set_level = function(level) {
      self$log_level <- sanitize_level(level)
      return(invisible(self))
    },
    with_fields = function(...) {
      self$entry_fields <- user_fields(...)
      return(invisible(self))
    },
    trace = function(..., .env = parent.frame()) {
      if (!should_log("TRACE", self$log_level)) {
        return(invisible(self))
      }
      entry <- build_entry("TRACE", glue::glue(..., .envir = .env), self$fields, self$entry_fields)
      self$entry_fields <- NULL
      lapply(self$outputs, function(output) {
        output$write(entry)
      })
      return(invisible(self))
    },
    debug = function(..., .env = parent.frame()) {
      if (!should_log("DEBUG", self$log_level)) {
        return(invisible(self))
      }
      entry <- build_entry("DEBUG", glue::glue(..., .envir = .env), self$fields, self$entry_fields)
      self$entry_fields <- NULL
      lapply(self$outputs, function(output) {
        output$write(entry)
      })
      return(invisible(self))
    },
    info = function(..., .env = parent.frame()) {
      if (!should_log("INFO", self$log_level)) {
        return(invisible(self))
      }
      entry <- build_entry("INFO", glue::glue(..., .envir = .env), self$fields, self$entry_fields)
      self$entry_fields <- NULL
      lapply(self$outputs, function(output) {
        output$write(entry)
      })
      return(invisible(self))
    },
    warn = function(..., .env = parent.frame()) {
      if (!should_log("WARN", self$log_level)) {
        return(invisible(self))
      }
      entry <- build_entry("WARN", glue::glue(..., .envir = .env), self$fields, self$entry_fields)
      self$entry_fields <- NULL
      lapply(self$outputs, function(output) {
        output$write(entry)
      })
      return(invisible(self))
    },
    error = function(..., .env = parent.frame()) {
      if (!should_log("ERROR", self$log_level)) {
        return(invisible(self))
      }
      entry <- build_entry("ERROR", glue::glue(..., .envir = .env), self$fields, self$entry_fields)
      self$entry_fields <- NULL
      lapply(self$outputs, function(output) {
        output$write(entry)
      })
      stop(glue::glue(..., .envir = .env), call. = FALSE)
    }
  )
)
