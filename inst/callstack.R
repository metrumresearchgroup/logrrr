source("R/tracef.R")
tb1 <- tracef("part1")
tb1

tb2 <- tracef("part2")
tb2
ft <- function(.m) {
  tracef(.m)
}


ft("test")
