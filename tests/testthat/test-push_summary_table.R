test_that("push_summary_table inserts logs correctly", {
  con <- connect_db()

  # Create a fake log with one entry
  log_tbl <- build_summary_table(user_login = "ibtissam", batch_id = 9999)
  log_tbl <- log_summary(
    log_tbl,
    symbol = "AAPL",
    status = "OK",
    n_rows = 42,
    message = "Test log from unit test"
  )

  # Push to DB
  result <- push_summary_table(con, log_tbl, schema = "student_ibtissam")

  expect_true(result)

  DBI::dbDisconnect(con)
})
