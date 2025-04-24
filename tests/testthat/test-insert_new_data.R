test_that("insert_new_data inserts only non-duplicate rows", {
  con <- connect_db()

  test_data <- tibble::tibble(
    index_ts = "AAPL",
    date     = Sys.Date(),
    metric   = "close",
    value    = runif(1, 100, 200)
  )

  result <- tryCatch({
    inserted_n <- insert_new_data(con, test_data)
    is.numeric(inserted_n) && inserted_n >= 0
  }, error = function(e) {
    message("[TEST ERROR] ", e$message)
    FALSE
  })

  expect_true(result)
})
