build_entry <- function(level, .x, fields, entry_fields) {
  entry <- list(
    level = level,
    message = .x,
    timestamp = format(Sys.time(),
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
      if (rlang::is_list(outputs)) {
        lapply(outputs, function(.x) {
          stopifnot(is_log_output(.x))
        })
        self$outputs <- outputs
      } else {
        stopifnot(is_log_output(outputs))
        self$outputs <- list(outputs)
      }
    },
    set_output = function(output) {
      self$output <- output
      return(self)
    },
    set_fields = function(...) {
      self$fields <- user_fields(...)
      return(self)
    },
    set_level = function(level) {
      self$log_level <- lvl_set
      self$set_level <- sanitize_level(level)
      return(self)
    },
    with_fields = function(...) {
      self$entry_fields <- user_fields(...)
      return(self)
    },
    trace = function(.x) {
      entry <- build_entry("TRACE", .x, self$fields, self$entry_fields)
      self$entry_fields <- NULL
      lapply(self$outputs, function(output) {
        output$write(entry)
      })
    },
    debug = function(.x) {
      entry <- build_entry("DEBUG", .x, self$fields, self$entry_fields)
      self$entry_fields <- NULL
      lapply(self$outputs, function(output) {
        output$write(entry)
      })
    },
    info = function(.x) {
      entry <- build_entry("INFO", .x, self$fields, self$entry_fields)
      self$entry_fields <- NULL
      lapply(self$outputs, function(output) {
        output$write(entry)
      })
    },
    warn = function(.x) {
      entry <- build_entry("WARN", .x, self$fields, self$entry_fields)
      self$entry_fields <- NULL
      lapply(self$outputs, function(output) {
        output$write(entry)
      })
    }
  )
)
