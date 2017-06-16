## This is not ideal because we get the *latest* but we don't know
## what version that actually is (and therefore whether it should be
## updated).  Leave this be for now but we'll need to go back and fix
## this up.
download_rstudio <- function(path, target = "windows", progress = TRUE) {
  dir.create(path, FALSE, TRUE)
  url <- url_rstudio(target)
  provisionr::download_files(url, path, labels = names(url),
                             count = length(url) > 1L, progress = progress)
}

url_rstudio <- function(target, version = NULL) {
  base <- "https://download1.rstudio.org"
  loc <- c(windows = "RStudio-%s.exe",
           macosx = "RStudio-%s.dmg",
           ## ubuntu32 = "rstudio-%s-i386.deb",
           ubuntu64 = "rstudio-%s-amd64.deb",
           ## fedora32 = "rstudio-%s-i686.rpm",
           fedora64 = "rstudio-%s-x86_64.rpm")

  if (identical(target, "ALL")) {
    target <- names(loc)
  } else {
    is_mac <- grepl("^macosx", target)
    if (any(is_mac)) {
      target <- c(target[!is_mac], "macosx")
    }
    is_linux <- target == "linux"
    if (any(is_linux)) {
      target <- c(target[!is_linux],
                  c("ubuntu32", "ubuntu64", "fedora32", "fedora64"))
    }
  }
  err <- setdiff(target, names(loc))
  if (length(err)) {
    stop("Invalid target ", paste(err, collapse = ", "))
  }

  ## Try and get the version verison:
  if (is.null(version)) {
    version <- readLines("https://download1.rstudio.org/current.ver",
                         warn = FALSE)
  }

  ret <- file.path(base, sprintf(loc[target], version))
  names(ret) <- target
  ret
}
