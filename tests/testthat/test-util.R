context("utils")

test_that("yaml treats logicals strictly", {
  expect_equal(yaml_load("a: n"), list(a = "n"))
  expect_equal(yaml_load("a: y"), list(a = "y"))
  expect_equal(yaml_load("a: no"), list(a = "no"))
  expect_equal(yaml_load("a: yes"), list(a = "yes"))
})

test_that("yaml error handling works", {
  path <- tempfile()
  writeLines("a: {", path)
  expect_error(yaml_read(path), "while reading '")
})

test_that("assertions", {
  expect_error(assert_scalar_logical(1), "must be logical")
  expect_error(assert_scalar_logical(c(TRUE, FALSE)), "must be a scalar")
  expect_error(assert_scalar_logical(NA), "must not be missing")
})
