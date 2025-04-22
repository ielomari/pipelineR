test_that("log_summary adds a new entry", {
  log_tbl <- tibble::tibble(
    user_login = character(),
    batch_id = integer(),
    symbol = character(),
    status = character(),
    n_rows = integer(),
    message = character(),
    timestamp = as.POSIXct(character())
  )

  updated <- log_summary(
    log_tbl = log_tbl,
    symbol = "AAPL",
    status = "OK",
    n_rows = 42,
    message = "Test run",
    user_login = "ibtissam",
    batch_id = 9999
  )

  expect_equal(nrow(updated), 1)
  expect_equal(updated$symbol[1], "AAPL")
  expect_equal(updated$status[1], "OK")
  expect_equal(updated$user_login[1], "ibtissam")
})
