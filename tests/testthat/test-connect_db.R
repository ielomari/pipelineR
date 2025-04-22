test_that("Database connection is successful", {
  con <- connect_db()
  expect_s4_class(con, "PqConnection")
  DBI::dbDisconnect(con)
})
