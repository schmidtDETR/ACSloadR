parse_acs_topic <- function(data, parser, config) {
  switch(
    parser,
    age = parse_age_data(data, config),
    employment = parse_employment_data(data, config),
    occupation = parse_occupation_data(data, config),
    earnings = parse_earnings_data(data, config),
    commuting = parse_commuting_data(data, config),
    stop("Unknown ACS parser: ", parser, call. = FALSE)
  )
}

parse_age_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)

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
  suffix <- stringr::str_match(data$table, "^B01001([A-I])$")[, 2]

  data$universe <- ifelse(
    is.na(suffix),
    config$universe,
    paste0(unname(race_labels[suffix]), " population")
  )
  data$measure <- "population"
  data$unit <- "count"
  data$sex <- dplyr::case_when(
    second == "Male" ~ "Male",
    second == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$age_group <- dplyr::if_else(!is.na(third), third, "Total")
  data$race_ethnicity <- unname(race_labels[suffix])
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("race_ethnicity", "sex", "age_group"))
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

parse_earnings_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  second <- token_at(tokens, 2L)
  third <- token_at(tokens, 3L)

  data$universe <- config$universe
  data$measure <- "median_earnings"
  data$unit <- "dollars"
  data$sex <- dplyr::case_when(
    second == "Male" ~ "Male",
    second == "Female" ~ "Female",
    TRUE ~ "Total"
  )
  data$educational_attainment <- dplyr::case_when(
    second %in% c("Male", "Female") & !is.na(third) ~ third,
    !second %in% c("Male", "Female") & !is.na(second) ~ second,
    TRUE ~ "Total"
  )
  data$value_source <- "published"
  finalize_acs_data(data, c("sex", "educational_attainment"))
}

parse_commuting_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  hierarchy <- purrr::map(tokens, function(x) if (length(x) > 1L) x[2:length(x)] else character())

  data$universe <- config$universe
  data$measure <- "workers"
  data$unit <- "count"
  data$transportation_mode <- deepest_token(hierarchy)
  data$transportation_mode[is.na(data$transportation_mode)] <- "All transportation modes"
  data$mode_major <- token_at(hierarchy, 1L)
  data$mode_detail <- token_at(hierarchy, 2L)
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)
  finalize_acs_data(data, c("transportation_mode", "mode_major", "mode_detail"))
}
