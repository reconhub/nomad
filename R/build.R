##' Build a nomad archive from a github repository
##'
##' @title Build a nomad archive from github
##'
##' @param ref A reference in \code{username/repo} format.  Branches
##'   may be used.
##'
##' @param dest Destination directory - must be an empty directory if
##'   it exists, otherwise specify a new place.
##'
##' @param progress Passed through to \code{nomad::pack}
##' @export
build <- function(ref, dest, progress = NULL) {
  dat <- provisionr:::parse_remote(ref)
  url_zipball <- dat$url_package
  tmp <- tempfile()
  dir.create(tmp, FALSE, TRUE)
  file <- sprintf("%s-%s.zip", dat$username, dat$repo)
  provisionr::download_files(url_zipball, tmp, dest_file = file, count = FALSE)
  unzip(file.path(tmp, file), exdir = tmp)
  path <- setdiff(dir(tmp), file)
  stopifnot(length(path) == 1L)
  path <- file.path(tmp, path)
  build_path(path, dest, progress)
}


##' @export
##' @rdname build
##' @param path Path to source, when using \code{build_path}
build_path <- function(path, dest, progress = NULL) {
  if (file.exists(dest)) {
    if (!is_directory(dest)) {
      stop("'dest' must be a directory")
    }
    if (length(dir(dest, all.files = TRUE, no.. = TRUE)) > 0L) {
      stop("'dest' must be an empty directory")
    }
  } else {
    dir.create(dest, FALSE, TRUE)
  }

  stopifnot(length(path) == 1L)
  path <- file.path(tmp, path)

  if (!is.null(dat$subdir)) {
    path <- file.path(path, dat$subdir)
  }

  cfg <- nomad_config(path)

  files <- file.path(path,
                     c("nomad.yml", cfg$package_list,
                       if (file.exists(file.path(path, cfg$package_sources)))
                         cfg$package_sources))
  stopifnot(all(file.exists(files)))

  file.copy(files, dest)

  files_inst <- dir(file.path(path, "inst"), full.names = TRUE)
  file.copy(files_inst, dest, recursive = TRUE)

  pack(dest, progress)
}
