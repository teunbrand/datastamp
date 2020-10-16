test_that("info_* functions work", {
  
  tmpfile <- tempfile(fileext = "txt")
  writeLines("A", tmpfile)
  
  stamp <- make_stamp(files = tmpfile)
  
  obj <- set_stamp(1, stamp)
  
  expect_identical(stamp$script, info_script(obj))
  expect_identical(stamp$system, info_system(obj))
  expect_identical(stamp$time, info_time(obj))
  expect_identical(stamp$system[c("user", "effective_user")],
                   info_user(obj))
  expect_identical(stamp$session$R.version, info_version(obj))
  
  
  unlink(tmpfile)
})
