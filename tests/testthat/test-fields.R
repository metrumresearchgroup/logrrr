context("test-fields.R")

describe("fields", {
  ue <- user_fields(time = Sys.time(), timeexpr = ~ Sys.time(), timefunc = Sys.time)
  it("can capture expressions", {
    expect_equal(typeof(ue[[1]]), "double")
    expect_equal(class(ue[[1]]), c("POSIXct", "POSIXt"))
    # expressions
    expect_true(rlang::is_function(ue[[2]]))
    # bare functions should also be ok
    expect_true(rlang::is_function(ue[[2]]))
  })
  it("will evaluate expressions and functions later", {
    ue_result <- eval_fields(ue)
    expect_equal(ue$time, ue_result$time)
    # these will not be exactly equal, but should be within the precision
    # of expect_equal
    expect_equal(ue_result$timeexpr, ue_result$timefunc)
    # sanity check that doing full equality on time fields should evaluate true
    # without needing a precision buffer
    expect_true(ue$time == ue_result$time)
    Sys.sleep(0.001)
    ue_result2 <- eval_fields(ue)
    expect_true("POSIXct" %in% class(ue_result$timeexpr))
    expect_false(ue_result$timeexpr == ue_result2$timeexpr)
    expect_true(ue_result$timeexpr < ue_result2$timeexpr)
  })
  it("won't crash if given no fields", {
    expect_equal(eval_fields(user_fields()),
                 structure(list(), .Names = character(0))
)
  })
})
