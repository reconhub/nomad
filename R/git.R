download_git <- function(path, progress = NULL) {
  version <- "2.13.1"
  root <- "https://github.com/git-for-windows/git/releases/download/"
  release <- sprintf("v%s.windows.1", version)
  filename <- sprintf("Git-%s-64-bit.exe", version)
  url <- file.path(root, release, filename)

  ## It is somewhat possible to fetch the most recent relase but it's
  ## flakey in tests and there are other things mixed in with the
  ## releases that look like it might make this a bit unreliable.  For
  ## the record though, this does work in theory, if not in practice:
  ##
  ##   url <- "https://api.github.com/repos/git-for-windows/git/releases/latest"
  ##   r <- curl::curl_fetch_memory(url)
  ##   dat <- jsonlite::fromJSON(rawToChar(r$content))
  ##   re <- "^Git-(.*)-64-bit.exe"
  ##   i <- grep(re, dat$assets$name)
  ##   if (length(i) != 1L) {
  ##     stop("Unexpected response from github release")
  ##   }
  ##   url <- dat$assets$browser_download_url[i]
  ##   version <- sub(re, "\\1", dat$assets$name[i])
  provisionr::download_files(url, path, labels = sprintf("git (%s)", version),
                             count = FALSE, progress = progress)
}
