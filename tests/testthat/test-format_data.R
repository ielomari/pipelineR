test_that("format_data returns correct columns", {
  con <- connect_db()
  symbols <- fetch_symbols(con)
  batch <- split_batch(symbols, batch_size = 5)[[1]]
  data_list <- yahoo_query_data(batch, from = Sys.Date() - 10, to = Sys.Date())
  formatted <- format_data(data_list)

  expect_s3_class(formatted, "tbl_df")

  if (nrow(formatted) == 0) {
    skip("No data returned — skipping column check")
  } else {
    expect_true(all(c("index_ts", "date", "metric", "value") %in% colnames(formatted)))
  }

  DBI::dbDisconnect(con)
})
