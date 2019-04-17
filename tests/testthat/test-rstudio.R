context("rstudio")

test_that("url_rstudio", {
  u <- url_rstudio("windows", "1.2.3")
  expect_equal(basename(u), "RStudio-1.2.3.exe")
  expect_equal(names(u), "windows")
})

test_that("url_rstudio: target all", {
  u <- url_rstudio("ALL", "1.2.3")
  expect_setequal(names(u), 
                  c("windows", "macos", "trusty", "xenial", "bionic",
                    "centos7", "debian9", "opensuse15", "opensuse"))
})

test_that("url_rstudio: linux", {
  u <- url_rstudio("linux", "1.2.3")
  expect_setequal(names(u),
                  c("trusty", "xenial", "bionic", "centos7", "debian9",
                    "opensuse15", "opensuse"))
})

test_that("url_rstudio: target invalid", {
  expect_error(url_rstudio("beos", NULL), "Invalid target beos")
})
