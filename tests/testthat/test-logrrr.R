context("test-logrrr")

describe("logrrr works", {
  it("can be initialized with defaults", {
    lgr <- Logrrr$new()
    lgr_output <- lgr$outputs[[1]]
    expect_true(inherits(lgr_output, "LogOutput"))
    expect_true(!is.null(lgr$log_level) && is.numeric(lgr$log_level))
    expect_true(lgr$log_level > 0)
  })
  it("can set the log level", {
    lgr <- Logrrr$new()
    lgr$set_level("WARN")
    warn_lvl <- lgr$log_level
    lgr$set_level("INFO")
    info_lvl <- lgr$log_level
    expect_true(warn_lvl > info_lvl)
  })
  it("can send messages to a connection", {
    outcon <- textConnection("outputstream", "w")
    lgr <- Logrrr$new(outputs = LogOutput$new(output = outcon))
    lgr$info("a message")
    lgr$warn("a message")
    close(outcon)
    expect_true(length(outputstream) == 2) # each message is a string
    expect_true(grepl("INFO", outputstream[[1]]))
    expect_true(grepl("WARN", outputstream[[2]]))
  })
  it("will suppress color ansi characters to output", {
    outcon <- textConnection("outputstream", "w")
    lgr <- Logrrr$new(outputs = LogOutput$new(output = outcon))
    lgrnc <- Logrrr$new(outputs = LogOutput$new(format_func = TextFormatter(no_color = TRUE), output = outcon))
    lgr$info("a message")
    lgrnc$info("a message")
    close(outcon)
    expect_equal(length(outputstream), 2) # each message is a string
    expect_true(outputstream[[1]] != outputstream[[2]])
    expect_equal(substr(outputstream[[1]], 1, 9), "\033[34mINFO")
    expect_equal(substr(outputstream[[2]], 1, 9), "INFO: a m")
  })
  it("will only log messages greater than a particular log level", {
    outcon <- textConnection("outputstream", "w")
    lgr <- Logrrr$new(outputs = LogOutput$new(output = outcon))
    lgr$info("a message")
    lgr$debug("a debug message")
    close(outcon)
    os_info <- outputstream
    expect_equal(length(os_info), 1) # no debug
    outcon <- textConnection("outputstream", "w")
    lgr <- Logrrr$new(outputs = LogOutput$new(output = outcon))
    lgr$set_level("DEBUG")
    lgr$info("a message")
    lgr$debug("a debug message")
    close(outcon)
    os_debug <- outputstream
    expect_equal(length(os_debug), 2)
    expect_equal(os_info, os_debug[[1]])
  })
})
