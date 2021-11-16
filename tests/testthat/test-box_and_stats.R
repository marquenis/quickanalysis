test_that("Error message with incorrect x input type", {
  expect_error(box_and_stats(mtcars, cyl, wt))
})

test_that("Error message with incorrect y input type", {
  expect_error(box_and_stats(iris, species, "hello"))
})

test_that("Returns the correct outputs", {
  subject <- box_and_stats(iris, Species, Sepal.Width)
  expect_s3_class(subject[[1]], "ggplot")
  expect_s3_class(subject[[2]], "data.frame")
})

test_that("Returns correct output", {
  expect_type(box_and_stats(iris, Species, Sepal.Width), "list")
})
