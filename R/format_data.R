format_data <- function(data_list) {
  if (length(data_list) == 0) {
    return(tibble::tibble(index_ts = character(), date = as.Date(character()),
                          metric = character(), value = numeric()))
  }

  purrr::imap_dfr(data_list, ~ {
    if (is.null(.x) || nrow(.x) == 0) return(NULL)

    .x |>
      dplyr::select(date, open, high, low, close, volume) |>
      tidyr::pivot_longer(
        cols = c(open, high, low, close, volume),
        names_to = "metric",
        values_to = "value"
      ) |>
      dplyr::mutate(index_ts = .y, .before = date)
  })
}
