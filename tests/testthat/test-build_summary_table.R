test_that("build_summary_table returns correct structure", {
  log_tbl <- build_summary_table()

  expect_s3_class(log_tbl, "tbl_df")
  expect_named(
    log_tbl,
    c("user_login", "batch_id", "symbol", "status", "n_rows", "message", "timestamp")
  )
  expect_equal(nrow(log_tbl), 0)
})
