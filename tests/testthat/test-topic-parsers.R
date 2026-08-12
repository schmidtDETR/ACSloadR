test_that("age tables remain separate and use their own age structures", {
  registry <- ACSloadR:::acs_table_registry()
  total <- ACSloadR:::parse_age_data(
    fixture_rows("B01001"), registry$age_total_population
  )
  race <- ACSloadR:::parse_age_data(
    fixture_rows("B01001A"), registry$age_race_ethnicity
  )

  expect_true(all(total$table == "B01001"))
  expect_true(all(race$table == "B01001A"))
  expect_true(all(is.na(total$race_ethnicity)))
  expect_true(all(race$race_ethnicity == "White alone"))
  expect_equal(unique(total$age_group[total$variable == "B01001_003"]), "Under 5 years")
  expect_equal(sort(unique(total$value_source)), c("derived", "published"))
})

test_that("employment parser identifies measures and demographic sections", {
  config <- ACSloadR:::acs_table_registry()$employment
  parsed <- ACSloadR:::parse_employment_data(fixture_rows("S2301"), config)

  age_rate <- parsed[parsed$variable == "S2301_C02_002", ]
  expect_equal(age_rate$measure, "labor_force_participation_rate")
  expect_equal(age_rate$unit, "percent")
  expect_equal(age_rate$characteristic_type, "age")
  expect_equal(age_rate$characteristic, "16 to 19 years")

  education <- parsed[parsed$variable == "S2301_C01_032", ]
  expect_equal(education$universe, "Population 25 to 64 years")
  expect_equal(education$characteristic_type, "educational_attainment")
  expect_equal(education$characteristic, "High school graduate (includes equivalency)")

  parent <- parsed[parsed$variable == "S2301_C01_025", ]
  expect_equal(parent$characteristic, "Female")
  expect_equal(parent$detail, "With own children under 6 years only")
})

test_that("occupation parser retains hierarchy and published sex shares", {
  config <- ACSloadR:::acs_table_registry()$occupation
  parsed <- ACSloadR:::parse_occupation_data(fixture_rows("S2401"), config)

  published_percent <- parsed[
    parsed$variable == "S2401_C03_002" & parsed$value_source == "published",
  ]
  expect_equal(published_percent$sex, "Male")
  expect_equal(published_percent$measure, "sex_share")
  expect_equal(published_percent$unit, "percent")

  derived_total <- parsed[
    parsed$variable == "S2401_C01_002" & parsed$value_source == "derived",
  ]
  expect_equal(derived_total$estimate, 40)
  expect_equal(derived_total$denominator_variable, "S2401_C01_001")
})

test_that("earnings and commuting parsers expose domain-specific columns", {
  registry <- ACSloadR:::acs_table_registry()
  earnings <- ACSloadR:::parse_earnings_data(fixture_rows("B20004"), registry$earnings)
  commuting <- ACSloadR:::parse_commuting_data(fixture_rows("B08301"), registry$commuting)

  male <- earnings[earnings$variable == "B20004_008", ]
  expect_equal(male$sex, "Male")
  expect_equal(male$educational_attainment, "Less than high school graduate")
  expect_equal(male$unit, "dollars")

  drove <- commuting[
    commuting$variable == "B08301_003" & commuting$value_source == "published",
  ]
  expect_equal(drove$transportation_mode, "Drove alone")
  expect_equal(drove$mode_major, "Car, truck, or van")
})

test_that("derived share MOEs follow the ACS proportion formula", {
  config <- ACSloadR:::acs_table_registry()$commuting
  parsed <- ACSloadR:::parse_commuting_data(fixture_rows("B08301"), config)
  share <- parsed[
    parsed$variable == "B08301_002" & parsed$value_source == "derived",
  ]

  expect_equal(share$estimate, 40)
  expect_equal(share$moe, 100 * sqrt(30^2 - (0.4^2 * 50^2)) / 1000)
  expect_equal(share$denominator_variable, "B08301_001")
})

test_that("zero denominators produce missing shares", {
  rows <- fixture_rows("B08301")
  rows$estimate[rows$variable == "B08301_001"] <- 0
  parsed <- ACSloadR:::parse_commuting_data(
    rows, ACSloadR:::acs_table_registry()$commuting
  )
  derived <- parsed[parsed$value_source == "derived", ]
  expect_true(all(is.na(derived$estimate)))
  expect_true(all(is.na(derived$moe)))
})

test_that("geometry-like columns are retained at the end", {
  rows <- fixture_rows("B20004")
  rows$geometry <- "POINT (0 0)"
  parsed <- ACSloadR:::parse_earnings_data(
    rows, ACSloadR:::acs_table_registry()$earnings
  )
  expect_equal(tail(names(parsed), 1), "geometry")
})
