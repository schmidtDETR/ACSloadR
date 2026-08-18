#' ACS Topic Catalog for Interactive Explorer and Code Generator
#'
#' Provides metadata about available ACSloadR topic helpers, including categories,
#' underlying Census tables, universes, returned bundle components, and getter names.
#'
#' @return A named list of topic specifications.
#' @keywords internal
#' @noRd
acs_topic_catalog <- function() {
  list(
    # --- Demographics ---
    age = list(
      id = "age",
      category = c("Demographics"),
      title = "Age and Sex",
      getter = "get_acs_age",
      tables = c("B01001", "B01001A-I"),
      universe = "Total population / Race & Hispanic origin groups",
      components = c("total_population", "race_ethnicity"),
      description = "Total population and race/ethnicity detailed age and sex distributions.",
      default_var = "age_data"
    ),

    # --- Labor Force & Employment ---
    employment = list(
      id = "employment",
      category = c("Labor Force & Employment"),
      title = "Employment Status Summary (Subject S2301)",
      getter = "get_acs_employment",
      tables = c("S2301"),
      universe = "Population 16 years and over",
      components = c("employment"),
      description = "Published population, labor-force participation, employment-population ratio, and unemployment rates.",
      default_var = "employment"
    ),
    employment_detail = list(
      id = "employment_detail",
      category = c("Labor Force & Employment"),
      title = "Detailed Employment Status & Cross-tabs",
      getter = "get_acs_employment_detail",
      tables = c("B23025", "B23001", "B23002A-I / C23002A-I", "B23006", "B23024"),
      universe = "Population 16 years and over",
      components = c("status", "age_sex", "race_ethnicity", "education", "poverty_disability"),
      description = "Detailed civilian employment/unemployment, age/sex, race/ethnicity, education, and poverty/disability breakdowns.",
      default_var = "emp_detail"
    ),
    work_experience = list(
      id = "work_experience",
      category = c("Labor Force & Employment"),
      title = "Work Intensity, Hours & Full-Time Status",
      getter = "get_acs_work_experience",
      tables = c("B23022", "B23026", "B23027", "B23018", "B23020", "B23013"),
      universe = "Population 16 to 64 years",
      components = c("hours_weeks", "full_time_by_age", "hours_summary"),
      description = "Usual hours worked per week by weeks worked, full-time/part-time status, mean hours, and median age of workers.",
      default_var = "work_exp"
    ),
    family_employment = list(
      id = "family_employment",
      category = c("Labor Force & Employment"),
      title = "Family & Parental Employment",
      getter = "get_acs_family_employment",
      tables = c("B23008", "B23003", "B23007", "B23009", "B23010"),
      universe = "Own children under 18 years / Families",
      components = c("children_parent_status", "females_with_children", "family_type_status", "family_workers"),
      description = "Parental employment for children under 18, mothers in the labor force, family work intensity, and family workers.",
      default_var = "fam_emp"
    ),

    # --- Industry, Occupation & Class of Worker ---
    occupation = list(
      id = "occupation",
      category = c("Industry, Occupation & Class of Worker", "Labor Force & Employment"),
      title = "Occupation Summary (Subject S2401 & Race)",
      getter = "get_acs_occupation",
      tables = c("S2401", "B24010A-I / C24010A-I"),
      universe = "Civilian employed population 16 years and over",
      components = c("occupation", "race_ethnicity"),
      description = "Standard broad occupational categories by sex and race/ethnicity companion tables.",
      default_var = "occupation"
    ),
    occupation_detailed = list(
      id = "occupation_detailed",
      category = c("Industry, Occupation & Class of Worker"),
      title = "Detailed Occupation & Earnings",
      getter = "get_acs_occupation_detailed",
      tables = c("B24010 / C24010", "B24020 / C24020", "B24011", "B24012", "B24021", "B24022"),
      universe = "Civilian employed population 16 years and over",
      components = c("occupation", "occupation_full_time", "earnings", "earnings_full_time"),
      description = "Detailed occupation counts, full-time/year-round counts, and median earnings by occupation and sex.",
      default_var = "occ_detail"
    ),
    industry = list(
      id = "industry",
      category = c("Industry, Occupation & Class of Worker"),
      title = "Industry & Earnings",
      getter = "get_acs_industry",
      tables = c("B24030 / C24030", "B24040 / C24040", "B24031", "B24032", "B24041", "B24042", "B24050 / C24050", "B24060 / C24060"),
      universe = "Civilian employed population 16 years and over",
      components = c("industry", "industry_full_time", "earnings", "earnings_full_time", "industry_by_occupation", "industry_by_class"),
      description = "Industry employment counts, full-time counts, median earnings, industry-by-occupation matrix, and class of worker.",
      default_var = "industry"
    ),
    class_of_worker = list(
      id = "class_of_worker",
      category = c("Industry, Occupation & Class of Worker", "Labor Force & Employment"),
      title = "Class of Worker & Earnings (Private, Non-profit, Government, Self-employed)",
      getter = "get_acs_class_of_worker",
      tables = c("B24080 / C24080", "B24090 / C24090", "B24081", "B24082", "B24091", "B24092"),
      universe = "Civilian employed population 16 years and over",
      components = c("class_of_worker", "class_of_worker_full_time", "earnings", "earnings_full_time", "class_by_occupation"),
      description = "Private for-profit, non-profit, local/state/federal government, and self-employed worker counts, full-time breakdowns, and earnings.",
      default_var = "cow",
      caveat = "Note: ACS 5-year ('acs5') uses collapsed table C24080. If table unavailability occurs for a vintage, consider using survey = 'acs1' (uses B24080) or vintage 2023."
    ),
    national_detailed = list(
      id = "national_detailed",
      category = c("Industry, Occupation & Class of Worker"),
      title = "National 500+ Detailed Occupation & Industry (US only)",
      getter = "get_acs_national_detailed",
      tables = c("B24114-B24126", "B24134-B24136"),
      universe = "Civilian employed population 16 years and over (US level)",
      components = c("detailed_occupation", "detailed_industry"),
      description = "Over 500 detailed occupation and industry line items available at the national level.",
      default_var = "nat_detail"
    ),

    # --- Income, Earnings & Inequality ---
    earnings = list(
      id = "earnings",
      category = c("Income, Earnings & Inequality"),
      title = "Median Earnings by Educational Attainment",
      getter = "get_acs_earnings",
      tables = c("B20004"),
      universe = "Population 25 years and over with earnings",
      components = c("earnings"),
      description = "Median earnings in the past 12 months by educational attainment and sex.",
      default_var = "earnings"
    ),
    household_income = list(
      id = "household_income",
      category = c("Income, Earnings & Inequality"),
      title = "Household Income Distributions & Medians",
      getter = "get_acs_household_income",
      tables = c("B19001", "B19013", "B19019", "B19037", "B19049", "B19001A-I", "B19013A-I"),
      universe = "Households",
      components = c("brackets", "median", "median_by_size", "by_age_of_householder", "race_ethnicity"),
      description = "Household income brackets, medians, medians by household size, by age of householder, and race/ethnicity companions.",
      default_var = "hh_income"
    ),
    family_income = list(
      id = "family_income",
      category = c("Income, Earnings & Inequality"),
      title = "Family & Nonfamily Income",
      getter = "get_acs_family_income",
      tables = c("B19101", "B19113", "B19119", "B19121", "B19125", "B19126", "B19131", "B19201", "B19202", "B19101A-I", "B19113A-I"),
      universe = "Families / Nonfamily households",
      components = c("family_brackets", "family_median", "family_median_by_size", "family_median_by_workers", "family_by_presence_of_children", "family_median_by_presence_of_children", "nonfamily_brackets", "nonfamily_median", "race_ethnicity"),
      description = "Family and nonfamily income brackets, medians by family size/workers/children, and race/ethnicity companions.",
      default_var = "fam_income"
    ),
    income_types = list(
      id = "income_types",
      category = c("Income, Earnings & Inequality"),
      title = "Income Types & Composition",
      getter = "get_acs_income_types",
      tables = c("B19051", "B19052", "B19053", "B19054", "B19055", "B19056", "B19057", "B19058", "B19059", "B19060", "B19061", "B19062"),
      universe = "Households",
      components = c("income_types", "aggregate_income"),
      description = "Household receipt of wage/salary, self-employment, interest/dividends, Social Security, SSI, public assistance, and SNAP.",
      default_var = "inc_types"
    ),
    income_inequality = list(
      id = "income_inequality",
      category = c("Income, Earnings & Inequality"),
      title = "Income Inequality & Distribution",
      getter = "get_acs_income_inequality",
      tables = c("B19083", "B19080", "B19081", "B19082", "B19301", "B19301A-I", "B19313"),
      universe = "Households / Total population",
      components = c("gini", "quintile_limits", "quintile_shares", "per_capita", "per_capita_race", "aggregate_income"),
      description = "Gini index of income inequality, household income quintile limits, shares of aggregate income, and per capita income.",
      default_var = "inequality"
    ),
    individual_income = list(
      id = "individual_income",
      category = c("Income, Earnings & Inequality"),
      title = "Individual Income & Earnings",
      getter = "get_acs_individual_income",
      tables = c("B20001", "B20002", "B20005", "B20017", "B20017A-I", "B19325", "B19326"),
      universe = "Population 15 years and over",
      components = c("income_by_sex", "median_income", "earnings_by_sex_work_exp", "median_earnings", "median_earnings_race", "median_by_work_exp_sex", "aggregate_wage_by_sex"),
      description = "Individual income and earnings distributions, medians by sex, work experience (full-time/year-round), and race/ethnicity.",
      default_var = "ind_income"
    ),

    # --- Education ---
    school_enrollment = list(
      id = "school_enrollment",
      category = c("Education"),
      title = "School Enrollment & Level",
      getter = "get_acs_school_enrollment",
      tables = c("B14001", "B14002", "B14003", "B14004", "B14005", "B14006", "B14007"),
      universe = "Population 3 years and over",
      components = c("enrollment_level", "enrollment_by_sex_age", "public_private", "private_by_sex_age", "youth_employment_status", "poverty_status", "race_ethnicity"),
      description = "Enrollment by level (nursery through graduate), public vs. private school, youth enrollment & employment, and poverty.",
      default_var = "enrollment"
    ),
    educational_attainment = list(
      id = "educational_attainment",
      category = c("Education"),
      title = "Educational Attainment",
      getter = "get_acs_educational_attainment",
      tables = c("B15001", "B15002", "B15003", "B15002A-I"),
      universe = "Population 18/25 years and over",
      components = c("attainment_by_age_sex", "attainment_25_plus", "attainment_detailed", "race_ethnicity"),
      description = "Detailed 24-category educational attainment, attainment by age and sex, and race/ethnicity companions.",
      default_var = "attainment"
    ),
    field_of_degree = list(
      id = "field_of_degree",
      category = c("Education"),
      title = "Undergraduate Field of Degree & Earnings",
      getter = "get_acs_field_of_degree",
      tables = c("B15010", "B15011", "B15012", "B15013", "B15014"),
      universe = "Civilian employed / Bachelor's degree holders 25 years and over",
      components = c("field_first_major", "field_by_sex_age", "field_earnings", "field_earnings_full_time", "field_by_occupation"),
      description = "Undergraduate majors (STEM, Business, Education, Humanities, etc.), median earnings by field, and occupation cross-tabs.",
      default_var = "field_degree"
    ),

    # --- Commuting & Migration ---
    commuting = list(
      id = "commuting",
      category = c("Commuting & Migration"),
      title = "Means of Transportation to Work",
      getter = "get_acs_commuting",
      tables = c("B08301"),
      universe = "Workers 16 years and over",
      components = c("commuting"),
      description = "Means of transportation to work (car, public transit, walk, bicycle, work from home, etc.).",
      default_var = "commuting"
    ),
    commuting_travel_time = list(
      id = "commuting_travel_time",
      category = c("Commuting & Migration"),
      title = "Commute Travel Time & Departure Time",
      getter = "get_acs_commuting_travel_time",
      tables = c("B08303", "B08013", "B08134", "B08136", "B08302", "B08132"),
      universe = "Workers 16 years and over who did not work from home",
      components = c("travel_time_brackets", "aggregate_travel_time", "mean_travel_time", "travel_time_by_means", "departure_time", "departure_time_by_means"),
      description = "Travel time to work brackets, aggregate/mean travel time, travel time by transit mode, and departure time to work.",
      default_var = "travel_time"
    ),
    place_of_work = list(
      id = "place_of_work",
      category = c("Commuting & Migration"),
      title = "Place of Work Geography",
      getter = "get_acs_place_of_work",
      tables = c("B08007", "B08008", "B08009", "B08406"),
      universe = "Workers 16 years and over",
      components = c("place_of_work_state_county", "place_of_work_place", "place_of_work_msa", "work_in_pmsa_by_means"),
      description = "Work in state/county of residence vs. outside, worked in place of residence, and metropolitan area commuting flow.",
      default_var = "place_work"
    ),
    commuting_characteristics = list(
      id = "commuting_characteristics",
      category = c("Commuting & Migration"),
      title = "Commuting Characteristics by Demographics",
      getter = "get_acs_commuting_characteristics",
      tables = c("B08101", "B08105A-I", "B08121", "B08122", "B08124", "B08126", "B08128", "B08141", "B08201", "B08203"),
      universe = "Workers 16 years and over",
      components = c("means_by_age_sex", "means_by_race_ethnicity", "median_earnings_by_means", "means_by_poverty_status", "means_by_occupation", "means_by_industry", "means_by_class_of_worker", "vehicles_by_workers", "household_vehicles_size", "household_vehicles_workers"),
      description = "Transportation mode crossed by age, sex, race, earnings, poverty, occupation, industry, and vehicle availability.",
      default_var = "commute_char"
    ),
    migration_current = list(
      id = "migration_current",
      category = c("Commuting & Migration"),
      title = "Geographical Mobility (Current Residence)",
      getter = "get_acs_migration_current",
      tables = c("B07001", "B07001A-I", "B07003", "B07008", "B07009", "B07010", "B07011", "B07012", "B07013"),
      universe = "Population 1 year and over",
      components = c("mobility_by_age", "mobility_by_race_ethnicity", "mobility_by_sex_age", "mobility_by_household_type", "mobility_by_educational_attainment", "mobility_by_individual_income", "mobility_by_median_income", "mobility_by_poverty_status", "mobility_by_tenure"),
      description = "Same house, moved within same county, moved from different county/state/abroad by age, race, education, income, and housing tenure.",
      default_var = "mig_current"
    ),
    migration_prior = list(
      id = "migration_prior",
      category = c("Commuting & Migration"),
      title = "Geographical Mobility (Residence 1 Year Ago)",
      getter = "get_acs_migration_prior",
      tables = c("B07401", "B07401A-I", "B07403", "B07408", "B07409", "B07410", "B07411", "B07412", "B07413"),
      universe = "Population 1 year and over in the US 1 year ago",
      components = c("mobility_by_age", "mobility_by_race_ethnicity", "mobility_by_sex_age", "mobility_by_household_type", "mobility_by_educational_attainment", "mobility_by_individual_income", "mobility_by_median_income", "mobility_by_poverty_status", "mobility_by_tenure"),
      description = "Out-migration characteristics categorized by location of residence 1 year ago.",
      default_var = "mig_prior"
    )
  )
}
