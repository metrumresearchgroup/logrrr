context("test-format-fields.R")


op <- options()
on.exit(options(op))
options(crayon.enabled = TRUE)

describe("formatting entry fields", {
  example_entries <- list(pid = 123, result = "success")
  it("formats without color", {
    expect_equal(
      format_entry_fields(example_entries),
      "pid=123 result=success"
    )
  })
  it("formats with color", {
    expect_equal(
      format_entry_fields(example_entries, crayon::blue),
      "\033[34mpid\033[39m=123 \033[34mresult\033[39m=success"
    )
  })
})
