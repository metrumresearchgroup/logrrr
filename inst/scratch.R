# generally would call the logger just 'log' but need extra names to show
# differences
library(logrrr)
logtext <- Logrrr$new()
logjson <- Logrrr$new(output = LogOutput$new(format_func = JSONFormatter()))
logcomb <- Logrrr$new(output = list(text = LogOutput$new(),
                                    json = LogOutput$new(format_func = JSONFormatter())))
logfile <- Logrrr$new(output = list(file = LogOutput$new(format_func = JSONFormatter(), output = "log.txt")))
logcsv <- Logrrr$new(output = list(csv = LogOutput$new(.wf = readr::write_csv, output = "log.csv", format_func = as.data.frame, .glue = FALSE))                                 )
# example factory function that would allow time differences relative
# to creation
diff_factory <- function(units = "secs", round = 2) {
  start_time <- Sys.time()
  return(function() {
    round(as.numeric(difftime(Sys.time(),start_time,  units = units)), round)
  })
}

logtext$set_fields(pid = Sys.getpid(), difftime = diff_factory())
logjson$set_fields(pid = Sys.getpid(), difftime = diff_factory())

print_fake_logs <- function(log, sleep_scale = 0.00001) {
  log$info("Starting App")
  Sys.sleep(runif(1, 1, 5)*sleep_scale)
  log$debug("User `John Smith` logged in!")
  log$trace("John Smith selected explore tab")
  log$with_fields(action = "submit analysis")$info("Begin analysis")
  Sys.sleep(runif(1, 1, 5)*sleep_scale)
  log$warn("Dataset loading timed out")
  log$with_fields(response = "success")$info("some info")
  sim_result <- "SUCCESSFUL"
  log$info("simulation result was {sim_result}")
  invisible()
}
print_fake_logs(logtext)
print_fake_logs(logjson)
print_fake_logs(logcomb)
print_fake_logs(logfile)
print_fake_logs(logcsv)

logtext$set_level("WARN")
print_fake_logs(logtext)

logtext$set_level("INFO")
print_fake_logs(logtext)

lwarn <- logtext$warn

lwarn("a warning")

# should retain pointer to existing object

logtext$set_fields(extra = "another field")

lwarn("a second warning")

logtext$set_fields(extra = NULL)
lwarn("a third warning")
