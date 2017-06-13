download_r <- function(path, target = "windows", r_version = NULL,
                       progress = NULL) {
  dir.create(path, FALSE, TRUE)
  r_version <- provisionr::check_r_version(r_version)
  version_str <- as.character(r_version)

  if (r_version == provisionr::check_r_version("release")) {
    loc <- c(windows = sprintf("bin/windows/base/R-%s-win.exe", version_str),
             macosx = sprintf("bin/macosx/R-%s.pkg", version_str))
  } else {
    loc <- c(windows = sprintf("bin/windows/base/old/%s/R-%s-win.exe",
                               version_str, version_str),
             macosx = sprintf("bin/macosx/old/R-%s.pkg", version_str))
  }
  loc[["source"]] <- sprintf("src/base/R-%d/R-%s.tar.gz",
                             as.integer(r_version[1,1]), version_str)

  valid <- names(loc)
  if (target == "ALL") {
    target <- valid
  } else {
    is_mac <- grepl("^macosx", target)
    if (any(is_mac)) {
      target <- c(target[!is_mac], "macosx")
    }
    is_linux <- target == "linux"
    if (any(is_linux)) {
      target[!is_linux] <- "source"
    }
    err <- setdiff(target, valid)
    if (length(err)) {
      stop("Invalid target ", paste(err, collapse = ", "))
    }
  }

  CRAN <- "https://cloud.r-project.org"
  url <- file.path(CRAN, sprintf(loc[target], version_str))

  provisionr::download_files(url, path, labels = target,
                             count = length(url) > 1L, progress = progress)

  file.path(path, basename(url))
}

download_rtools <- function(path, r_version = NULL, progress = progress) {
  dir.create(path, FALSE, TRUE)
  r_version <- provisionr::check_r_version(r_version)

  v <- c("34" = numeric_version("3.3.0"),
         "33" = numeric_version("3.2.0"),
         "32" = numeric_version("3.1.0"))

  i <- which(r_version > v)
  if (length(i) == 0) {
    stop("R version is too old")
  }
  CRAN <- "https://cloud.r-project.org"
  rtools_path <- sprintf("bin/windows/Rtools/Rtools%s.exe", names(i)[[1L]])
  url <- file.path(CRAN, rtools_path)
  provisionr::download_files(url, path, count = FALSE, progress = progress)
}
