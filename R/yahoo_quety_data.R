#' Query Yahoo Finance for OHLCV data
#'
#' @param batch A tibble of tickers (from split_batch)
#' @param from Start date (YYYY-MM-DD)
#' @param to End date (YYYY-MM-DD)
#'
#' @return A named list of tibbles, one per ticker
#' @export
yahoo_query_data <- function(batch, from, to) {
  symbols <- batch$symbol

  purrr::map(symbols, ~ {
    tryCatch({
      tidyquant::tq_get(.x, get = "stock.prices", from = from, to = to)
    }, error = function(e) {
      message("Failed to fetch data for ", .x)
      return(NULL)
    })
  }) |>
    purrr::set_names(symbols)
}
