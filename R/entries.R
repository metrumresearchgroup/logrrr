user_entries <- function(...) {
  lapply(rlang::dots_list(...), function(.x) {
    if (rlang::is_bare_formula(.x) || rlang::is_function(.x)) {
      return(rlang::as_function(.x))
    }
    return(.x)
  })
}

eval_entries <- function(.e) {
  if (is.null(.e)) {
    return(NULL)
  }
  lapply(.e, function(.x) {
    # these should be the entries coerced from formula to function
    if (rlang::is_function(.x)) {
      return(.x())
    }
    return(.x)
  })
}


