test_that("fetch_symbols returns valid tibble", {
  con <- connect_db()
  symbols <- fetch_symbols(con)
  expect_s3_class(symbols, "tbl_df")
  expect_true("symbol" %in% colnames(symbols))
  expect_true("index_ts" %in% colnames(symbols))
  DBI::dbDisconnect(con)
})
