test_that("insert_new_data inserts correctly", {
  con <- connect_db()
  symbols <- fetch_symbols(con)
  batch <- split_batch(symbols, batch_size = 3)[[1]]
  raw_data <- yahoo_query_data(batch, from = Sys.Date() - 10, to = Sys.Date())
  formatted <- format_data(raw_data)

  result <- insert_new_data(con, formatted, schema = "student_ibtissam")
  expect_true(result)

  DBI::dbDisconnect(con)
})
