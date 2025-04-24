#' Fetch demo tickers (testing version)
#'
#' @param con A PostgreSQL connection
#'
#' @return A tibble with real Yahoo-compatible symbols
#' @export
#'
#' @examples
#' \dontrun{
#' con <- connect_db()
#' fetch_symbols(con)
#' }
fetch_symbols <- function(con) {
  tibble::tibble(symbol = c("AAPL", "MSFT", "GOOGL", "AMZN", "META"))
}
