test_that("yahoo_query_data returns valid list of tibbles", {
  con <- connect_db()
  symbols <- fetch_symbols(con)
  batch <- split_batch(symbols, batch_size = 5)[[1]]
  data_list <- yahoo_query_data(batch, from = Sys.Date() - 10, to = Sys.Date())

  expect_type(data_list, "list")
  expect_true(all(purrr::map_lgl(data_list, ~ is.null(.x) || inherits(.x, "tbl_df"))))

  DBI::dbDisconnect(con)
})
