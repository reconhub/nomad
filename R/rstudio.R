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
# "https://download1.rstudio.org/desktop/windows/RStudio-1.2.1335.exe"
# "https://download1.rstudio.org/desktop/macos/RStudio-1.2.1335.dmg"
# "https://download1.rstudio.org/desktop/trusty/amd64/rstudio-1.2.1335-amd64.deb"
# "https://download1.rstudio.org/desktop/xenial/amd64/rstudio-1.2.1335-amd64.deb"
# "https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.1335-amd64.deb"
# "https://download1.rstudio.org/desktop/centos7/x86_64/rstudio-1.2.1335-x86_64.rpm"
# "https://download1.rstudio.org/desktop/debian9/x86_64/rstudio-1.2.1335-amd64.deb"
# "https://download1.rstudio.org/desktop/opensuse15/x86_64/rstudio-1.2.1335-x86_64.rpm"
# "https://download1.rstudio.org/desktop/opensuse/x86_64/rstudio-1.2.1335-x86_64.rpm"

url_rstudio <- function(target, version = NULL) {
  # Note to future nomads:
  #
  # You've got 404
  # Dispare no more and seek out
  # a new URL
  #
  # Just use the source, $luke
  # https://www.rstudio.com/products/rstudio/download/#download
  base <- "https://download1.rstudio.org/desktop"
  loc_linux <- c(
                 xenial     = "xenial/amd64/rstudio-%s-amd64.deb",
                 bionic     = "bionic/amd64/rstudio-%s-amd64.deb",
                 centos7    = "centos7/x86_64/rstudio-%s-x86_64.rpm",
                 debian9    = "debian9/x86_64/rstudio-%s-x86_64.rpm",
                 opensuse15 = "opensuse15/x86_64/rstudio-%s-x86_64.rpm",
                 opensuse   = "opensuse/x86_64/rstudio-%s-x86_64.rpm",
                 NULL
                )
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
    # remove extra BS
    version <- gsub("-\\d+$", "", version)
  }

  ret <- file.path(base, sprintf(loc[target], version))
  names(ret) <- target
  ret
}
