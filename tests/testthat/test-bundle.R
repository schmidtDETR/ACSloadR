test_that("bundles retain named data frames and reject implicit flattening", {
  bundle <- ACSloadR:::new_acs_lmi_bundle(
    list(total_population = fixture_rows("B01001")),
    topic = "Age and sex",
    year = 2024,
    survey = "acs5"
  )

  expect_s3_class(bundle, "acs_lmi_bundle")
  expect_s3_class(bundle$total_population, "data.frame")
  expect_output(print(bundle), "\\$total_population")
  expect_error(as.data.frame(bundle), "Extract a named component")
})

test_that("multi-component industry and employment detail bundles print appropriately", {
  ind_bundle <- ACSloadR:::new_acs_lmi_bundle(
    list(
      industry = fixture_rows("C24030"),
      earnings = fixture_rows("C24031")
    ),
    topic = "Industry",
    year = 2024,
    survey = "acs5"
  )
  expect_s3_class(ind_bundle, "acs_lmi_bundle")
  expect_named(ind_bundle, c("industry", "earnings"))
  expect_output(print(ind_bundle), "<acs_lmi_bundle> Industry")
  expect_output(print(ind_bundle), "\\$industry")
  expect_output(print(ind_bundle), "\\$earnings")
})

test_that("income bundles print component list correctly", {
  inc_bundle <- ACSloadR:::new_acs_lmi_bundle(
    list(
      income_brackets = fixture_rows("B19001"),
      median_income = fixture_rows("B19013")
    ),
    topic = "Household income",
    year = 2024,
    survey = "acs5"
  )
  expect_s3_class(inc_bundle, "acs_lmi_bundle")
  expect_named(inc_bundle, c("income_brackets", "median_income"))
  expect_output(print(inc_bundle), "<acs_lmi_bundle> Household income")
})

test_that("education bundles print component list correctly", {
  edu_bundle <- ACSloadR:::new_acs_lmi_bundle(
    list(
      enrollment_level = fixture_rows("B14001"),
      attainment_sex = fixture_rows("B15002")
    ),
    topic = "Education",
    year = 2024,
    survey = "acs5"
  )
  expect_s3_class(edu_bundle, "acs_lmi_bundle")
  expect_named(edu_bundle, c("enrollment_level", "attainment_sex"))
  expect_output(print(edu_bundle), "<acs_lmi_bundle> Education")
})

test_that("commute bundles print component list correctly", {
  comm_bundle <- ACSloadR:::new_acs_lmi_bundle(
    list(
      travel_time_residence = fixture_rows("B08303"),
      place_of_work_county = fixture_rows("B08007")
    ),
    topic = "Commute",
    year = 2024,
    survey = "acs5"
  )
  expect_s3_class(comm_bundle, "acs_lmi_bundle")
  expect_named(comm_bundle, c("travel_time_residence", "place_of_work_county"))
  expect_output(print(comm_bundle), "<acs_lmi_bundle> Commute")
})

test_that("migration bundles print component list correctly", {
  mig_bundle <- ACSloadR:::new_acs_lmi_bundle(
    list(
      migration_age = fixture_rows("B07001"),
      migration_income = fixture_rows("B07010")
    ),
    topic = "Geographical mobility",
    year = 2024,
    survey = "acs5"
  )
  expect_s3_class(mig_bundle, "acs_lmi_bundle")
  expect_named(mig_bundle, c("migration_age", "migration_income"))
  expect_output(print(mig_bundle), "<acs_lmi_bundle> Geographical mobility")
})
