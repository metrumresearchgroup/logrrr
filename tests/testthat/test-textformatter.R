context("test-textformatter")

describe("TextFormatter", {
  it("returns entries", {
    tf <- TextFormatter$new()
    entry <- list(yo = "dog", hello = "there")
    expect_equal(tf$format_entry(entry),
                 entry)
  })
  it("renames entries in the field map", {
    tf <- TextFormatter$new(c(hello = "goodbye"))
    expect_equal(tf$format_entry(list(yo = "dog", hello = "there")),
                 list(yo = "dog", goodbye = "there"))
  })
})
