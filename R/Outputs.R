is_log_output <- function(.x) {
       inherits(.x, "LogOutput")
}

#' LogOutput base class
#' @export
LogOutput <- R6Class("LogOutput",
     public = list(
     initialize = function(format_func = TextFormatter(),
                           output = stdout(),
                           ...,
                           # force these by name
                           .wf = function(m, f, ...) cat(m, file = f, ...),
                           .glue = TRUE
                           )
                            {
        if (!rlang::is_function(format_func)) {
          stop("format_func must be a function")
        }
        private$format_func <- format_func
        private$out <- output
        private$writer_func <- .wf
        private$glue <- .glue
     },
     write = function(.x, ..., append = TRUE) {
        if (private$glue) {
          private$writer_func(glue::glue("{msg}\n\n", msg = private$format_func(.x)), private$out, append = append, ...)
        } else {
          private$writer_func(private$format_func(.x), private$out, append = append, ...)
        }
        return(invisible(self))
     }
     ),
     private = list(
             format_func = NULL,
             writer_func = NULL,
             out = NULL,
             glue = NULL
     )
)
