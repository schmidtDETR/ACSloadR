test_that("load_acs_lmi_table issues warning and returns empty structure for missing tables", {
  # Mock load_variables to return an empty metadata frame
  testthat::with_mocked_bindings(
    load_variables = function(...) {
      data.frame(
        name = character(),
        label = character(),
        concept = character(),
        stringsAsFactors = FALSE
      )
    },
    code = {
      config <- list(tables = "C24080", dataset_type = "detailed")
      expect_warning(
        res <- ACSloadR:::load_acs_lmi_table(
          config = config,
          year = 2024,
          survey = "acs5",
          geography = "state"
        ),
        regexp = "ACS table\\(s\\) unavailable for 2024 acs5: C24080"
      )
      expect_s3_class(res, "tbl_df")
      expect_equal(nrow(res), 0)
    },
    .package = "tidycensus"
  )
})

test_that("parse_acs_topic returns empty tibble for NULL or empty raw data", {
  config <- list(parser = "employment")
  empty_raw <- tibble::tibble()
  res <- ACSloadR:::parse_acs_topic(empty_raw, parser = "employment", config = config)
  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 0)
})

test_that("print.acs_lmi_bundle displays warning badge for empty components", {
  empty_comp <- tibble::tibble()
  full_comp <- tibble::tibble(
    table = "B24081",
    universe = "Civilian population",
    value = 100
  )
  bundle <- ACSloadR:::new_acs_lmi_bundle(
    list(missing_part = empty_comp, valid_part = full_comp),
    topic = "Test Topic",
    year = 2024,
    survey = "acs5"
  )

  output <- capture.output(print(bundle))
  expect_true(any(grepl("missing_part: \\[WARNING: 0 rows - table unavailable\\]", output)))
  expect_true(any(grepl("valid_part: 1 rows", output)))
})

test_that("wizard topic catalog includes detailed and collapsed components", {
  cat <- acs_topic_catalog()
  expect_true("class_of_worker" %in% names(cat))
  expect_true("class_of_worker_collapsed" %in% cat$class_of_worker$components)
  expect_true("industry_collapsed" %in% cat$industry$components)
})
