#' #' Fetch S&P500 tickers from the sp500.info table
#' #'
#' #' @param con A PostgreSQL DB connection
#' #'
#' #' @return A tibble with columns symbol and index_ts
#' #' @export
#' fetch_symbols <- function(con) {
#'   query <- "SELECT symbol, index_ts FROM sp500.info"
#'   symbols <- DBI::dbGetQuery(con, query)
#'   tibble::as_tibble(symbols)
#' }


#' Fetch demo tickers (testing version)
#'
#' @param con A PostgreSQL connection
#'
#' @return A tibble with real Yahoo-compatible symbols
#' @export
fetch_symbols <- function(con) {
  tibble::tibble(symbol = c("AAPL", "MSFT", "GOOGL", "AMZN", "META"))
}
