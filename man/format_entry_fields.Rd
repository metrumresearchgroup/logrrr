% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format-fields.R
\name{format_entry_fields}
\alias{format_entry_fields}
\title{format fields}
\usage{
format_entry_fields(fields, color_func = NULL, sep = "=",
  collapse = " ")
}
\arguments{
\item{fields}{list or vector with names}

\item{color_func}{function to provide color to names}

\item{sep}{separator between name value}

\item{collapse}{separator between elements}
}
\description{
format fields
}
\examples{
format_entry_fields(list(pid = 123, result = "success"), color_func = crayon::blue)
}
