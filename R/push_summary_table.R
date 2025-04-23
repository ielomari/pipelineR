#' Push log entries into pipeline_logs
#'
#' @param con DB connection
#' @param log_tbl Tibble with logs
#' @param schema Schema name
#' @return TRUE
#' @export
push_summary_table <- function(con, log_tbl, schema = "student_ibtissam") {
  if (nrow(log_tbl) == 0) {
    message("[INFO] No logs to push.")
    return(invisible(TRUE))
  }

  log_tbl <- log_tbl |>
    dplyr::mutate(across(where(is.factor), as.character))

  tryCatch({
    DBI::dbAppendTable(con, DBI::Id(schema = schema, table = "pipeline_logs"), log_tbl)
    message("[INFO] Logs inserted into pipeline_logs.")
  }, error = function(e) {
    message("[ERROR] Inserting logs failed: ", e$message)
  })

  invisible(TRUE)
}
