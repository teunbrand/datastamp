test_that("make_stamp() responds to global options", {
  old_opts <- options()
  
  test <- get_stamp(stamp(1))
  expect_identical(names(test), c("script", "time", "system", "session"))
  
  options(
    "datastamp.system" = FALSE,
    "datastamp.session" = FALSE,
    "datastamp.script" = TRUE,
    "datastamp.time" = TRUE
  )
  
  test <- get_stamp(stamp(1))
  expect_identical(names(test), c("script", "time"))
  
  options(old_opts)
})