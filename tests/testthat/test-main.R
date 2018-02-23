context("script support")

test_that("parse", {
  expect_equal(main_args("x"), list(path = "x", progress = TRUE))
  expect_equal(main_args(c("x", "--no-progress")),
               list(path = "x", progress = FALSE))
  expect_equal(main_args(c("--no-progress", "x")),
               list(path = "x", progress = FALSE))

  expect_error(main_args(character()), "Usage:")
  expect_error(main_args(c("--no-progress")), "Usage:")
  expect_error(main_args(c("--progress", "x")), "Usage:")
  expect_error(main_args(c("x", "y")), "Usage:")

  expect_error(main_args(c("--help")), "Usage:")
})


test_that("write script", {
  path <- write_script(tempfile())
  expect_true(file.exists(path))
  expect_match(readLines(path), "nomad:::main()", fixed = TRUE, all = FALSE)
})


test_that("build", {
  skip_on_cran()
  skip_if_no_internet()

  path <- tempfile()
  dir.create(path)
  on.exit(unlink(path, recursive = TRUE))
  writeLines(c("git: false", "r: false", "rstudio: false", "rtools: false"),
             file.path(path, "nomad.yml"))
  writeLines("ape", file.path(path, "package_list.txt"))

  res <- main(c(path, "--no-progress"))
  expect_true(file.exists(file.path(path, "src")))
  expect_true(file.exists(file.path(path, "bin")))
})
