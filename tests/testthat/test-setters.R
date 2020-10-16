test_that("setters set stamps appropriately", {
  
  stamp <- make_stamp()
  
  atomic   <- 1:5
  s4vector <- S4Vectors::Rle(1:5)
  
  atomic   <- set_stamp(atomic, stamp)
  s4vector <- set_stamp(s4vector, stamp)
  
  expect_true("datastamp"  %in% names(attributes(atomic)))
  expect_false("datastamp" %in% names(attributes(s4vector)))
  expect_true("datastamp" %in% names(attr(s4vector, "metadata")))
  
  expect_s3_class(attr(atomic, "datastamp"), "datastamp")
  expect_s3_class(attr(s4vector, "metadata")$datastamp, "datastamp")
})

test_that("setters cannot stamp stamps", {
  
  stamp <- make_stamp()
  
  expect_error(set_stamp(stamp, stamp))
})