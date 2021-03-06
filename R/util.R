yaml_load <- function(string) {
  ## More restrictive true/false handling.  Only accept if it maps to
  ## full true/false:
  handlers <- list("bool#yes" = function(x) {
    if (identical(toupper(x), "TRUE")) TRUE else x},
    "bool#no" = function(x) {
      if (identical(toupper(x), "FALSE")) FALSE else x})
  yaml::yaml.load(string, handlers = handlers)
}

yaml_read <- function(filename) {
  catch_yaml <- function(e) {
    stop(sprintf("while reading %s\n%s", squote(filename), e$message),
         call. = FALSE)
  }
  tryCatch(yaml_load(read_lines(filename)),
           error = catch_yaml)
}

read_lines <- function(...) {
  paste(readLines(...), collapse = "\n")
}

squote <- function(x) {
  sprintf("'%s'", x)
}

assert_character_or_null <- function(x, name) {
  if (!(is.null(x) || (is.character(x) && length(x) > 0L))) {
    stop(sprintf("%s must be a character vector (or NULL)", squote(name)))
  }
}

assert_scalar_logical_or_null <- function(x, name) {
  if (!(is.null(x) || (is.character(x) && length(x) > 0L))) {
    assert_scalar_logical(x, squote(name))
  }
}

assert_scalar_logical <- function(x, name = deparse(substitute(x))) {
  if (!is.logical(x)) {
    stop(sprintf("%s must be logical", squote(name)))
  }
  if (length(x) != 1L) {
    stop(sprintf("%s must be a scalar", squote(name)))
  }
  if (is.na(x)) {
    stop(sprintf("%s must not be missing", squote(name)))
  }
}

is_directory <- function(path) {
  file.info(path)$isdir
}
