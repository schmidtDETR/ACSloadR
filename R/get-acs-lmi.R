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

#' Get tidy ACS detailed employment status data
#'
#' Downloads detailed B- and C-series employment tables, including table B23025
#' (overall counts and labor force shares), age and sex breakdowns (B23001),
#' race and ethnicity companion tables (B23002A-I / C23002A-I), educational
#' attainment by employment status (B23006), and poverty by disability by
#' employment status (B23024).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` with `status`, `age_sex`, `race_ethnicity`,
#'   `education`, and `poverty_disability` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' emp_detail <- get_acs_employment_detail(2024, "acs5", "county", state = "MA")
#' emp_detail$status
#' emp_detail$age_sex
#' emp_detail$race_ethnicity
#' emp_detail$education
#' emp_detail$poverty_disability
#' }
get_acs_employment_detail <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                      cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()
  age_sex_key <- paste0("employment_detail_age_sex_", survey)
  race_key <- paste0("employment_detail_race_", survey)

  status_raw <- load_acs_lmi_table(
    registry$employment_detail_status, year, survey, geography, cache_table, ...
  )
  age_sex_raw <- load_acs_lmi_table(
    registry[[age_sex_key]], year, survey, geography, cache_table, ...
  )
  race_raw <- load_acs_lmi_table(
    registry[[race_key]], year, survey, geography, cache_table, ...
  )
  education_raw <- load_acs_lmi_table(
    registry$employment_detail_education, year, survey, geography, cache_table, ...
  )
  poverty_raw <- load_acs_lmi_table(
    registry$employment_detail_poverty_disability, year, survey, geography, cache_table, ...
  )

  components <- list(
    status = parse_acs_topic(
      status_raw, registry$employment_detail_status$parser, registry$employment_detail_status
    ),
    age_sex = parse_acs_topic(
      age_sex_raw, registry[[age_sex_key]]$parser, registry[[age_sex_key]]
    ),
    race_ethnicity = parse_acs_topic(
      race_raw, registry[[race_key]]$parser, registry[[race_key]]
    ),
    education = parse_acs_topic(
      education_raw, registry$employment_detail_education$parser, registry$employment_detail_education
    ),
    poverty_disability = parse_acs_topic(
      poverty_raw, registry$employment_detail_poverty_disability$parser, registry$employment_detail_poverty_disability
    )
  )
  new_acs_lmi_bundle(components, "Detailed employment status", year, survey)
}

#' Get tidy ACS work experience and hours worked data
#'
#' Downloads detailed tables on usual hours worked per week by weeks worked
#' (B23022, B23026), full-time year-round work status by age (B23027), and
#' summary metrics for hours and median age (B23018, B23020, B23013).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` with `hours_weeks`, `full_time_by_age`, and
#'   `hours_summary` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' work <- get_acs_work_experience(2024, "acs5", "state", state = "MA")
#' work$hours_weeks
#' work$full_time_by_age
#' work$hours_summary
#' }
get_acs_work_experience <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                    cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()
  hw_key <- paste0("work_experience_hours_weeks_", survey)

  hours_weeks_raw <- load_acs_lmi_table(
    registry[[hw_key]], year, survey, geography, cache_table, ...
  )
  full_time_raw <- load_acs_lmi_table(
    registry$work_experience_full_time, year, survey, geography, cache_table, ...
  )
  summary_raw <- load_acs_lmi_table(
    registry$work_experience_hours_summary, year, survey, geography, cache_table, ...
  )

  components <- list(
    hours_weeks = parse_acs_topic(
      hours_weeks_raw, registry[[hw_key]]$parser, registry[[hw_key]]
    ),
    full_time_by_age = parse_acs_topic(
      full_time_raw, registry$work_experience_full_time$parser, registry$work_experience_full_time
    ),
    hours_summary = parse_acs_topic(
      summary_raw, registry$work_experience_hours_summary$parser, registry$work_experience_hours_summary
    )
  )
  new_acs_lmi_bundle(components, "Work experience and hours", year, survey)
}

#' Get tidy ACS family and parental employment data
#'
#' Downloads detailed tables on age of children and parental employment status
#' (B23008), employment status of females with own children (B23003),
#' presence of own children and family type by employment status (B23007),
#' and family worker counts and work experience (B23009, B23010).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` with `children_parent_status`, `females_with_children`,
#'   `family_type_status`, and `family_workers` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' family <- get_acs_family_employment(2024, "acs5", "state", state = "MA")
#' family$children_parent_status
#' family$females_with_children
#' family$family_type_status
#' family$family_workers
#' }
get_acs_family_employment <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                      cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()
  children_key <- paste0("family_employment_children_", survey)
  types_key <- paste0("family_employment_types_", survey)

  children_raw <- load_acs_lmi_table(
    registry[[children_key]], year, survey, geography, cache_table, ...
  )
  females_raw <- load_acs_lmi_table(
    registry$family_employment_females, year, survey, geography, cache_table, ...
  )
  types_raw <- load_acs_lmi_table(
    registry[[types_key]], year, survey, geography, cache_table, ...
  )
  workers_raw <- load_acs_lmi_table(
    registry$family_employment_workers, year, survey, geography, cache_table, ...
  )

  components <- list(
    children_parent_status = parse_acs_topic(
      children_raw, registry[[children_key]]$parser, registry[[children_key]]
    ),
    females_with_children = parse_acs_topic(
      females_raw, registry$family_employment_females$parser, registry$family_employment_females
    ),
    family_type_status = parse_acs_topic(
      types_raw, registry[[types_key]]$parser, registry[[types_key]]
    ),
    family_workers = parse_acs_topic(
      workers_raw, registry$family_employment_workers$parser, registry$family_employment_workers
    )
  )
  new_acs_lmi_bundle(components, "Family and parental employment", year, survey)
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

#' Get tidy ACS detailed occupation counts and earnings data
#'
#' Complements [get_acs_occupation()] by providing total-population detailed
#' occupation counts (B24010 / C24010), full-time counts (B24020 / C24020),
#' and median earnings (B24011, B24012, B24021, B24022).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` with `occupation`, `occupation_full_time`,
#'   `earnings`, and `earnings_full_time` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' occ_detail <- get_acs_occupation_detailed(2024, "acs5", "state", state = "MA")
#' occ_detail$occupation
#' occ_detail$occupation_full_time
#' occ_detail$earnings
#' occ_detail$earnings_full_time
#' }
get_acs_occupation_detailed <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                        cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()
  occ_key <- paste0("occupation_detailed_total_", survey)
  ft_key <- paste0("occupation_detailed_full_time_", survey)
  earn_key <- paste0("occupation_earnings_", survey)
  earn_ft_key <- paste0("occupation_earnings_full_time_", survey)

  occ_raw <- load_acs_lmi_table(registry[[occ_key]], year, survey, geography, cache_table, ...)
  ft_raw <- load_acs_lmi_table(registry[[ft_key]], year, survey, geography, cache_table, ...)
  earn_raw <- load_acs_lmi_table(registry[[earn_key]], year, survey, geography, cache_table, ...)
  earn_ft_raw <- load_acs_lmi_table(registry[[earn_ft_key]], year, survey, geography, cache_table, ...)

  components <- list(
    occupation = parse_acs_topic(occ_raw, registry[[occ_key]]$parser, registry[[occ_key]]),
    occupation_full_time = parse_acs_topic(ft_raw, registry[[ft_key]]$parser, registry[[ft_key]]),
    earnings = parse_acs_topic(earn_raw, registry[[earn_key]]$parser, registry[[earn_key]]),
    earnings_full_time = parse_acs_topic(earn_ft_raw, registry[[earn_ft_key]]$parser, registry[[earn_ft_key]])
  )
  new_acs_lmi_bundle(components, "Detailed occupation", year, survey)
}

#' Get tidy ACS industry data
#'
#' Downloads and parses ACS detailed industry tables. ACS 1-year uses B24030-B24070;
#' ACS 5-year uses collapsed C24030-C24070. Includes industry counts, full-time
#' counts, median earnings (overall and full-time), industry by occupation, and
#' industry by class of worker.
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` with `industry`, `industry_full_time`,
#'   `earnings`, `earnings_full_time`, `industry_by_occupation`, and
#'   `industry_by_class` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' ind <- get_acs_industry(2024, "acs5", "state", state = "MA")
#' ind$industry
#' ind$industry_full_time
#' ind$earnings
#' ind$earnings_full_time
#' ind$industry_by_occupation
#' ind$industry_by_class
#' }
get_acs_industry <- function(year, survey = c("acs5", "acs1"), geography, ...,
                             cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()
  ind_key <- paste0("industry_", survey)
  ft_key <- paste0("industry_full_time_", survey)
  earn_key <- paste0("industry_earnings_", survey)
  earn_ft_key <- paste0("industry_earnings_full_time_", survey)
  occ_key <- paste0("industry_by_occupation_", survey)
  class_key <- paste0("industry_by_class_", survey)

  ind_raw <- load_acs_lmi_table(registry[[ind_key]], year, survey, geography, cache_table, ...)
  ft_raw <- load_acs_lmi_table(registry[[ft_key]], year, survey, geography, cache_table, ...)
  earn_raw <- load_acs_lmi_table(registry[[earn_key]], year, survey, geography, cache_table, ...)
  earn_ft_raw <- load_acs_lmi_table(registry[[earn_ft_key]], year, survey, geography, cache_table, ...)
  occ_raw <- load_acs_lmi_table(registry[[occ_key]], year, survey, geography, cache_table, ...)
  class_raw <- load_acs_lmi_table(registry[[class_key]], year, survey, geography, cache_table, ...)

  components <- list(
    industry = parse_acs_topic(ind_raw, registry[[ind_key]]$parser, registry[[ind_key]]),
    industry_full_time = parse_acs_topic(ft_raw, registry[[ft_key]]$parser, registry[[ft_key]]),
    earnings = parse_acs_topic(earn_raw, registry[[earn_key]]$parser, registry[[earn_key]]),
    earnings_full_time = parse_acs_topic(earn_ft_raw, registry[[earn_ft_key]]$parser, registry[[earn_ft_key]]),
    industry_by_occupation = parse_acs_topic(occ_raw, registry[[occ_key]]$parser, registry[[occ_key]]),
    industry_by_class = parse_acs_topic(class_raw, registry[[class_key]]$parser, registry[[class_key]])
  )
  new_acs_lmi_bundle(components, "Industry", year, survey)
}

#' Get tidy ACS class of worker data
#'
#' Downloads and parses ACS detailed class of worker tables. ACS 1-year uses
#' B24080-B24092 & B24060; ACS 5-year uses collapsed C24080-C24092 & C24060.
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` with `class_of_worker`, `class_of_worker_full_time`,
#'   `earnings`, `earnings_full_time`, and `class_by_occupation` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' cow <- get_acs_class_of_worker(2024, "acs5", "state", state = "MA")
#' cow$class_of_worker
#' cow$class_of_worker_full_time
#' cow$earnings
#' cow$earnings_full_time
#' cow$class_by_occupation
#' }
get_acs_class_of_worker <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                    cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()
  cow_key <- paste0("class_of_worker_", survey)
  ft_key <- paste0("class_of_worker_full_time_", survey)
  earn_key <- paste0("class_of_worker_earnings_", survey)
  earn_ft_key <- paste0("class_of_worker_earnings_full_time_", survey)
  occ_key <- paste0("class_by_occupation_", survey)

  cow_raw <- load_acs_lmi_table(registry[[cow_key]], year, survey, geography, cache_table, ...)
  ft_raw <- load_acs_lmi_table(registry[[ft_key]], year, survey, geography, cache_table, ...)
  earn_raw <- load_acs_lmi_table(registry[[earn_key]], year, survey, geography, cache_table, ...)
  earn_ft_raw <- load_acs_lmi_table(registry[[earn_ft_key]], year, survey, geography, cache_table, ...)
  occ_raw <- load_acs_lmi_table(registry[[occ_key]], year, survey, geography, cache_table, ...)

  components <- list(
    class_of_worker = parse_acs_topic(cow_raw, registry[[cow_key]]$parser, registry[[cow_key]]),
    class_of_worker_full_time = parse_acs_topic(ft_raw, registry[[ft_key]]$parser, registry[[ft_key]]),
    earnings = parse_acs_topic(earn_raw, registry[[earn_key]]$parser, registry[[earn_key]]),
    earnings_full_time = parse_acs_topic(earn_ft_raw, registry[[earn_ft_key]]$parser, registry[[earn_ft_key]]),
    class_by_occupation = parse_acs_topic(occ_raw, registry[[occ_key]]$parser, registry[[occ_key]])
  )
  new_acs_lmi_bundle(components, "Class of worker", year, survey)
}

#' Get tidy ACS 500+ detailed occupation and industry national data
#'
#' Downloads and parses detailed occupation (B24114-B24126) and detailed
#' industry (B24134-B24136) tables. Note: Census publishes these detailed
#' 500+ categories only for the United States as a whole (`geography = "us"`).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` with `detailed_occupation` and `detailed_industry`
#'   tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' national <- get_acs_national_detailed(2024, "acs5", "us")
#' national$detailed_occupation
#' national$detailed_industry
#' }
get_acs_national_detailed <- function(year, survey = c("acs5", "acs1"), geography = "us", ...,
                                      cache_table = TRUE) {
  survey <- match.arg(survey)
  if (!identical(geography, "us")) {
    stop("Tables B24114-B24136 are only published at the US national level (`geography = 'us'`).", call. = FALSE)
  }
  registry <- acs_table_registry()

  occ_raw <- load_acs_lmi_table(registry$national_detailed_occupation, year, survey, geography, cache_table, ...)
  ind_raw <- load_acs_lmi_table(registry$national_detailed_industry, year, survey, geography, cache_table, ...)

  components <- list(
    detailed_occupation = parse_acs_topic(occ_raw, registry$national_detailed_occupation$parser, registry$national_detailed_occupation),
    detailed_industry = parse_acs_topic(ind_raw, registry$national_detailed_industry$parser, registry$national_detailed_industry)
  )
  new_acs_lmi_bundle(components, "National detailed occupation and industry", year, survey)
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

#' Get tidy ACS household income data
#'
#' Downloads detailed household income tables covering income brackets (B19001),
#' median household income (B19013), median income by size (B19019), median income
#' by age (B19049, B19037), and racial companion tables (B19001A-I, B19013A-I).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing `income_brackets`, `race_ethnicity_brackets`,
#'   `median_income`, `median_race_ethnicity`, `median_by_size`, and `by_age` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' hh_inc <- get_acs_household_income(2024, "acs5", "state", state = "MA")
#' hh_inc$income_brackets
#' hh_inc$median_income
#' }
get_acs_household_income <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                     cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  brackets_key <- paste0("household_income_brackets_", survey)
  race_brackets_key <- paste0("household_income_race_", survey)

  b_raw <- load_acs_lmi_table(registry[[brackets_key]], year, survey, geography, cache_table, ...)
  rb_raw <- load_acs_lmi_table(registry[[race_brackets_key]], year, survey, geography, cache_table, ...)
  m_raw <- load_acs_lmi_table(registry$household_income_median, year, survey, geography, cache_table, ...)
  rm_raw <- load_acs_lmi_table(registry$household_income_median_race, year, survey, geography, cache_table, ...)
  sz_raw <- load_acs_lmi_table(registry$household_income_size, year, survey, geography, cache_table, ...)
  age_raw <- load_acs_lmi_table(registry$household_income_age, year, survey, geography, cache_table, ...)

  components <- list(
    income_brackets = parse_acs_topic(b_raw, registry[[brackets_key]]$parser, registry[[brackets_key]]),
    race_ethnicity_brackets = parse_acs_topic(rb_raw, registry[[race_brackets_key]]$parser, registry[[race_brackets_key]]),
    median_income = parse_acs_topic(m_raw, registry$household_income_median$parser, registry$household_income_median),
    median_race_ethnicity = parse_acs_topic(rm_raw, registry$household_income_median_race$parser, registry$household_income_median_race),
    median_by_size = parse_acs_topic(sz_raw, registry$household_income_size$parser, registry$household_income_size),
    by_age = parse_acs_topic(age_raw, registry$household_income_age$parser, registry$household_income_age)
  )
  new_acs_lmi_bundle(components, "Household income", year, survey)
}

#' Get tidy ACS family and nonfamily income data
#'
#' Downloads detailed family and nonfamily income tables covering brackets (B19101, B19131, B19201),
#' medians (B19113, B19119, B19121, B19125, B19126, B19202, B19215), and racial companion tables.
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing `family_brackets`, `family_race_brackets`,
#'   `family_medians`, `family_race_medians`, `family_children`, `nonfamily_brackets`,
#'   `nonfamily_medians`, and `nonfamily_race_medians` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' fam_inc <- get_acs_family_income(2024, "acs5", "state", state = "MA")
#' fam_inc$family_brackets
#' fam_inc$family_medians
#' }
get_acs_family_income <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                  cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  fam_b_key <- paste0("family_income_brackets_", survey)
  fam_rb_key <- paste0("family_income_race_", survey)
  fam_child_key <- paste0("family_income_children_", survey)
  nonfam_b_key <- paste0("nonfamily_income_brackets_", survey)

  fb_raw <- load_acs_lmi_table(registry[[fam_b_key]], year, survey, geography, cache_table, ...)
  frb_raw <- load_acs_lmi_table(registry[[fam_rb_key]], year, survey, geography, cache_table, ...)
  fm_raw <- load_acs_lmi_table(registry$family_income_median, year, survey, geography, cache_table, ...)
  frm_raw <- load_acs_lmi_table(registry$family_income_median_race, year, survey, geography, cache_table, ...)
  fc_raw <- load_acs_lmi_table(registry[[fam_child_key]], year, survey, geography, cache_table, ...)
  nfb_raw <- load_acs_lmi_table(registry[[nonfam_b_key]], year, survey, geography, cache_table, ...)
  nfm_raw <- load_acs_lmi_table(registry$nonfamily_income_median, year, survey, geography, cache_table, ...)
  nfrm_raw <- load_acs_lmi_table(registry$nonfamily_income_median_race, year, survey, geography, cache_table, ...)

  components <- list(
    family_brackets = parse_acs_topic(fb_raw, registry[[fam_b_key]]$parser, registry[[fam_b_key]]),
    family_race_brackets = parse_acs_topic(frb_raw, registry[[fam_rb_key]]$parser, registry[[fam_rb_key]]),
    family_medians = parse_acs_topic(fm_raw, registry$family_income_median$parser, registry$family_income_median),
    family_race_medians = parse_acs_topic(frm_raw, registry$family_income_median_race$parser, registry$family_income_median_race),
    family_children = parse_acs_topic(fc_raw, registry[[fam_child_key]]$parser, registry[[fam_child_key]]),
    nonfamily_brackets = parse_acs_topic(nfb_raw, registry[[nonfam_b_key]]$parser, registry[[nonfam_b_key]]),
    nonfamily_medians = parse_acs_topic(nfm_raw, registry$nonfamily_income_median$parser, registry$nonfamily_income_median),
    nonfamily_race_medians = parse_acs_topic(nfrm_raw, registry$nonfamily_income_median_race$parser, registry$nonfamily_income_median_race)
  )
  new_acs_lmi_bundle(components, "Family and nonfamily income", year, survey)
}

#' Get tidy ACS income types and composition data
#'
#' Downloads detailed tables on household receipt of specific income types
#' (B19051-B19060: earnings, wages, self-employment, Social Security, SSI, public assistance,
#' retirement, etc.) and aggregate dollar amounts (B19061-B19070).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing `household_counts` and `aggregate_dollars` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' inc_types <- get_acs_income_types(2024, "acs5", "state", state = "MA")
#' inc_types$household_counts
#' inc_types$aggregate_dollars
#' }
get_acs_income_types <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                 cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  c_raw <- load_acs_lmi_table(registry$income_types_counts, year, survey, geography, cache_table, ...)
  a_raw <- load_acs_lmi_table(registry$income_types_aggregates, year, survey, geography, cache_table, ...)

  components <- list(
    household_counts = parse_acs_topic(c_raw, registry$income_types_counts$parser, registry$income_types_counts),
    aggregate_dollars = parse_acs_topic(a_raw, registry$income_types_aggregates$parser, registry$income_types_aggregates)
  )
  new_acs_lmi_bundle(components, "Income types and composition", year, survey)
}

#' Get tidy ACS income inequality and aggregate income metrics
#'
#' Downloads income inequality and distribution metrics: Gini Index (B19083),
#' Quintile upper limits (B19080), Quintile mean income (B19081), Quintile aggregate income shares (B19082),
#' Per Capita Income (B19301, B19301A-I), and Aggregate Total Income (B19313, B19313A-I).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing `gini_index`, `quintile_limits`, `quintile_means`,
#'   `quintile_shares`, `per_capita_income`, `per_capita_race`, `aggregate_income`, and
#'   `aggregate_race` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' ineq <- get_acs_income_inequality(2024, "acs5", "state", state = "MA")
#' ineq$gini_index
#' ineq$quintile_shares
#' }
get_acs_income_inequality <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                      cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  g_raw <- load_acs_lmi_table(registry$income_inequality_gini, year, survey, geography, cache_table, ...)
  ql_raw <- load_acs_lmi_table(registry$income_quintiles_limits, year, survey, geography, cache_table, ...)
  qm_raw <- load_acs_lmi_table(registry$income_quintiles_means, year, survey, geography, cache_table, ...)
  qs_raw <- load_acs_lmi_table(registry$income_quintiles_shares, year, survey, geography, cache_table, ...)
  pc_raw <- load_acs_lmi_table(registry$per_capita_income, year, survey, geography, cache_table, ...)
  pcr_raw <- load_acs_lmi_table(registry$per_capita_income_race, year, survey, geography, cache_table, ...)
  agg_raw <- load_acs_lmi_table(registry$aggregate_income, year, survey, geography, cache_table, ...)
  aggr_raw <- load_acs_lmi_table(registry$aggregate_income_race, year, survey, geography, cache_table, ...)

  components <- list(
    gini_index = parse_acs_topic(g_raw, registry$income_inequality_gini$parser, registry$income_inequality_gini),
    quintile_limits = parse_acs_topic(ql_raw, registry$income_quintiles_limits$parser, registry$income_quintiles_limits),
    quintile_means = parse_acs_topic(qm_raw, registry$income_quintiles_means$parser, registry$income_quintiles_means),
    quintile_shares = parse_acs_topic(qs_raw, registry$income_quintiles_shares$parser, registry$income_quintiles_shares),
    per_capita_income = parse_acs_topic(pc_raw, registry$per_capita_income$parser, registry$per_capita_income),
    per_capita_race = parse_acs_topic(pcr_raw, registry$per_capita_income_race$parser, registry$per_capita_income_race),
    aggregate_income = parse_acs_topic(agg_raw, registry$aggregate_income$parser, registry$aggregate_income),
    aggregate_race = parse_acs_topic(aggr_raw, registry$aggregate_income_race$parser, registry$aggregate_income_race)
  )
  new_acs_lmi_bundle(components, "Income inequality and aggregates", year, survey)
}

#' Get tidy ACS individual income, earnings, and work experience data
#'
#' Downloads detailed individual income and earnings tables covering brackets (B20001, B20005, B19325),
#' medians (B20002, B20017, B20018, B19326), aggregate earnings (B20003), and racial companion tables (B20005A-I, B20017A-I).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing `earnings_brackets`, `earnings_median`,
#'   `earnings_aggregate`, `earnings_work_exp`, `earnings_work_exp_race`,
#'   `earnings_median_work_exp`, `earnings_median_work_exp_race`, `earnings_full_time`,
#'   `income_brackets`, and `income_median` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' ind_inc <- get_acs_individual_income(2024, "acs5", "state", state = "MA")
#' ind_inc$earnings_brackets
#' ind_inc$earnings_work_exp
#' }
get_acs_individual_income <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                      cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  we_key <- paste0("individual_earnings_work_exp_", survey)
  wer_key <- paste0("individual_earnings_work_exp_race_", survey)

  eb_raw <- load_acs_lmi_table(registry$individual_earnings_brackets, year, survey, geography, cache_table, ...)
  em_raw <- load_acs_lmi_table(registry$individual_earnings_median, year, survey, geography, cache_table, ...)
  ea_raw <- load_acs_lmi_table(registry$individual_earnings_aggregate, year, survey, geography, cache_table, ...)
  we_raw <- load_acs_lmi_table(registry[[we_key]], year, survey, geography, cache_table, ...)
  wer_raw <- load_acs_lmi_table(registry[[wer_key]], year, survey, geography, cache_table, ...)
  mwe_raw <- load_acs_lmi_table(registry$individual_earnings_median_work_exp, year, survey, geography, cache_table, ...)
  mwer_raw <- load_acs_lmi_table(registry$individual_earnings_median_work_exp_race, year, survey, geography, cache_table, ...)
  ft_raw <- load_acs_lmi_table(registry$individual_earnings_full_time, year, survey, geography, cache_table, ...)
  ib_raw <- load_acs_lmi_table(registry$individual_income_brackets, year, survey, geography, cache_table, ...)
  im_raw <- load_acs_lmi_table(registry$individual_income_median, year, survey, geography, cache_table, ...)

  components <- list(
    earnings_brackets = parse_acs_topic(eb_raw, registry$individual_earnings_brackets$parser, registry$individual_earnings_brackets),
    earnings_median = parse_acs_topic(em_raw, registry$individual_earnings_median$parser, registry$individual_earnings_median),
    earnings_aggregate = parse_acs_topic(ea_raw, registry$individual_earnings_aggregate$parser, registry$individual_earnings_aggregate),
    earnings_work_exp = parse_acs_topic(we_raw, registry[[we_key]]$parser, registry[[we_key]]),
    earnings_work_exp_race = parse_acs_topic(wer_raw, registry[[wer_key]]$parser, registry[[wer_key]]),
    earnings_median_work_exp = parse_acs_topic(mwe_raw, registry$individual_earnings_median_work_exp$parser, registry$individual_earnings_median_work_exp),
    earnings_median_work_exp_race = parse_acs_topic(mwer_raw, registry$individual_earnings_median_work_exp_race$parser, registry$individual_earnings_median_work_exp_race),
    earnings_full_time = parse_acs_topic(ft_raw, registry$individual_earnings_full_time$parser, registry$individual_earnings_full_time),
    income_brackets = parse_acs_topic(ib_raw, registry$individual_income_brackets$parser, registry$individual_income_brackets),
    income_median = parse_acs_topic(im_raw, registry$individual_income_median$parser, registry$individual_income_median)
  )
  new_acs_lmi_bundle(components, "Individual income and earnings", year, survey)
}

#' Get tidy ACS school enrollment data
#'
#' Downloads detailed school enrollment tables covering overall enrollment (B14001),
#' detailed grade levels (B14007/C14007 & race B14007A-I), public vs private school type (B14002/C14002, B14003/C14003, B14004),
#' youth enrollment & employment (B14005/C14005), and enrollment by poverty status (B14006).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing `enrollment_level`, `enrollment_detailed`,
#'   `enrollment_detailed_race`, `enrollment_type`, `enrollment_age`, `college_enrollment_age`,
#'   `youth_enrollment_employment`, and `poverty_enrollment` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' enroll <- get_acs_school_enrollment(2024, "acs5", "state", state = "MA")
#' enroll$enrollment_level
#' enroll$enrollment_detailed
#' }
get_acs_school_enrollment <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                      cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  det_key <- paste0("school_enrollment_detailed_", survey)
  det_race_key <- paste0("school_enrollment_detailed_race_", survey)
  type_key <- paste0("school_enrollment_type_", survey)
  age_key <- paste0("school_enrollment_age_", survey)
  youth_key <- paste0("youth_enrollment_employment_", survey)

  l_raw <- load_acs_lmi_table(registry$school_enrollment_level, year, survey, geography, cache_table, ...)
  d_raw <- load_acs_lmi_table(registry[[det_key]], year, survey, geography, cache_table, ...)
  dr_raw <- load_acs_lmi_table(registry[[det_race_key]], year, survey, geography, cache_table, ...)
  t_raw <- load_acs_lmi_table(registry[[type_key]], year, survey, geography, cache_table, ...)
  a_raw <- load_acs_lmi_table(registry[[age_key]], year, survey, geography, cache_table, ...)
  c_raw <- load_acs_lmi_table(registry$college_enrollment_age, year, survey, geography, cache_table, ...)
  y_raw <- load_acs_lmi_table(registry[[youth_key]], year, survey, geography, cache_table, ...)
  p_raw <- load_acs_lmi_table(registry$school_enrollment_poverty, year, survey, geography, cache_table, ...)

  components <- list(
    enrollment_level = parse_acs_topic(l_raw, registry$school_enrollment_level$parser, registry$school_enrollment_level),
    enrollment_detailed = parse_acs_topic(d_raw, registry[[det_key]]$parser, registry[[det_key]]),
    enrollment_detailed_race = parse_acs_topic(dr_raw, registry[[det_race_key]]$parser, registry[[det_race_key]]),
    enrollment_type = parse_acs_topic(t_raw, registry[[type_key]]$parser, registry[[type_key]]),
    enrollment_age = parse_acs_topic(a_raw, registry[[age_key]]$parser, registry[[age_key]]),
    college_enrollment_age = parse_acs_topic(c_raw, registry$college_enrollment_age$parser, registry$college_enrollment_age),
    youth_enrollment_employment = parse_acs_topic(y_raw, registry[[youth_key]]$parser, registry[[youth_key]]),
    poverty_enrollment = parse_acs_topic(p_raw, registry$school_enrollment_poverty$parser, registry$school_enrollment_poverty)
  )
  new_acs_lmi_bundle(components, "School enrollment", year, survey)
}

#' Get tidy ACS educational attainment data
#'
#' Downloads detailed educational attainment tables for population 18+ and 25+
#' covering age and sex breakdowns (B15001), sex breakdowns (B15002/C15002), detailed
#' 24-category attainment levels (B15003/C15003), and racial companion tables (B15002A-I).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing `attainment_age_sex`, `attainment_sex`,
#'   `attainment_race`, and `attainment_detailed` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' attain <- get_acs_educational_attainment(2024, "acs5", "state", state = "MA")
#' attain$attainment_sex
#' attain$attainment_detailed
#' }
get_acs_educational_attainment <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                           cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  sex_key <- paste0("educational_attainment_sex_", survey)
  race_key <- paste0("educational_attainment_race_", survey)
  det_key <- paste0("educational_attainment_detailed_", survey)

  as_raw <- load_acs_lmi_table(registry$educational_attainment_age_sex, year, survey, geography, cache_table, ...)
  s_raw <- load_acs_lmi_table(registry[[sex_key]], year, survey, geography, cache_table, ...)
  r_raw <- load_acs_lmi_table(registry[[race_key]], year, survey, geography, cache_table, ...)
  d_raw <- load_acs_lmi_table(registry[[det_key]], year, survey, geography, cache_table, ...)

  components <- list(
    attainment_age_sex = parse_acs_topic(as_raw, registry$educational_attainment_age_sex$parser, registry$educational_attainment_age_sex),
    attainment_sex = parse_acs_topic(s_raw, registry[[sex_key]]$parser, registry[[sex_key]]),
    attainment_race = parse_acs_topic(r_raw, registry[[race_key]]$parser, registry[[race_key]]),
    attainment_detailed = parse_acs_topic(d_raw, registry[[det_key]]$parser, registry[[det_key]])
  )
  new_acs_lmi_bundle(components, "Educational attainment", year, survey)
}

#' Get tidy ACS undergraduate field of degree data
#'
#' Downloads detailed Bachelor's degree major field of degree tables covering broad categories by sex and age (B15011),
#' detailed major fields (B15010/C15010 & B15012), median earnings by field of degree and sex (B15013),
#' and median earnings by field of degree and age (B15014).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing `field_broad`, `field_detailed`,
#'   `field_total_reported`, `earnings_by_sex`, and `earnings_by_age` tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' field <- get_acs_field_of_degree(2024, "acs5", "state", state = "MA")
#' field$field_detailed
#' field$earnings_by_sex
#' }
get_acs_field_of_degree <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                    cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  det_key <- paste0("field_of_degree_detailed_", survey)

  b_raw <- load_acs_lmi_table(registry$field_of_degree_broad, year, survey, geography, cache_table, ...)
  d_raw <- load_acs_lmi_table(registry[[det_key]], year, survey, geography, cache_table, ...)
  t_raw <- load_acs_lmi_table(registry$field_of_degree_total, year, survey, geography, cache_table, ...)
  es_raw <- load_acs_lmi_table(registry$field_of_degree_earnings_sex, year, survey, geography, cache_table, ...)
  ea_raw <- load_acs_lmi_table(registry$field_of_degree_earnings_age, year, survey, geography, cache_table, ...)

  components <- list(
    field_broad = parse_acs_topic(b_raw, registry$field_of_degree_broad$parser, registry$field_of_degree_broad),
    field_detailed = parse_acs_topic(d_raw, registry[[det_key]]$parser, registry[[det_key]]),
    field_total_reported = parse_acs_topic(t_raw, registry$field_of_degree_total$parser, registry$field_of_degree_total),
    earnings_by_sex = parse_acs_topic(es_raw, registry$field_of_degree_earnings_sex$parser, registry$field_of_degree_earnings_sex),
    earnings_by_age = parse_acs_topic(ea_raw, registry$field_of_degree_earnings_age$parser, registry$field_of_degree_earnings_age)
  )
  new_acs_lmi_bundle(components, "Undergraduate field of degree", year, survey)
}

#' Get tidy ACS travel time to work and departure time data
#'
#' Downloads detailed travel time to work tables covering travel time distributions (B08303, B08603),
#' time leaving home and arriving at work (B08302, B08602, B08011), travel time by sex (B08012, B08412),
#' travel time by mode (B08134/C08134, B08534/C08534), departure time by mode (B08132/C08132, B08532/C08532),
#' and aggregate travel times in minutes (B08013, B08131, B08135, B08136/C08136, B08536/C08536).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing travel time and departure time tibbles for both residence and workplace geographies.
#' @export
#'
#' @examples
#' \dontrun{
#' tt <- get_acs_commuting_travel_time(2024, "acs5", "state", state = "MA")
#' tt$travel_time_residence
#' tt$departure_time_residence
#' }
get_acs_commuting_travel_time <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                           cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  ttm_res_key <- paste0("travel_time_mode_residence_", survey)
  ttm_wp_key <- paste0("travel_time_mode_workplace_", survey)
  dtm_res_key <- paste0("departure_time_mode_residence_", survey)
  atm_wp_key <- paste0("arrival_time_mode_workplace_", survey)
  attm_res_key <- paste0("aggregate_travel_time_mode_residence_", survey)
  attm_wp_key <- paste0("aggregate_travel_time_mode_workplace_", survey)

  ttr_raw <- load_acs_lmi_table(registry$travel_time_residence, year, survey, geography, cache_table, ...)
  ttw_raw <- load_acs_lmi_table(registry$travel_time_workplace, year, survey, geography, cache_table, ...)
  dtr_raw <- load_acs_lmi_table(registry$departure_time_residence, year, survey, geography, cache_table, ...)
  atw_raw <- load_acs_lmi_table(registry$arrival_time_workplace, year, survey, geography, cache_table, ...)
  dts_raw <- load_acs_lmi_table(registry$departure_time_sex, year, survey, geography, cache_table, ...)
  ttsr_raw <- load_acs_lmi_table(registry$travel_time_sex_residence, year, survey, geography, cache_table, ...)
  ttsw_raw <- load_acs_lmi_table(registry$travel_time_sex_workplace, year, survey, geography, cache_table, ...)
  ttmr_raw <- load_acs_lmi_table(registry[[ttm_res_key]], year, survey, geography, cache_table, ...)
  ttmw_raw <- load_acs_lmi_table(registry[[ttm_wp_key]], year, survey, geography, cache_table, ...)
  dtmr_raw <- load_acs_lmi_table(registry[[dtm_res_key]], year, survey, geography, cache_table, ...)
  atmw_raw <- load_acs_lmi_table(registry[[atm_wp_key]], year, survey, geography, cache_table, ...)
  attmr_raw <- load_acs_lmi_table(registry[[attm_res_key]], year, survey, geography, cache_table, ...)
  attmw_raw <- load_acs_lmi_table(registry[[attm_wp_key]], year, survey, geography, cache_table, ...)
  attt_raw <- load_acs_lmi_table(registry$aggregate_travel_time_total, year, survey, geography, cache_table, ...)
  attc_raw <- load_acs_lmi_table(registry$aggregate_travel_time_county, year, survey, geography, cache_table, ...)
  atttt_raw <- load_acs_lmi_table(registry$aggregate_travel_time_travel_time, year, survey, geography, cache_table, ...)

  components <- list(
    travel_time_residence = parse_acs_topic(ttr_raw, registry$travel_time_residence$parser, registry$travel_time_residence),
    travel_time_workplace = parse_acs_topic(ttw_raw, registry$travel_time_workplace$parser, registry$travel_time_workplace),
    departure_time_residence = parse_acs_topic(dtr_raw, registry$departure_time_residence$parser, registry$departure_time_residence),
    arrival_time_workplace = parse_acs_topic(atw_raw, registry$arrival_time_workplace$parser, registry$arrival_time_workplace),
    departure_time_sex = parse_acs_topic(dts_raw, registry$departure_time_sex$parser, registry$departure_time_sex),
    travel_time_sex_residence = parse_acs_topic(ttsr_raw, registry$travel_time_sex_residence$parser, registry$travel_time_sex_residence),
    travel_time_sex_workplace = parse_acs_topic(ttsw_raw, registry$travel_time_sex_workplace$parser, registry$travel_time_sex_workplace),
    travel_time_mode_residence = parse_acs_topic(ttmr_raw, registry[[ttm_res_key]]$parser, registry[[ttm_res_key]]),
    travel_time_mode_workplace = parse_acs_topic(ttmw_raw, registry[[ttm_wp_key]]$parser, registry[[ttm_wp_key]]),
    departure_time_mode_residence = parse_acs_topic(dtmr_raw, registry[[dtm_res_key]]$parser, registry[[dtm_res_key]]),
    arrival_time_mode_workplace = parse_acs_topic(atmw_raw, registry[[atm_wp_key]]$parser, registry[[atm_wp_key]]),
    aggregate_travel_time_mode_residence = parse_acs_topic(attmr_raw, registry[[attm_res_key]]$parser, registry[[attm_res_key]]),
    aggregate_travel_time_mode_workplace = parse_acs_topic(attmw_raw, registry[[attm_wp_key]]$parser, registry[[attm_wp_key]]),
    aggregate_travel_time_total = parse_acs_topic(attt_raw, registry$aggregate_travel_time_total$parser, registry$aggregate_travel_time_total),
    aggregate_travel_time_county = parse_acs_topic(attc_raw, registry$aggregate_travel_time_county$parser, registry$aggregate_travel_time_county),
    aggregate_travel_time_by_travel_time = parse_acs_topic(atttt_raw, registry$aggregate_travel_time_travel_time$parser, registry$aggregate_travel_time_travel_time)
  )
  new_acs_lmi_bundle(components, "Travel time and departure time to work", year, survey)
}

#' Get tidy ACS place of work geography data
#'
#' Downloads detailed place of work tables covering state & county level (B08007), place level (B08008),
#' MCD level (B08009), Metro MSA level (B08016/C08016), Micro MSA level (B08017), Non-metro level (B08018),
#' and total workplace worker population (B08604).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing place of work location tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' pow <- get_acs_place_of_work(2024, "acs5", "state", state = "MA")
#' pow$place_of_work_county
#' pow$workplace_worker_pop
#' }
get_acs_place_of_work <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                  cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  msa_key <- paste0("place_of_work_msa_", survey)

  powc_raw <- load_acs_lmi_table(registry$place_of_work_county, year, survey, geography, cache_table, ...)
  powp_raw <- load_acs_lmi_table(registry$place_of_work_place, year, survey, geography, cache_table, ...)
  powm_raw <- load_acs_lmi_table(registry$place_of_work_mcd, year, survey, geography, cache_table, ...)
  powmsa_raw <- load_acs_lmi_table(registry[[msa_key]], year, survey, geography, cache_table, ...)
  powmicro_raw <- load_acs_lmi_table(registry$place_of_work_micro, year, survey, geography, cache_table, ...)
  pownon_raw <- load_acs_lmi_table(registry$place_of_work_nonmetro, year, survey, geography, cache_table, ...)
  wp_raw <- load_acs_lmi_table(registry$workplace_worker_pop, year, survey, geography, cache_table, ...)

  components <- list(
    place_of_work_county = parse_acs_topic(powc_raw, registry$place_of_work_county$parser, registry$place_of_work_county),
    place_of_work_place = parse_acs_topic(powp_raw, registry$place_of_work_place$parser, registry$place_of_work_place),
    place_of_work_mcd = parse_acs_topic(powm_raw, registry$place_of_work_mcd$parser, registry$place_of_work_mcd),
    place_of_work_msa = parse_acs_topic(powmsa_raw, registry[[msa_key]]$parser, registry[[msa_key]]),
    place_of_work_micro = parse_acs_topic(powmicro_raw, registry$place_of_work_micro$parser, registry$place_of_work_micro),
    place_of_work_nonmetro = parse_acs_topic(pownon_raw, registry$place_of_work_nonmetro$parser, registry$place_of_work_nonmetro),
    workplace_worker_pop = parse_acs_topic(wp_raw, registry$workplace_worker_pop$parser, registry$workplace_worker_pop)
  )
  new_acs_lmi_bundle(components, "Place of work geography", year, survey)
}

#' Get tidy ACS commuting characteristics data
#'
#' Downloads detailed transportation mode cross-tabulations by socio-economic characteristics for both residence and workplace geographies:
#' age (B08101/C08101, B08501/C08501), median age (B08103, B08503), earnings (B08119/C08119, B08519/C08519),
#' median earnings (B08121, B08521), poverty status (B08122/C08122, B08522/C08522), occupation (B08124/C08124, B08524/C08524),
#' industry (B08126/C08126, B08526/C08526), class of worker (B08128/C08128, B08528/C08528), vehicles available (B08141/C08141, B08541/C08541),
#' and racial iterations (B08105A-I, B08505A-I).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing mode cross-tabulation tibbles for residence and workplace geographies.
#' @export
#'
#' @examples
#' \dontrun{
#' comm_char <- get_acs_commuting_characteristics(2024, "acs5", "state", state = "MA")
#' comm_char$commuting_earnings_residence
#' comm_char$commuting_vehicles_residence
#' }
get_acs_commuting_characteristics <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                              cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  age_res_key <- paste0("commuting_age_residence_", survey)
  age_wp_key <- paste0("commuting_age_workplace_", survey)
  earn_res_key <- paste0("commuting_earnings_residence_", survey)
  earn_wp_key <- paste0("commuting_earnings_workplace_", survey)
  pov_res_key <- paste0("commuting_poverty_residence_", survey)
  pov_wp_key <- paste0("commuting_poverty_workplace_", survey)
  occ_res_key <- paste0("commuting_occupation_residence_", survey)
  occ_wp_key <- paste0("commuting_occupation_workplace_", survey)
  ind_res_key <- paste0("commuting_industry_residence_", survey)
  ind_wp_key <- paste0("commuting_industry_workplace_", survey)
  cls_res_key <- paste0("commuting_class_residence_", survey)
  cls_wp_key <- paste0("commuting_class_workplace_", survey)
  veh_res_key <- paste0("commuting_vehicles_residence_", survey)
  veh_wp_key <- paste0("commuting_vehicles_workplace_", survey)

  ager_raw <- load_acs_lmi_table(registry[[age_res_key]], year, survey, geography, cache_table, ...)
  agew_raw <- load_acs_lmi_table(registry[[age_wp_key]], year, survey, geography, cache_table, ...)
  mager_raw <- load_acs_lmi_table(registry$commuting_median_age_residence, year, survey, geography, cache_table, ...)
  magew_raw <- load_acs_lmi_table(registry$commuting_median_age_workplace, year, survey, geography, cache_table, ...)
  racer_raw <- load_acs_lmi_table(registry$commuting_race_residence, year, survey, geography, cache_table, ...)
  racew_raw <- load_acs_lmi_table(registry$commuting_race_workplace, year, survey, geography, cache_table, ...)
  earnr_raw <- load_acs_lmi_table(registry[[earn_res_key]], year, survey, geography, cache_table, ...)
  earnw_raw <- load_acs_lmi_table(registry[[earn_wp_key]], year, survey, geography, cache_table, ...)
  mearnr_raw <- load_acs_lmi_table(registry$commuting_median_earnings_residence, year, survey, geography, cache_table, ...)
  mearnw_raw <- load_acs_lmi_table(registry$commuting_median_earnings_workplace, year, survey, geography, cache_table, ...)
  povr_raw <- load_acs_lmi_table(registry[[pov_res_key]], year, survey, geography, cache_table, ...)
  povw_raw <- load_acs_lmi_table(registry[[pov_wp_key]], year, survey, geography, cache_table, ...)
  occr_raw <- load_acs_lmi_table(registry[[occ_res_key]], year, survey, geography, cache_table, ...)
  occw_raw <- load_acs_lmi_table(registry[[occ_wp_key]], year, survey, geography, cache_table, ...)
  indr_raw <- load_acs_lmi_table(registry[[ind_res_key]], year, survey, geography, cache_table, ...)
  indw_raw <- load_acs_lmi_table(registry[[ind_wp_key]], year, survey, geography, cache_table, ...)
  clsr_raw <- load_acs_lmi_table(registry[[cls_res_key]], year, survey, geography, cache_table, ...)
  clsw_raw <- load_acs_lmi_table(registry[[cls_wp_key]], year, survey, geography, cache_table, ...)
  vehr_raw <- load_acs_lmi_table(registry[[veh_res_key]], year, survey, geography, cache_table, ...)
  vehw_raw <- load_acs_lmi_table(registry[[veh_wp_key]], year, survey, geography, cache_table, ...)

  components <- list(
    commuting_age_residence = parse_acs_topic(ager_raw, registry[[age_res_key]]$parser, registry[[age_res_key]]),
    commuting_age_workplace = parse_acs_topic(agew_raw, registry[[age_wp_key]]$parser, registry[[age_wp_key]]),
    commuting_median_age_residence = parse_acs_topic(mager_raw, registry$commuting_median_age_residence$parser, registry$commuting_median_age_residence),
    commuting_median_age_workplace = parse_acs_topic(magew_raw, registry$commuting_median_age_workplace$parser, registry$commuting_median_age_workplace),
    commuting_race_residence = parse_acs_topic(racer_raw, registry$commuting_race_residence$parser, registry$commuting_race_residence),
    commuting_race_workplace = parse_acs_topic(racew_raw, registry$commuting_race_workplace$parser, registry$commuting_race_workplace),
    commuting_earnings_residence = parse_acs_topic(earnr_raw, registry[[earn_res_key]]$parser, registry[[earn_res_key]]),
    commuting_earnings_workplace = parse_acs_topic(earnw_raw, registry[[earn_wp_key]]$parser, registry[[earn_wp_key]]),
    commuting_median_earnings_residence = parse_acs_topic(mearnr_raw, registry$commuting_median_earnings_residence$parser, registry$commuting_median_earnings_residence),
    commuting_median_earnings_workplace = parse_acs_topic(mearnw_raw, registry$commuting_median_earnings_workplace$parser, registry$commuting_median_earnings_workplace),
    commuting_poverty_residence = parse_acs_topic(povr_raw, registry[[pov_res_key]]$parser, registry[[pov_res_key]]),
    commuting_poverty_workplace = parse_acs_topic(povw_raw, registry[[pov_wp_key]]$parser, registry[[pov_wp_key]]),
    commuting_occupation_residence = parse_acs_topic(occr_raw, registry[[occ_res_key]]$parser, registry[[occ_res_key]]),
    commuting_occupation_workplace = parse_acs_topic(occw_raw, registry[[occ_wp_key]]$parser, registry[[occ_wp_key]]),
    commuting_industry_residence = parse_acs_topic(indr_raw, registry[[ind_res_key]]$parser, registry[[ind_res_key]]),
    commuting_industry_workplace = parse_acs_topic(indw_raw, registry[[ind_wp_key]]$parser, registry[[ind_wp_key]]),
    commuting_class_residence = parse_acs_topic(clsr_raw, registry[[cls_res_key]]$parser, registry[[cls_res_key]]),
    commuting_class_workplace = parse_acs_topic(clsw_raw, registry[[cls_wp_key]]$parser, registry[[cls_wp_key]]),
    commuting_vehicles_residence = parse_acs_topic(vehr_raw, registry[[veh_res_key]]$parser, registry[[veh_res_key]]),
    commuting_vehicles_workplace = parse_acs_topic(vehw_raw, registry[[veh_wp_key]]$parser, registry[[veh_wp_key]])
  )
  new_acs_lmi_bundle(components, "Commuting characteristics by transportation mode", year, survey)
}

#' Get tidy ACS geographical mobility data by current residence
#'
#' Downloads detailed migration and geographical mobility tables for population in current residence
#' covering age (B07001/C07001), median age (B07002), sex (B07003), race (B07004A-I), citizenship (B07007),
#' marital status (B07008/C07008), education (B07009), income (B07010), median income (B07011), poverty (B07012),
#' tenure (B07013), region-to-region movers (B07101), Metro MSA (B07201/C07201), Micro MSA (B07202), Non-metro (B07203),
#' and State/County/Place level (B07204/C07204).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing current residence geographical mobility tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' mig_curr <- get_acs_migration_current(2024, "acs5", "state", state = "MA")
#' mig_curr$migration_age
#' mig_curr$migration_income
#' }
get_acs_migration_current <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                       cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  age_key <- paste0("migration_current_age_", survey)
  mar_key <- paste0("migration_current_marital_", survey)
  msa_key <- paste0("migration_current_msa_", survey)
  place_key <- paste0("migration_current_place_", survey)

  a_raw <- load_acs_lmi_table(registry[[age_key]], year, survey, geography, cache_table, ...)
  ma_raw <- load_acs_lmi_table(registry$migration_current_median_age, year, survey, geography, cache_table, ...)
  s_raw <- load_acs_lmi_table(registry$migration_current_sex, year, survey, geography, cache_table, ...)
  r_raw <- load_acs_lmi_table(registry$migration_current_race, year, survey, geography, cache_table, ...)
  c_raw <- load_acs_lmi_table(registry$migration_current_citizenship, year, survey, geography, cache_table, ...)
  m_raw <- load_acs_lmi_table(registry[[mar_key]], year, survey, geography, cache_table, ...)
  e_raw <- load_acs_lmi_table(registry$migration_current_education, year, survey, geography, cache_table, ...)
  i_raw <- load_acs_lmi_table(registry$migration_current_income, year, survey, geography, cache_table, ...)
  mi_raw <- load_acs_lmi_table(registry$migration_current_median_income, year, survey, geography, cache_table, ...)
  p_raw <- load_acs_lmi_table(registry$migration_current_poverty, year, survey, geography, cache_table, ...)
  t_raw <- load_acs_lmi_table(registry$migration_current_tenure, year, survey, geography, cache_table, ...)
  reg_raw <- load_acs_lmi_table(registry$migration_current_region, year, survey, geography, cache_table, ...)
  msa_raw <- load_acs_lmi_table(registry[[msa_key]], year, survey, geography, cache_table, ...)
  micro_raw <- load_acs_lmi_table(registry$migration_current_micro, year, survey, geography, cache_table, ...)
  non_raw <- load_acs_lmi_table(registry$migration_current_nonmetro, year, survey, geography, cache_table, ...)
  place_raw <- load_acs_lmi_table(registry[[place_key]], year, survey, geography, cache_table, ...)

  components <- list(
    migration_age = parse_acs_topic(a_raw, registry[[age_key]]$parser, registry[[age_key]]),
    migration_median_age = parse_acs_topic(ma_raw, registry$migration_current_median_age$parser, registry$migration_current_median_age),
    migration_sex = parse_acs_topic(s_raw, registry$migration_current_sex$parser, registry$migration_current_sex),
    migration_race = parse_acs_topic(r_raw, registry$migration_current_race$parser, registry$migration_current_race),
    migration_citizenship = parse_acs_topic(c_raw, registry$migration_current_citizenship$parser, registry$migration_current_citizenship),
    migration_marital = parse_acs_topic(m_raw, registry[[mar_key]]$parser, registry[[mar_key]]),
    migration_education = parse_acs_topic(e_raw, registry$migration_current_education$parser, registry$migration_current_education),
    migration_income = parse_acs_topic(i_raw, registry$migration_current_income$parser, registry$migration_current_income),
    migration_median_income = parse_acs_topic(mi_raw, registry$migration_current_median_income$parser, registry$migration_current_median_income),
    migration_poverty = parse_acs_topic(p_raw, registry$migration_current_poverty$parser, registry$migration_current_poverty),
    migration_tenure = parse_acs_topic(t_raw, registry$migration_current_tenure$parser, registry$migration_current_tenure),
    migration_region = parse_acs_topic(reg_raw, registry$migration_current_region$parser, registry$migration_current_region),
    migration_msa = parse_acs_topic(msa_raw, registry[[msa_key]]$parser, registry[[msa_key]]),
    migration_micro = parse_acs_topic(micro_raw, registry$migration_current_micro$parser, registry$migration_current_micro),
    migration_nonmetro = parse_acs_topic(non_raw, registry$migration_current_nonmetro$parser, registry$migration_current_nonmetro),
    migration_place = parse_acs_topic(place_raw, registry[[place_key]]$parser, registry[[place_key]])
  )
  new_acs_lmi_bundle(components, "Geographical mobility by current residence", year, survey)
}

#' Get tidy ACS geographical mobility data by residence 1 year ago
#'
#' Downloads detailed migration and geographical mobility tables for population by residence 1 year ago
#' covering age (B07401/C07401), median age (B07402), sex (B07403), race (B07404A-I), citizenship (B07407),
#' marital status (B07408), education (B07409), income (B07410), median income (B07411), poverty (B07412),
#' and tenure (B07413).
#'
#' @inheritParams get_acs_employment
#' @return An `acs_lmi_bundle` containing residence 1 year ago geographical mobility tibbles.
#' @export
#'
#' @examples
#' \dontrun{
#' mig_prior <- get_acs_migration_prior(2024, "acs5", "state", state = "MA")
#' mig_prior$migration_age
#' mig_prior$migration_income
#' }
get_acs_migration_prior <- function(year, survey = c("acs5", "acs1"), geography, ...,
                                     cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()

  age_key <- paste0("migration_prior_age_", survey)

  a_raw <- load_acs_lmi_table(registry[[age_key]], year, survey, geography, cache_table, ...)
  ma_raw <- load_acs_lmi_table(registry$migration_prior_median_age, year, survey, geography, cache_table, ...)
  s_raw <- load_acs_lmi_table(registry$migration_prior_sex, year, survey, geography, cache_table, ...)
  r_raw <- load_acs_lmi_table(registry$migration_prior_race, year, survey, geography, cache_table, ...)
  c_raw <- load_acs_lmi_table(registry$migration_prior_citizenship, year, survey, geography, cache_table, ...)
  m_raw <- load_acs_lmi_table(registry$migration_prior_marital, year, survey, geography, cache_table, ...)
  e_raw <- load_acs_lmi_table(registry$migration_prior_education, year, survey, geography, cache_table, ...)
  i_raw <- load_acs_lmi_table(registry$migration_prior_income, year, survey, geography, cache_table, ...)
  mi_raw <- load_acs_lmi_table(registry$migration_prior_median_income, year, survey, geography, cache_table, ...)
  p_raw <- load_acs_lmi_table(registry$migration_prior_poverty, year, survey, geography, cache_table, ...)
  t_raw <- load_acs_lmi_table(registry$migration_prior_tenure, year, survey, geography, cache_table, ...)

  components <- list(
    migration_age = parse_acs_topic(a_raw, registry[[age_key]]$parser, registry[[age_key]]),
    migration_median_age = parse_acs_topic(ma_raw, registry$migration_prior_median_age$parser, registry$migration_prior_median_age),
    migration_sex = parse_acs_topic(s_raw, registry$migration_prior_sex$parser, registry$migration_prior_sex),
    migration_race = parse_acs_topic(r_raw, registry$migration_prior_race$parser, registry$migration_prior_race),
    migration_citizenship = parse_acs_topic(c_raw, registry$migration_prior_citizenship$parser, registry$migration_prior_citizenship),
    migration_marital = parse_acs_topic(m_raw, registry$migration_prior_marital$parser, registry$migration_prior_marital),
    migration_education = parse_acs_topic(e_raw, registry$migration_prior_education$parser, registry$migration_prior_education),
    migration_income = parse_acs_topic(i_raw, registry$migration_prior_income$parser, registry$migration_prior_income),
    migration_median_income = parse_acs_topic(mi_raw, registry$migration_prior_median_income$parser, registry$migration_prior_median_income),
    migration_poverty = parse_acs_topic(p_raw, registry$migration_prior_poverty$parser, registry$migration_prior_poverty),
    migration_tenure = parse_acs_topic(t_raw, registry$migration_prior_tenure$parser, registry$migration_prior_tenure)
  )
  new_acs_lmi_bundle(components, "Geographical mobility by residence 1 year ago", year, survey)
}
