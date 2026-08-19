#' Launch the Geographic Region Select Shiny App
#'
#' This function launches an interactive Shiny application that allows users to
#' select geographic regions (counties, tracts, ZCTAs, etc.) on a map and exports
#' the selected regions as R code for use in data analysis.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' run_region_select()
#' }
region_select <- function() {
  # Find the directory where the app is installed
  appDir <- system.file("shiny", "region_select", package = "ACSloadR")

  if (appDir == "") {
    stop("Could not find the app directory. Try re-installing `ACSloadR`.", call. = FALSE)
  }

  # Launch the app
  shiny::runApp(appDir, display.mode = "normal")
}
