context("r")

test_that("url_r", {
  u <- url_r("windows", "release")
  expect_match(u, "/bin/windows/base/R-", fixed = TRUE)
  expect_identical(url_r("windows", provisionr:::r_release_version()), u)

  u <- url_r("windows", "oldrel")
  expect_match(u, "/bin/windows/base/old", fixed = TRUE)
  expect_identical(url_r("windows", provisionr:::r_oldrel_version()), u)
})

test_that("url_r: target all", {
  u <- url_r("ALL", NULL)
  expect_equal(sort(names(u)), sort(c("windows", "macosx", "source")))
})

test_that("url_r: target invalid", {
  expect_error(url_r("beos", NULL), "Invalid target beos")
})

test_that("rtools old", {
  expect_error(url_rtools("2.14.1"), "R version is too old")
})
