test_that("split_batch splits into correct number of batches", {
  con <- connect_db()
  symbols <- fetch_symbols(con)
  batches <- split_batch(symbols, batch_size = 10)

  expect_type(batches, "list")
  expect_true(all(purrr::map_lgl(batches, ~ "symbol" %in% colnames(.x))))
  expect_true(length(batches) >= 1)

  DBI::dbDisconnect(con)
})
