#' Push logs to student_ibtissam.pipeline_logs
#'
#' @param con DB connection
#' @param log_tbl Log tibble
#' @param schema Schema name
#'
#' @return TRUE if successful
#' @export
push_summary_table <- function(con, log_tbl, schema = "student_ibtissam") {
  if (nrow(log_tbl) == 0) {
    message("ℹ️ No logs to push.")
    return(TRUE)
  }

  DBI::dbAppendTable(con, DBI::Id(schema = schema, table = "pipeline_logs"), log_tbl)
  message("✅ Logs inserted into pipeline_logs.")
  return(TRUE)
}
