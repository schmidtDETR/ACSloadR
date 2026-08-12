acs_table_registry <- function() {
  list(
    age_total_population = list(
      tables = "B01001", dataset_type = "detailed", parser = "age",
      universe = "Total population", shares = TRUE
    ),
    age_race_ethnicity = list(
      tables = paste0("B01001", LETTERS[1:9]), dataset_type = "detailed",
      parser = "age", universe = "Race or ethnicity population", shares = TRUE
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
      tables = "B20004", dataset_type = "detailed", parser = "earnings",
      universe = "Population 25 years and over with earnings", shares = FALSE
    ),
    commuting = list(
      tables = "B08301", dataset_type = "detailed", parser = "commuting",
      universe = "Workers 16 years and over", shares = TRUE
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
