fixture_rows <- function(table = NULL) {
  rows <- utils::read.csv(
    testthat::test_path("fixtures", "table_rows.csv"),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
  if (!is.null(table)) rows <- rows[rows$table %in% table, , drop = FALSE]
  tibble::as_tibble(rows)
}
