##' Create recon usb stick
##'
##' @title Create recon usb stick
##'
##' @param path Path to download things to.  This directory must
##'   already exist, and may contain a \code{nomad.yml} file to
##'   control the behaviour of nomad.
##'
##' @param progress Print a progress bar for each downloaded file.
##'   The default \code{NULL} respects the value of
##'   \code{getOption(provisionr.download.progress)} which you can set
##'   to \code{FALSE} to prevent the printing of progress bars.
##'
##' @export
pack <- function(path, progress = NULL) {
  if (!file.exists(path) || !file.info(path)$isdir) {
    stop("'path' must be an existing directory")
  }
  cfg <- nomad_prepare(nomad_config(path))

  target_includes_windows <- cfg$target %in% c("ALL", "windows")

  ## Then we start the fun part:
  message("nomad: cran")
  provisionr::download_cran(cfg$package_list, cfg$path,
                            cfg$r_version, cfg$target, cfg$suggests,
                            cfg$package_sources, progress)

  path_extra <- file.path(cfg$path, "extra")
  if (cfg$r) {
    message("nomad: r")
    download_r(path_extra, cfg$target, cfg$r_version, progress = progress)
  }
  if (cfg$rstudio) {
    message("nomad: rstudio")
    download_rstudio(path_extra, cfg$target, progress = progress)
  }
  if (cfg$rtools && target_includes_windows) {
    message("nomad: rtools")
    download_rtools(path_extra, cfg$r_version, progress = progress)
  }
  if (cfg$git && target_includes_windows) {
    message("nomad: git")
    download_git(path_extra, progress = progress)
  }

  invisible(path)
}
