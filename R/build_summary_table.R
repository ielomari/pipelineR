#' Create an empty summary log table with full structure
#'
#' @param user_login Who is running the pipeline
#' @param batch_id Batch identifier (e.g. based on date or increment)
#'
#' @return A tibble with the structure of pipeline_logs
#' @export
build_summary_table <- function(user_login = Sys.getenv("USER"), batch_id = as.integer(Sys.time())) {
  tibble::tibble(
    user_login = user_login,
    batch_id   = batch_id,
    symbol     = character(),
    status     = character(),
    n_rows     = integer(),
    message    = character(),
    timestamp  = Sys.time()
  )[0, ]
}
