#' Insert new stock data into the student_ibtissam schema
#'
#' This function inserts new stock data into student_ibtissam.data_sp500.
#' It removes duplicates (same date/index_ts/metric) before insertion.
#'
#' @param con A valid DBI database connection.
#' @param new_data A tibble matching the table structure (index_ts, date, metric, value).
#'
#' @return The number of rows actually inserted.
#' @export
insert_new_data <- function(con, new_data) {
  if (is.null(con) || is.null(new_data)) {
    stop("Both 'con' and 'new_data' must be provided.")
  }

  required_cols <- c("index_ts", "date", "metric", "value")
  if (!all(required_cols %in% colnames(new_data))) {
    stop(glue::glue(
      "new_data must contain the following columns: {paste(required_cols, collapse = ', ')}"
    ))
  }

  schema <- "student_ibtissam"  # Forcément ton propre schéma

  # Préparation des listes pour la requête
  index_ts_list <- unique(new_data$index_ts)
  date_list <- unique(new_data$date)

  existing <- tryCatch({
    DBI::dbGetQuery(con, glue::glue_sql(
      "SELECT date, index_ts, metric
       FROM {`schema`}.data_sp500
       WHERE index_ts IN ({index_ts_list*})
         AND date IN ({date_list*})",
      .con = con
    ))
  }, error = function(e) {
    message("[ERROR] Could not fetch existing records: ", e$message)
    # retourne un tibble vide avec bonnes colonnes
    return(tibble::tibble(
      date = as.Date(character()),
      index_ts = character(),
      metric = character()
    ))
  })

  # Supprimer les doublons
  if (nrow(existing) > 0) {
    new_data_prepared <- dplyr::anti_join(
      new_data,
      existing,
      by = c("date", "index_ts", "metric")
    )
  } else {
    new_data_prepared <- new_data
  }

  if (nrow(new_data_prepared) == 0) {
    message("[INFO] No new data to insert (already exists).")
    return(0)
  }

  DBI::dbWriteTable(
    conn = con,
    name = DBI::Id(schema = schema, table = "data_sp500"),
    value = new_data_prepared,
    append = TRUE,
    row.names = FALSE
  )

  message(glue::glue("[INFO] {nrow(new_data_prepared)} new rows inserted into {schema}.data_sp500"))

  return(nrow(new_data_prepared))
}
