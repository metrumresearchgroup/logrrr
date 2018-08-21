# generally would call the logger just 'log' but need extra names to show
# differences
logtext <- Logrrr$new()
logjson <- Logrrr$new(output = LogOutput$new(format_func = JSONFormatter()))

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

print_fake_logs <- function(log, sleep_scale = 0.001) {
  log$info("Starting App")
  Sys.sleep(runif(1, 1, 5)*sleep_scale)
  log$info("User `John Smith` logged in!")
  log$trace("John Smith selected explore tab")
  log$with_fields(addl = "something more")$info("Begin loading dataset")
  Sys.sleep(runif(1, 1, 5)*sleep_scale)
  log$warn("Dataset loading timed out")
  invisible()
}
print_fake_logs(logtext)
print_fake_logs(logjson)
