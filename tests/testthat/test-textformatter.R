context("test-textformatter")

describe("TextFormatter", {
  sample_info <- list(level = "INFO", pid = 23434, message = "success")
  sample_error <- list(level = "ERROR", pid = 23434, message = "something bad happened")

  it("returns entries", {
    tf <- TextFormatter()
    expect_equal(tf(sample_error),
                 glue::glue("\033[31mERRO\033[39m: something bad happened              \033[31mpid\033[39m=23434"))
    expect_equal(tf(sample_info),
                 glue::glue("\033[34mINFO\033[39m: success                             \033[34mpid\033[39m=23434")
                 )
  })
  it("can suppress colored output", {
    tf <- TextFormatter(no_color = TRUE)
    expect_equal(tf(sample_error),
                 glue::glue("ERRO: something bad happened              pid=23434"))
  })
  it("can keep full level names", {
    tf <- TextFormatter(no_truncate = TRUE, no_color = TRUE)
    expect_equal(tf(sample_error),
                 glue::glue("ERROR: something bad happened              pid=23434"))
  })
  it("can suppress extra whitespace for messages", {

  })
  it("renames entries in the field map", {
  })
})
