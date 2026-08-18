test_that("optional live Census checks support both surveys", {
  skip_if(Sys.getenv("ACSLOADR_RUN_LIVE_TESTS") != "true")

  for (survey in c("acs1", "acs5")) {
    result <- get_acs_commuting(
      2024, survey, "state", state = "MA", cache_table = FALSE
    )
    expect_s3_class(result, "acs_lmi_bundle")
    expect_true(nrow(result$commuting) > 0)
    expect_true(all(result$commuting$table == "B08301"))
  }
})

test_that("optional live occupation checks return survey-specific race tables", {
  skip_if(Sys.getenv("ACSLOADR_RUN_LIVE_TESTS") != "true")

  expected_prefix <- c(acs1 = "B24010", acs5 = "C24010")
  for (survey in names(expected_prefix)) {
    result <- get_acs_occupation(
      2024, survey, "state", state = "MA", cache_table = FALSE
    )
    expect_named(result, c("occupation", "race_ethnicity"))
    expect_true(all(result$occupation$table == "S2401"))
    expect_true(all(stringr::str_starts(
      result$race_ethnicity$table, expected_prefix[[survey]]
    )))
    derived_totals <- result$race_ethnicity[
      result$race_ethnicity$sex == "Total" &
        result$race_ethnicity$occupation != "All occupations" &
        result$race_ethnicity$measure == "employment",
    ]
    expect_true(nrow(derived_totals) > 0)
    expect_true(all(derived_totals$value_source == "derived"))
    expect_true(all(stringr::str_detect(derived_totals$source_variables, ";")))
  }
})

test_that("optional live checks for new topic getters return valid bundles", {
  skip_if(Sys.getenv("ACSLOADR_RUN_LIVE_TESTS") != "true")

  detail <- get_acs_employment_detail(2024, "acs5", "state", state = "MA", cache_table = FALSE)
  expect_s3_class(detail, "acs_lmi_bundle")
  expect_named(detail, c("status", "age_sex", "race_ethnicity", "education", "poverty_disability"))

  work <- get_acs_work_experience(2024, "acs5", "state", state = "MA", cache_table = FALSE)
  expect_s3_class(work, "acs_lmi_bundle")
  expect_named(work, c("hours_weeks", "full_time_by_age", "hours_summary"))

  family <- get_acs_family_employment(2024, "acs5", "state", state = "MA", cache_table = FALSE)
  expect_s3_class(family, "acs_lmi_bundle")
  expect_named(family, c("children_parent_status", "females_with_children", "family_type_status", "family_workers"))

  ind <- get_acs_industry(2024, "acs5", "state", state = "MA", cache_table = FALSE)
  expect_s3_class(ind, "acs_lmi_bundle")
  expect_named(ind, c("industry", "industry_full_time", "earnings", "earnings_full_time", "industry_by_occupation", "industry_by_class"))

  cow <- get_acs_class_of_worker(2024, "acs5", "state", state = "MA", cache_table = FALSE)
  expect_s3_class(cow, "acs_lmi_bundle")
  expect_named(cow, c("class_of_worker", "class_of_worker_full_time", "earnings", "earnings_full_time", "class_by_occupation"))

  occ_det <- get_acs_occupation_detailed(2024, "acs5", "state", state = "MA", cache_table = FALSE)
  expect_s3_class(occ_det, "acs_lmi_bundle")
  expect_named(occ_det, c("occupation", "occupation_full_time", "earnings", "earnings_full_time"))
})
