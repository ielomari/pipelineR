#' Insert new metrics into student_ibtissam.data_sp500
#'
#' @param con A PostgreSQL connection
#' @param data A tibble with index_ts, date, metric, value
#' @param schema PostgreSQL schema name (default = student_ibtissam)
#'
#' @return TRUE if insertion completed
#' @export
insert_new_data <- function(con, data, schema = "student_ibtissam") {
  if (nrow(data) == 0) {
    message("ℹ️ No data to insert.")
    return(TRUE)
  }

  existing <- DBI::dbGetQuery(con, glue::glue("
    SELECT index_ts, date, metric FROM {schema}.data_sp500
    WHERE index_ts IN ({glue::glue_collapse(unique(data$index_ts), sep = ',', quote = TRUE)})
    AND date IN ({glue::glue_collapse(unique(data$date), sep = ',', quote = TRUE)})
    AND metric IN ({glue::glue_collapse(unique(data$metric), sep = ',', quote = TRUE)})
  "))

  to_insert <- dplyr::anti_join(data, existing, by = c("index_ts", "date", "metric"))

  if (nrow(to_insert) > 0) {
    DBI::dbAppendTable(con, DBI::Id(schema = schema, table = "data_sp500"), to_insert)
    message("✅ Inserted ", nrow(to_insert), " new rows.")
  } else {
    message("ℹ️ No new data to insert.")
  }

  return(TRUE)
}
