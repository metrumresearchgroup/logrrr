#' Stub formatter
#' @export
Formatter <- R6Class("Formatter",
                     public = list(
                       initialize = function(field_map = NULL) {
                       },
                       #' @param entry entry should have, at minimum, fields message, timestamp, level
                       format_entry = function(entry) {
                         .NotYetImplemented()
                       }
                     )
)

#' text formatter
#' @export
TextFormatter <- R6Class("TextFormatter",
                         inherit = Formatter,
                         public = list(
                           initialize = function(...) {
                             super$initialize(...)
                           }
                         )
)
