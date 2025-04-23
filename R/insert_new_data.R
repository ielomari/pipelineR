#' Insert new stock data into student_ibtissam.data_sp500
#'
#' @param con A DBI connection
#' @param data A tibble with index_ts, date, metric, value
#' @param schema PostgreSQL schema name
#'
#' @return TRUE (invisible)
#' @export
insert_new_data <- function(con, data, schema = "student_ibtissam") {
  if (nrow(data) == 0) {
    message("[INFO] No data to insert.")
    return(invisible(TRUE))
  }

  # Sanitize data
  data <- data |>
    dplyr::filter(!is.na(index_ts) & !is.na(date) & !is.na(metric))

  if (nrow(data) == 0) {
    message("[INFO] No valid data to insert after sanitizing.")
    return(invisible(TRUE))
  }

  existing <- tryCatch({
    DBI::dbGetQuery(con, glue::glue_sql(
      "SELECT index_ts, date, metric FROM {.schema}.data_sp500
     WHERE index_ts IN ({index_ts*})
     AND date IN ({date*})
     AND metric IN ({metric*})",
      .con = con,
      index_ts = unique(data$index_ts),
      date = unique(data$date),
      metric = unique(data$metric),
      .schema = DBI::SQL(schema)
    ))
  }, error = function(e) {
    message("[ERROR] Could not check existing data: ", e$message)
    # Renvoie un tibble vide mais avec les bonnes colonnes !
    return(tibble::tibble(
      index_ts = character(),
      date = as.Date(character()),
      metric = character()
    ))
  })


  to_insert <- dplyr::anti_join(data, existing, by = c("index_ts", "date", "metric"))

  if (nrow(to_insert) > 0) {
    DBI::dbAppendTable(con, DBI::Id(schema = schema, table = "data_sp500"), to_insert)
    message("[INFO] Inserted ", nrow(to_insert), " new rows.")
  } else {
    message("[INFO] No new data to insert.")
  }

  invisible(TRUE)
}
