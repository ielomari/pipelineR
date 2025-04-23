test_that("insert_new_data inserts only new rows", {
  con <- connect_db()

  test_data <- tibble::tibble(
    index_ts = "AAPL",
    date     = as.Date("2025-01-01"),
    metric   = "close",
    value    = 123.45
  )

  result <- insert_new_data(con, test_data, schema = "student_ibtissam")
  expect_true(result)
})
