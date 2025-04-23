test_that("push_summary_table inserts logs into DB", {
  con <- connect_db()

  log_tbl <- tibble::tibble(
    user_login = "ibtissam",
    batch_id = 1745323146,
    symbol = "AAPL",
    status = "OK",
    n_rows = 10,
    message = "Test log entry",
    timestamp = Sys.time()
  )

  result <- push_summary_table(con, log_tbl, schema = "student_ibtissam")
  expect_true(result)
})

