## This is not ideal because we get the *latest* but we don't know
## what version that actually is (and therefore whether it should be
## updated).  Leave this be for now but we'll need to go back and fix
## this up.
download_rstudio <- function(path, target = "windows", progress = TRUE) {
  dir.create(path, FALSE, TRUE)
  url <- url_rstudio(target)
  res <- try({
    provisionr::download_files(url, path, labels = names(url),
                               count = length(url) > 1L, progress = progress)
  }, silent = TRUE)
  if (inherits(res, "try-error")) {
    url <- gsub("-1\\.([a-z]{3})", ".\\1", url)
    print(url)
    provisionr::download_files(url, path, labels = names(url),
                               count = length(url) > 1L, progress = progress)

  }
}

url_rstudio <- function(target, version = NULL) {
  base <- "https://download1.rstudio.org/desktop"
  loc_linux <- c(
                 ## ubuntu32 = "rstudio-%s-i386.deb",
                 ubuntu64 = "%s/rstudio-%s-amd64.deb",
                 ## fedora32 = "rstudio-%s-i686.rpm",
                 fedora64 = "%s/rstudio-%s-x86_64.rpm")
  loc <- c(windows = "windows/RStudio-%s.exe",
           macos   = "macos/RStudio-%s.dmg",
           loc_linux)

  if (identical(target, "ALL")) {
    target <- names(loc)
  } else {
    is_mac <- grepl("^macos", target)
    if (any(is_mac)) {
      target <- c(target[!is_mac], "macos")
    }
    is_linux <- target == "linux"
    if (any(is_linux)) {
      target <- c(target[!is_linux], names(loc_linux))
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
