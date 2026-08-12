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
