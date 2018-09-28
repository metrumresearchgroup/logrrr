
[![Travis build
status](https://travis-ci.org/metrumresearchgroup/logrrr.svg?branch=master)](https://travis-ci.org/metrumresearchgroup/logrrr)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# logrrr

The goal of logrrr is to provide structured, pluggable logging tailored
to shiny applications and rest apis. It is also useful for analytics,
but provides “sugar” around activities commonly performed in
applications.

## Structured Logging

TODO

## Basic Usage

A Logrrr instance must be initialized, and by default will use text
logging to stdout.

``` r
library(logrrr)
# likely don't call it log as it will override the mathematical log function
lgr <- Logrrr$new()
lgr$info("an info message")
#> INFO: an info message                     timestamp=2018-09-28 20:04:53.53
lgr$warn("careful!")
#> WARN: careful!                            timestamp=2018-09-28 20:04:53.53
lgr$with_fields(user = "devin")$info("logged in")
#> INFO: logged in                           timestamp=2018-09-28 20:04:53.53 user=devin
```

The various levels are colored

![output](man/figures/logrrr_levels.png)

``` r
lgr$debug("a debug message that you won't see")
lgr$set_level("DEBUG")
lgr$debug("now you can see")
#> DEBU: now you can see                     timestamp=2018-09-28 20:04:53.53
lgr$info("of course can still see info")
#> INFO: of course can still see info        timestamp=2018-09-28 20:04:53.53
lgr$set_level("WARN")
lgr$info("can't see this now!")
lgr$warn("but can see this")
#> WARN: but can see this                    timestamp=2018-09-28 20:04:53.53
```

## Customization

Log levels can be set at initiation (default:
info)

``` r
lgr <- Logrrr$new(log_level = "DEBUG")
```

### JSON logging

``` r
logjson <- Logrrr$new(output = LogOutput$new(format_func = JSONFormatter()))
logjson$info("an info message")
#> {"level":"INFO","message":"an info message","timestamp":"2018-09-28 20:04:53.53"}
logjson$warn("careful!")
#> {"level":"WARN","message":"careful!","timestamp":"2018-09-28 20:04:53.53"}
logjson$with_fields(user = "devin")$info("logged in")
#> {"level":"INFO","message":"logged in","timestamp":"2018-09-28 20:04:53.53","user":"devin"}
```

### Multiple Outputs

Multiple outputs can be simultaneously logged to:

``` r
logfile <- tempfile(fileext = ".txt")
logcomb <- Logrrr$new(output = list(text = LogOutput$new(),
                                    json = LogOutput$new(format_func = JSONFormatter(), output = logfile)))

logcomb$info("an info message")
#> INFO: an info message                     timestamp=2018-09-28 20:04:53.53
logcomb$warn("careful!")
#> WARN: careful!                            timestamp=2018-09-28 20:04:53.53
logcomb$with_fields(user = "devin")$info("logged in")
#> INFO: logged in                           timestamp=2018-09-28 20:04:53.53 user=devin

cat("\ncontents of log file: \n\n")
#> 
#> contents of log file:
readLines(logfile)
#> [1] "{\"level\":\"INFO\",\"message\":\"an info message\",\"timestamp\":\"2018-09-28 20:04:53.53\"}"             
#> [2] "{\"level\":\"WARN\",\"message\":\"careful!\",\"timestamp\":\"2018-09-28 20:04:53.53\"}"                    
#> [3] "{\"level\":\"INFO\",\"message\":\"logged in\",\"timestamp\":\"2018-09-28 20:04:53.53\",\"user\":\"devin\"}"
```

## shiny application

``` r
is_production <- function() {
  Sys.getenv("R_DEV_ENV") == "production"
}
lgr <- if (is_production()) {
  # in production don't need debug/tracing, and log as json to a file
  Logrrr$new(log_level = "INFO", outputs = LogOutput$new(format_func = JSONFormatter(), output = logfile))
} else {
  ## development mode want all log levels printed right to console
  Logrrr$new(log_level = "TRACE")
}
```

## Some performance notes

On a macbook pro (eg fast ssd), writing to a file will be more
performant than printing to the console.

Interesting, the serialization cost of json is actually less than the
gluing and formatting of text for structured text logging. Hence, for
log files not for easy scanning by human-only, json formatting is a
great option.

| type      |    n |   median |      max | n\_gc |
| :-------- | ---: | -------: | -------: | ----: |
| logstdout |    1 |   1.12ms |  38.14ms |     3 |
| logtxt    |    1 | 943.28µs |  26.31ms |     3 |
| logjson   |    1 | 681.48µs |  30.45ms |     4 |
| logstdout |  100 | 119.06ms | 162.62ms |     3 |
| logtxt    |  100 |  82.59ms |  85.94ms |     5 |
| logjson   |  100 |  79.81ms |  99.09ms |     4 |
| logstdout | 1000 |    1.14s |    1.14s |     8 |
| logtxt    | 1000 | 825.99ms | 825.99ms |     7 |
| logjson   | 1000 | 748.17ms | 748.17ms |     7 |

Furthermore, the json logs can be easily coerced into a structured data
frame for easy slicing and
dicing.

``` r
purrr::map_dfr(readr::read_lines("path/to/log.txt"), jsonlite::fromJSON) 
```

## Installation

You can install from:

``` r
devtools::install_github("metrumresearchgroup/logrrr")
```

``` r
si <- sessioninfo::session_info()
si$platform
#>  setting  value                       
#>  version  R version 3.5.1 (2018-07-02)
#>  os       macOS High Sierra 10.13.6   
#>  system   x86_64, darwin15.6.0        
#>  ui       X11                         
#>  language (EN)                        
#>  collate  en_US.UTF-8                 
#>  ctype    en_US.UTF-8                 
#>  tz       America/New_York            
#>  date     2018-09-28
as.data.frame(si$packages,row.names = NULL)[, c("package", "ondiskversion","date", "source")]
#>                 package ondiskversion       date         source
#> assertthat   assertthat         0.2.0 2017-04-11 CRAN (R 3.5.0)
#> backports     backports         1.1.2 2017-12-13 CRAN (R 3.5.0)
#> cli                 cli         1.0.0 2017-11-05 CRAN (R 3.5.0)
#> crayon           crayon         1.3.4 2017-09-16 CRAN (R 3.5.0)
#> digest           digest        0.6.16 2018-08-22 CRAN (R 3.5.0)
#> evaluate       evaluate          0.11 2018-07-17 CRAN (R 3.5.0)
#> glue               glue         1.3.0 2018-07-17 CRAN (R 3.5.0)
#> htmltools     htmltools         0.3.6 2017-04-28 CRAN (R 3.5.0)
#> jsonlite       jsonlite           1.5 2017-06-01 CRAN (R 3.5.0)
#> knitr             knitr          1.20 2018-02-20 CRAN (R 3.5.0)
#> logrrr           logrrr         0.0.1 2018-09-28          local
#> magrittr       magrittr           1.5 2014-11-22 CRAN (R 3.5.0)
#> R6                   R6         2.2.2 2017-06-17 CRAN (R 3.5.0)
#> Rcpp               Rcpp       0.12.18 2018-07-23 CRAN (R 3.5.0)
#> rlang             rlang         0.2.2 2018-08-16 CRAN (R 3.5.0)
#> rmarkdown     rmarkdown          1.10 2018-06-11 CRAN (R 3.5.0)
#> rprojroot     rprojroot         1.3.2 2018-01-03 CRAN (R 3.5.0)
#> sessioninfo sessioninfo         1.1.0 2018-09-25 CRAN (R 3.5.0)
#> stringi         stringi         1.2.4 2018-07-20 CRAN (R 3.5.0)
#> stringr         stringr         1.3.1 2018-05-10 CRAN (R 3.5.0)
#> withr             withr         2.1.2 2018-03-15 CRAN (R 3.5.0)
#> yaml               yaml         2.2.0 2018-07-25 CRAN (R 3.5.0)
```
