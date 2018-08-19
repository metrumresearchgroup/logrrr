#' Create a Logrrr
#' @importFrom R6 R6Class
#' @name Logrrr
#' @examples
NULL


#' @export
Logrrr <- R6Class(
  "Logrrr",
  public = list(
    fields = NULL,
    initialize = function(output = getOption("logrrr.output_file", stdout())) {
      # output can be a file or connection
      private$out <- output
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
      self$log_level <- lvl_set
      return(self)
    },

    with_fields = function() {
      return(self)
    },
    info = function() {

    }
  ),
  private = list(out = NULL)
)
