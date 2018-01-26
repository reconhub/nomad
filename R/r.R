download_r <- function(path, target = "windows", r_version = NULL,
                       progress = NULL) {
  dir.create(path, FALSE, TRUE)
  url <- url_r(target, r_version)
  provisionr::download_files(url, path, labels = names(url),
                             count = length(url) > 1L, progress = progress)
  file.path(path, basename(url))
}

download_rtools <- function(path, r_version = NULL, progress = progress) {
  dir.create(path, FALSE, TRUE)
  url <- url_rtools(r_version)
  provisionr::download_files(url, path, count = FALSE, progress = progress)
}

url_r <- function(target, r_version) {
  r_version <- provisionr::check_r_version(r_version)
  r_release <- provisionr::check_r_version("release")
  version_str <- as.character(r_version)

  if (r_version == r_release) {
    loc <- c(windows = sprintf("bin/windows/base/R-%s-win.exe", version_str),
             macosx = sprintf("bin/macosx/R-%s.pkg", version_str))
  } else {
    if (r_version[1, 1:2] == r_release[1, 1:2]) {
      mac_path <- "bin/macosx/R-%s.pkg"
    } else {
      mac_path <- "bin/macosx/old/R-%s.pkg"
    }
    loc <- c(windows = sprintf("bin/windows/base/old/%s/R-%s-win.exe",
                               version_str, version_str),
             macosx = sprintf(mac_path, version_str))
  }
  loc[["source"]] <- sprintf("src/base/R-%d/R-%s.tar.gz",
                             as.integer(r_version[1,1]), version_str)

  valid <- names(loc)
  if (identical(unname(target), "ALL")) {
    target <- valid
  } else {
    is_mac <- grepl("^macosx", target)
    if (any(is_mac)) {
      target <- c(target[!is_mac], "macosx")
    }
    is_linux <- target == "linux"
    if (any(is_linux)) {
      target[is_linux] <- "source"
    }
    err <- setdiff(target, valid)
    if (length(err)) {
      stop("Invalid target ", paste(err, collapse = ", "))
    }
  }

  CRAN <- "https://cloud.r-project.org"
  url <- file.path(CRAN, sprintf(loc[target], version_str))
  names(url) <- target
  url
}

url_rtools <- function(r_version) {
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
  file.path(CRAN, rtools_path)
}
