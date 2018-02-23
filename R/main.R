main <- function(args = commandArgs(TRUE)) {
  args <- main_args(args)
  pack(args$path, args$progress)
}


main_args <- function(args) {
  "Usage:
  nomad [--no-progress] <path>

Options:
  --no-progress     Suppress progress bar" -> usage

  if ("--help" %in% args) {
    stop(usage, call. = FALSE)
  }

  if ("--no-progress" %in% args) {
    progress <- FALSE
    args <- setdiff(args, "--no-progress")
  } else {
    progress <- TRUE
  }

  if (length(args) != 1) {
    stop(usage, call. = FALSE)
  }

  list(path = args, progress = progress)
}


write_script <- function(path) {
  code <- c("#!/usr/bin/env Rscript", "nomad:::main()")
  dir.create(dirname(path), FALSE, TRUE)
  writeLines(code, path)
  Sys.chmod(path, "755")
  invisible(path)
}
