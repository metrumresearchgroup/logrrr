library(logrrr)

logstdout <- logrrr::Logrrr$new()
logfile <- logrrr::Logrrr$new()
jsonfile <- tempfile(fileext=".txt")
txtfile <- tempfile(fileext=".txt")
logjson <- Logrrr$new(output = list(file = LogOutput$new(format_func = JSONFormatter(), output = jsonfile)))
logtxt <- Logrrr$new(output = list(file = LogOutput$new(format_func = TextFormatter(no_color = TRUE), output = txtfile)))

logmsgs <- function(lgr, n) {
  lapply(1:n, function(x) {
    lgr$with_fields(n = x)$info("message")
  })
  return(TRUE)
}
catmsgs <- function(n) {
  lapply(1:n, function(x) {
    cat(glue::glue("level: INFO n={x}\n\n"), file = stdout())
  })
  return(TRUE)
}
bmr <- bench::mark(
  logmsgs(logstdout, 1),
  logmsgs(logstdout, 100),
  logmsgs(logstdout, 1000),
  logmsgs(logtxt, 1),
  logmsgs(logtxt, 100),
  logmsgs(logtxt, 1000),
  logmsgs(logjson, 1),
  logmsgs(logjson, 100),
  logmsgs(logjson, 1000),
  check = FALSE
)
