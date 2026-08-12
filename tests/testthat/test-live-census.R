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
