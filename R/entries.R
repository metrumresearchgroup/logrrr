user_entries <- function(...) {
  lapply(rlang::dots_list(...), function(.x) {
    if (!rlang::is_bare_formula(.x)) {
      return(.x)
    }
    return(rlang::as_function(.x))
  })
}

invoke_entries <- function(.e) {
  if (is.null(.e)) {
    return(NULL)
  }
  lapply(.e, function(.x) {
    # these should be the entries coerced from formula to function
    if (rlang::is_closure(.x)) {
      return(.x())
    }
    return(.x)
  })
}


