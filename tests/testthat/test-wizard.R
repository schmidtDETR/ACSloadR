test_that("topic catalog is well-formed and all getters exist in package", {
  catalog <- ACSloadR:::acs_topic_catalog()
  expect_type(catalog, "list")
  expect_true(length(catalog) >= 20)

  for (topic_id in names(catalog)) {
    topic <- catalog[[topic_id]]
    expect_true(nzchar(topic$title))
    expect_true(length(topic$category) >= 1)
    expect_true(all(nzchar(topic$category)))
    expect_true(nzchar(topic$getter))
    expect_true(length(topic$tables) >= 1)
    expect_true(length(topic$components) >= 1)

    # Verify that the getter function is exported by ACSloadR
    expect_true(
      exists(topic$getter, where = asNamespace("ACSloadR"), mode = "function"),
      info = paste("Getter function", topic$getter, "must exist in ACSloadR")
    )
  }
})

test_that("class_of_worker is properly indexed and produces valid code", {
  catalog <- ACSloadR:::acs_topic_catalog()
  expect_true("class_of_worker" %in% names(catalog))
  cow <- catalog$class_of_worker
  expect_equal(cow$getter, "get_acs_class_of_worker")
  expect_true("Industry, Occupation & Class of Worker" %in% cow$category)
  expect_true("Labor Force & Employment" %in% cow$category)

  script <- generate_acs_script(
    topic = "class_of_worker",
    year = 2024,
    survey = "acs5",
    geography = "county",
    state = "MA"
  )
  expect_match(script, "get_acs_class_of_worker")
  expect_match(script, "class_of_worker <- cow\\$class_of_worker")
  parsed <- parse(text = script)
  expect_true(length(parsed) > 0)
})

test_that("geography helper dictionaries are defined and populated", {
  common_geos <- ACSloadR:::common_acs_geographies()
  all_geos <- ACSloadR:::all_acs_geographies()

  expect_type(common_geos, "character")
  expect_type(all_geos, "character")
  expect_true(length(common_geos) >= 8)
  expect_true(length(all_geos) >= 25)
  expect_true("state" %in% names(common_geos))
  expect_true("county" %in% names(common_geos))
  expect_true("school district (unified)" %in% names(all_geos))
  expect_true("congressional district" %in% names(all_geos))
})

test_that("generate_acs_script produces parseable R code with correct parameters", {
  script <- generate_acs_script(
    topic = "employment_detail",
    year = 2024,
    survey = "acs5",
    geography = "county",
    state = "MA"
  )

  expect_type(script, "character")
  expect_match(script, "library\\(ACSloadR\\)")
  expect_match(script, "get_acs_employment_detail")
  expect_match(script, 'year = 2024')
  expect_match(script, 'survey = "acs5"')
  expect_match(script, 'geography = "county"')
  expect_match(script, 'state = "MA"')
  expect_match(script, "status <- emp_detail\\$status")
  expect_match(script, "age_sex <- emp_detail\\$age_sex")

  # Code should be syntactically valid R code
  parsed_expr <- parse(text = script)
  expect_true(length(parsed_expr) > 0)
})

test_that("generate_acs_script handles custom var_name and county filter", {
  script <- generate_acs_script(
    topic = "age",
    year = 2023,
    survey = "acs1",
    geography = "tract",
    state = "NV",
    county = "Clark",
    var_name = "my_custom_age"
  )

  expect_match(script, 'my_custom_age <- get_acs_age')
  expect_match(script, 'county = "Clark"')
  expect_match(script, 'total_population <- my_custom_age\\$total_population')

  parsed_expr <- parse(text = script)
  expect_true(length(parsed_expr) > 0)
})

test_that("generate_acs_script raises error for unknown topic", {
  expect_error(generate_acs_script(topic = "non_existent_topic"), "Unknown topic")
})

test_that("create_acs_script / acs_wizard writes file non-interactively when options given", {
  tmp_dir <- tempfile("wizard_test_")
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

  out_path <- create_acs_script(
    topic = "earnings",
    year = 2024,
    survey = "acs5",
    geography = "state",
    state = "MA",
    output_dir = tmp_dir,
    filename = "test_earnings.R"
  )

  expect_true(file.exists(out_path))
  content <- readLines(out_path)
  expect_true(any(grepl("get_acs_earnings", content)))
})
