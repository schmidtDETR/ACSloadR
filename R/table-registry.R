acs_table_registry <- function() {
  list(
    age_total_population = list(
      tables = "B01001", dataset_type = "detailed", parser = "generic",
      universe = "Total population", shares = TRUE,
      schema = list(
        levels = c(sex = 2L, age_group = 3L),
        measure = "population", unit = "count",
        key_cols = c("race_ethnicity", "sex", "age_group")
      )
    ),
    age_race_ethnicity = list(
      tables = paste0("B01001", LETTERS[1:9]), dataset_type = "detailed",
      parser = "generic", universe = "Race or ethnicity population", shares = TRUE,
      schema = list(
        race_suffix = TRUE,
        race_universe_fmt = "%s population",
        levels = c(sex = 2L, age_group = 3L),
        measure = "population", unit = "count",
        key_cols = c("race_ethnicity", "sex", "age_group")
      )
    ),
    employment = list(
      tables = "S2301", dataset_type = "subject", parser = "employment",
      universe = "Population 16 years and over", shares = FALSE
    ),
    occupation = list(
      tables = "S2401", dataset_type = "subject", parser = "occupation",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    occupation_race_acs1 = list(
      tables = paste0("B24010", LETTERS[1:9]), dataset_type = "detailed",
      parser = "occupation_race",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    occupation_race_acs5 = list(
      tables = paste0("C24010", LETTERS[1:9]), dataset_type = "detailed",
      parser = "occupation_race",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    earnings = list(
      tables = "B20004", dataset_type = "detailed", parser = "generic",
      universe = "Population 25 years and over with earnings", shares = FALSE,
      schema = list(
        sex_cross = TRUE, levels = c(sex = 2L, educational_attainment = 3L),
        measure = "median_earnings", unit = "dollars",
        key_cols = c("sex", "educational_attainment")
      )
    ),
    commuting = list(
      tables = "B08301", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over", shares = TRUE,
      schema = list(
        levels = c(mode_major = 2L, mode_detail = 3L),
        category_col = "transportation_mode", category_start_level = 2L, default_category = "All transportation modes",
        measure = "workers", unit = "count",
        key_cols = c("transportation_mode", "mode_major", "mode_detail")
      )
    ),

    # Detailed Employment Status
    employment_detail_status = list(
      tables = "B23025", dataset_type = "detailed", parser = "detailed_employment_status",
      universe = "Population 16 years and over", shares = TRUE
    ),
    employment_detail_age_sex_acs1 = list(
      tables = "B23001", dataset_type = "detailed", parser = "detailed_employment_age_sex",
      universe = "Population 16 years and over", shares = TRUE
    ),
    employment_detail_age_sex_acs5 = list(
      tables = "B23001", dataset_type = "detailed", parser = "detailed_employment_age_sex",
      universe = "Population 16 years and over", shares = TRUE
    ),
    employment_detail_race_acs1 = list(
      tables = paste0("B23002", LETTERS[1:9]), dataset_type = "detailed",
      parser = "detailed_employment_race",
      universe = "Population 16 years and over", shares = TRUE
    ),
    employment_detail_race_acs5 = list(
      tables = paste0("C23002", LETTERS[1:9]), dataset_type = "detailed",
      parser = "detailed_employment_race",
      universe = "Population 16 years and over", shares = TRUE
    ),
    employment_detail_education = list(
      tables = "B23006", dataset_type = "detailed", parser = "detailed_employment_education",
      universe = "Population 25 to 64 years", shares = TRUE
    ),
    employment_detail_poverty_disability = list(
      tables = "B23024", dataset_type = "detailed", parser = "detailed_employment_poverty_disability",
      universe = "Population 20 to 64 years", shares = TRUE
    ),
    employment_detail_seniors = list(
      tables = "C23004", dataset_type = "detailed", parser = "detailed_employment_seniors",
      universe = "Civilian population 65 years and over", shares = TRUE
    ),

    # Work Experience & Hours
    work_experience_hours_weeks_acs1 = list(
      tables = c("B23022", "B23026"), dataset_type = "detailed", parser = "work_experience_hours_weeks",
      universe = "Population 16 years and over", shares = TRUE
    ),
    work_experience_hours_weeks_acs5 = list(
      tables = c("B23022", "B23026"), dataset_type = "detailed", parser = "work_experience_hours_weeks",
      universe = "Population 16 years and over", shares = TRUE
    ),
    work_experience_full_time = list(
      tables = "B23027", dataset_type = "detailed", parser = "work_experience_full_time",
      universe = "Population 16 years and over", shares = TRUE
    ),
    work_experience_hours_summary = list(
      tables = c("B23018", "B23020", "B23013"), dataset_type = "detailed", parser = "work_experience_summary",
      universe = "Workers 16 to 64 years", shares = FALSE
    ),

    # Family & Child Employment
    family_employment_children_acs1 = list(
      tables = "B23008", dataset_type = "detailed", parser = "family_employment_children",
      universe = "Own children in families and subfamilies", shares = TRUE
    ),
    family_employment_children_acs5 = list(
      tables = "B23008", dataset_type = "detailed", parser = "family_employment_children",
      universe = "Own children in families and subfamilies", shares = TRUE
    ),
    family_employment_females = list(
      tables = "B23003", dataset_type = "detailed", parser = "family_employment_females",
      universe = "Females 20 to 64 years", shares = TRUE
    ),
    family_employment_types_acs1 = list(
      tables = "B23007", dataset_type = "detailed", parser = "family_employment_types",
      universe = "Own children under 18 years", shares = TRUE
    ),
    family_employment_types_acs5 = list(
      tables = "B23007", dataset_type = "detailed", parser = "family_employment_types",
      universe = "Own children under 18 years", shares = TRUE
    ),
    family_employment_workers = list(
      tables = c("B23009", "B23010"), dataset_type = "detailed", parser = "family_employment_workers",
      universe = "Families with own children under 18 years", shares = TRUE
    ),

    # Industry
    industry_acs1 = list(
      tables = "B24030", dataset_type = "detailed", parser = "industry_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_acs5 = list(
      tables = "B24030", dataset_type = "detailed", parser = "industry_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_collapsed_acs1 = list(
      tables = "C24030", dataset_type = "detailed", parser = "industry_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_collapsed_acs5 = list(
      tables = "C24030", dataset_type = "detailed", parser = "industry_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_full_time_acs1 = list(
      tables = "B24040", dataset_type = "detailed", parser = "industry_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    industry_full_time_acs5 = list(
      tables = "B24040", dataset_type = "detailed", parser = "industry_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    industry_full_time_collapsed_acs1 = list(
      tables = "C24040", dataset_type = "detailed", parser = "industry_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    industry_full_time_collapsed_acs5 = list(
      tables = "C24040", dataset_type = "detailed", parser = "industry_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    industry_earnings_acs1 = list(
      tables = c("B24031", "B24032"), dataset_type = "detailed", parser = "industry_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    industry_earnings_acs5 = list(
      tables = c("B24031", "B24032"), dataset_type = "detailed", parser = "industry_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    industry_earnings_collapsed_acs1 = list(
      tables = c("C24031", "C24032"), dataset_type = "detailed", parser = "industry_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    industry_earnings_collapsed_acs5 = list(
      tables = c("C24031", "C24032"), dataset_type = "detailed", parser = "industry_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    industry_earnings_full_time_acs1 = list(
      tables = c("B24041", "B24042"), dataset_type = "detailed", parser = "industry_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    industry_earnings_full_time_acs5 = list(
      tables = c("B24041", "B24042"), dataset_type = "detailed", parser = "industry_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    industry_earnings_full_time_collapsed_acs1 = list(
      tables = c("C24041", "C24042"), dataset_type = "detailed", parser = "industry_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    industry_earnings_full_time_collapsed_acs5 = list(
      tables = c("C24041", "C24042"), dataset_type = "detailed", parser = "industry_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    industry_by_occupation_acs1 = list(
      tables = "B24050", dataset_type = "detailed", parser = "industry_by_occupation",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_by_occupation_acs5 = list(
      tables = "B24050", dataset_type = "detailed", parser = "industry_by_occupation",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_by_occupation_collapsed_acs1 = list(
      tables = "C24050", dataset_type = "detailed", parser = "industry_by_occupation",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_by_occupation_collapsed_acs5 = list(
      tables = "C24050", dataset_type = "detailed", parser = "industry_by_occupation",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_by_class_acs1 = list(
      tables = "B24070", dataset_type = "detailed", parser = "industry_by_class",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_by_class_acs5 = list(
      tables = "B24070", dataset_type = "detailed", parser = "industry_by_class",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_by_class_collapsed_acs1 = list(
      tables = "C24070", dataset_type = "detailed", parser = "industry_by_class",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    industry_by_class_collapsed_acs5 = list(
      tables = "C24070", dataset_type = "detailed", parser = "industry_by_class",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),

    # Class of Worker
    class_of_worker_acs1 = list(
      tables = "B24080", dataset_type = "detailed", parser = "class_of_worker_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    class_of_worker_acs5 = list(
      tables = "B24080", dataset_type = "detailed", parser = "class_of_worker_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    class_of_worker_collapsed_acs1 = list(
      tables = "C24080", dataset_type = "detailed", parser = "class_of_worker_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    class_of_worker_collapsed_acs5 = list(
      tables = "C24080", dataset_type = "detailed", parser = "class_of_worker_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    class_of_worker_full_time_acs1 = list(
      tables = "B24090", dataset_type = "detailed", parser = "class_of_worker_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    class_of_worker_full_time_acs5 = list(
      tables = "B24090", dataset_type = "detailed", parser = "class_of_worker_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    class_of_worker_full_time_collapsed_acs1 = list(
      tables = "C24090", dataset_type = "detailed", parser = "class_of_worker_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    class_of_worker_full_time_collapsed_acs5 = list(
      tables = "C24090", dataset_type = "detailed", parser = "class_of_worker_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    class_of_worker_earnings_acs1 = list(
      tables = c("B24081", "B24082"), dataset_type = "detailed", parser = "class_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    class_of_worker_earnings_acs5 = list(
      tables = c("B24081", "B24082"), dataset_type = "detailed", parser = "class_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    class_of_worker_earnings_collapsed_acs1 = list(
      tables = c("C24081", "C24082"), dataset_type = "detailed", parser = "class_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    class_of_worker_earnings_collapsed_acs5 = list(
      tables = c("C24081", "C24082"), dataset_type = "detailed", parser = "class_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    class_of_worker_earnings_full_time_acs1 = list(
      tables = c("B24091", "B24092"), dataset_type = "detailed", parser = "class_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    class_of_worker_earnings_full_time_acs5 = list(
      tables = c("B24091", "B24092"), dataset_type = "detailed", parser = "class_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    class_of_worker_earnings_full_time_collapsed_acs1 = list(
      tables = c("C24091", "C24092"), dataset_type = "detailed", parser = "class_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    class_of_worker_earnings_full_time_collapsed_acs5 = list(
      tables = c("C24091", "C24092"), dataset_type = "detailed", parser = "class_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    class_by_occupation_acs1 = list(
      tables = "B24060", dataset_type = "detailed", parser = "class_by_occupation",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    class_by_occupation_acs5 = list(
      tables = "B24060", dataset_type = "detailed", parser = "class_by_occupation",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    class_by_occupation_collapsed_acs1 = list(
      tables = "C24060", dataset_type = "detailed", parser = "class_by_occupation",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    class_by_occupation_collapsed_acs5 = list(
      tables = "C24060", dataset_type = "detailed", parser = "class_by_occupation",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),

    # Occupation Detailed Base & Earnings
    occupation_detailed_total_acs1 = list(
      tables = "B24010", dataset_type = "detailed", parser = "occupation_detailed_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    occupation_detailed_total_acs5 = list(
      tables = "B24010", dataset_type = "detailed", parser = "occupation_detailed_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    occupation_detailed_total_collapsed_acs1 = list(
      tables = "C24010", dataset_type = "detailed", parser = "occupation_detailed_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    occupation_detailed_total_collapsed_acs5 = list(
      tables = "C24010", dataset_type = "detailed", parser = "occupation_detailed_counts",
      universe = "Civilian employed population 16 years and over", shares = TRUE
    ),
    occupation_detailed_full_time_acs1 = list(
      tables = "B24020", dataset_type = "detailed", parser = "occupation_detailed_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    occupation_detailed_full_time_acs5 = list(
      tables = "B24020", dataset_type = "detailed", parser = "occupation_detailed_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    occupation_detailed_full_time_collapsed_acs1 = list(
      tables = "C24020", dataset_type = "detailed", parser = "occupation_detailed_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    occupation_detailed_full_time_collapsed_acs5 = list(
      tables = "C24020", dataset_type = "detailed", parser = "occupation_detailed_counts",
      universe = "Full-time, year-round civilian employed population 16 years and over", shares = TRUE
    ),
    occupation_earnings_acs1 = list(
      tables = c("B24011", "B24012"), dataset_type = "detailed", parser = "occupation_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    occupation_earnings_acs5 = list(
      tables = c("B24011", "B24012"), dataset_type = "detailed", parser = "occupation_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    occupation_earnings_collapsed_acs1 = list(
      tables = c("C24011", "C24012"), dataset_type = "detailed", parser = "occupation_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    occupation_earnings_collapsed_acs5 = list(
      tables = c("C24011", "C24012"), dataset_type = "detailed", parser = "occupation_earnings",
      universe = "Civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    occupation_earnings_full_time_acs1 = list(
      tables = c("B24021", "B24022"), dataset_type = "detailed", parser = "occupation_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    occupation_earnings_full_time_acs5 = list(
      tables = c("B24021", "B24022"), dataset_type = "detailed", parser = "occupation_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    occupation_earnings_full_time_collapsed_acs1 = list(
      tables = c("C24021", "C24022"), dataset_type = "detailed", parser = "occupation_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),
    occupation_earnings_full_time_collapsed_acs5 = list(
      tables = c("C24021", "C24022"), dataset_type = "detailed", parser = "occupation_earnings",
      universe = "Full-time, year-round civilian employed population 16 years and over with earnings", shares = FALSE
    ),

    # National Detailed
    national_detailed_occupation = list(
      tables = c("B24114", "B24115", "B24116", "B24121", "B24122", "B24123", "B24124", "B24125", "B24126"),
      dataset_type = "detailed", parser = "national_detailed_occupation",
      universe = "Civilian employed population 16 years and over (US total)", shares = TRUE
    ),
    national_detailed_industry = list(
      tables = c("B24134", "B24135", "B24136"),
      dataset_type = "detailed", parser = "national_detailed_industry",
      universe = "Civilian employed population 16 years and over (US total)", shares = TRUE
    ),

    # Household Income
    household_income_brackets_acs1 = list(
      tables = "B19001", dataset_type = "detailed", parser = "household_income_brackets",
      universe = "Households", shares = TRUE
    ),
    household_income_brackets_acs5 = list(
      tables = "C19001", dataset_type = "detailed", parser = "household_income_brackets",
      universe = "Households", shares = TRUE
    ),
    household_income_race_acs1 = list(
      tables = paste0("B19001", LETTERS[1:9]), dataset_type = "detailed", parser = "household_income_brackets",
      universe = "Households by race/ethnicity", shares = TRUE
    ),
    household_income_race_acs5 = list(
      tables = paste0("C19001", LETTERS[1:9]), dataset_type = "detailed", parser = "household_income_brackets",
      universe = "Households by race/ethnicity", shares = TRUE
    ),
    household_income_median = list(
      tables = "B19013", dataset_type = "detailed", parser = "household_income_median",
      universe = "Households", shares = FALSE
    ),
    household_income_median_race = list(
      tables = paste0("B19013", LETTERS[1:9]), dataset_type = "detailed", parser = "household_income_median",
      universe = "Households by race/ethnicity", shares = FALSE
    ),
    household_income_size = list(
      tables = "B19019", dataset_type = "detailed", parser = "household_income_size",
      universe = "Households", shares = FALSE
    ),
    household_income_age = list(
      tables = c("B19037", "B19049"), dataset_type = "detailed", parser = "household_income_age",
      universe = "Households", shares = TRUE
    ),

    # Family & Nonfamily Income
    family_income_brackets_acs1 = list(
      tables = "B19101", dataset_type = "detailed", parser = "family_income_brackets",
      universe = "Families", shares = TRUE
    ),
    family_income_brackets_acs5 = list(
      tables = "C19101", dataset_type = "detailed", parser = "family_income_brackets",
      universe = "Families", shares = TRUE
    ),
    family_income_race_acs1 = list(
      tables = paste0("B19101", LETTERS[1:9]), dataset_type = "detailed", parser = "family_income_brackets",
      universe = "Families by race/ethnicity", shares = TRUE
    ),
    family_income_race_acs5 = list(
      tables = paste0("C19101", LETTERS[1:9]), dataset_type = "detailed", parser = "family_income_brackets",
      universe = "Families by race/ethnicity", shares = TRUE
    ),
    family_income_median = list(
      tables = c("B19113", "B19119", "B19121", "B19125", "B19126"), dataset_type = "detailed", parser = "family_income_median",
      universe = "Families", shares = FALSE
    ),
    family_income_median_race = list(
      tables = paste0("B19113", LETTERS[1:9]), dataset_type = "detailed", parser = "family_income_median",
      universe = "Families by race/ethnicity", shares = FALSE
    ),
    family_income_children_acs1 = list(
      tables = "B19131", dataset_type = "detailed", parser = "family_income_children",
      universe = "Families", shares = TRUE
    ),
    family_income_children_acs5 = list(
      tables = "C19131", dataset_type = "detailed", parser = "family_income_children",
      universe = "Families", shares = TRUE
    ),
    nonfamily_income_brackets_acs1 = list(
      tables = "B19201", dataset_type = "detailed", parser = "nonfamily_income_brackets",
      universe = "Nonfamily households", shares = TRUE
    ),
    nonfamily_income_brackets_acs5 = list(
      tables = "C19201", dataset_type = "detailed", parser = "nonfamily_income_brackets",
      universe = "Nonfamily households", shares = TRUE
    ),
    nonfamily_income_median = list(
      tables = c("B19202", "B19215"), dataset_type = "detailed", parser = "nonfamily_income_median",
      universe = "Nonfamily households", shares = FALSE
    ),
    nonfamily_income_median_race = list(
      tables = paste0("B19202", LETTERS[1:9]), dataset_type = "detailed", parser = "nonfamily_income_median",
      universe = "Nonfamily households by race/ethnicity", shares = FALSE
    ),

    # Income Types & Composition
    income_types_counts = list(
      tables = c("B19051", "B19052", "B19053", "B19054", "B19055", "B19056", "B19057", "B19058", "B19059", "B19060"),
      dataset_type = "detailed", parser = "income_types_counts",
      universe = "Households", shares = TRUE
    ),
    income_types_aggregates = list(
      tables = c("B19061", "B19062", "B19063", "B19064", "B19065", "B19066", "B19067", "B19069", "B19070"),
      dataset_type = "detailed", parser = "income_types_aggregates",
      universe = "Households", shares = FALSE
    ),

    # Income Inequality & Aggregates
    income_inequality_gini = list(
      tables = "B19083", dataset_type = "detailed", parser = "income_inequality_gini",
      universe = "Households", shares = FALSE
    ),
    income_quintiles_limits = list(
      tables = "B19080", dataset_type = "detailed", parser = "income_quintiles_limits",
      universe = "Households", shares = FALSE
    ),
    income_quintiles_means = list(
      tables = "B19081", dataset_type = "detailed", parser = "income_quintiles_means",
      universe = "Households", shares = FALSE
    ),
    income_quintiles_shares = list(
      tables = "B19082", dataset_type = "detailed", parser = "income_quintiles_shares",
      universe = "Households", shares = FALSE
    ),
    per_capita_income = list(
      tables = "B19301", dataset_type = "detailed", parser = "per_capita_income",
      universe = "Total population", shares = FALSE
    ),
    per_capita_income_race = list(
      tables = paste0("B19301", LETTERS[1:9]), dataset_type = "detailed", parser = "per_capita_income",
      universe = "Total population by race/ethnicity", shares = FALSE
    ),
    aggregate_income = list(
      tables = "B19313", dataset_type = "detailed", parser = "aggregate_income",
      universe = "Total population", shares = FALSE
    ),
    aggregate_income_race = list(
      tables = paste0("B19313", LETTERS[1:9]), dataset_type = "detailed", parser = "aggregate_income",
      universe = "Total population by race/ethnicity", shares = FALSE
    ),

    # Individual Income & Earnings
    individual_earnings_brackets = list(
      tables = "B20001", dataset_type = "detailed", parser = "individual_earnings_brackets",
      universe = "Population 15 years and over with earnings", shares = TRUE
    ),
    individual_earnings_median = list(
      tables = "B20002", dataset_type = "detailed", parser = "individual_earnings_median",
      universe = "Population 15 years and over with earnings", shares = FALSE
    ),
    individual_earnings_aggregate = list(
      tables = "B20003", dataset_type = "detailed", parser = "individual_earnings_aggregate",
      universe = "Population 15 years and over with earnings", shares = FALSE
    ),
    individual_earnings_work_exp_acs1 = list(
      tables = "B20005", dataset_type = "detailed", parser = "individual_earnings_work_exp",
      universe = "Population 15 years and over with earnings", shares = TRUE
    ),
    individual_earnings_work_exp_acs5 = list(
      tables = "C20005", dataset_type = "detailed", parser = "individual_earnings_work_exp",
      universe = "Population 15 years and over with earnings", shares = TRUE
    ),
    individual_earnings_work_exp_race_acs1 = list(
      tables = paste0("B20005", LETTERS[1:9]), dataset_type = "detailed", parser = "individual_earnings_work_exp",
      universe = "Population 15 years and over by race/ethnicity", shares = TRUE
    ),
    individual_earnings_work_exp_race_acs5 = list(
      tables = paste0("C20005", LETTERS[1:9]), dataset_type = "detailed", parser = "individual_earnings_work_exp",
      universe = "Population 15 years and over by race/ethnicity", shares = TRUE
    ),
    individual_earnings_median_work_exp = list(
      tables = "B20017", dataset_type = "detailed", parser = "individual_earnings_median_work_exp",
      universe = "Population 15 years and over with earnings", shares = FALSE
    ),
    individual_earnings_median_work_exp_race = list(
      tables = paste0("B20017", LETTERS[1:9]), dataset_type = "detailed", parser = "individual_earnings_median_work_exp",
      universe = "Population 15 years and over by race/ethnicity", shares = FALSE
    ),
    individual_earnings_full_time = list(
      tables = "B20018", dataset_type = "detailed", parser = "individual_earnings_median_work_exp",
      universe = "Full-time, year-round workers 15 years and over with earnings", shares = FALSE
    ),
    individual_income_brackets = list(
      tables = "B19325", dataset_type = "detailed", parser = "individual_income_brackets",
      universe = "Population 15 years and over with income", shares = TRUE
    ),
    individual_income_median = list(
      tables = "B19326", dataset_type = "detailed", parser = "individual_income_median",
      universe = "Population 15 years and over with income", shares = FALSE
    ),

    # School Enrollment
    school_enrollment_level = list(
      tables = "B14001", dataset_type = "detailed", parser = "school_enrollment_level",
      universe = "Population 3 years and over", shares = TRUE
    ),
    school_enrollment_detailed_acs1 = list(
      tables = "B14007", dataset_type = "detailed", parser = "school_enrollment_detailed",
      universe = "Population 3 years and over", shares = TRUE
    ),
    school_enrollment_detailed_acs5 = list(
      tables = "C14007", dataset_type = "detailed", parser = "school_enrollment_detailed",
      universe = "Population 3 years and over", shares = TRUE
    ),
    school_enrollment_detailed_race_acs1 = list(
      tables = paste0("B14007", LETTERS[1:9]), dataset_type = "detailed", parser = "school_enrollment_detailed",
      universe = "Population 3 years and over by race/ethnicity", shares = TRUE
    ),
    school_enrollment_detailed_race_acs5 = list(
      tables = paste0("C14007", LETTERS[1:9]), dataset_type = "detailed", parser = "school_enrollment_detailed",
      universe = "Population 3 years and over by race/ethnicity", shares = TRUE
    ),
    school_enrollment_type_acs1 = list(
      tables = "B14002", dataset_type = "detailed", parser = "school_enrollment_type",
      universe = "Population 3 years and over enrolled in school", shares = TRUE
    ),
    school_enrollment_type_acs5 = list(
      tables = "C14002", dataset_type = "detailed", parser = "school_enrollment_type",
      universe = "Population 3 years and over enrolled in school", shares = TRUE
    ),
    school_enrollment_age_acs1 = list(
      tables = "B14003", dataset_type = "detailed", parser = "school_enrollment_age",
      universe = "Population 3 years and over enrolled in school", shares = TRUE
    ),
    school_enrollment_age_acs5 = list(
      tables = "C14003", dataset_type = "detailed", parser = "school_enrollment_age",
      universe = "Population 3 years and over enrolled in school", shares = TRUE
    ),
    college_enrollment_age = list(
      tables = "B14004", dataset_type = "detailed", parser = "college_enrollment_age",
      universe = "Population 15 years and over enrolled in college or graduate school", shares = TRUE
    ),
    youth_enrollment_employment_acs1 = list(
      tables = "B14005", dataset_type = "detailed", parser = "youth_enrollment_employment",
      universe = "Population 16 to 19 years", shares = TRUE
    ),
    youth_enrollment_employment_acs5 = list(
      tables = "C14005", dataset_type = "detailed", parser = "youth_enrollment_employment",
      universe = "Population 16 to 19 years", shares = TRUE
    ),
    school_enrollment_poverty = list(
      tables = "B14006", dataset_type = "detailed", parser = "school_enrollment_poverty",
      universe = "Population 3 years and over for whom poverty status is determined", shares = TRUE
    ),

    # Educational Attainment
    educational_attainment_age_sex = list(
      tables = "B15001", dataset_type = "detailed", parser = "educational_attainment_age_sex",
      universe = "Population 18 years and over", shares = TRUE
    ),
    educational_attainment_sex_acs1 = list(
      tables = "B15002", dataset_type = "detailed", parser = "educational_attainment_sex",
      universe = "Population 25 years and over", shares = TRUE
    ),
    educational_attainment_sex_acs5 = list(
      tables = "C15002", dataset_type = "detailed", parser = "educational_attainment_sex",
      universe = "Population 25 years and over", shares = TRUE
    ),
    educational_attainment_race_acs1 = list(
      tables = paste0("B15002", LETTERS[1:9]), dataset_type = "detailed", parser = "educational_attainment_sex",
      universe = "Population 25 years and over by race/ethnicity", shares = TRUE
    ),
    educational_attainment_race_acs5 = list(
      tables = paste0("C15002", LETTERS[1:9]), dataset_type = "detailed", parser = "educational_attainment_sex",
      universe = "Population 25 years and over by race/ethnicity", shares = TRUE
    ),
    educational_attainment_detailed_acs1 = list(
      tables = "B15003", dataset_type = "detailed", parser = "educational_attainment_detailed",
      universe = "Population 25 years and over", shares = TRUE
    ),
    educational_attainment_detailed_acs5 = list(
      tables = "C15003", dataset_type = "detailed", parser = "educational_attainment_detailed",
      universe = "Population 25 years and over", shares = TRUE
    ),

    # Field of Degree
    field_of_degree_broad = list(
      tables = "B15011", dataset_type = "detailed", parser = "field_of_degree_broad",
      universe = "Civilian substituted bachelor degree holders 25 years and over", shares = TRUE
    ),
    field_of_degree_detailed_acs1 = list(
      tables = "B15010", dataset_type = "detailed", parser = "field_of_degree_detailed",
      universe = "Population 25 years and over with a Bachelor degree or higher", shares = TRUE
    ),
    field_of_degree_detailed_acs5 = list(
      tables = "C15010", dataset_type = "detailed", parser = "field_of_degree_detailed",
      universe = "Population 25 years and over with a Bachelor degree or higher", shares = TRUE
    ),
    field_of_degree_total = list(
      tables = "B15012", dataset_type = "detailed", parser = "field_of_degree_detailed",
      universe = "Bachelor degree fields reported", shares = TRUE
    ),
    field_of_degree_earnings_sex = list(
      tables = "B15013", dataset_type = "detailed", parser = "field_of_degree_earnings_sex",
      universe = "Population 25 years and over with a Bachelor degree or higher with earnings", shares = FALSE
    ),
    field_of_degree_earnings_age = list(
      tables = "B15014", dataset_type = "detailed", parser = "field_of_degree_earnings_age",
      universe = "Population 25 years and over with a Bachelor degree or higher with earnings", shares = FALSE
    ),

    # Travel Time & Departure Time
    travel_time_residence = list(
      tables = "B08303", dataset_type = "detailed", parser = "travel_time_residence",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    travel_time_workplace = list(
      tables = "B08603", dataset_type = "detailed", parser = "travel_time_workplace",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    departure_time_residence = list(
      tables = "B08302", dataset_type = "detailed", parser = "departure_time_residence",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    arrival_time_workplace = list(
      tables = "B08602", dataset_type = "detailed", parser = "arrival_time_workplace",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    departure_time_sex = list(
      tables = "B08011", dataset_type = "detailed", parser = "departure_time_sex",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    travel_time_sex_residence = list(
      tables = "B08012", dataset_type = "detailed", parser = "travel_time_sex",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    travel_time_sex_workplace = list(
      tables = "B08412", dataset_type = "detailed", parser = "travel_time_sex",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    travel_time_mode_residence_acs1 = list(
      tables = "B08134", dataset_type = "detailed", parser = "travel_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    travel_time_mode_residence_acs5 = list(
      tables = "C08134", dataset_type = "detailed", parser = "travel_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    travel_time_mode_workplace_acs1 = list(
      tables = "B08534", dataset_type = "detailed", parser = "travel_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    travel_time_mode_workplace_acs5 = list(
      tables = "C08534", dataset_type = "detailed", parser = "travel_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    departure_time_mode_residence_acs1 = list(
      tables = "B08132", dataset_type = "detailed", parser = "departure_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    departure_time_mode_residence_acs5 = list(
      tables = "C08132", dataset_type = "detailed", parser = "departure_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    arrival_time_mode_workplace_acs1 = list(
      tables = "B08532", dataset_type = "detailed", parser = "arrival_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    arrival_time_mode_workplace_acs5 = list(
      tables = "C08532", dataset_type = "detailed", parser = "arrival_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = TRUE
    ),
    aggregate_travel_time_mode_residence_acs1 = list(
      tables = "B08136", dataset_type = "detailed", parser = "aggregate_travel_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = FALSE
    ),
    aggregate_travel_time_mode_residence_acs5 = list(
      tables = "C08136", dataset_type = "detailed", parser = "aggregate_travel_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = FALSE
    ),
    aggregate_travel_time_mode_workplace_acs1 = list(
      tables = "B08536", dataset_type = "detailed", parser = "aggregate_travel_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = FALSE
    ),
    aggregate_travel_time_mode_workplace_acs5 = list(
      tables = "C08536", dataset_type = "detailed", parser = "aggregate_travel_time_mode",
      universe = "Workers 16 years and over who did not work from home", shares = FALSE
    ),
    aggregate_travel_time_total = list(
      tables = "B08013", dataset_type = "detailed", parser = "aggregate_travel_time_sex",
      universe = "Workers 16 years and over who did not work from home", shares = FALSE
    ),
    aggregate_travel_time_county = list(
      tables = "B08131", dataset_type = "detailed", parser = "aggregate_travel_time_place",
      universe = "Workers 16 years and over who did not work from home", shares = FALSE
    ),
    aggregate_travel_time_travel_time = list(
      tables = "B08135", dataset_type = "detailed", parser = "aggregate_travel_time_travel_time",
      universe = "Workers 16 years and over who did not work from home", shares = FALSE
    ),

    # Place of Work
    place_of_work_county = list(
      tables = "B08007", dataset_type = "detailed", parser = "place_of_work_sex",
      universe = "Workers 16 years and over", shares = TRUE
    ),
    place_of_work_place = list(
      tables = "B08008", dataset_type = "detailed", parser = "place_of_work_sex",
      universe = "Workers 16 years and over", shares = TRUE
    ),
    place_of_work_mcd = list(
      tables = "B08009", dataset_type = "detailed", parser = "place_of_work_sex",
      universe = "Workers 16 years and over in 12 selected states", shares = TRUE
    ),
    place_of_work_msa_acs1 = list(
      tables = "B08016", dataset_type = "detailed", parser = "place_of_work_msa",
      universe = "Workers 16 years and over", shares = TRUE
    ),
    place_of_work_msa_acs5 = list(
      tables = "C08016", dataset_type = "detailed", parser = "place_of_work_msa",
      universe = "Workers 16 years and over", shares = TRUE
    ),
    place_of_work_micro = list(
      tables = "B08017", dataset_type = "detailed", parser = "place_of_work_msa",
      universe = "Workers 16 years and over", shares = TRUE
    ),
    place_of_work_nonmetro = list(
      tables = "B08018", dataset_type = "detailed", parser = "place_of_work_msa",
      universe = "Workers 16 years and over", shares = TRUE
    ),
    workplace_worker_pop = list(
      tables = "B08604", dataset_type = "detailed", parser = "workplace_worker_pop",
      universe = "Workers 16 years and over in workplace geography", shares = FALSE
    ),

    # Commuting Characteristics
    commuting_age_residence_acs1 = list(
      tables = "B08101", dataset_type = "detailed", parser = "commuting_cross_age",
      universe = "Workers 16 years and over", shares = TRUE
    ),
    commuting_age_residence_acs5 = list(
      tables = "C08101", dataset_type = "detailed", parser = "commuting_cross_age",
      universe = "Workers 16 years and over", shares = TRUE
    ),
    commuting_age_workplace_acs1 = list(
      tables = "B08501", dataset_type = "detailed", parser = "commuting_cross_age",
      universe = "Workers 16 years and over in workplace geography", shares = TRUE
    ),
    commuting_age_workplace_acs5 = list(
      tables = "C08501", dataset_type = "detailed", parser = "commuting_cross_age",
      universe = "Workers 16 years and over in workplace geography", shares = TRUE
    ),
    commuting_median_age_residence = list(
      tables = "B08103", dataset_type = "detailed", parser = "commuting_median_age",
      universe = "Workers 16 years and over", shares = FALSE
    ),
    commuting_median_age_workplace = list(
      tables = "B08503", dataset_type = "detailed", parser = "commuting_median_age",
      universe = "Workers 16 years and over in workplace geography", shares = FALSE
    ),
    commuting_race_residence = list(
      tables = paste0("B08105", LETTERS[1:9]), dataset_type = "detailed", parser = "commuting_race",
      universe = "Workers 16 years and over by race/ethnicity", shares = TRUE
    ),
    commuting_race_workplace = list(
      tables = paste0("B08505", LETTERS[1:9]), dataset_type = "detailed", parser = "commuting_race",
      universe = "Workers 16 years and over in workplace geography by race/ethnicity", shares = TRUE
    ),
    commuting_earnings_residence_acs1 = list(
      tables = "B08119", dataset_type = "detailed", parser = "commuting_cross_earnings",
      universe = "Workers 16 years and over with earnings", shares = TRUE
    ),
    commuting_earnings_residence_acs5 = list(
      tables = "C08119", dataset_type = "detailed", parser = "commuting_cross_earnings",
      universe = "Workers 16 years and over with earnings", shares = TRUE
    ),
    commuting_earnings_workplace_acs1 = list(
      tables = "B08519", dataset_type = "detailed", parser = "commuting_cross_earnings",
      universe = "Workers 16 years and over with earnings in workplace geography", shares = TRUE
    ),
    commuting_earnings_workplace_acs5 = list(
      tables = "C08519", dataset_type = "detailed", parser = "commuting_cross_earnings",
      universe = "Workers 16 years and over with earnings in workplace geography", shares = TRUE
    ),
    commuting_median_earnings_residence = list(
      tables = "B08121", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over with earnings", shares = FALSE,
      schema = list(category_col = "transportation_mode", measure = "median_earnings", unit = "dollars", key_cols = c("transportation_mode"))
    ),
    commuting_median_earnings_workplace = list(
      tables = "B08521", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over with earnings in workplace geography", shares = FALSE,
      schema = list(category_col = "transportation_mode", measure = "median_earnings", unit = "dollars", key_cols = c("transportation_mode"))
    ),
    commuting_poverty_residence_acs1 = list(
      tables = "B08122", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over for whom poverty status is determined", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "poverty_status", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "poverty_status")
      )
    ),
    commuting_poverty_residence_acs5 = list(
      tables = "C08122", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over for whom poverty status is determined", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "poverty_status", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "poverty_status")
      )
    ),
    commuting_poverty_workplace_acs1 = list(
      tables = "B08522", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over for whom poverty status is determined in workplace geography", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "poverty_status", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "poverty_status")
      )
    ),
    commuting_poverty_workplace_acs5 = list(
      tables = "C08522", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over for whom poverty status is determined in workplace geography", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "poverty_status", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "poverty_status")
      )
    ),
    commuting_occupation_residence_acs1 = list(
      tables = "B08124", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "occupation_group", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "occupation_group")
      )
    ),
    commuting_occupation_residence_acs5 = list(
      tables = "C08124", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "occupation_group", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "occupation_group")
      )
    ),
    commuting_occupation_workplace_acs1 = list(
      tables = "B08524", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over in workplace geography", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "occupation_group", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "occupation_group")
      )
    ),
    commuting_occupation_workplace_acs5 = list(
      tables = "C08524", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over in workplace geography", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "occupation_group", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "occupation_group")
      )
    ),
    commuting_industry_residence_acs1 = list(
      tables = "B08126", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "industry_group", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "industry_group")
      )
    ),
    commuting_industry_residence_acs5 = list(
      tables = "C08126", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "industry_group", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "industry_group")
      )
    ),
    commuting_industry_workplace_acs1 = list(
      tables = "B08526", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over in workplace geography", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "industry_group", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "industry_group")
      )
    ),
    commuting_industry_workplace_acs5 = list(
      tables = "C08526", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over in workplace geography", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "industry_group", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "industry_group")
      )
    ),
    commuting_class_residence_acs1 = list(
      tables = "B08128", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "class_of_worker", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "class_of_worker")
      )
    ),
    commuting_class_residence_acs5 = list(
      tables = "C08128", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "class_of_worker", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "class_of_worker")
      )
    ),
    commuting_class_workplace_acs1 = list(
      tables = "B08528", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over in workplace geography", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "class_of_worker", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "class_of_worker")
      )
    ),
    commuting_class_workplace_acs5 = list(
      tables = "C08528", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over in workplace geography", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "class_of_worker", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "class_of_worker")
      )
    ),
    commuting_vehicles_residence_acs1 = list(
      tables = "B08141", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over in households", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "vehicles_available", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "vehicles_available")
      )
    ),
    commuting_vehicles_residence_acs5 = list(
      tables = "C08141", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over in households", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "vehicles_available", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "vehicles_available")
      )
    ),
    commuting_vehicles_workplace_acs1 = list(
      tables = "B08541", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over in households in workplace geography", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "vehicles_available", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "vehicles_available")
      )
    ),
    commuting_vehicles_workplace_acs5 = list(
      tables = "C08541", dataset_type = "detailed", parser = "generic",
      universe = "Workers 16 years and over in households in workplace geography", shares = TRUE,
      schema = list(
        levels = c(transportation_mode = 1L), category_col = "vehicles_available", category_start_level = 2L,
        measure = "workers", unit = "count", key_cols = c("transportation_mode", "vehicles_available")
      )
    ),

    # Current Residence Migration
    migration_current_age_acs1 = list(
      tables = "B07001", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = TRUE,
      schema = list(
        levels = c(age_group = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("age_group", "migration_status")
      )
    ),
    migration_current_age_acs5 = list(
      tables = "C07001", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = TRUE,
      schema = list(
        levels = c(age_group = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("age_group", "migration_status")
      )
    ),
    migration_current_median_age = list(
      tables = "B07002", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = FALSE,
      schema = list(
        category_col = "migration_status", measure = "median_age", unit = "years",
        key_cols = c("migration_status")
      )
    ),
    migration_current_sex = list(
      tables = "B07003", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = TRUE,
      schema = list(
        levels = c(sex = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("sex", "migration_status")
      )
    ),
    migration_current_race = list(
      tables = paste0("B07004", LETTERS[1:9]), dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence by race/ethnicity", shares = TRUE,
      schema = list(
        race_suffix = TRUE, race_universe_fmt = "%s population 1 year and over",
        category_col = "migration_status", measure = "population", unit = "count",
        key_cols = c("race_ethnicity", "migration_status")
      )
    ),
    migration_current_citizenship = list(
      tables = "B07007", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = TRUE,
      schema = list(
        levels = c(citizenship_status = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("citizenship_status", "migration_status")
      )
    ),
    migration_current_marital_acs1 = list(
      tables = "B07008", dataset_type = "detailed", parser = "generic",
      universe = "Population 15 years and over in current residence", shares = TRUE,
      schema = list(
        levels = c(marital_status = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("marital_status", "migration_status")
      )
    ),
    migration_current_marital_acs5 = list(
      tables = "C07008", dataset_type = "detailed", parser = "generic",
      universe = "Population 15 years and over in current residence", shares = TRUE,
      schema = list(
        levels = c(marital_status = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("marital_status", "migration_status")
      )
    ),
    migration_current_education = list(
      tables = "B07009", dataset_type = "detailed", parser = "generic",
      universe = "Population 25 years and over in current residence", shares = TRUE,
      schema = list(
        levels = c(educational_attainment = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("educational_attainment", "migration_status")
      )
    ),
    migration_current_income = list(
      tables = "B07010", dataset_type = "detailed", parser = "generic",
      universe = "Population 15 years and over with income in current residence", shares = TRUE,
      schema = list(
        levels = c(income_bracket = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("income_bracket", "migration_status")
      )
    ),
    migration_current_median_income = list(
      tables = "B07011", dataset_type = "detailed", parser = "generic",
      universe = "Population 15 years and over with income in current residence", shares = FALSE,
      schema = list(
        category_col = "migration_status", measure = "median_income", unit = "dollars",
        key_cols = c("migration_status")
      )
    ),
    migration_current_poverty = list(
      tables = "B07012", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over for whom poverty status is determined in current residence", shares = TRUE,
      schema = list(
        levels = c(poverty_ratio = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("poverty_ratio", "migration_status")
      )
    ),
    migration_current_tenure = list(
      tables = "B07013", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in housing units in current residence", shares = TRUE,
      schema = list(
        levels = c(housing_tenure = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("housing_tenure", "migration_status")
      )
    ),
    migration_current_region = list(
      tables = "B07101", dataset_type = "detailed", parser = "generic",
      universe = "Movers between regions in current residence", shares = TRUE,
      schema = list(category_col = "mover_region", measure = "movers", unit = "count", key_cols = c("mover_region"))
    ),
    migration_current_msa_acs1 = list(
      tables = "B07201", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = TRUE,
      schema = list(category_col = "migration_status", measure = "population", unit = "count", key_cols = c("migration_status"))
    ),
    migration_current_msa_acs5 = list(
      tables = "C07201", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = TRUE,
      schema = list(category_col = "migration_status", measure = "population", unit = "count", key_cols = c("migration_status"))
    ),
    migration_current_micro = list(
      tables = "B07202", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = TRUE,
      schema = list(category_col = "migration_status", measure = "population", unit = "count", key_cols = c("migration_status"))
    ),
    migration_current_nonmetro = list(
      tables = "B07203", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = TRUE,
      schema = list(category_col = "migration_status", measure = "population", unit = "count", key_cols = c("migration_status"))
    ),
    migration_current_place_acs1 = list(
      tables = "B07204", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = TRUE,
      schema = list(category_col = "migration_status", measure = "population", unit = "count", key_cols = c("migration_status"))
    ),
    migration_current_place_acs5 = list(
      tables = "C07204", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in current residence", shares = TRUE,
      schema = list(category_col = "migration_status", measure = "population", unit = "count", key_cols = c("migration_status"))
    ),

    # Prior Residence 1 Year Ago Migration
    migration_prior_age_acs1 = list(
      tables = "B07401", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in residence 1 year ago", shares = TRUE,
      schema = list(
        levels = c(age_group = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("age_group", "migration_status")
      )
    ),
    migration_prior_age_acs5 = list(
      tables = "C07401", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in residence 1 year ago", shares = TRUE,
      schema = list(
        levels = c(age_group = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("age_group", "migration_status")
      )
    ),
    migration_prior_median_age = list(
      tables = "B07402", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in residence 1 year ago", shares = FALSE,
      schema = list(
        category_col = "migration_status", measure = "median_age", unit = "years",
        key_cols = c("migration_status")
      )
    ),
    migration_prior_sex = list(
      tables = "B07403", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in residence 1 year ago", shares = TRUE,
      schema = list(
        levels = c(sex = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("sex", "migration_status")
      )
    ),
    migration_prior_race = list(
      tables = paste0("B07404", LETTERS[1:9]), dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in residence 1 year ago by race/ethnicity", shares = TRUE,
      schema = list(
        race_suffix = TRUE, race_universe_fmt = "%s population 1 year and over",
        category_col = "migration_status", measure = "population", unit = "count",
        key_cols = c("race_ethnicity", "migration_status")
      )
    ),
    migration_prior_citizenship = list(
      tables = "B07407", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in residence 1 year ago", shares = TRUE,
      schema = list(
        levels = c(citizenship_status = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("citizenship_status", "migration_status")
      )
    ),
    migration_prior_marital = list(
      tables = "B07408", dataset_type = "detailed", parser = "generic",
      universe = "Population 15 years and over in residence 1 year ago", shares = TRUE,
      schema = list(
        levels = c(marital_status = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("marital_status", "migration_status")
      )
    ),
    migration_prior_education = list(
      tables = "B07409", dataset_type = "detailed", parser = "generic",
      universe = "Population 25 years and over in residence 1 year ago", shares = TRUE,
      schema = list(
        levels = c(educational_attainment = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("educational_attainment", "migration_status")
      )
    ),
    migration_prior_income = list(
      tables = "B07410", dataset_type = "detailed", parser = "generic",
      universe = "Population 15 years and over with income in residence 1 year ago", shares = TRUE,
      schema = list(
        levels = c(income_bracket = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("income_bracket", "migration_status")
      )
    ),
    migration_prior_median_income = list(
      tables = "B07411", dataset_type = "detailed", parser = "generic",
      universe = "Population 15 years and over with income in residence 1 year ago", shares = FALSE,
      schema = list(
        category_col = "migration_status", measure = "median_income", unit = "dollars",
        key_cols = c("migration_status")
      )
    ),
    migration_prior_poverty = list(
      tables = "B07412", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over for whom poverty status is determined in residence 1 year ago", shares = TRUE,
      schema = list(
        levels = c(poverty_ratio = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("poverty_ratio", "migration_status")
      )
    ),
    migration_prior_tenure = list(
      tables = "B07413", dataset_type = "detailed", parser = "generic",
      universe = "Population 1 year and over in housing units in residence 1 year ago", shares = TRUE,
      schema = list(
        levels = c(housing_tenure = 2L), category_col = "migration_status", category_start_level = 2L,
        measure = "population", unit = "count", key_cols = c("housing_tenure", "migration_status")
      )
    )
  )
}

acs_dataset <- function(survey, dataset_type) {
  survey <- match.arg(survey, c("acs1", "acs5"))
  if (identical(dataset_type, "subject")) paste0(survey, "/subject") else survey
}

table_from_variable <- function(variable) {
  stringr::str_extract(variable, "^[A-Z]\\d{4,5}[A-Z]?")
}
