validate_getter_dots <- function(dots) {
  reserved <- intersect(
    names(dots),
    c("year", "survey", "geography", "variables", "table", "output", "cache_table")
  )
  if (length(reserved)) {
    stop(
      "These arguments are managed by ACSloadR and cannot be supplied through `...`: ",
      paste(reserved, collapse = ", "),
      call. = FALSE
    )
  }
}

load_acs_lmi_table <- function(config, year, survey, geography, cache_table, ...) {
  dataset <- acs_dataset(survey, config$dataset_type)
  metadata <- tryCatch(
    tidycensus::load_variables(
      year = year,
      dataset = dataset,
      cache = cache_table
    ),
    error = function(e) {
      warning(
        "Failed to load ACS variables metadata for ", year, " ", dataset, ": ", e$message,
        call. = FALSE
      )
      NULL
    }
  )

  empty_res <- tibble::tibble(
    GEOID = character(), NAME = character(), variable = character(),
    estimate = numeric(), moe = numeric(), year = integer(), survey = character(),
    table = character(), label = character(), concept = character()
  )

  if (is.null(metadata) || nrow(metadata) == 0) {
    warning(
      "ACS table(s) unavailable for ", year, " ", dataset, ": ",
      paste(config$tables, collapse = ", "),
      call. = FALSE
    )
    return(empty_res)
  }

  pattern <- paste0("^(", paste(config$tables, collapse = "|"), ")_")
  metadata <- metadata[stringr::str_detect(metadata$name, pattern), , drop = FALSE]
  found_tables <- unique(table_from_variable(metadata$name))
  missing_tables <- setdiff(config$tables, found_tables)

  if (length(missing_tables)) {
    warning(
      "ACS table(s) unavailable for ", year, " ", dataset, ": ",
      paste(missing_tables, collapse = ", "),
      call. = FALSE
    )
  }

  if (nrow(metadata) == 0) {
    return(empty_res)
  }

  dots <- rlang::list2(...)
  validate_getter_dots(dots)
  args <- c(
    list(
      geography = geography,
      variables = metadata$name,
      year = year,
      # tidycensus detects S-table variables and selects the subject endpoint.
      # Passing "acs5/subject" here would duplicate the URL path.
      survey = survey,
      cache_table = cache_table,
      output = "tidy"
    ),
    dots
  )
  downloaded <- tryCatch(
    do.call(tidycensus::get_acs, args),
    error = function(e) {
      warning(
        "Failed to download ACS data for ", year, " ", dataset, " (",
        paste(found_tables, collapse = ", "), "): ", e$message,
        call. = FALSE
      )
      NULL
    }
  )

  if (is.null(downloaded) || nrow(downloaded) == 0) {
    return(empty_res)
  }

  metadata <- metadata |>
    dplyr::select(dplyr::all_of(c("name", "label", "concept"))) |>
    dplyr::rename(variable = name)

  downloaded |>
    dplyr::left_join(metadata, by = "variable") |>
    dplyr::mutate(
      year = as.integer(year),
      survey = survey,
      table = table_from_variable(.data$variable)
    )
}

proportion_moe <- function(numerator, numerator_moe, denominator, denominator_moe) {
  proportion <- numerator / denominator
  subtract_radicand <- numerator_moe^2 - (proportion^2 * denominator_moe^2)
  radicand <- ifelse(
    is.na(subtract_radicand),
    NA_real_,
    ifelse(
      subtract_radicand >= 0,
      subtract_radicand,
      numerator_moe^2 + (proportion^2 * denominator_moe^2)
    )
  )
  out <- 100 * sqrt(radicand) / denominator
  out[is.na(denominator) | denominator <= 0] <- NA_real_
  out
}

add_share_rows <- function(data, eligible, denominator_variable,
                           share_measure = "share_of_table_universe") {
  if (!any(eligible, na.rm = TRUE)) return(data)

  derived <- data[eligible, , drop = FALSE]
  derived$denominator_variable <- denominator_variable[eligible]

  data_key <- paste(data$GEOID, data$table, data$variable, sep = "\r")
  denominator_key <- paste(
    derived$GEOID, derived$table, derived$denominator_variable, sep = "\r"
  )
  denominator_index <- match(denominator_key, data_key)
  denominator_estimate <- data$estimate[denominator_index]
  denominator_moe <- data$moe[denominator_index]

  derived$estimate <- 100 * derived$estimate / denominator_estimate
  derived$moe <- proportion_moe(
    numerator = data$estimate[which(eligible)],
    numerator_moe = data$moe[which(eligible)],
    denominator = denominator_estimate,
    denominator_moe = denominator_moe
  )
  derived$estimate[is.na(denominator_estimate) | denominator_estimate <= 0] <- NA_real_
  derived$measure <- share_measure
  derived$unit <- "percent"
  derived$value_source <- "derived"

  dplyr::bind_rows(data, derived)
}

finalize_acs_data <- function(data, dimensions = character()) {
  if (!"denominator_variable" %in% names(data)) {
    data$denominator_variable <- NA_character_
  }

  leading <- c(
    "GEOID", "NAME", "year", "survey", "table", "variable", "concept",
    "universe", "measure", "unit", dimensions, "estimate", "moe",
    "value_source", "denominator_variable", "label"
  )
  leading <- leading[leading %in% names(data)]
  geometry <- intersect("geometry", names(data))
  remaining <- setdiff(names(data), c(leading, geometry))
  data[, c(leading, remaining, geometry), drop = FALSE]
}

run_topic_getter <- function(registry_name, topic, component_name, year, survey,
                             geography, cache_table, ...) {
  config <- acs_table_registry()[[registry_name]]
  raw <- load_acs_lmi_table(
    config = config,
    year = year,
    survey = survey,
    geography = geography,
    cache_table = cache_table,
    ...
  )
  parsed <- parse_acs_topic(raw, parser = config$parser, config = config)
  new_acs_lmi_bundle(
    stats::setNames(list(parsed), component_name),
    topic = topic,
    year = year,
    survey = survey
  )
}
