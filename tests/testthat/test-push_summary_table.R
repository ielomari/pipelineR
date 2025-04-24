test_that("push_summary_table inserts logs into student_ibtissam.pipeline_logs", {
  con <- connect_db()

  log_tbl <- tibble::tibble(
    batch_id = 9999,
    symbol = "AAPL",
    status = "OK",
    n_rows = 42,
    message = "Test log entry from testthat",
    timestamp = Sys.time()
  )

  result <- tryCatch({
    push_summary_table(con, log_tbl, user_login = "ibtissam")
    TRUE
  }, error = function(e) {
    message("[TEST ERROR] ", e$message)
    FALSE
  })

  expect_true(result)
})
