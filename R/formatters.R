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


#' text formatter
#' @export
JSONFormatter <- R6Class("JSONformatter",
                         inherit = Formatter,
                         public = list(
                           auto_unbox = NULL,
                           initialize = function(..., auto_unbox = TRUE) {
                             if (!requireNamespace("jsonlite", quietly = TRUE)) {
                               stop("JSON formatter requires the jsonlite package")
                             }
                             self$auto_unbox <- auto_unbox
                             super$initialize(...)
                           },
                           format_entry = function(entry) {
                             entry <- super$format_entry(entry)
                             jsonlite::toJSON(entry, auto_unbox = self$auto_unbox)
                           }
                         )
)
