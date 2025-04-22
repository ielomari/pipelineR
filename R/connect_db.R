#' Connect to PostgreSQL database
#'
#' @return A DBI connection object
#' @export
connect_db <- function() {
  DBI::dbConnect(
    RPostgres::Postgres(),
    host     = Sys.getenv("PG_HOST"),
    user     = Sys.getenv("PG_USER"),
    password = Sys.getenv("PG_PASSWORD"),
    dbname   = Sys.getenv("PG_DB")
  )
}
