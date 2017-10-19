context("nomad")

## Somewhat minimal set, but containing everything:
test_that("pack", {
  skip_on_cran()
  skip_if_no_internet()
  path <- tempfile()
  dir.create(path)
  on.exit(unlink(path, recursive = TRUE))
  writeLines("git: true", file.path(path, "nomad.yml"))
  writeLines("ape", file.path(path, "package_list.txt"))

  expect_equal(pack(path, PROGRESS), path)

  v2 <- as.character(getRversion()[1, 1:2])
  v3 <- as.character(getRversion())

  expect_equal(sort(dir(path)),
               sort(c("activate.R", "bin", "extra", "nomad.yml",
                      "package_list.txt", "src")))
  expect_equal(sort(dir(file.path(path, "bin"))),
               sort(c("macosx", "windows")))

  p <- file.path(path, "bin", "windows", "contrib", v2)
  expect_true(file.exists(file.path(p, "PACKAGES")))
  expect_match(dir(p), "^ape_.*\\.zip$", all = FALSE)

  ## Mac is harder so cheat a little:
  expect_match(
    basename(dir(file.path(path, "bin", "macosx"), recursive = TRUE)),
    "^ape_.*\\.tgz$", all = FALSE)

  p <- file.path(path, "src", "contrib")
  expect_true(file.exists(file.path(p, "PACKAGES")))
  expect_match(dir(p), "^ape_.*\\.tar\\.gz$", all = FALSE)

  extra <- dir(file.path(path, "extra"))

  expect_true(sprintf("R-%s.pkg", v3) %in% extra) # mac
  expect_true(sprintf("R-%s-win.exe", v3) %in% extra) # windows

  expect_match(extra, "^Rtools[0-9]+\\.exe$", all = FALSE)

  expect_match(extra, "^RStudio-.*\\.exe$", all = FALSE)
  expect_match(extra, "^RStudio-.*\\.dmg$", all = FALSE)

  expect_match(extra, "^Git-.*\\.exe$", all = FALSE)
})

test_that("require existing directory", {
  path <- tempfile()
  expect_error(pack(path), "'path' must be an existing directory")
  writeLines(character(0), path)
  expect_error(pack(path), "'path' must be an existing directory")
})

test_that("use package sources", {
  skip_on_cran()
  skip_if_no_internet()
  path <- tempfile()
  dir.create(path)
  on.exit(unlink(path, recursive = TRUE))
  writeLines("git: false\nr: false\nrstudio: false\nrtools: false",
             file.path(path, "nomad.yml"))
  writeLines("syncr", file.path(path, "package_list.txt"))
  writeLines("richfitz/syncr", file.path(path, "package_sources.txt"))

  expect_equal(pack(path, PROGRESS), path)
})

test_that("use repository", {
  skip_on_cran()
  skip_if_no_internet()
  path <- tempfile()
  dir.create(path)
  on.exit(unlink(path, recursive = TRUE))
  writeLines("git: false\nr: false\nrstudio: false\nrtools: false",
             file.path(path, "nomad.yml"))
  writeLines("syncr", file.path(path, "package_list.txt"))
  writeLines("repo::https://richfitz.github.io/drat",
             file.path(path, "package_sources.txt"))
  pack(path, PROGRESS)
  expect_equal(pack(path, PROGRESS), path)
})

test_that("build", {
  skip_on_cran()
  skip_if_no_internet()

  ref <- "reconhub/nomad/tests/testthat/example"
  dest <- tempfile()
  res <- build(ref, dest)

  expected <- c("bin", "src", "nomad.yml", "package_list.txt", "README.md")
  expect_true(all(expected %in% dir(res)))

  expect_error(build(ref, dest), "'dest' must be an empty directory")
  expect_error(build(ref, file.path(dest, "README.md")),
               "'dest' must be a directory")

  expect_message(source(file.path(dest, "activate.R"), chdir = TRUE),
                 "Nomad is activated")
  expect_equal(normalizePath(getOption("nomad.location")),
               normalizePath(res))
})
