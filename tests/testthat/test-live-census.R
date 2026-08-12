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
