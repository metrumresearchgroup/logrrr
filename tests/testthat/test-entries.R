context("test-entries.R")

describe("entries", {
  ue <- user_entries(time = Sys.time(), timeexpr = ~ Sys.time(), timefunc = Sys.time)
  it("can capture expressions", {
    expect_equal(typeof(ue[[1]]), "double")
    expect_equal(class(ue[[1]]), c("POSIXct", "POSIXt"))
    # expressions should be converted to functions
    expect_equal(typeof(ue[[2]]), "closure")
    expect_equal(class(ue[[2]]), "function")
    # bare functions should also be ok
    expect_equal(typeof(ue[[3]]), "closure")
    expect_equal(class(ue[[3]]), "function")
  })
  it("will evaluate expressions and functions later", {
    ue_result <- eval_entries(ue)
    expect_equal(ue$time, ue_result$time)
    # these will not be exactly equal, but should be within the precision
    # of expect_equal
    expect_equal(ue_result$timeexpr, ue_result$timefunc)
    # sanity check that doing full equality on time entries should evaluate true
    # without needing a precision buffer
    expect_true(ue$time == ue_result$time)
    Sys.sleep(0.001)
    ue_result2 <- eval_entries(ue)
    expect_true("POSIXct" %in% class(ue_result$timeexpr))
    expect_false(ue_result$timeexpr == ue_result2$timeexpr)
    expect_true(ue_result$timeexpr < ue_result2$timeexpr)
  })
})
