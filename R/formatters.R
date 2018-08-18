#' Stub formatter
#' @export
Formatter <- R6Class("Formatter",
                     public = list(
                       initialize = function(field_map = NULL) {
                         private$field_map <- field_map
                       },
                       #' @param entry entry should have, at minimum, fields message, timestamp, level
                       format_entry = function(entry) {
                         if (!is.null(private$field_map)) {
                           names(entry)[which(names(entry) %in% names(private$field_map))] <- private$field_map
                         }
                         entry
                       }
                     ),
                     private = list(
                       field_map = NULL
                     )
)

#' text formatter
#' @export
TextFormatter <- R6Class("TextFormatter",
                         inherit = Formatter,
                         public = list(
                           initialize = function(...) {
                             super$initialize(...)
                           },
                           format_entry = function(entry) {
                             entry <- super$format_entry(entry)
                             entry
                           }
                         )
)
