local({
  expected <- c("nomad.yml", "bin", "src")
  missing <- setdiff(expected, dir())
  if (length(missing) > 0L) {
    msg <- c(sprintf("Folder '%s' does not look like a nomad archive", getwd()),
             "The following files and directorieas are missing:",
             sprintf("  - %s", missing),
             "Please check the path and try again")
    stop(paste(msg, collapse = "\n"))
  }

  nomad_url <- paste0("file:///", getwd())
  nomad_url <- sub("file:////", "file:///", nomad_url)
  options(repos = nomad_url,
          nomad.location = getwd())

  message("Setting nomad archive as local cran respository")
  message("packages will be installed from:")
  message("  ", getwd())
  if (file.exists("activate.txt")) {
    message()
    message(paste(readLines("activate.txt"), collapse = "\n"))
  }
})
