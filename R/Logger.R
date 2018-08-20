build_entry <- function(level, .x, fields) {
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
    output = NULL,
    log_level = NULL,
    initialize = function(log_level = "INFO", output = LogOutput$new(TextFormatter(), stdout())) {
      # output can be a file or connection
      self$log_level <- sanitize_level(log_level)
      self$output <- output
    },
    set_output = function() {
      return(self)
    },
    set_fields = function(...) {
      self$fields <- user_fields(...)
      return(self)
    },
    set_formatter = function() {
      return(self)
    },
    set_level = function(level) {
      self$log_level <- lvl_set
      self$set_level <- sanitize_level(level)
      return(self)
    },
    with_fields = function() {
      return(self)
    },
    trace = function(.x) {
      entry <- build_entry("TRACE", .x, self$fields)
      self$output$write(entry)
    },
    debug = function(.x) {
      entry <- build_entry("DEBUG", .x, self$fields)
      self$output$write(entry)
    },
    info = function(.x) {
      entry <- build_entry("INFO", .x, self$fields)
      self$output$write(entry)
    },
    warn = function(.x) {
      entry <- build_entry("WARN", .x, self$fields)
      self$output$write(entry)
    }
  ),
  private = list(out = NULL)
)
