#' Load and Parse Census Variables
#'
#' @description Retrieves variables for a specific year and census dataset, then cleans
#' and expands the `label` column into hierarchical columns for easier filtering and analysis.
#'
#' @param year A numeric value or string specifying the vintage of the census dataset.
#' @param dataset A string specifying the dataset to load (e.g., "acs5", "acs1").
#'
#' @return A tibble of census variables with cleaned, level-separated labels.
#'
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' \dontrun{
#' # Fetch and parse variables for the 2021 ACS 5-year dataset
#' parsed_vars <- parsed_variables(year = 2021, dataset = "acs5")
#' }
parsed_variables <- function(year, dataset) {
  out <- tidycensus::load_variables(year = year, dataset = dataset) |>
    dplyr::mutate(
      table = stringr::str_remove(.data$name, "_.*"),
      year = year,
      dataset = dataset
    ) |>
    dplyr::rename("variable" = "name")

  parse_label_levels(out, label_col = "label", remove_measure = TRUE) |>
    dplyr::select(-.data$label_depth)
}
