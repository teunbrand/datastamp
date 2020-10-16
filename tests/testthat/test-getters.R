test_that("getters work as expected", {
  
  atomic <- 1:5
  s4vector <- S4Vectors::Rle(1:5)
  
  stamp <- make_stamp()
  
  atomic <- set_stamp(atomic, stamp)
  s4vector <- set_stamp(s4vector, stamp)
  
  test1 <- get_stamp(atomic)
  test2 <- get_stamp(s4vector)
  test3 <- get_stamp(stamp)
  
  expect_identical(test1, test2)
  expect_identical(test1, test3)
})
