parse_acs_topic <- function(data, parser, config) {
  if (identical(parser, "generic")) {
    return(parse_generic_table(data, config))
  }
  switch(
    parser,
    generic = parse_generic_table(data, config),
    # Core & Demographic Parsers
    employment = parse_employment_data(data, config),
    occupation = parse_occupation_data(data, config),
    occupation_race = parse_occupation_race_data(data, config),

    # Detailed Employment Parsers
    detailed_employment_status = parse_detailed_employment_status_data(data, config),
    detailed_employment_age_sex = parse_detailed_employment_age_sex_data(data, config),
    detailed_employment_race = parse_detailed_employment_race_data(data, config),
    detailed_employment_education = parse_detailed_employment_education_data(data, config),
    detailed_employment_poverty_disability = parse_detailed_employment_poverty_disability_data(data, config),
    detailed_employment_seniors = parse_detailed_employment_seniors_data(data, config),

    # Work Experience Parsers
    work_experience_hours_weeks = parse_work_experience_hours_weeks_data(data, config),
    work_experience_full_time = parse_work_experience_full_time_data(data, config),
    work_experience_summary = parse_work_experience_summary_data(data, config),

    # Family Employment Parsers
    family_employment_children = parse_family_employment_children_data(data, config),
    family_employment_females = parse_family_employment_females_data(data, config),
    family_employment_types = parse_family_employment_types_data(data, config),
    family_employment_workers = parse_family_employment_workers_data(data, config),

    # Industry Parsers
    industry_counts = parse_industry_counts_data(data, config),
    industry_earnings = parse_industry_earnings_data(data, config),
    industry_by_occupation = ,
    industry_occupation = parse_industry_by_occupation_data(data, config),
    industry_by_class = ,
    industry_class = parse_industry_by_class_data(data, config),

    # Class of Worker Parsers
    class_of_worker_counts = parse_class_of_worker_counts_data(data, config),
    class_earnings = parse_class_earnings_data(data, config),
    class_by_occupation = ,
    class_occupation = parse_class_by_occupation_data(data, config),

    # Occupation Detailed Parsers
    occupation_detailed_counts = parse_occupation_detailed_counts_data(data, config),
    occupation_earnings = parse_occupation_earnings_data(data, config),

    # National Detailed Parsers
    national_detailed_occupation = parse_national_detailed_occupation_data(data, config),
    national_detailed_industry = parse_national_detailed_industry_data(data, config),

    # Income Parsers
    household_income_brackets = parse_household_income_brackets_data(data, config),
    household_income_median = parse_household_income_median_data(data, config),
    household_income_size = parse_household_income_size_data(data, config),
    household_income_age = parse_household_income_age_data(data, config),
    family_income_brackets = parse_family_income_brackets_data(data, config),
    family_income_median = parse_family_income_median_data(data, config),
    family_income_children = parse_family_income_children_data(data, config),
    nonfamily_income_brackets = parse_nonfamily_income_brackets_data(data, config),
    nonfamily_income_median = parse_nonfamily_income_median_data(data, config),
    income_types_counts = parse_income_types_counts_data(data, config),
    income_types_aggregates = parse_income_types_aggregates_data(data, config),
    income_inequality_gini = parse_income_inequality_gini_data(data, config),
    income_quintiles_limits = parse_income_quintiles_limits_data(data, config),
    income_quintiles_means = parse_income_quintiles_means_data(data, config),
    income_quintiles_shares = parse_income_quintiles_shares_data(data, config),
    per_capita_income = parse_per_capita_income_data(data, config),
    aggregate_income = parse_aggregate_income_data(data, config),
    individual_earnings_brackets = parse_individual_earnings_brackets_data(data, config),
    individual_earnings_median = parse_individual_earnings_median_data(data, config),
    individual_earnings_aggregate = parse_individual_earnings_aggregate_data(data, config),
    individual_earnings_work_exp = parse_individual_earnings_work_exp_data(data, config),
    individual_earnings_median_work_exp = parse_individual_earnings_median_work_exp_data(data, config),
    individual_income_brackets = parse_individual_income_brackets_data(data, config),
    individual_income_median = parse_individual_income_median_data(data, config),

    # Education Parsers
    school_enrollment_level = parse_school_enrollment_level_data(data, config),
    school_enrollment_detailed = parse_school_enrollment_detailed_data(data, config),
    school_enrollment_type = parse_school_enrollment_type_data(data, config),
    school_enrollment_age = parse_school_enrollment_age_data(data, config),
    college_enrollment_age = parse_college_enrollment_age_data(data, config),
    youth_enrollment_employment = parse_youth_enrollment_employment_data(data, config),
    school_enrollment_poverty = parse_school_enrollment_poverty_data(data, config),
    educational_attainment_age_sex = parse_educational_attainment_age_sex_data(data, config),
    educational_attainment_sex = parse_educational_attainment_sex_data(data, config),
    educational_attainment_detailed = parse_educational_attainment_detailed_data(data, config),
    field_of_degree_broad = parse_field_of_degree_broad_data(data, config),
    field_of_degree_detailed = parse_field_of_degree_detailed_data(data, config),
    field_of_degree_earnings_sex = parse_field_of_degree_earnings_sex_data(data, config),
    field_of_degree_earnings_age = parse_field_of_degree_earnings_age_data(data, config),

    # Commute Parsers
    travel_time_residence = parse_travel_time_data(data, config),
    travel_time_workplace = parse_travel_time_data(data, config),
    departure_time_residence = parse_departure_time_data(data, config),
    arrival_time_workplace = parse_arrival_time_data(data, config),
    departure_time_sex = parse_departure_time_sex_data(data, config),
    travel_time_sex = parse_travel_time_sex_data(data, config),
    travel_time_mode = parse_travel_time_mode_data(data, config),
    departure_time_mode = parse_departure_time_mode_data(data, config),
    arrival_time_mode = parse_arrival_time_mode_data(data, config),
    aggregate_travel_time_mode = parse_aggregate_travel_time_mode_data(data, config),
    aggregate_travel_time_sex = parse_aggregate_travel_time_sex_data(data, config),
    aggregate_travel_time_place = parse_aggregate_travel_time_place_data(data, config),
    aggregate_travel_time_travel_time = parse_aggregate_travel_time_travel_time_data(data, config),
    place_of_work_sex = parse_place_of_work_sex_data(data, config),
    place_of_work_msa = parse_place_of_work_msa_data(data, config),
    workplace_worker_pop = parse_workplace_worker_pop_data(data, config),
    commuting_cross_age = parse_commuting_cross_age_data(data, config),
    commuting_median_age = parse_commuting_median_age_data(data, config),
    commuting_race = parse_commuting_race_data(data, config),
    commuting_cross_earnings = parse_commuting_cross_earnings_data(data, config),
    stop("Unknown ACS parser: ", parser, call. = FALSE)
  )
}

parse_generic_table <- function(data, config) {
  schema <- config$schema
  if (is.null(schema)) {
    stop("No schema defined for generic parser in table config.", call. = FALSE)
  }

  tokens <- acs_label_tokens(data$label)

  # 1. Race / Ethnicity Suffix handling
  if (isTRUE(schema$race_suffix)) {
    race <- parse_income_race_suffix(data$table[[1]])
    data$race_ethnicity <- if (!is.na(race)) race else NA_character_
    if (!is.na(race) && !is.null(schema$race_universe_fmt)) {
      data$universe <- sprintf(schema$race_universe_fmt, race)
    } else if (!is.na(race)) {
      data$universe <- paste0(race, " population")
    } else {
      data$universe <- config$universe
    }
  } else {
    data$universe <- config$universe
    if ("race_ethnicity" %in% (schema$key_cols %||% character())) {
      data$race_ethnicity <- NA_character_
    }
  }

  # 2. Measures and units
  data$measure <- schema$measure %||% "population"
  data$unit <- schema$unit %||% "count"

  # 3. Process positional level columns
  if (!is.null(schema$levels)) {
    level_cols <- names(schema$levels)
    has_sex_col <- "sex" %in% level_cols

    for (col in level_cols) {
      spec <- schema$levels[[col]]

      if (col == "sex") {
        tok_val <- token_at(tokens, spec)
        data$sex <- dplyr::case_when(
          tok_val == "Male" ~ "Male",
          tok_val == "Female" ~ "Female",
          TRUE ~ "Total"
        )
      } else if (isTRUE(schema$sex_cross) && has_sex_col) {
        sex_pos <- schema$levels[["sex"]]
        sex_tok <- token_at(tokens, sex_pos)
        detail_tok <- token_at(tokens, spec)

        data[[col]] <- dplyr::case_when(
          sex_tok %in% c("Male", "Female") & !is.na(detail_tok) ~ detail_tok,
          !sex_tok %in% c("Male", "Female") & !is.na(sex_tok) ~ sex_tok,
          TRUE ~ "Total"
        )
      } else {
        tok_val <- token_at(tokens, spec)
        default_val <- if (is.character(schema$default_level)) schema$default_level else "Total"
        data[[col]] <- dplyr::if_else(!is.na(tok_val), tok_val, default_val)
      }
    }
  }

  # 4. Process category token column
  cat_col <- schema$category_col %||% schema$leaf_col
  if (!is.null(cat_col)) {
    start_pos <- schema$category_start_level %||% schema$leaf_start %||% 1L
    cat_tok <- deepest_token(tokens, start = start_pos)
    default_cat <- schema$default_category %||% schema$default_leaf %||% "Total"
    data[[cat_col]] <- dplyr::if_else(!is.na(cat_tok), cat_tok, default_cat)
  }

  # 5. Metadata defaults
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  # 6. Share derivation
  shares_enabled <- if (!is.null(schema$shares)) schema$shares else isTRUE(config$shares)
  if (shares_enabled) {
    denominator <- schema$denominator %||% paste0(data$table, "_001")
    share_measure <- schema$share_measure %||% "share"
    data <- add_share_rows(
      data,
      rep(TRUE, nrow(data)),
      denominator,
      share_measure = share_measure
    )
  }

  # 7. Finalize column ordering and sorting keys
  key_cols <- schema$key_cols %||% c(
    if (isTRUE(schema$race_suffix)) "race_ethnicity",
    names(schema$levels),
    cat_col
  )
  key_cols <- unique(key_cols[key_cols %in% names(data)])

  finalize_acs_data(data, key_cols)
}



employment_characteristics <- function(tokens) {
  headers <- c(
    "AGE", "RACE AND HISPANIC OR LATINO ORIGIN", "SEX",
    "POVERTY STATUS IN THE PAST 12 MONTHS", "DISABILITY STATUS",
    "EDUCATIONAL ATTAINMENT"
  )
  type_names <- c(
    AGE = "age",
    `RACE AND HISPANIC OR LATINO ORIGIN` = "race_ethnicity",
    SEX = "sex",
    `POVERTY STATUS IN THE PAST 12 MONTHS` = "poverty_status",
    `DISABILITY STATUS` = "disability_status",
    `EDUCATIONAL ATTAINMENT` = "educational_attainment"
  )

  purrr::map(tokens, function(x) {
    index <- match(headers, x, nomatch = 0L)
    index <- index[index > 0L]
    if (!length(index)) {
      return(list(type = "total", value = "Total", detail = NA_character_))
    }
    header_index <- index[[1]]
    value_index <- header_index + 1L
    if (length(x) >= value_index && stringr::str_detect(x[[value_index]], "^Population")) {
      value_index <- value_index + 1L
    }
    value <- if (length(x) >= value_index) x[[value_index]] else "Total"
    detail <- if (length(x) > value_index) x[[length(x)]] else NA_character_
    list(type = unname(type_names[x[[header_index]]]), value = value, detail = detail)
  })
}

parse_employment_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  code <- stringr::str_extract(data$variable, "C\\d{2}")
  characteristics <- employment_characteristics(tokens)

  data$universe <- purrr::map_chr(tokens, function(x) {
    match <- x[stringr::str_detect(x, "^Population ")]
    if (length(match)) match[[1]] else config$universe
  })
  data$measure <- unname(c(
    C01 = "population",
    C02 = "labor_force_participation_rate",
    C03 = "employment_population_ratio",
    C04 = "unemployment_rate"
  )[code])
  data$unit <- ifelse(code == "C01", "count", "percent")
  data$characteristic_type <- purrr::map_chr(characteristics, "type")
  data$characteristic <- purrr::map_chr(characteristics, "value")
  data$detail <- purrr::map_chr(characteristics, "detail", .default = NA_character_)
  data$value_source <- "published"

  finalize_acs_data(data, c("characteristic_type", "characteristic", "detail"))
}

parse_occupation_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  code <- stringr::str_extract(data$variable, "C\\d{2}")
  hierarchy <- purrr::map(tokens, function(x) if (length(x) > 2L) x[3:length(x)] else character())

  data$universe <- config$universe
  data$sex <- unname(c(C01 = "Total", C02 = "Male", C03 = "Male", C04 = "Female", C05 = "Female")[code])
  data$measure <- ifelse(code %in% c("C01", "C02", "C04"), "employment", "sex_share")
  data$unit <- ifelse(data$measure == "employment", "count", "percent")
  data$occupation_major <- token_at(hierarchy, 1L)
  data$occupation_intermediate <- token_at(hierarchy, 2L)
  data$occupation_detail <- token_at(hierarchy, 3L)
  data$occupation <- deepest_token(hierarchy)
  data$occupation[is.na(data$occupation)] <- "All occupations"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  eligible <- config$shares & code %in% c("C01", "C02", "C04")
  denominator <- paste0(data$table, "_", code, "_001")
  data <- add_share_rows(
    data,
    eligible,
    denominator,
    share_measure = "share_of_sex_employment"
  )
  finalize_acs_data(
    data,
    c("sex", "occupation", "occupation_major", "occupation_intermediate", "occupation_detail")
  )
}

parse_occupation_race_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  second <- token_at(tokens, 2L)
  hierarchy <- purrr::map(
    tokens,
    function(x) if (length(x) > 2L) x[3:length(x)] else character()
  )

  race_labels <- c(
    A = "White alone",
    B = "Black or African American alone",
    C = "American Indian and Alaska Native alone",
    D = "Asian alone",
    E = "Native Hawaiian and Other Pacific Islander alone",
    F = "Some other race alone",
    G = "Two or more races",
    H = "White alone, not Hispanic or Latino",
    I = "Hispanic or Latino"
  )
  suffix <- stringr::str_match(data$table, "^[BC]24010([A-I])$")[, 2]

  data$race_ethnicity <- unname(race_labels[suffix])
  data$universe <- paste0(
    data$race_ethnicity,
    " civilian employed population 16 years and over"
  )
  data$sex <- dplyr::case_when(
    second == "Male" ~ "Male",
    second == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$measure <- "employment"
  data$unit <- "count"
  data$occupation_major <- token_at(hierarchy, 1L)
  data$occupation_intermediate <- token_at(hierarchy, 2L)
  data$occupation_detail <- token_at(hierarchy, 3L)
  data$occupation <- deepest_token(hierarchy)
  data$occupation[is.na(data$occupation)] <- "All occupations"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_
  data$source_variables <- NA_character_

  occupation_key <- paste(
    data$GEOID, data$table, data$occupation_major,
    data$occupation_intermediate, data$occupation_detail, data$occupation,
    sep = "\r"
  )
  male_index <- which(data$sex == "Male" & data$occupation != "All occupations")
  female_lookup <- stats::setNames(
    which(data$sex == "Female" & data$occupation != "All occupations"),
    occupation_key[data$sex == "Female" & data$occupation != "All occupations"]
  )
  female_index <- unname(female_lookup[occupation_key[male_index]])
  matched <- !is.na(female_index)

  if (any(matched)) {
    male_index <- male_index[matched]
    female_index <- female_index[matched]
    totals <- data[male_index, , drop = FALSE]
    totals$estimate <- data$estimate[male_index] + data$estimate[female_index]
    totals$moe <- sqrt(data$moe[male_index]^2 + data$moe[female_index]^2)
    totals$sex <- "Total"
    totals$source_variables <- paste(
      data$variable[male_index], data$variable[female_index], sep = ";"
    )
    totals$variable <- paste0("derived:", totals$source_variables)
    totals$label <- paste0("Derived!!Total!!", totals$occupation)
    totals$value_source <- "derived"
    data <- dplyr::bind_rows(data, totals)
  }

  root_rows <- data$occupation == "All occupations"
  denominator_lookup <- stats::setNames(
    data$variable[root_rows],
    paste(data$table[root_rows], data$sex[root_rows], sep = "\r")
  )
  denominator <- unname(
    denominator_lookup[paste(data$table, data$sex, sep = "\r")]
  )

  data <- add_share_rows(
    data,
    eligible = config$shares & !is.na(denominator),
    denominator_variable = denominator,
    share_measure = "share_of_race_sex_employment"
  )
  finalize_acs_data(
    data,
    c(
      "race_ethnicity", "sex", "occupation", "occupation_major",
      "occupation_intermediate", "occupation_detail"
    )
  )
}



# ------------------------------------------------------------------------------
# Detailed Employment Parsers
# ------------------------------------------------------------------------------

parse_detailed_employment_status_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  data$labor_force_status <- purrr::map_chr(tokens, function(x) {
    if (length(x) <= 1L) "Total"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else if ("In labor force" %in% x) "In labor force"
    else "Total"
  })

  data$civilian_status <- purrr::map_chr(tokens, function(x) {
    if ("Civilian labor force" %in% x) "Civilian labor force"
    else if ("Armed Forces" %in% x) "Armed Forces"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else "Total"
  })

  data$employment_status <- purrr::map_chr(tokens, function(x) {
    if ("Employed" %in% x) "Employed"
    else if ("Unemployed" %in% x) "Unemployed"
    else if ("Armed Forces" %in% x) "Armed Forces"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else "Total"
  })

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("labor_force_status", "civilian_status", "employment_status"))
}

parse_detailed_employment_age_sex_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)

  data$sex <- dplyr::case_when(
    second == "Male" ~ "Male",
    second == "Female" ~ "Female",
    TRUE ~ "Total"
  )

  data$age_group <- dplyr::if_else(!is.na(third), third, "Total")

  data$labor_force_status <- purrr::map_chr(tokens, function(x) {
    if (length(x) <= 3L) "Total"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else if ("In labor force" %in% x) "In labor force"
    else "Total"
  })

  data$employment_status <- purrr::map_chr(tokens, function(x) {
    if ("Employed" %in% x) "Employed"
    else if ("Unemployed" %in% x) "Unemployed"
    else if ("Armed Forces" %in% x) "Armed Forces"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else "Total"
  })

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "age_group", "labor_force_status", "employment_status"))
}

parse_detailed_employment_race_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race_labels <- c(
    A = "White alone",
    B = "Black or African American alone",
    C = "American Indian and Alaska Native alone",
    D = "Asian alone",
    E = "Native Hawaiian and Other Pacific Islander alone",
    F = "Some other race alone",
    G = "Two or more races",
    H = "White alone, not Hispanic or Latino",
    I = "Hispanic or Latino"
  )
  suffix <- stringr::str_match(data$table, "^[BC]23002([A-I])$")[, 2]
  data$race_ethnicity <- unname(race_labels[suffix])
  data$universe <- paste0(data$race_ethnicity, " population 16 years and over")
  data$measure <- "population"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)

  data$sex <- dplyr::case_when(
    second == "Male" ~ "Male",
    second == "Female" ~ "Female",
    TRUE ~ "Total"
  )

  data$age_group <- dplyr::if_else(!is.na(third), third, "Total")

  data$labor_force_status <- purrr::map_chr(tokens, function(x) {
    if (length(x) <= 3L) "Total"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else if ("In labor force" %in% x) "In labor force"
    else "Total"
  })

  data$employment_status <- purrr::map_chr(tokens, function(x) {
    if ("Employed" %in% x) "Employed"
    else if ("Unemployed" %in% x) "Unemployed"
    else if ("Armed Forces" %in% x) "Armed Forces"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else "Total"
  })

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("race_ethnicity", "sex", "age_group", "labor_force_status", "employment_status"))
}

parse_detailed_employment_education_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  data$educational_attainment <- dplyr::if_else(!is.na(second), second, "Total")

  data$labor_force_status <- purrr::map_chr(tokens, function(x) {
    if (length(x) <= 2L) "Total"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else if ("In labor force" %in% x) "In labor force"
    else "Total"
  })

  data$employment_status <- purrr::map_chr(tokens, function(x) {
    if ("Employed" %in% x) "Employed"
    else if ("Unemployed" %in% x) "Unemployed"
    else if ("Armed Forces" %in% x) "Armed Forces"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else "Total"
  })

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("educational_attainment", "labor_force_status", "employment_status"))
}

parse_detailed_employment_poverty_disability_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)

  data$poverty_status <- dplyr::if_else(!is.na(second), second, "Total")
  data$disability_status <- dplyr::if_else(!is.na(third), third, "Total")

  data$labor_force_status <- purrr::map_chr(tokens, function(x) {
    if (length(x) <= 3L) "Total"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else if ("In labor force" %in% x) "In labor force"
    else "Total"
  })

  data$employment_status <- purrr::map_chr(tokens, function(x) {
    if ("Employed" %in% x) "Employed"
    else if ("Unemployed" %in% x) "Unemployed"
    else if ("Armed Forces" %in% x) "Armed Forces"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else "Total"
  })

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("poverty_status", "disability_status", "labor_force_status", "employment_status"))
}

parse_detailed_employment_seniors_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  data$work_status_past_year <- dplyr::if_else(!is.na(second), second, "Total")

  data$labor_force_status <- purrr::map_chr(tokens, function(x) {
    if (length(x) <= 2L) "Total"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else if ("In labor force" %in% x) "In labor force"
    else "Total"
  })

  data$employment_status <- purrr::map_chr(tokens, function(x) {
    if ("Employed" %in% x) "Employed"
    else if ("Unemployed" %in% x) "Unemployed"
    else if ("Armed Forces" %in% x) "Armed Forces"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else "Total"
  })

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("work_status_past_year", "labor_force_status", "employment_status"))
}

# ------------------------------------------------------------------------------
# Work Experience & Hours Parsers
# ------------------------------------------------------------------------------

parse_work_experience_hours_weeks_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  data$sex <- dplyr::case_when(
    second == "Male" ~ "Male",
    second == "Female" ~ "Female",
    TRUE ~ "Total"
  )

  data$work_status <- purrr::map_chr(tokens, function(x) {
    match <- x[stringr::str_detect(x, stringr::regex("work(ed)? in the past 12 months", ignore_case = TRUE))]
    if (length(match)) match[[1]] else "Total"
  })

  data$hours_per_week <- purrr::map_chr(tokens, function(x) {
    match <- x[stringr::str_detect(x, stringr::regex("hours per week", ignore_case = TRUE))]
    if (length(match)) match[[1]] else "Total"
  })

  data$weeks_worked <- purrr::map_chr(tokens, function(x) {
    match <- x[stringr::str_detect(x, stringr::regex("weeks$", ignore_case = TRUE))]
    if (length(match)) match[[1]] else "Total"
  })

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "work_status", "hours_per_week", "weeks_worked"))
}

parse_work_experience_full_time_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)

  data$age_group <- dplyr::if_else(!is.na(second), second, "Total")
  data$work_status <- dplyr::if_else(!is.na(third), third, "Total")

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("age_group", "work_status"))
}

parse_work_experience_summary_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  second <- token_at(tokens, 2L)

  data$universe <- config$universe
  data$sex <- dplyr::case_when(
    second == "Male" ~ "Male",
    second == "Female" ~ "Female",
    TRUE ~ "Total"
  )

  data$measure <- dplyr::case_when(
    data$table == "B23018" ~ "aggregate_usual_hours",
    data$table == "B23020" ~ "mean_usual_hours",
    data$table == "B23013" ~ "median_age",
    TRUE ~ "estimate"
  )
  data$unit <- dplyr::case_when(
    data$table %in% c("B23018", "B23020") ~ "hours",
    data$table == "B23013" ~ "years",
    TRUE ~ "count"
  )
  data$value_source <- "published"
  finalize_acs_data(data, c("sex"))
}

# ------------------------------------------------------------------------------
# Family & Child Employment Parsers
# ------------------------------------------------------------------------------

parse_family_employment_children_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "children"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)
  fourth <- token_at(tokens, 4L)

  data$child_age_group <- dplyr::if_else(!is.na(second), second, "Total")
  data$living_arrangement <- dplyr::if_else(!is.na(third), third, "Total")
  data$parental_employment_status <- dplyr::if_else(!is.na(fourth), fourth, "Total")

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("child_age_group", "living_arrangement", "parental_employment_status"))
}

parse_family_employment_females_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$sex <- "Female"
  data$measure <- "population"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  data$children_age_group <- dplyr::if_else(!is.na(second), second, "Total")

  data$labor_force_status <- purrr::map_chr(tokens, function(x) {
    if (length(x) <= 2L) "Total"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else if ("In labor force" %in% x) "In labor force"
    else "Total"
  })

  data$employment_status <- purrr::map_chr(tokens, function(x) {
    if ("Employed" %in% x) "Employed"
    else if ("Unemployed" %in% x) "Unemployed"
    else if ("Armed Forces" %in% x) "Armed Forces"
    else if ("Not in labor force" %in% x) "Not in labor force"
    else "Total"
  })

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "children_age_group", "labor_force_status", "employment_status"))
}

parse_family_employment_types_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "children"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)
  fourth <- token_at(tokens, 4L)

  data$family_type <- dplyr::if_else(!is.na(second), second, "Total")
  data$children_age_group <- dplyr::if_else(!is.na(third), third, "Total")
  data$parent_labor_force_status <- dplyr::if_else(!is.na(fourth), fourth, "Total")

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("family_type", "children_age_group", "parent_labor_force_status"))
}

parse_family_employment_workers_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "families"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)
  fourth <- token_at(tokens, 4L)

  data$family_type <- dplyr::case_when(
    data$table == "B23010" ~ "Married-couple families",
    !is.na(second) ~ second,
    TRUE ~ "Total"
  )
  data$children_presence <- dplyr::case_when(
    data$table == "B23010" & !is.na(second) ~ second,
    !is.na(third) ~ third,
    TRUE ~ "Total"
  )
  data$workers_in_family <- dplyr::case_when(
    data$table == "B23010" & !is.na(third) ~ third,
    !is.na(fourth) ~ fourth,
    TRUE ~ "Total"
  )
  data$detail <- deepest_token(tokens, start = 2L)

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("family_type", "children_presence", "workers_in_family", "detail"))
}

# ------------------------------------------------------------------------------
# Industry Parsers
# ------------------------------------------------------------------------------

parse_industry_counts_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  second <- token_at(tokens, 2L)
  hierarchy <- purrr::map(tokens, function(x) if (length(x) > 2L) x[3:length(x)] else character())

  data$universe <- config$universe
  data$sex <- dplyr::case_when(
    second == "Male" ~ "Male",
    second == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$work_status <- ifelse(
    stringr::str_starts(data$table, "^[BC]24040"),
    "full_time_year_round",
    "all"
  )
  data$measure <- "employment"
  data$unit <- "count"
  data$industry_major <- token_at(hierarchy, 1L)
  data$industry_detail <- token_at(hierarchy, 2L)
  data$industry <- deepest_token(hierarchy)
  data$industry[is.na(data$industry)] <- "All industries"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  industry_key <- paste(
    data$GEOID, data$table, data$work_status, data$industry_major,
    data$industry_detail, data$industry, sep = "\r"
  )
  male_index <- which(data$sex == "Male" & data$industry != "All industries")
  female_lookup <- stats::setNames(
    which(data$sex == "Female" & data$industry != "All industries"),
    industry_key[data$sex == "Female" & data$industry != "All industries"]
  )
  female_index <- unname(female_lookup[industry_key[male_index]])
  matched <- !is.na(female_index)

  if (any(matched)) {
    male_index <- male_index[matched]
    female_index <- female_index[matched]
    totals <- data[male_index, , drop = FALSE]
    totals$estimate <- data$estimate[male_index] + data$estimate[female_index]
    totals$moe <- sqrt(data$moe[male_index]^2 + data$moe[female_index]^2)
    totals$sex <- "Total"
    totals$source_variables <- paste(data$variable[male_index], data$variable[female_index], sep = ";")
    totals$variable <- paste0("derived:", totals$source_variables)
    totals$label <- paste0("Derived!!Total!!", totals$industry)
    totals$value_source <- "derived"
    data <- dplyr::bind_rows(data, totals)
  }

  root_rows <- data$industry == "All industries"
  denominator_lookup <- stats::setNames(
    data$variable[root_rows],
    paste(data$table[root_rows], data$sex[root_rows], sep = "\r")
  )
  denominator <- unname(
    denominator_lookup[paste(data$table, data$sex, sep = "\r")]
  )

  data <- add_share_rows(
    data,
    eligible = config$shares & !is.na(denominator),
    denominator_variable = denominator,
    share_measure = "share_of_industry_employment"
  )
  finalize_acs_data(data, c("sex", "work_status", "industry", "industry_major", "industry_detail"))
}

parse_industry_earnings_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$sex <- dplyr::case_when(
    first %in% c("Male", "Female") ~ first,
    second %in% c("Male", "Female") ~ second,
    TRUE ~ "Total"
  )

  hierarchy <- purrr::map(tokens, function(x) {
    if (length(x) == 0L) character()
    else if (x[[1]] %in% c("Male", "Female", "Total")) {
      if (length(x) > 1L) x[2:length(x)] else character()
    } else if (length(x) > 2L && x[[2]] %in% c("Male", "Female")) {
      x[3:length(x)]
    } else {
      if (length(x) > 1L) x[2:length(x)] else character()
    }
  })

  data$universe <- config$universe
  data$work_status <- ifelse(
    stringr::str_detect(data$table, "^[BC]2404"),
    "full_time_year_round",
    "all"
  )
  data$measure <- "median_earnings"
  data$unit <- "dollars"
  data$industry_major <- token_at(hierarchy, 1L)
  data$industry_detail <- token_at(hierarchy, 2L)
  data$industry <- deepest_token(hierarchy)
  data$industry[is.na(data$industry)] <- "All industries"
  data$value_source <- "published"

  finalize_acs_data(data, c("sex", "work_status", "industry", "industry_major", "industry_detail"))
}

parse_industry_by_occupation_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  hierarchy <- purrr::map(tokens, function(x) if (length(x) > 1L) x[2:length(x)] else character())
  occ_majors <- c(
    "Management, business, science, and arts occupations",
    "Service occupations",
    "Sales and office occupations",
    "Natural resources, construction, and maintenance occupations",
    "Production, transportation, and material moving occupations"
  )

  parsed_dims <- purrr::map(hierarchy, function(h) {
    if (length(h) == 0L) {
      return(list(
        industry_major = "All industries", industry = "All industries",
        occupation_major = "All occupations", occupation = "All occupations"
      ))
    }
    occ_idx <- which(h %in% occ_majors | stringr::str_detect(h, "occupations$"))
    if (length(occ_idx) > 0L) {
      first_occ <- occ_idx[[1]]
      ind_tokens <- if (first_occ > 1L) h[1:(first_occ - 1L)] else character()
      occ_tokens <- h[first_occ:length(h)]
    } else {
      ind_tokens <- h
      occ_tokens <- character()
    }
    list(
      industry_major = if (length(ind_tokens) >= 1L) ind_tokens[[1]] else "All industries",
      industry = if (length(ind_tokens) >= 1L) ind_tokens[[length(ind_tokens)]] else "All industries",
      occupation_major = if (length(occ_tokens) >= 1L) occ_tokens[[1]] else "All occupations",
      occupation = if (length(occ_tokens) >= 1L) occ_tokens[[length(occ_tokens)]] else "All occupations"
    )
  })

  data$universe <- config$universe
  data$measure <- "employment"
  data$unit <- "count"
  data$industry_major <- purrr::map_chr(parsed_dims, "industry_major")
  data$industry <- purrr::map_chr(parsed_dims, "industry")
  data$occupation_major <- purrr::map_chr(parsed_dims, "occupation_major")
  data$occupation <- purrr::map_chr(parsed_dims, "occupation")
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("industry_major", "industry", "occupation_major", "occupation"))
}

parse_industry_by_class_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  hierarchy <- purrr::map(tokens, function(x) if (length(x) > 1L) x[2:length(x)] else character())
  class_pattern <- "(?i)wage and salary workers|government workers|self-employed|unpaid family"

  parsed_dims <- purrr::map(hierarchy, function(h) {
    if (length(h) == 0L) {
      return(list(
        industry_major = "All industries", industry = "All industries",
        class_of_worker = "All classes of worker"
      ))
    }
    class_idx <- which(stringr::str_detect(h, class_pattern))
    if (length(class_idx) > 0L) {
      first_class <- class_idx[[1]]
      ind_tokens <- if (first_class > 1L) h[1:(first_class - 1L)] else character()
      class_tokens <- h[first_class:length(h)]
    } else {
      ind_tokens <- h
      class_tokens <- character()
    }
    list(
      industry_major = if (length(ind_tokens) >= 1L) ind_tokens[[1]] else "All industries",
      industry = if (length(ind_tokens) >= 1L) ind_tokens[[length(ind_tokens)]] else "All industries",
      class_of_worker = if (length(class_tokens) >= 1L) class_tokens[[length(class_tokens)]] else "All classes of worker"
    )
  })

  data$universe <- config$universe
  data$measure <- "employment"
  data$unit <- "count"
  data$industry_major <- purrr::map_chr(parsed_dims, "industry_major")
  data$industry <- purrr::map_chr(parsed_dims, "industry")
  data$class_of_worker <- purrr::map_chr(parsed_dims, "class_of_worker")
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("industry_major", "industry", "class_of_worker"))
}

# ------------------------------------------------------------------------------
# Class of Worker Parsers
# ------------------------------------------------------------------------------

parse_class_of_worker_counts_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  second <- token_at(tokens, 2L)
  hierarchy <- purrr::map(tokens, function(x) if (length(x) > 2L) x[3:length(x)] else character())

  data$universe <- config$universe
  data$sex <- dplyr::case_when(
    second == "Male" ~ "Male",
    second == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$work_status <- ifelse(
    stringr::str_starts(data$table, "^[BC]24090"),
    "full_time_year_round",
    "all"
  )
  data$measure <- "employment"
  data$unit <- "count"
  data$class_of_worker_major <- token_at(hierarchy, 1L)
  data$class_of_worker_detail <- token_at(hierarchy, 2L)
  data$class_of_worker <- deepest_token(hierarchy)
  data$class_of_worker[is.na(data$class_of_worker)] <- "All classes of worker"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  class_key <- paste(
    data$GEOID, data$table, data$work_status, data$class_of_worker_major,
    data$class_of_worker_detail, data$class_of_worker, sep = "\r"
  )
  male_index <- which(data$sex == "Male" & data$class_of_worker != "All classes of worker")
  female_lookup <- stats::setNames(
    which(data$sex == "Female" & data$class_of_worker != "All classes of worker"),
    class_key[data$sex == "Female" & data$class_of_worker != "All classes of worker"]
  )
  female_index <- unname(female_lookup[class_key[male_index]])
  matched <- !is.na(female_index)

  if (any(matched)) {
    male_index <- male_index[matched]
    female_index <- female_index[matched]
    totals <- data[male_index, , drop = FALSE]
    totals$estimate <- data$estimate[male_index] + data$estimate[female_index]
    totals$moe <- sqrt(data$moe[male_index]^2 + data$moe[female_index]^2)
    totals$sex <- "Total"
    totals$source_variables <- paste(data$variable[male_index], data$variable[female_index], sep = ";")
    totals$variable <- paste0("derived:", totals$source_variables)
    totals$label <- paste0("Derived!!Total!!", totals$class_of_worker)
    totals$value_source <- "derived"
    data <- dplyr::bind_rows(data, totals)
  }

  root_rows <- data$class_of_worker == "All classes of worker"
  denominator_lookup <- stats::setNames(
    data$variable[root_rows],
    paste(data$table[root_rows], data$sex[root_rows], sep = "\r")
  )
  denominator <- unname(
    denominator_lookup[paste(data$table, data$sex, sep = "\r")]
  )

  data <- add_share_rows(
    data,
    eligible = config$shares & !is.na(denominator),
    denominator_variable = denominator,
    share_measure = "share_of_class_employment"
  )
  finalize_acs_data(data, c("sex", "work_status", "class_of_worker", "class_of_worker_major", "class_of_worker_detail"))
}

parse_class_earnings_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$sex <- dplyr::case_when(
    first %in% c("Male", "Female") ~ first,
    second %in% c("Male", "Female") ~ second,
    TRUE ~ "Total"
  )

  hierarchy <- purrr::map(tokens, function(x) {
    if (length(x) == 0L) character()
    else if (x[[1]] %in% c("Male", "Female", "Total")) {
      if (length(x) > 1L) x[2:length(x)] else character()
    } else if (length(x) > 2L && x[[2]] %in% c("Male", "Female")) {
      x[3:length(x)]
    } else {
      if (length(x) > 1L) x[2:length(x)] else character()
    }
  })

  data$universe <- config$universe
  data$work_status <- ifelse(
    stringr::str_detect(data$table, "^[BC]2409"),
    "full_time_year_round",
    "all"
  )
  data$measure <- "median_earnings"
  data$unit <- "dollars"
  data$class_of_worker_major <- token_at(hierarchy, 1L)
  data$class_of_worker <- deepest_token(hierarchy)
  data$class_of_worker[is.na(data$class_of_worker)] <- "All classes of worker"
  data$value_source <- "published"

  finalize_acs_data(data, c("sex", "work_status", "class_of_worker", "class_of_worker_major"))
}

parse_class_by_occupation_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  hierarchy <- purrr::map(tokens, function(x) if (length(x) > 1L) x[2:length(x)] else character())
  class_pattern <- "(?i)wage and salary workers|government workers|self-employed|unpaid family"

  parsed_dims <- purrr::map(hierarchy, function(h) {
    if (length(h) == 0L) {
      return(list(
        occupation_major = "All occupations", occupation = "All occupations",
        class_of_worker = "All classes of worker"
      ))
    }
    class_idx <- which(stringr::str_detect(h, class_pattern))
    if (length(class_idx) > 0L) {
      first_class <- class_idx[[1]]
      occ_tokens <- if (first_class > 1L) h[1:(first_class - 1L)] else character()
      class_tokens <- h[first_class:length(h)]
    } else {
      occ_tokens <- h
      class_tokens <- character()
    }
    list(
      occupation_major = if (length(occ_tokens) >= 1L) occ_tokens[[1]] else "All occupations",
      occupation = if (length(occ_tokens) >= 1L) occ_tokens[[length(occ_tokens)]] else "All occupations",
      class_of_worker = if (length(class_tokens) >= 1L) class_tokens[[length(class_tokens)]] else "All classes of worker"
    )
  })

  data$universe <- config$universe
  data$measure <- "employment"
  data$unit <- "count"
  data$occupation_major <- purrr::map_chr(parsed_dims, "occupation_major")
  data$occupation <- purrr::map_chr(parsed_dims, "occupation")
  data$class_of_worker <- purrr::map_chr(parsed_dims, "class_of_worker")
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("occupation_major", "occupation", "class_of_worker"))
}

# ------------------------------------------------------------------------------
# Occupation Detailed & Earnings Parsers
# ------------------------------------------------------------------------------

parse_occupation_detailed_counts_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  second <- token_at(tokens, 2L)
  hierarchy <- purrr::map(tokens, function(x) if (length(x) > 2L) x[3:length(x)] else character())

  data$universe <- config$universe
  data$sex <- dplyr::case_when(
    second == "Male" ~ "Male",
    second == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$work_status <- ifelse(
    stringr::str_starts(data$table, "^[BC]24020"),
    "full_time_year_round",
    "all"
  )
  data$measure <- "employment"
  data$unit <- "count"
  data$occupation_major <- token_at(hierarchy, 1L)
  data$occupation_intermediate <- token_at(hierarchy, 2L)
  data$occupation_detail <- token_at(hierarchy, 3L)
  data$occupation <- deepest_token(hierarchy)
  data$occupation[is.na(data$occupation)] <- "All occupations"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  occ_key <- paste(
    data$GEOID, data$table, data$work_status, data$occupation_major,
    data$occupation_intermediate, data$occupation_detail, data$occupation, sep = "\r"
  )
  male_index <- which(data$sex == "Male" & data$occupation != "All occupations")
  female_lookup <- stats::setNames(
    which(data$sex == "Female" & data$occupation != "All occupations"),
    occ_key[data$sex == "Female" & data$occupation != "All occupations"]
  )
  female_index <- unname(female_lookup[occ_key[male_index]])
  matched <- !is.na(female_index)

  if (any(matched)) {
    male_index <- male_index[matched]
    female_index <- female_index[matched]
    totals <- data[male_index, , drop = FALSE]
    totals$estimate <- data$estimate[male_index] + data$estimate[female_index]
    totals$moe <- sqrt(data$moe[male_index]^2 + data$moe[female_index]^2)
    totals$sex <- "Total"
    totals$source_variables <- paste(data$variable[male_index], data$variable[female_index], sep = ";")
    totals$variable <- paste0("derived:", totals$source_variables)
    totals$label <- paste0("Derived!!Total!!", totals$occupation)
    totals$value_source <- "derived"
    data <- dplyr::bind_rows(data, totals)
  }

  root_rows <- data$occupation == "All occupations"
  denominator_lookup <- stats::setNames(
    data$variable[root_rows],
    paste(data$table[root_rows], data$sex[root_rows], sep = "\r")
  )
  denominator <- unname(
    denominator_lookup[paste(data$table, data$sex, sep = "\r")]
  )

  data <- add_share_rows(
    data,
    eligible = config$shares & !is.na(denominator),
    denominator_variable = denominator,
    share_measure = "share_of_occupation_employment"
  )
  finalize_acs_data(
    data,
    c("sex", "work_status", "occupation", "occupation_major", "occupation_intermediate", "occupation_detail")
  )
}

parse_occupation_earnings_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$sex <- dplyr::case_when(
    first %in% c("Male", "Female") ~ first,
    second %in% c("Male", "Female") ~ second,
    TRUE ~ "Total"
  )

  hierarchy <- purrr::map(tokens, function(x) {
    if (length(x) == 0L) character()
    else if (x[[1]] %in% c("Male", "Female", "Total")) {
      if (length(x) > 1L) x[2:length(x)] else character()
    } else if (length(x) > 2L && x[[2]] %in% c("Male", "Female")) {
      x[3:length(x)]
    } else {
      if (length(x) > 1L) x[2:length(x)] else character()
    }
  })

  data$universe <- config$universe
  data$work_status <- ifelse(
    stringr::str_detect(data$table, "^[BC]2402"),
    "full_time_year_round",
    "all"
  )
  data$measure <- "median_earnings"
  data$unit <- "dollars"
  data$occupation_major <- token_at(hierarchy, 1L)
  data$occupation_intermediate <- token_at(hierarchy, 2L)
  data$occupation_detail <- token_at(hierarchy, 3L)
  data$occupation <- deepest_token(hierarchy)
  data$occupation[is.na(data$occupation)] <- "All occupations"
  data$value_source <- "published"

  finalize_acs_data(
    data,
    c("sex", "work_status", "occupation", "occupation_major", "occupation_intermediate", "occupation_detail")
  )
}

# ------------------------------------------------------------------------------
# National Detailed Parsers
# ------------------------------------------------------------------------------

parse_national_detailed_occupation_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- ifelse(stringr::str_detect(data$table, "^B2412[1-3]"), "median_earnings", "employment")
  data$unit <- ifelse(data$measure == "median_earnings", "dollars", "count")
  data$work_status <- ifelse(stringr::str_detect(data$table, "^B2412"), "full_time_year_round", "all")
  data$sex <- dplyr::case_when(
    data$table %in% c("B24115", "B24122", "B24125") ~ "Male",
    data$table %in% c("B24116", "B24123", "B24126") ~ "Female",
    TRUE ~ "Total"
  )
  data$occupation <- deepest_token(tokens, start = 2L)
  data$occupation[is.na(data$occupation)] <- "All occupations"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  eligible <- config$shares & data$measure == "employment"
  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, eligible, denominator)
  finalize_acs_data(data, c("sex", "work_status", "occupation"))
}

parse_national_detailed_industry_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "employment"
  data$unit <- "count"
  data$work_status <- "all"
  data$sex <- dplyr::case_when(
    data$table == "B24135" ~ "Male",
    data$table == "B24136" ~ "Female",
    TRUE ~ "Total"
  )
  data$industry <- deepest_token(tokens, start = 2L)
  data$industry[is.na(data$industry)] <- "All industries"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "work_status", "industry"))
}

# ------------------------------------------------------------------------------
# Household & Family Income Parsers
# ------------------------------------------------------------------------------

parse_income_race_suffix <- function(table_code) {
  race_labels <- c(
    A = "White alone",
    B = "Black or African American alone",
    C = "American Indian and Alaska Native alone",
    D = "Asian alone",
    E = "Native Hawaiian and Other Pacific Islander alone",
    F = "Some other race alone",
    G = "Two or more races",
    H = "White alone, not Hispanic or Latino",
    I = "Hispanic or Latino"
  )
  suffix <- stringr::str_match(table_code, "^[BC]\\d{5}([A-I])$")[, 2]
  unname(race_labels[suffix])
}

parse_household_income_brackets_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " households") else config$universe
  data$measure <- "households"
  data$unit <- "count"
  data$income_bracket <- deepest_token(tokens)
  data$income_bracket[is.na(data$income_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("race_ethnicity", "income_bracket"))
}

parse_household_income_median_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " households") else config$universe
  data$measure <- "median_income"
  data$unit <- "dollars"
  data$value_source <- "published"

  finalize_acs_data(data, c("race_ethnicity"))
}

parse_household_income_size_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "median_income"
  data$unit <- "dollars"
  data$household_size <- deepest_token(tokens)
  data$household_size[is.na(data$household_size)] <- "Total"
  data$value_source <- "published"

  finalize_acs_data(data, c("household_size"))
}

parse_household_income_age_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$householder_age <- token_at(tokens, 1L)
  data$householder_age[is.na(data$householder_age)] <- "Total"

  is_bracket <- stringr::str_detect(data$table, "19037")
  data$measure <- ifelse(is_bracket, "households", "median_income")
  data$unit <- ifelse(is_bracket, "count", "dollars")
  data$income_bracket <- ifelse(is_bracket, deepest_token(tokens, start = 2L), NA_character_)
  data$income_bracket[is.na(data$income_bracket) & is_bracket] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  eligible <- is_bracket & rep(config$shares, nrow(data))
  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, eligible, denominator)
  finalize_acs_data(data, c("householder_age", "income_bracket"))
}

parse_family_income_brackets_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " families") else config$universe
  data$measure <- "families"
  data$unit <- "count"
  data$income_bracket <- deepest_token(tokens)
  data$income_bracket[is.na(data$income_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("race_ethnicity", "income_bracket"))
}

parse_family_income_median_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])
  second <- token_at(tokens, 1L)

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " families") else config$universe
  data$measure <- "median_income"
  data$unit <- "dollars"
  data$family_characteristic <- dplyr::case_when(
    !is.na(race) ~ "Total",
    !is.na(second) ~ second,
    TRUE ~ "Total"
  )
  data$value_source <- "published"

  finalize_acs_data(data, c("race_ethnicity", "family_characteristic"))
}

parse_family_income_children_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "families"
  data$unit <- "count"
  data$family_type <- token_at(tokens, 1L)
  data$family_type[is.na(data$family_type)] <- "Total"
  data$children_presence <- token_at(tokens, 2L)
  data$children_presence[is.na(data$children_presence)] <- "Total"
  data$income_bracket <- deepest_token(tokens, start = 3L)
  data$income_bracket[is.na(data$income_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("family_type", "children_presence", "income_bracket"))
}

parse_nonfamily_income_brackets_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "nonfamily_households"
  data$unit <- "count"
  data$income_bracket <- deepest_token(tokens)
  data$income_bracket[is.na(data$income_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("income_bracket"))
}

parse_nonfamily_income_median_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])
  second <- token_at(tokens, 1L)

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " nonfamily households") else config$universe
  data$measure <- "median_income"
  data$unit <- "dollars"
  data$householder_characteristic <- dplyr::case_when(
    !is.na(race) ~ "Total",
    !is.na(second) ~ second,
    TRUE ~ "Total"
  )
  data$value_source <- "published"

  finalize_acs_data(data, c("race_ethnicity", "householder_characteristic"))
}

# ------------------------------------------------------------------------------
# Income Types & Composition Parsers
# ------------------------------------------------------------------------------

parse_income_types_counts_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  second <- token_at(tokens, 1L)

  type_map <- c(
    B19051 = "Earnings", B19052 = "Wage or salary income",
    B19053 = "Self-employment income", B19054 = "Interest, dividends, or net rental income",
    B19055 = "Social Security income", B19056 = "Supplemental Security Income (SSI)",
    B19057 = "Public assistance income", B19058 = "Food Stamps/SNAP",
    B19059 = "Retirement income", B19060 = "Other types of income"
  )

  data$universe <- config$universe
  data$income_type <- unname(type_map[data$table])
  data$receipt_status <- dplyr::case_when(
    stringr::str_detect(second, "(?i)With") ~ "With income type",
    stringr::str_detect(second, "(?i)No") ~ "Without income type",
    TRUE ~ "Total"
  )
  data$measure <- "households"
  data$unit <- "count"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("income_type", "receipt_status"))
}

parse_income_types_aggregates_data <- function(data, config) {
  type_map <- c(
    B19061 = "Earnings", B19062 = "Wage or salary income",
    B19063 = "Self-employment income", B19064 = "Interest, dividends, or net rental income",
    B19065 = "Social Security income", B19066 = "Supplemental Security Income (SSI)",
    B19067 = "Public assistance income", B19069 = "Retirement income",
    B19070 = "Other types of income"
  )

  data$universe <- config$universe
  data$income_type <- unname(type_map[data$table])
  data$measure <- "aggregate_income"
  data$unit <- "dollars"
  data$value_source <- "published"

  finalize_acs_data(data, c("income_type"))
}

# ------------------------------------------------------------------------------
# Income Inequality Parsers
# ------------------------------------------------------------------------------

parse_income_inequality_gini_data <- function(data, config) {
  data$universe <- config$universe
  data$measure <- "gini_index"
  data$unit <- "index"
  data$value_source <- "published"
  finalize_acs_data(data)
}

parse_income_quintiles_limits_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "quintile_upper_limit"
  data$unit <- "dollars"
  data$quintile <- deepest_token(tokens)
  data$quintile[is.na(data$quintile)] <- "Total"
  data$value_source <- "published"
  finalize_acs_data(data, c("quintile"))
}

parse_income_quintiles_means_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "mean_quintile_income"
  data$unit <- "dollars"
  data$quintile <- deepest_token(tokens)
  data$quintile[is.na(data$quintile)] <- "Total"
  data$value_source <- "published"
  finalize_acs_data(data, c("quintile"))
}

parse_income_quintiles_shares_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "share_of_aggregate_income"
  data$unit <- "percent"
  data$quintile <- deepest_token(tokens)
  data$quintile[is.na(data$quintile)] <- "Total"
  data$value_source <- "published"
  finalize_acs_data(data, c("quintile"))
}

parse_per_capita_income_data <- function(data, config) {
  race <- parse_income_race_suffix(data$table[[1]])
  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " population") else config$universe
  data$measure <- "per_capita_income"
  data$unit <- "dollars"
  data$value_source <- "published"
  finalize_acs_data(data, c("race_ethnicity"))
}

parse_aggregate_income_data <- function(data, config) {
  race <- parse_income_race_suffix(data$table[[1]])
  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " population") else config$universe
  data$measure <- "aggregate_income"
  data$unit <- "dollars"
  data$value_source <- "published"
  finalize_acs_data(data, c("race_ethnicity"))
}

# ------------------------------------------------------------------------------
# Individual Income & Earnings Parsers
# ------------------------------------------------------------------------------

parse_individual_earnings_brackets_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  
  data$universe <- config$universe
  data$measure <- "population_with_earnings"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$earnings_bracket <- deepest_token(tokens, start = 2L)
  data$earnings_bracket[is.na(data$earnings_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "earnings_bracket"))
}

parse_individual_earnings_median_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  data$universe <- config$universe
  data$measure <- "median_earnings"
  data$unit <- "dollars"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$value_source <- "published"
  finalize_acs_data(data, c("sex"))
}

parse_individual_earnings_aggregate_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)
  data$universe <- config$universe
  data$measure <- "aggregate_earnings"
  data$unit <- "dollars"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$work_experience <- dplyr::if_else(!is.na(second), second, "Total")
  data$value_source <- "published"
  finalize_acs_data(data, c("sex", "work_experience"))
}

parse_individual_earnings_work_exp_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " population with earnings") else config$universe
  data$measure <- "population_with_earnings"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$work_experience <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(second) ~ second,
    !first %in% c("Male", "Female") & !is.na(first) ~ first,
    TRUE ~ "Total"
  )
  data$earnings_bracket <- deepest_token(tokens, start = 3L)
  data$earnings_bracket[is.na(data$earnings_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("race_ethnicity", "sex", "work_experience", "earnings_bracket"))
}

parse_individual_earnings_median_work_exp_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " population with earnings") else config$universe
  data$measure <- "median_earnings"
  data$unit <- "dollars"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$work_experience <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(second) ~ second,
    !first %in% c("Male", "Female") & !is.na(first) ~ first,
    TRUE ~ "Total"
  )
  data$value_source <- "published"
  finalize_acs_data(data, c("race_ethnicity", "sex", "work_experience"))
}

parse_individual_income_brackets_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$universe <- config$universe
  data$measure <- "population_with_income"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$work_experience <- dplyr::if_else(!is.na(second), second, "Total")
  data$income_bracket <- deepest_token(tokens, start = 3L)
  data$income_bracket[is.na(data$income_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "work_experience", "income_bracket"))
}

parse_individual_income_median_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$universe <- config$universe
  data$measure <- "median_income"
  data$unit <- "dollars"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$work_experience <- dplyr::if_else(!is.na(second), second, "Total")
  data$value_source <- "published"
  finalize_acs_data(data, c("sex", "work_experience"))
}

# ------------------------------------------------------------------------------
# Education Parsers (School Enrollment, Educational Attainment, Field of Degree)
# ------------------------------------------------------------------------------

parse_school_enrollment_level_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$enrollment_status <- deepest_token(tokens)
  data$enrollment_status[is.na(data$enrollment_status)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("enrollment_status"))
}

parse_school_enrollment_detailed_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " population 3 years and over") else config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$enrollment_level <- deepest_token(tokens)
  data$enrollment_level[is.na(data$enrollment_level)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("race_ethnicity", "enrollment_level"))
}

parse_school_enrollment_type_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)

  data$universe <- config$universe
  data$measure <- "enrolled_population"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$enrollment_level <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(second) ~ second,
    !first %in% c("Male", "Female") & !is.na(first) ~ first,
    TRUE ~ "Total"
  )
  data$school_type <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(third) ~ third,
    !first %in% c("Male", "Female") & !is.na(second) ~ second,
    TRUE ~ "Total"
  )
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "enrollment_level", "school_type"))
}

parse_school_enrollment_age_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)

  data$universe <- config$universe
  data$measure <- "enrolled_population"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$school_type <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(second) ~ second,
    !first %in% c("Male", "Female") & !is.na(first) ~ first,
    TRUE ~ "Total"
  )
  data$age_group <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(third) ~ third,
    !first %in% c("Male", "Female") & !is.na(second) ~ second,
    TRUE ~ "Total"
  )
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "school_type", "age_group"))
}

parse_college_enrollment_age_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)

  data$universe <- config$universe
  data$measure <- "enrolled_population"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$enrollment_type <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(second) ~ second,
    !first %in% c("Male", "Female") & !is.na(first) ~ first,
    TRUE ~ "Total"
  )
  data$age_group <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(third) ~ third,
    !first %in% c("Male", "Female") & !is.na(second) ~ second,
    TRUE ~ "Total"
  )
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "enrollment_type", "age_group"))
}

parse_youth_enrollment_employment_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "youth_population"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$enrollment_attainment_status <- deepest_token(tokens, start = 2L)
  data$enrollment_attainment_status[is.na(data$enrollment_attainment_status)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "enrollment_attainment_status"))
}

parse_school_enrollment_poverty_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$poverty_status <- dplyr::case_when(
    stringr::str_detect(first, "(?i)Income in the past 12 months below") ~ "Below poverty level",
    stringr::str_detect(first, "(?i)Income in the past 12 months at or above") ~ "At or above poverty level",
    TRUE ~ "Total"
  )
  data$enrollment_level <- deepest_token(tokens, start = 2L)
  data$enrollment_level[is.na(data$enrollment_level)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("poverty_status", "enrollment_level"))
}

parse_educational_attainment_age_sex_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$age_group <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(second) ~ second,
    !first %in% c("Male", "Female") & !is.na(first) ~ first,
    TRUE ~ "Total"
  )
  data$educational_attainment <- deepest_token(tokens, start = 3L)
  data$educational_attainment[is.na(data$educational_attainment)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "age_group", "educational_attainment"))
}

parse_educational_attainment_sex_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])
  first <- token_at(tokens, 1L)

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " population 25 years and over") else config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$educational_attainment <- deepest_token(tokens, start = 2L)
  data$educational_attainment[is.na(data$educational_attainment)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("race_ethnicity", "sex", "educational_attainment"))
}

parse_educational_attainment_detailed_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)

  data$universe <- config$universe
  data$measure <- "population"
  data$unit <- "count"
  data$educational_attainment <- deepest_token(tokens)
  data$educational_attainment[is.na(data$educational_attainment)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("educational_attainment"))
}

parse_field_of_degree_broad_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$universe <- config$universe
  data$measure <- "bachelor_degree_holders"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$age_group <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(second) ~ second,
    !first %in% c("Male", "Female") & !is.na(first) ~ first,
    TRUE ~ "Total"
  )
  data$field_of_degree <- deepest_token(tokens, start = 3L)
  data$field_of_degree[is.na(data$field_of_degree)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "age_group", "field_of_degree"))
}

parse_field_of_degree_detailed_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " population with Bachelor degree or higher") else config$universe
  data$measure <- "bachelor_degree_holders"
  data$unit <- "count"
  data$field_of_degree_major <- token_at(tokens, 1L)
  data$field_of_degree <- deepest_token(tokens)
  data$field_of_degree[is.na(data$field_of_degree)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("race_ethnicity", "field_of_degree_major", "field_of_degree"))
}

parse_field_of_degree_earnings_sex_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$universe <- config$universe
  data$measure <- "median_earnings"
  data$unit <- "dollars"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$field_of_degree <- dplyr::case_when(
    first %in% c("Male", "Female") & !is.na(second) ~ second,
    !first %in% c("Male", "Female") & !is.na(first) ~ first,
    TRUE ~ "Total"
  )
  data$value_source <- "published"
  finalize_acs_data(data, c("sex", "field_of_degree"))
}

parse_field_of_degree_earnings_age_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  second <- token_at(tokens, 2L)

  data$universe <- config$universe
  data$measure <- "median_earnings"
  data$unit <- "dollars"
  data$age_group <- dplyr::case_when(
    !is.na(first) & stringr::str_detect(first, "(?i)years") ~ first,
    TRUE ~ "Total"
  )
  data$field_of_degree <- deepest_token(tokens, start = 2L)
  data$field_of_degree[is.na(data$field_of_degree)] <- "Total"
  data$value_source <- "published"
  finalize_acs_data(data, c("age_group", "field_of_degree"))
}

# ------------------------------------------------------------------------------
# Commute Parsers (Travel Time, Departure Time, Place of Work, Characteristics)
# ------------------------------------------------------------------------------

parse_travel_time_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$travel_time_bracket <- deepest_token(tokens)
  data$travel_time_bracket[is.na(data$travel_time_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("travel_time_bracket"))
}

parse_departure_time_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$departure_time_window <- deepest_token(tokens)
  data$departure_time_window[is.na(data$departure_time_window)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("departure_time_window"))
}

parse_arrival_time_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$arrival_time_window <- deepest_token(tokens)
  data$arrival_time_window[is.na(data$arrival_time_window)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("arrival_time_window"))
}

parse_departure_time_sex_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$departure_time_window <- deepest_token(tokens, start = 2L)
  data$departure_time_window[is.na(data$departure_time_window)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "departure_time_window"))
}

parse_travel_time_sex_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$travel_time_bracket <- deepest_token(tokens, start = 2L)
  data$travel_time_bracket[is.na(data$travel_time_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "travel_time_bracket"))
}

parse_travel_time_mode_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$transportation_mode <- dplyr::if_else(!is.na(first), first, "Total")
  data$travel_time_bracket <- deepest_token(tokens, start = 2L)
  data$travel_time_bracket[is.na(data$travel_time_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("transportation_mode", "travel_time_bracket"))
}

parse_departure_time_mode_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$transportation_mode <- dplyr::if_else(!is.na(first), first, "Total")
  data$departure_time_window <- deepest_token(tokens, start = 2L)
  data$departure_time_window[is.na(data$departure_time_window)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("transportation_mode", "departure_time_window"))
}

parse_arrival_time_mode_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$transportation_mode <- dplyr::if_else(!is.na(first), first, "Total")
  data$arrival_time_window <- deepest_token(tokens, start = 2L)
  data$arrival_time_window[is.na(data$arrival_time_window)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("transportation_mode", "arrival_time_window"))
}

parse_aggregate_travel_time_mode_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "aggregate_travel_time"
  data$unit <- "minutes"
  data$transportation_mode <- deepest_token(tokens)
  data$transportation_mode[is.na(data$transportation_mode)] <- "Total"
  data$value_source <- "published"
  finalize_acs_data(data, c("transportation_mode"))
}

parse_aggregate_travel_time_sex_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)
  data$universe <- config$universe
  data$measure <- "aggregate_travel_time"
  data$unit <- "minutes"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$value_source <- "published"
  finalize_acs_data(data, c("sex"))
}

parse_aggregate_travel_time_place_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "aggregate_travel_time"
  data$unit <- "minutes"
  data$place_of_work <- deepest_token(tokens)
  data$place_of_work[is.na(data$place_of_work)] <- "Total"
  data$value_source <- "published"
  finalize_acs_data(data, c("place_of_work"))
}

parse_aggregate_travel_time_travel_time_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "aggregate_travel_time"
  data$unit <- "minutes"
  data$travel_time_bracket <- deepest_token(tokens)
  data$travel_time_bracket[is.na(data$travel_time_bracket)] <- "Total"
  data$value_source <- "published"
  finalize_acs_data(data, c("travel_time_bracket"))
}

parse_place_of_work_sex_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    first == "Male" ~ "Male",
    first == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$place_of_work_location <- deepest_token(tokens, start = 2L)
  data$place_of_work_location[is.na(data$place_of_work_location)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("sex", "place_of_work_location"))
}

parse_place_of_work_msa_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$place_of_work_location <- deepest_token(tokens)
  data$place_of_work_location[is.na(data$place_of_work_location)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("place_of_work_location"))
}

parse_workplace_worker_pop_data <- function(data, config) {
  data$universe <- config$universe
  data$measure <- "workplace_workers"
  data$unit <- "count"
  data$value_source <- "published"
  finalize_acs_data(data, character(0))
}

parse_commuting_cross_age_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$transportation_mode <- dplyr::if_else(!is.na(first), first, "Total")
  data$age_group <- deepest_token(tokens, start = 2L)
  data$age_group[is.na(data$age_group)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("transportation_mode", "age_group"))
}

parse_commuting_median_age_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "median_age"
  data$unit <- "years"
  data$transportation_mode <- deepest_token(tokens)
  data$transportation_mode[is.na(data$transportation_mode)] <- "Total"
  data$value_source <- "published"
  finalize_acs_data(data, c("transportation_mode"))
}

parse_commuting_race_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " workers 16 years and over") else config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$transportation_mode <- deepest_token(tokens)
  data$transportation_mode[is.na(data$transportation_mode)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("race_ethnicity", "transportation_mode"))
}

parse_commuting_cross_earnings_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$transportation_mode <- dplyr::if_else(!is.na(first), first, "Total")
  data$earnings_bracket <- deepest_token(tokens, start = 2L)
  data$earnings_bracket[is.na(data$earnings_bracket)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("transportation_mode", "earnings_bracket"))
}

parse_commuting_median_earnings_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  data$universe <- config$universe
  data$measure <- "median_earnings"
  data$unit <- "dollars"
  data$transportation_mode <- deepest_token(tokens)
  data$transportation_mode[is.na(data$transportation_mode)] <- "Total"
  data$value_source <- "published"
  finalize_acs_data(data, c("transportation_mode"))
}

parse_commuting_cross_poverty_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$transportation_mode <- dplyr::if_else(!is.na(first), first, "Total")
  data$poverty_status <- deepest_token(tokens, start = 2L)
  data$poverty_status[is.na(data$poverty_status)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("transportation_mode", "poverty_status"))
}

parse_commuting_cross_occupation_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$transportation_mode <- dplyr::if_else(!is.na(first), first, "Total")
  data$occupation_group <- deepest_token(tokens, start = 2L)
  data$occupation_group[is.na(data$occupation_group)] <- "Total"
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("transportation_mode", "occupation_group"))
}


