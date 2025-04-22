#' Add a log entry to the summary log tibble
#'
#' @param log_tbl The existing log tibble
#' @param symbol The stock symbol being processed
#' @param status Status of the operation ("OK" or "ERROR")
#' @param n_rows Number of rows inserted (or 0 if error)
#' @param message Optional message (e.g. error details)
#' @param user_login The user running the pipeline
#' @param batch_id The batch ID for this pipeline run
#'
#' @return An updated tibble with the new log row added
#' @export
log_summary <- function(log_tbl, symbol, status, n_rows = 0, message = "",
                        user_login = Sys.getenv("USER"),
                        batch_id = as.integer(Sys.time())) {
  log_entry <- tibble::tibble(
    user_login = user_login,
    batch_id = batch_id,
    symbol = symbol,
    status = status,
    n_rows = as.integer(n_rows),
    message = message,
    timestamp = Sys.time()
  )

  dplyr::bind_rows(log_tbl, log_entry)
}
