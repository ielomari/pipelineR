#' Run the full data pipeline
#'
#' @param from Start date (Yahoo Finance)
#' @param to End date (Yahoo Finance)
#' @param batch_size Number of tickers per batch
#' @param user_login Name of the user running the pipeline
#'
#' @export
start_pipeline <- function(from, to, batch_size = 10, user_login = Sys.getenv("USER")) {
  con <- connect_db()
  on.exit(DBI::dbDisconnect(con))

  # Unique ID for the batch
  batch_id <- as.integer(Sys.time())

  # Initialize log table
  log_tbl <- tibble::tibble(
    user_login = character(),
    batch_id = integer(),
    symbol = character(),
    status = character(),
    n_rows = integer(),
    message = character(),
    timestamp = as.POSIXct(character())
  )

  # Fetch tickers and split into batches
  symbols <- fetch_symbols(con)
  batches <- split_batch(symbols, batch_size)

  for (batch in batches) {
    data_list <- yahoo_query_data(batch, from = from, to = to)
    formatted <- format_data(data_list)

    tryCatch({
      insert_new_data(con, formatted)

      for (sym in unique(formatted$index_ts)) {
        log_tbl <- log_summary(
          log_tbl,
          symbol = sym,
          status = "OK",
          n_rows = sum(formatted$index_ts == sym),
          message = "Inserted successfully",
          user_login = user_login,
          batch_id = batch_id
        )
      }
    }, error = function(e) {
      for (sym in batch$symbol) {
        log_tbl <- log_summary(
          log_tbl,
          symbol = sym,
          status = "ERROR",
          n_rows = 0,
          message = e$message,
          user_login = user_login,
          batch_id = batch_id
        )
      }
    })
  }

  # Push log to the database
  push_summary_table(con, log_tbl)
}
