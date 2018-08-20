#' stub output
#' @export
LogOutput <- R6Class("LogOutput",
     public = list(
     format_func = NULL,
     out = NULL,
     initialize = function(format_func = TextFormatter(),
                           output = stdout(),
                           append = TRUE,
                           ...) {
        if (!rlang::is_function(format_func)) {
          stop("format_func must be a function")
        }
        self$format_func <- format_func
        self$out <- output
     },
     write = function(.x) {
        cat(glue::glue("{msg}\n\n", msg = self$format_func(.x)), file = self$out, append = append, ...)
     }
     )
)
