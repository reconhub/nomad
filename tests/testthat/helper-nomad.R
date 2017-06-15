skip_if_no_internet <- function() {
  if (has_internet()) {
    return()
  }
  testthat::skip("no internet")
}

has_internet <- function() {
  !is.null(suppressWarnings(utils::nsl("www.google.com")))
}

PROGRESS <- FALSE
