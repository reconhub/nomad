download_git <- function(path, progress = NULL) {
  url <- "https://api.github.com/repos/git-for-windows/git/releases/latest"
  r <- curl::curl_fetch_memory(url)
  dat <- jsonlite::fromJSON(rawToChar(r$content))
  re <- "^Git-(.*)-64-bit.exe"
  i <- grep(re, dat$assets$name)
  if (length(i) != 1L) {
    stop("Unexpected response from github release") # nocov
  }
  label <- sprintf("git (%s)", sub(re, "\\1", dat$assets$name[i]))
  provisionr::download_files(dat$assets$browser_download_url[i],
                             path, labels = label, count = FALSE,
                             progress = progress)
}
