library(logrrr)
logtext <- Logrrr$new()

logtext$with_fields(trace = tracef("m1"))$info("hello1")
logtext$with_fields(trace = tracef("m2"))$warn("hello2")
