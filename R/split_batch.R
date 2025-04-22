#' Split tickers into batches
#'
#' @param symbols A tibble of tickers (from fetch_symbols)
#' @param batch_size Number of tickers per batch
#'
#' @return A list of tibbles
#' @export
split_batch <- function(symbols, batch_size = 20) {
  split(
    symbols,
    ceiling(seq_along(1:nrow(symbols)) / batch_size)
  )
}
