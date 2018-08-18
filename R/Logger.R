
#' Create a Logrrr
#' @importFrom R6 R6Class
#' @name Logrrr
#' @examples
NULL

#' @export
Logrrr <- R6Class("Logrrr",
 public =
   list(
     initialize = function(output = getOption("explogger.output_file", stdout())) {
        # output can be a file or connection
       private$out <- output
     },
     set_output = function() {
         return(self)
     }
     set_formatter = function() {
         return(self)
     },
     set_level = function() {
         return(self)
     },
     with_fields = function() {
         return(self)
     },
     info = function(){
     }
   ),
 private = list(
     out = NULL
 )
)
