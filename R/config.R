nomad_config <- function(path) {
  ret <- list(r_version = getRversion(),
              target = c("windows", "macosx"),
              suggests = FALSE,
              package_list = "package_list.txt",
              package_sources = "package_sources.txt",
              ## Extras:
              r = TRUE,
              rstudio = TRUE,
              rtools = TRUE,
              git = FALSE)
  file <- file.path(path, "nomad.yml")
  if (file.exists(file)) {
    d <- yaml_read(file)
    extra <- setdiff(names(d), names(ret))
    if (length(extra) > 0L) {
      stop(sprintf("Unknown keys in %s: %s",
                   file, paste(extra, collapse = ", ")))
    }
    ## TODO: there could always be a bunch of work sanitising the
    ## inputs here.  This is pretty minimal:
    fieldname <- function(x) {
      sprintf("%s:%s", basename(file), x)
    }
    if (!is.null(d$r_version)) {
      d$r_version <- provisionr::check_r_version(d$r_version)
    }
    assert_character_or_null(d$target, fieldname("target"))
    assert_scalar_logical_or_null(d$suggests, fieldname("suggests"))
    assert_character_or_null(d$package_list, fieldname("package_list"))
    assert_character_or_null(d$package_sources, fieldname("package_sources"))
    assert_scalar_logical_or_null(d$git, fieldname("git"))
    assert_scalar_logical_or_null(d$r, fieldname("r"))
    assert_scalar_logical_or_null(d$rstudio, fieldname("rstudio"))
    assert_scalar_logical_or_null(d$rtools, fieldname("rtools"))
    ## NOTE: modifyList does exactly the wrong thing here and so I am
    ## avoiding it.
    keep <- d[lengths(d) > 0]
    ret[names(keep)] <- keep
  }
  ret$path <- path
  ret
}

filter_comments <- function(x) {
  x[!grepl("^\\s*(#.*)?$", x)]
}

nomad_prepare <- function(cfg) {
  package_list_file <- file.path(cfg$path, cfg$package_list)
  if (!file.exists(package_list_file)) {
    stop(sprintf("Did not find %s within %s",
                 squote(basename(package_list_file)), squote(cfg$path)))
  }
  cfg$package_list <- filter_comments(readLines(package_list_file))

  package_sources_file <- file.path(cfg$path, cfg$package_sources)
  if (file.exists(package_sources_file)) {
    spec <- filter_comments(readLines(package_sources_file))
    cfg$package_sources <- provisionr::package_sources(spec = spec)
    if (length(cfg$package_sources$spec) > 0L) {
      ## Hmm, I wonder if we can just store these in the main repo?
      ## Probably not...
      cfg$package_sources$local_drat <- file.path(cfg$path, "drat")
    }
  } else {
    cfg$package_sources <- NULL
  }
  cfg
}
