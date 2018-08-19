context("test-entries.R")

describe("entries", {
  it("can capture expressions", {
    ue <- user_entries(time = Sys.time(), timeexpr = ~ Sys.time())
    expect_equal(length(ue), 2)
    expect_equal(typeof(ue[[2]]), "closure")
  })
})
