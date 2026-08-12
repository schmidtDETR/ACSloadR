#' Get tidy ACS age and sex data
#'
#' Downloads the B01001 total-population table and the B01001A-I race and
#' ethnicity companion tables. The two structures are returned as separate
#' bundle components because their age bands differ.
#'
#' @inheritParams get_acs_employment
#'
#' @return An `acs_lmi_bundle` with `total_population` and `race_ethnicity`
#'   tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' age <- get_acs_age(2024, "acs5", "state", state = "MA")
#' age$total_population
#' age$race_ethnicity
#' }
get_acs_age <- function(year, survey = c("acs5", "acs1"), geography, ...,
                        cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()
  total_raw <- load_acs_lmi_table(
    registry$age_total_population, year, survey, geography, cache_table, ...
  )
  race_raw <- load_acs_lmi_table(
    registry$age_race_ethnicity, year, survey, geography, cache_table, ...
  )

  components <- list(
    total_population = parse_acs_topic(
      total_raw, registry$age_total_population$parser, registry$age_total_population
    ),
    race_ethnicity = parse_acs_topic(
      race_raw, registry$age_race_ethnicity$parser, registry$age_race_ethnicity
    )
  )
  new_acs_lmi_bundle(components, "Age and sex", year, survey)
}

#' Get tidy ACS employment-status data
#'
#' Downloads and parses subject table S2301. Published population, labor-force
#' participation, employment-population, and unemployment measures are kept in
#' a common long structure.
#'
#' @param year Numeric ACS vintage.
#' @param survey Either `"acs5"` or `"acs1"`.
#' @param geography A geography accepted by [tidycensus::get_acs()].
#' @param ... Additional geography and geometry arguments forwarded to
#'   [tidycensus::get_acs()]. Managed arguments such as `variables`, `table`,
#'   and `output` cannot be supplied here.
#' @param cache_table Logical; cache Census metadata and downloaded tables.
#'
#' @return An `acs_lmi_bundle` containing an `employment` tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' employment <- get_acs_employment(2024, "acs5", "county", state = "MA")
#' employment$employment
#' }
get_acs_employment <- function(year, survey = c("acs5", "acs1"), geography, ...,
                               cache_table = TRUE) {
  survey <- match.arg(survey)
  run_topic_getter(
    "employment", "Employment status", "employment", year, survey,
    geography, cache_table, ...
  )
}

#' Get tidy ACS occupation data
#'
#' Downloads and parses subject table S2401 plus the available detailed-table
#' race and ethnicity companions. ACS 1-year data use B24010A-I; ACS 5-year
#' data use the more aggregated C24010A-I tables. The outputs remain separate
#' because their occupation hierarchies differ. Race/ethnicity occupation totals
#' are derived by summing the published male and female estimates; derived rows
#' retain both source variable IDs and approximate the MOE for a sum.
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing `occupation` and `race_ethnicity`
#'   tibbles.
#' @export
get_acs_occupation <- function(year, survey = c("acs5", "acs1"), geography, ...,
                               cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()
  race_config <- registry[[paste0("occupation_race_", survey)]]

  occupation_raw <- load_acs_lmi_table(
    registry$occupation, year, survey, geography, cache_table, ...
  )
  race_raw <- load_acs_lmi_table(
    race_config, year, survey, geography, cache_table, ...
  )

  components <- list(
    occupation = parse_acs_topic(
      occupation_raw, registry$occupation$parser, registry$occupation
    ),
    race_ethnicity = parse_acs_topic(
      race_raw, race_config$parser, race_config
    )
  )
  new_acs_lmi_bundle(components, "Occupation by sex", year, survey)
}

#' Get tidy ACS earnings by educational attainment data
#'
#' Downloads and parses detailed table B20004. Values are published inflation-
#' adjusted median earnings; this function does not calculate earnings gaps.
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing an `earnings` tibble.
#' @export
get_acs_earnings <- function(year, survey = c("acs5", "acs1"), geography, ...,
                             cache_table = TRUE) {
  survey <- match.arg(survey)
  run_topic_getter(
    "earnings", "Earnings by educational attainment", "earnings", year,
    survey, geography, cache_table, ...
  )
}

#' Get tidy ACS commuting-mode data
#'
#' Downloads and parses detailed table B08301, retaining the transportation
#' hierarchy and adding shares of the table universe with propagated MOEs.
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing a `commuting` tibble.
#' @export
get_acs_commuting <- function(year, survey = c("acs5", "acs1"), geography, ...,
                              cache_table = TRUE) {
  survey <- match.arg(survey)
  run_topic_getter(
    "commuting", "Means of transportation to work", "commuting", year,
    survey, geography, cache_table, ...
  )
}
