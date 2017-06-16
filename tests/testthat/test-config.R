context("config")

test_that("defaults", {
  cfg <- nomad_config(tempdir())
  expect_equal(cfg$r_version, getRversion())
  expect_equal(cfg$target, c("windows", "macosx"))

  expect_false(cfg$suggests)
  expect_equal(cfg$package_list, "package_list.txt")
  expect_equal(cfg$package_sources, "package_sources.txt")

  expect_true(cfg$r)
  expect_true(cfg$rtools)
  expect_true(cfg$rstudio)

  expect_false(cfg$git)
  expect_equal(cfg$path, tempdir())
})

test_that("change defaults", {
  path <- tempfile()
  dir.create(path)
  writeLines(c("git: true",
               "rstudio: false",
               "rtools: false",
               "r: false",
               "target: windows",
               "suggests: true",
               "r_version: 3.2.4",
               "package_list: plist",
               "package_sources: slist"),
             file.path(path, "nomad.yml"))
  cfg <- nomad_config(path)
  expect_equal(cfg$r_version, numeric_version("3.2.4"))
  expect_equal(cfg$target, "windows")

  expect_true(cfg$suggests)
  expect_equal(cfg$package_list, "plist")
  expect_equal(cfg$package_sources, "slist")

  expect_false(cfg$r)
  expect_false(cfg$rtools)
  expect_false(cfg$rstudio)
  expect_true(cfg$git)

  expect_equal(cfg$path, path)
})

test_that("prepare", {
  path <- tempfile()
  dir.create(path)
  writeLines(c("package_list: mylist.txt",
               "package_sources: mysources.txt"),
             file.path(path, "nomad.yml"))
  cfg <- nomad_config(path)
  expect_error(nomad_prepare(cfg),
               "Did not find 'mylist.txt' within")
  writeLines("storr", file.path(path, "mylist.txt"))
  dat <- nomad_prepare(cfg)
  expect_null(dat$package_sources)
  expect_equal(dat$package_list, "storr")

  writeLines(c("repo::https://foo.com/bar", "username/repo"),
             file.path(path, "mysources.txt"))
  dat <- nomad_prepare(cfg)
  expect_equal(dat$package_sources$repos, "https://foo.com/bar")
  expect_equal(dat$package_sources$spec, "github::username/repo")
  expect_equal(dat$package_sources$local_drat, file.path(path, "drat"))
})

test_that("invalid config", {
  path <- tempfile()
  dir.create(path)
  writeLines("foo: bar", file.path(path, "nomad.yml"))
  expect_error(nomad_config(path),
               "Unknown keys in .*/nomad\\.yml: foo")
})

test_that("validation", {
  path <- tempfile()
  dir.create(path)

  writeLines("target: 1", file.path(path, "nomad.yml"))
  expect_error(nomad_config(path),
               "'nomad.yml:target' must be a character vector")
})

test_that("example config is OK", {
  expect_silent(nomad_config(system.file("nomad.yml", package = "nomad")))
})
