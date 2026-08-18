test_that("age tables remain separate and use their own age structures", {
  registry <- ACSloadR:::acs_table_registry()
  total <- ACSloadR:::parse_generic_table(
    fixture_rows("B01001"), registry$age_total_population
  )
  race <- ACSloadR:::parse_generic_table(
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

test_that("detailed employment status parser handles B23025 counts and shares", {
  config <- ACSloadR:::acs_table_registry()$employment_detail_status
  parsed <- ACSloadR:::parse_detailed_employment_status_data(fixture_rows("B23025"), config)

  employed <- parsed[parsed$variable == "B23025_004" & parsed$value_source == "published", ]
  expect_equal(employed$labor_force_status, "In labor force")
  expect_equal(employed$civilian_status, "Civilian labor force")
  expect_equal(employed$employment_status, "Employed")
  expect_equal(employed$estimate, 650)

  derived_share <- parsed[parsed$variable == "B23025_004" & parsed$value_source == "derived", ]
  expect_equal(derived_share$estimate, 65)
  expect_equal(derived_share$unit, "percent")
  expect_equal(derived_share$denominator_variable, "B23025_001")
})

test_that("detailed employment age, sex, race, education, and poverty parsers work", {
  reg <- ACSloadR:::acs_table_registry()

  age_sex <- ACSloadR:::parse_detailed_employment_age_sex_data(
    fixture_rows("B23001"), reg$employment_detail_age_sex_acs5
  )
  employed_teen <- age_sex[age_sex$variable == "B23001_006" & age_sex$value_source == "published", ]
  expect_equal(employed_teen$sex, "Male")
  expect_equal(employed_teen$age_group, "16 to 19 years")
  expect_equal(employed_teen$employment_status, "Employed")

  race <- ACSloadR:::parse_detailed_employment_race_data(
    fixture_rows("C23002A"), reg$employment_detail_race_acs5
  )
  expect_equal(unique(race$race_ethnicity), "White alone")
  race_emp <- race[race$variable == "C23002A_006" & race$value_source == "published", ]
  expect_equal(race_emp$sex, "Male")
  expect_equal(race_emp$age_group, "16 to 64 years")
  expect_equal(race_emp$employment_status, "Employed")

  edu <- ACSloadR:::parse_detailed_employment_education_data(
    fixture_rows("B23006"), reg$employment_detail_education
  )
  edu_row <- edu[edu$variable == "B23006_004" & edu$value_source == "published", ]
  expect_equal(edu_row$educational_attainment, "Less than high school graduate")
  expect_equal(edu_row$employment_status, "Employed")

  pov <- ACSloadR:::parse_detailed_employment_poverty_disability_data(
    fixture_rows("B23024"), reg$employment_detail_poverty_disability
  )
  pov_row <- pov[pov$variable == "B23024_005" & pov$value_source == "published", ]
  expect_equal(pov_row$poverty_status, "Income in the past 12 months below poverty level")
  expect_equal(pov_row$disability_status, "With a disability")
  expect_equal(pov_row$employment_status, "Employed")

  seniors <- ACSloadR:::parse_detailed_employment_seniors_data(
    fixture_rows("C23004"), reg$employment_detail_seniors
  )
  sen_row <- seniors[seniors$variable == "C23004_004" & seniors$value_source == "published", ]
  expect_equal(sen_row$work_status_past_year, "Worked in the past 12 months")
  expect_equal(sen_row$employment_status, "Employed")
})

test_that("work experience and hours parsers work", {
  reg <- ACSloadR:::acs_table_registry()

  hours <- ACSloadR:::parse_work_experience_hours_weeks_data(
    fixture_rows("B23022"), reg$work_experience_hours_weeks_acs5
  )
  h_row <- hours[hours$variable == "B23022_005" & hours$value_source == "published", ]
  expect_equal(h_row$sex, "Male")
  expect_equal(h_row$work_status, "Worked in the past 12 months")
  expect_equal(h_row$hours_per_week, "Usually worked 35 or more hours per week")
  expect_equal(h_row$weeks_worked, "50 to 52 weeks")

  ft <- ACSloadR:::parse_work_experience_full_time_data(
    fixture_rows("B23027"), reg$work_experience_full_time
  )
  ft_row <- ft[ft$variable == "B23027_003" & ft$value_source == "published", ]
  expect_equal(ft_row$age_group, "16 to 64 years")
  expect_equal(ft_row$work_status, "Worked full-time, year-round in the past 12 months")

  summ <- ACSloadR:::parse_work_experience_summary_data(
    rbind(fixture_rows("B23018"), fixture_rows("B23020"), fixture_rows("B23013")),
    reg$work_experience_hours_summary
  )
  expect_equal(summ$unit[summ$table == "B23018"], "hours")
  expect_equal(summ$measure[summ$table == "B23020"], "mean_usual_hours")
  expect_equal(summ$unit[summ$table == "B23013"], "years")
})

test_that("family employment parsers work", {
  reg <- ACSloadR:::acs_table_registry()

  children <- ACSloadR:::parse_family_employment_children_data(
    fixture_rows("B23008"), reg$family_employment_children_acs5
  )
  c_row <- children[children$variable == "B23008_004" & children$value_source == "published", ]
  expect_equal(c_row$child_age_group, "Under 6 years")
  expect_equal(c_row$living_arrangement, "Living with two parents")
  expect_equal(c_row$parental_employment_status, "Both parents in labor force")

  females <- ACSloadR:::parse_family_employment_females_data(
    fixture_rows("B23003"), reg$family_employment_females
  )
  f_row <- females[females$variable == "B23003_005" & females$value_source == "published", ]
  expect_equal(f_row$sex, "Female")
  expect_equal(f_row$children_age_group, "With own children under 6 years only")
  expect_equal(f_row$employment_status, "Employed")

  types <- ACSloadR:::parse_family_employment_types_data(
    fixture_rows("B23007"), reg$family_employment_types_acs5
  )
  t_row <- types[types$variable == "B23007_005" & types$value_source == "published", ]
  expect_equal(t_row$family_type, "In married-couple families")
  expect_equal(t_row$children_age_group, "With own children under 6 years only")
  expect_equal(t_row$parent_labor_force_status, "One or more parents in labor force")

  workers <- ACSloadR:::parse_family_employment_workers_data(
    fixture_rows("B23009"), reg$family_employment_workers
  )
  w_row <- workers[workers$variable == "B23009_005" & workers$value_source == "published", ]
  expect_equal(w_row$family_type, "In married-couple families")
  expect_equal(w_row$children_presence, "With own children under 18 years")
  expect_equal(w_row$workers_in_family, "1 worker")
})

test_that("industry parsers handle counts, earnings, and cross-tabulations", {
  reg <- ACSloadR:::acs_table_registry()

  ind_counts <- ACSloadR:::parse_industry_counts_data(
    fixture_rows("C24030"), reg$industry_acs5
  )
  ind_row <- ind_counts[ind_counts$variable == "C24030_003" & ind_counts$value_source == "published", ]
  expect_equal(ind_row$sex, "Male")
  expect_equal(ind_row$industry, "Agriculture, forestry, fishing and hunting, and mining")
  expect_equal(ind_row$work_status, "all")

  ind_totals <- ind_counts[
    ind_counts$sex == "Total" &
      ind_counts$industry == "Agriculture, forestry, fishing and hunting, and mining" &
      ind_counts$measure == "employment",
  ]
  expect_equal(ind_totals$estimate, 20)
  expect_equal(ind_totals$value_source, "derived")

  ind_earn <- ACSloadR:::parse_industry_earnings_data(
    fixture_rows("C24031"), reg$industry_earnings_acs5
  )
  e_row <- ind_earn[ind_earn$variable == "C24031_002", ]
  expect_equal(e_row$measure, "median_earnings")
  expect_equal(e_row$unit, "dollars")
  expect_equal(e_row$estimate, 45000)

  ind_occ <- ACSloadR:::parse_industry_by_occupation_data(
    fixture_rows("C24050"), reg$industry_by_occupation_acs5
  )
  io_row <- ind_occ[ind_occ$variable == "C24050_002" & ind_occ$value_source == "published", ]
  expect_equal(io_row$industry, "Agriculture, forestry, fishing and hunting, and mining")
  expect_equal(io_row$occupation, "Management, business, science, and arts occupations")

  ind_class <- ACSloadR:::parse_industry_by_class_data(
    fixture_rows("C24070"), reg$industry_by_class_acs5
  )
  ic_row <- ind_class[ind_class$variable == "C24070_002" & ind_class$value_source == "published", ]
  expect_equal(ic_row$industry, "Agriculture, forestry, fishing and hunting, and mining")
  expect_equal(ic_row$class_of_worker, "Private for-profit wage and salary workers")
})

test_that("class of worker parsers handle counts, earnings, and cross-tabulations", {
  reg <- ACSloadR:::acs_table_registry()

  cow_counts <- ACSloadR:::parse_class_of_worker_counts_data(
    fixture_rows("C24080"), reg$class_of_worker_acs5
  )
  cow_row <- cow_counts[cow_counts$variable == "C24080_003" & cow_counts$value_source == "published", ]
  expect_equal(cow_row$sex, "Male")
  expect_equal(cow_row$class_of_worker_major, "Private for-profit wage and salary workers")
  expect_equal(cow_row$class_of_worker, "Employee of private company workers")

  cow_totals <- cow_counts[
    cow_counts$sex == "Total" &
      cow_counts$class_of_worker == "Employee of private company workers" &
      cow_counts$measure == "employment",
  ]
  expect_equal(cow_totals$estimate, 680)
  expect_equal(cow_totals$value_source, "derived")

  cow_earn <- ACSloadR:::parse_class_earnings_data(
    fixture_rows("C24081"), reg$class_of_worker_earnings_acs5
  )
  ce_row <- cow_earn[cow_earn$variable == "C24081_002", ]
  expect_equal(ce_row$class_of_worker, "Private for-profit wage and salary workers")
  expect_equal(ce_row$estimate, 55000)

  class_occ <- ACSloadR:::parse_class_by_occupation_data(
    fixture_rows("C24060"), reg$class_by_occupation_acs5
  )
  co_row <- class_occ[class_occ$variable == "C24060_002" & class_occ$value_source == "published", ]
  expect_equal(co_row$occupation, "Management, business, science, and arts occupations")
  expect_equal(co_row$class_of_worker, "Private for-profit wage and salary workers")
})

test_that("detailed occupation base and earnings parsers work", {
  reg <- ACSloadR:::acs_table_registry()

  occ_counts <- ACSloadR:::parse_occupation_detailed_counts_data(
    fixture_rows("C24010"), reg$occupation_detailed_total_acs5
  )
  oc_row <- occ_counts[occ_counts$variable == "C24010_003" & occ_counts$value_source == "published", ]
  expect_equal(oc_row$sex, "Male")
  expect_equal(oc_row$occupation, "Management, business, science, and arts occupations")

  occ_totals <- occ_counts[
    occ_counts$sex == "Total" &
      occ_counts$occupation == "Management, business, science, and arts occupations" &
      occ_counts$measure == "employment",
  ]
  expect_equal(occ_totals$estimate, 400)
  expect_equal(occ_totals$value_source, "derived")

  occ_earn <- ACSloadR:::parse_occupation_earnings_data(
    fixture_rows("C24011"), reg$occupation_earnings_acs5
  )
  oe_row <- occ_earn[occ_earn$variable == "C24011_002", ]
  expect_equal(oe_row$occupation, "Management, business, science, and arts occupations")
  expect_equal(oe_row$estimate, 85000)
})

test_that("national detailed occupation and industry parsers work", {
  reg <- ACSloadR:::acs_table_registry()

  nat_occ <- ACSloadR:::parse_national_detailed_occupation_data(
    fixture_rows("B24114"), reg$national_detailed_occupation
  )
  no_row <- nat_occ[nat_occ$variable == "B24114_002" & nat_occ$value_source == "published", ]
  expect_equal(no_row$occupation, "Chief executives")
  expect_equal(no_row$measure, "employment")

  nat_ind <- ACSloadR:::parse_national_detailed_industry_data(
    fixture_rows("B24134"), reg$national_detailed_industry
  )
  ni_row <- nat_ind[nat_ind$variable == "B24134_002" & nat_ind$value_source == "published", ]
  expect_equal(ni_row$industry, "Crop production")
  expect_equal(ni_row$measure, "employment")
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

test_that("occupation race parser handles survey-specific table depth", {
  registry <- ACSloadR:::acs_table_registry()
  acs1 <- ACSloadR:::parse_occupation_race_data(
    fixture_rows("B24010A"), registry$occupation_race_acs1
  )
  acs5 <- ACSloadR:::parse_occupation_race_data(
    fixture_rows("C24010A"), registry$occupation_race_acs5
  )

  expect_true(all(acs1$race_ethnicity == "White alone"))
  expect_true(all(acs5$race_ethnicity == "White alone"))

  detailed <- acs1[
    acs1$variable == "B24010A_005" & acs1$value_source == "published",
  ]
  expect_equal(detailed$sex, "Male")
  expect_equal(detailed$occupation_major, "Management, business, science, and arts occupations")
  expect_equal(detailed$occupation_intermediate, "Management, business, and financial occupations")
  expect_equal(detailed$occupation_detail, "Management occupations")

  collapsed <- acs5[
    acs5$variable == "C24010A_003" & acs5$value_source == "derived",
  ]
  expect_equal(collapsed$measure, "share_of_race_sex_employment")
  expect_equal(collapsed$estimate, 100 * 120 / 330)
  expect_equal(collapsed$denominator_variable, "C24010A_002")
  expect_true(is.na(collapsed$occupation_intermediate))

  total_count <- acs5[
    acs5$sex == "Total" &
      acs5$occupation == "Management, business, science, and arts occupations" &
      acs5$measure == "employment",
  ]
  expect_equal(total_count$estimate, 230)
  expect_equal(total_count$moe, sqrt(15^2 + 14^2))
  expect_equal(total_count$value_source, "derived")
  expect_equal(total_count$source_variables, "C24010A_003;C24010A_009")

  total_share <- acs5[
    acs5$sex == "Total" &
      acs5$occupation == "Management, business, science, and arts occupations" &
      acs5$measure == "share_of_race_sex_employment",
  ]
  expect_equal(total_share$estimate, 100 * 230 / 700)
  expect_equal(total_share$denominator_variable, "C24010A_001")
})

test_that("earnings and commuting parsers expose domain-specific columns", {
  registry <- ACSloadR:::acs_table_registry()
  earnings <- ACSloadR:::parse_generic_table(fixture_rows("B20004"), registry$earnings)
  commuting <- ACSloadR:::parse_generic_table(fixture_rows("B08301"), registry$commuting)

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
  parsed <- ACSloadR:::parse_generic_table(fixture_rows("B08301"), config)
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
  parsed <- ACSloadR:::parse_generic_table(
    rows, ACSloadR:::acs_table_registry()$commuting
  )
  derived <- parsed[parsed$value_source == "derived", ]
  expect_true(all(is.na(derived$estimate)))
  expect_true(all(is.na(derived$moe)))
})

test_that("geometry-like columns are retained at the end", {
  rows <- fixture_rows("B20004")
  rows$geometry <- "POINT (0 0)"
  parsed <- ACSloadR:::parse_generic_table(
    rows, ACSloadR:::acs_table_registry()$earnings
  )
  expect_equal(tail(names(parsed), 1), "geometry")
})

test_that("all registry entries map to valid parsers in parse_acs_topic", {
  registry <- ACSloadR:::acs_table_registry()
  for (name in names(registry)) {
    entry <- registry[[name]]
    dummy_df <- data.frame(
      GEOID = "25", NAME = "MA", year = 2024, survey = "acs5",
      table = entry$tables[[1]], variable = paste0(entry$tables[[1]], "_001"),
      concept = "Concept", label = "Estimate!!Total:",
      estimate = 100, moe = 10,
      stringsAsFactors = FALSE
    )
    res <- ACSloadR:::parse_acs_topic(dummy_df, entry$parser, entry)
    expect_s3_class(res, "data.frame")
  }
})

test_that("earnings companion tables correctly parse sex dimension without Total prefix", {
  reg <- ACSloadR:::acs_table_registry()
  
  # B24082 (Sex by Class of Worker and Median Earnings)
  dummy_b24082 <- data.frame(
    GEOID = "25", NAME = "MA", year = 2024, survey = "acs1",
    table = "B24082", variable = c("B24082_001", "B24082_010"),
    concept = "Sex by Class of Worker and Median Earnings",
    label = c("Estimate!!Male:", "Estimate!!Female:"),
    estimate = c(50000, 45000), moe = c(1000, 1200),
    stringsAsFactors = FALSE
  )
  parsed_cow <- ACSloadR:::parse_class_earnings_data(dummy_b24082, reg$class_of_worker_earnings_acs1)
  expect_equal(parsed_cow$sex, c("Male", "Female"))

  # B24032 (Sex by Industry and Median Earnings)
  dummy_b24032 <- data.frame(
    GEOID = "25", NAME = "MA", year = 2024, survey = "acs1",
    table = "B24032", variable = c("B24032_001", "B24032_010"),
    concept = "Sex by Industry and Median Earnings",
    label = c("Estimate!!Male:", "Estimate!!Female:"),
    estimate = c(60000, 52000), moe = c(1500, 1400),
    stringsAsFactors = FALSE
  )
  parsed_ind <- ACSloadR:::parse_industry_earnings_data(dummy_b24032, reg$industry_earnings_acs1)
  expect_equal(parsed_ind$sex, c("Male", "Female"))

  # B24012 (Sex by Occupation and Median Earnings)
  dummy_b24012 <- data.frame(
    GEOID = "25", NAME = "MA", year = 2024, survey = "acs1",
    table = "B24012", variable = c("B24012_001", "B24012_010"),
    concept = "Sex by Occupation and Median Earnings",
    label = c("Estimate!!Male:", "Estimate!!Female:"),
    estimate = c(70000, 65000), moe = c(2000, 1800),
    stringsAsFactors = FALSE
  )
  parsed_occ <- ACSloadR:::parse_occupation_earnings_data(dummy_b24012, reg$occupation_earnings_acs1)
  expect_equal(parsed_occ$sex, c("Male", "Female"))
})

test_that("get_acs_national_detailed validates that geography is 'us'", {
  expect_error(
    get_acs_national_detailed(2024, "acs5", geography = "state"),
    "only published at the US national level"
  )
})

test_that("derived sex total creation handles NA estimates gracefully", {
  reg <- ACSloadR:::acs_table_registry()
  dummy_c24080 <- data.frame(
    GEOID = rep("25", 4), NAME = rep("MA", 4), year = rep(2024, 4), survey = rep("acs5", 4),
    table = rep("C24080", 4),
    variable = c("C24080_001", "C24080_002", "C24080_003", "C24080_012"),
    concept = rep("Sex by Class of Worker", 4),
    label = c(
      "Estimate!!Total:",
      "Estimate!!Total:!!Male:",
      "Estimate!!Total:!!Male:!!Private for-profit wage and salary workers:!!Employee of private company workers",
      "Estimate!!Total:!!Female:!!Private for-profit wage and salary workers:!!Employee of private company workers"
    ),
    estimate = c(1000, 500, NA, 300),
    moe = c(50, 30, NA, 20),
    stringsAsFactors = FALSE
  )
  res <- ACSloadR:::parse_class_of_worker_counts_data(dummy_c24080, reg$class_of_worker_acs5)
  derived <- res[res$sex == "Total" & res$class_of_worker == "Employee of private company workers" & res$measure == "employment", ]
  expect_equal(nrow(derived), 1)
  expect_true(is.na(derived$estimate))
  expect_true(is.na(derived$moe))
})

test_that("migration parsers parse age, income, and geographical mobility correctly", {
  reg <- ACSloadR:::acs_table_registry()

  res_age <- ACSloadR:::parse_acs_topic(fixture_rows("B07001"), reg$migration_current_age_acs1$parser, reg$migration_current_age_acs1)
  expect_true("migration_status" %in% names(res_age))
  expect_true("age_group" %in% names(res_age))
  expect_true(any(res_age$migration_status == "Same house 1 year ago"))

  res_inc <- ACSloadR:::parse_acs_topic(fixture_rows("B07010"), reg$migration_current_income$parser, reg$migration_current_income)
  expect_true("migration_status" %in% names(res_inc))
  expect_true("income_bracket" %in% names(res_inc))

  res_prior <- ACSloadR:::parse_acs_topic(fixture_rows("B07401"), reg$migration_prior_age_acs1$parser, reg$migration_prior_age_acs1)
  expect_true("migration_status" %in% names(res_prior))
})
