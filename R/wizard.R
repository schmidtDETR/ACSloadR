#' Generate R Script for an ACS Topic
#'
#' Pure function to construct a well-commented, analysis-ready R script
#' for downloading and extracting a specific ACSloadR topic bundle.
#'
#' @param topic A topic specification list or topic identifier string (e.g., `"employment_detail"`).
#' @param year Integer or numeric ACS vintage year (e.g., 2024).
#' @param survey Survey type, either `"acs5"` or `"acs1"`.
#' @param geography Geography level (e.g., `"state"`, `"county"`, `"tract"`).
#' @param state Optional state abbreviation or FIPS (e.g., `"MA"`).
#' @param county Optional county name or FIPS code.
#' @param var_name Variable name for the returned bundle object. If `NULL`, uses a topic-specific default.
#'
#' @return A character string containing the generated R script.
#' @keywords internal
#' @export
generate_acs_script <- function(topic,
                                year = 2024,
                                survey = c("acs5", "acs1"),
                                geography = "state",
                                state = NULL,
                                county = NULL,
                                var_name = NULL) {
  survey <- match.arg(survey)
  catalog <- acs_topic_catalog()

  if (is.character(topic)) {
    if (!topic %in% names(catalog)) {
      stop(
        "Unknown topic '", topic, "'. Available topics: ",
        paste(names(catalog), collapse = ", "),
        call. = FALSE
      )
    }
    topic_info <- catalog[[topic]]
  } else if (is.list(topic)) {
    topic_info <- topic
  } else {
    stop("`topic` must be a topic id string or topic metadata list.", call. = FALSE)
  }

  if (is.null(var_name) || !nzchar(var_name)) {
    var_name <- topic_info$default_var %||% paste0(topic_info$id, "_bundle")
  }

  # Build function call arguments string
  call_args <- list()
  call_args$year <- as.character(year)
  call_args$survey <- paste0('"', survey, '"')
  call_args$geography <- paste0('"', geography, '"')

  if (!is.null(state) && nzchar(trimws(state))) {
    call_args$state <- paste0('"', trimws(state), '"')
  }
  if (!is.null(county) && nzchar(trimws(county))) {
    call_args$county <- paste0('"', trimws(county), '"')
  }

  call_args_str <- paste(
    names(call_args),
    "=",
    unname(call_args),
    collapse = ",\n  "
  )

  # Format components extraction code
  comp_lines <- if (length(topic_info$components) > 0) {
    paste0(
      vapply(topic_info$components, function(cmp) {
        paste0(cmp, " <- ", var_name, "$", cmp)
      }, character(1)),
      collapse = "\n"
    )
  } else {
    paste0("# (No specific subcomponents defined)")
  }

  tables_str <- paste(topic_info$tables, collapse = ", ")
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

  script <- paste0(
    "# =========================================================================\n",
    "# ACSloadR Script: ", topic_info$title, "\n",
    "# Generated: ", timestamp, "\n",
    "# Topic ID: ", topic_info$id, "\n",
    "# ACS Source Tables: ", tables_str, "\n",
    "# Universe: ", topic_info$universe, "\n",
    "# =========================================================================\n\n",
    "# 1. Load required libraries\n",
    "library(ACSloadR)\n",
    "library(dplyr)\n\n",
    "# 2. Census API Key Check\n",
    "# Ensure your Census API key is set. You can install it permanently with:\n",
    "# tidycensus::census_api_key(\"YOUR_KEY_HERE\", install = TRUE)\n",
    "if (Sys.getenv(\"CENSUS_API_KEY\") == \"\") {\n",
    "  message(\"Note: CENSUS_API_KEY environment variable is not set. Requests may be rate-limited.\")\n",
    "}\n\n",
    "# 3. Fetch topic data bundle\n",
    var_name, " <- ", topic_info$getter, "(\n  ",
    call_args_str, "\n",
    ")\n\n",
    "# 4. Inspect bundle metadata & summary\n",
    "print(", var_name, ")\n\n",
    "# 5. Extract bundle components into individual tibbles\n",
    comp_lines, "\n"
  )

  script
}

# Helper fallback operator
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

#' Interactive ACSloadR Script Wizard & Topic Explorer
#'
#' Launches an interactive console assistant that guides you through exploring
#' available ACS topics, reviewing table coverage and returned data structures,
#' configuring download parameters (vintage, survey, geography), and creating
#' ready-to-run R scripts saved to a temporary scratchpad or project folder.
#'
#' @param topic Optional topic identifier (e.g. `"age"`, `"employment_detail"`) to bypass topic selection.
#' @param year Optional default vintage year.
#' @param survey Optional survey vintage (`"acs5"` or `"acs1"`).
#' @param geography Optional geography level.
#' @param state Optional state abbreviation.
#' @param output_dir Optional destination folder for non-interactive / direct script generation.
#' @param filename Optional destination file name.
#'
#' @return Invisibly returns the file path of the generated script.
#' @export
#'
#' @examples
#' \dontrun{
#' # Launch interactive wizard
#' acs_wizard()
#'
#' # Generate script directly for a known topic
#' create_acs_script(topic = "employment", geography = "county", state = "MA")
#' }
acs_wizard <- function(topic = NULL,
                       year = 2024,
                       survey = c("acs5", "acs1"),
                       geography = "state",
                       state = NULL,
                       output_dir = NULL,
                       filename = NULL) {
  if (!interactive() && is.null(topic)) {
    stop("`acs_wizard()` interactive mode requires an interactive R session. Provide arguments explicitly when non-interactive.", call. = FALSE)
  }

  catalog <- acs_topic_catalog()
  survey <- match.arg(survey)

  cli::cli_h1("ACSloadR Script Wizard & Topic Explorer")
  cli::cli_text("Explore Census ACS topics and generate ready-to-run R scripts.")
  cli::cli_rule()

  # Step 1 & 2: Topic Selection (if not pre-specified)
  selected_topic_info <- NULL

  if (!is.null(topic)) {
    if (is.character(topic) && topic %in% names(catalog)) {
      selected_topic_info <- catalog[[topic]]
    } else {
      cli::cli_alert_warning("Specified topic '{topic}' not found in catalog. Opening topic browser...")
    }
  }

  while (is.null(selected_topic_info)) {
    selected_topic_info <- prompt_topic_selection(catalog)
  }

  cli::cli_alert_success("Selected Topic: {.strong {selected_topic_info$title}}")
  cli::cli_text("{.field Tables}: {paste(selected_topic_info$tables, collapse = ', ')}")
  cli::cli_text("{.field Universe}: {selected_topic_info$universe}")
  cli::cli_text("{.field Components}: {paste(selected_topic_info$components, collapse = ', ')}")
  if (!is.null(selected_topic_info$caveat)) {
    cli::cli_alert_info("{selected_topic_info$caveat}")
  }
  cli::cli_rule()

  # Step 3: Query Parameter Prompts (if interactive)
  params <- prompt_query_parameters(
    year = year,
    survey = survey,
    geography = geography,
    state = state
  )

  if (!is.null(selected_topic_info$caveat) && params$survey == "acs5") {
    cli::cli_alert_warning("Reminder for survey '{params$survey}': {selected_topic_info$caveat}")
  }

  # Step 4: Destination Selection
  dest <- prompt_destination(
    topic_id = selected_topic_info$id,
    year = params$year,
    output_dir = output_dir,
    filename = filename
  )

  # Step 5: Generate Script
  script_content <- generate_acs_script(
    topic = selected_topic_info,
    year = params$year,
    survey = params$survey,
    geography = params$geography,
    state = params$state,
    var_name = selected_topic_info$default_var
  )

  # Write script to target path
  writeLines(script_content, con = dest$path)

  cli::cli_rule()
  cli::cli_alert_success("Created R script: {.file {dest$path}}")

  # Clipboard integration
  if (requireNamespace("clipr", quietly = TRUE) && clipr::clipr_available()) {
    tryCatch({
      clipr::write_clip(script_content)
      cli::cli_alert_info("Code copied to system clipboard.")
    }, error = function(e) NULL)
  }

  # Open in editor if interactive
  if (interactive()) {
    tryCatch({
      utils::file.edit(dest$path)
    }, error = function(e) {
      cli::cli_alert_info("Open file with: file.edit(\"{dest$path}\")")
    })
  }

  # Display script preview
  cli::cli_h2("Generated Code Preview")
  cli::cli_code(script_content, language = "r")

  invisible(dest$path)
}

#' @rdname acs_wizard
#' @export
create_acs_script <- acs_wizard

# -----------------------------------------------------------------------------
# Geography Definitions
# -----------------------------------------------------------------------------

common_acs_geographies <- function() {
  c(
    "state" = "State",
    "county" = "County",
    "tract" = "Census Tract",
    "block group" = "Census Block Group",
    "place" = "Place / City / Town",
    "cbsa" = "Metropolitan / Micropolitan Statistical Area (CBSA)",
    "zcta" = "ZIP Code Tabulation Area (ZCTA)",
    "public use microdata area" = "Public Use Microdata Area (PUMA)",
    "us" = "United States (National)"
  )
}

all_acs_geographies <- function() {
  c(
    "us" = "United States (National)",
    "region" = "Census Region (Northeast, Midwest, South, West)",
    "division" = "Census Division (9 regional divisions)",
    "state" = "State",
    "county" = "County",
    "county subdivision" = "County Subdivision / Minor Civil Division (MCD)",
    "tract" = "Census Tract",
    "block group" = "Census Block Group",
    "place" = "Place / Incorporated City / Town / CDP",
    "cbsa" = "Metropolitan / Micropolitan Statistical Area (CBSA)",
    "metropolitan statistical area/micropolitan statistical area" = "Metropolitan / Micropolitan Area (Full Name)",
    "combined statistical area" = "Combined Statistical Area (CSA)",
    "zcta" = "ZIP Code Tabulation Area (ZCTA)",
    "public use microdata area" = "Public Use Microdata Area (PUMA)",
    "congressional district" = "Congressional District (Current)",
    "state legislative district (upper chamber)" = "State Legislative District (Upper / Senate)",
    "state legislative district (lower chamber)" = "State Legislative District (Lower / House)",
    "school district (unified)" = "School District (Unified)",
    "school district (elementary)" = "School District (Elementary)",
    "school district (secondary)" = "School District (Secondary)",
    "urban area" = "Urban Area",
    "principal city" = "Principal City",
    "new england city and town area" = "New England City and Town Area (NECTA)",
    "combined new england city and town area" = "Combined NECTA",
    "necta division" = "NECTA Division",
    "american indian area/alaska native area/hawaiian home land" = "American Indian / Alaska Native / Hawaiian Home Land",
    "alaska native regional corporation" = "Alaska Native Regional Corporation",
    "voting district" = "Voting District"
  )
}

# -----------------------------------------------------------------------------
# Internal Prompt Helpers
# -----------------------------------------------------------------------------

prompt_topic_selection <- function(catalog) {
  categories <- unique(unlist(lapply(catalog, function(x) x$category)))

  cli::cli_h2("Step 1: Choose a Topic Category")
  cat_choices <- c(categories, "Search all topics by keyword", "[Exit Wizard]")
  cat_idx <- utils::menu(cat_choices, title = "Select a category to browse:")

  if (cat_idx == 0 || cat_idx == length(cat_choices)) {
    stop("Wizard cancelled by user.", call. = FALSE)
  }

  # Handle keyword search
  if (cat_idx == length(categories) + 1) {
    query <- readline(prompt = "Enter search keyword (e.g. 'income', 'commute', 'S2301', 'class of worker', 'race'): ")
    query <- trimws(query)
    if (!nzchar(query)) return(NULL)

    matches <- catalog[vapply(catalog, function(item) {
      grepl(query, item$title, ignore.case = TRUE) ||
      grepl(query, item$description, ignore.case = TRUE) ||
      any(grepl(query, item$tables, ignore.case = TRUE)) ||
      grepl(query, item$universe, ignore.case = TRUE) ||
      any(grepl(query, item$category, ignore.case = TRUE))
    }, logical(1))]

    if (length(matches) == 0) {
      cli::cli_alert_warning("No topics found matching '{query}'.")
      return(NULL)
    }

    cli::cli_h2(paste0("Search Results for '", query, "':"))
    topic_titles <- vapply(matches, function(x) paste0(x$title, " (", paste(x$tables, collapse = ", "), ")"), character(1))
    topic_choices <- c(topic_titles, "[Back to Categories]")
    top_idx <- utils::menu(topic_choices, title = "Select a topic:")

    if (top_idx == 0 || top_idx == length(topic_choices)) {
      return(NULL)
    }
    return(matches[[top_idx]])
  }

  # Category browsing
  selected_cat <- categories[cat_idx]
  cat_topics <- catalog[vapply(catalog, function(x) selected_cat %in% x$category, logical(1))]

  cli::cli_h2(paste0("Topics in '", selected_cat, "'"))
  topic_titles <- vapply(cat_topics, function(x) {
    paste0(x$title, " [Tables: ", paste(x$tables, collapse = ", "), "]")
  }, character(1))

  topic_choices <- c(topic_titles, "[Back to Categories]")
  top_idx <- utils::menu(topic_choices, title = "Select a topic:")

  if (top_idx == 0 || top_idx == length(topic_choices)) {
    return(NULL)
  }

  chosen <- cat_topics[[top_idx]]

  # Topic Preview & Confirmation
  cli::cli_h3(chosen$title)
  cli::cli_text("{.emph {chosen$description}}")
  cli::cli_text("{.field Tables}: {paste(chosen$tables, collapse = ', ')}")
  cli::cli_text("{.field Universe}: {chosen$universe}")
  cli::cli_text("{.field Components}: {paste(chosen$components, collapse = ', ')}")
  if (!is.null(chosen$caveat)) {
    cli::cli_alert_info("{chosen$caveat}")
  }

  confirm_choices <- c("Use this topic", "Select a different topic")
  c_idx <- utils::menu(confirm_choices, title = "Proceed with this topic?")
  if (c_idx == 1) {
    return(chosen)
  }

  NULL
}

prompt_geography_selection <- function(default_geography = "state") {
  common_geos <- common_acs_geographies()
  all_geos <- all_acs_geographies()

  while (TRUE) {
    geo_choices <- c(
      unname(common_geos),
      "[Browse full list of accepted Census geographies...]",
      "[Enter custom geography string...]"
    )

    geo_idx <- utils::menu(geo_choices, title = "Select Geography Level (Common):")
    if (geo_idx == 0) {
      return(default_geography)
    }

    if (geo_idx <= length(common_geos)) {
      return(names(common_geos)[geo_idx])
    }

    # Full list option
    if (geo_idx == length(common_geos) + 1) {
      all_choices <- c(
        unname(all_geos),
        "[Back to common geographies]"
      )
      all_idx <- utils::menu(all_choices, title = "Select from full list of Census geographies:")
      if (all_idx > 0 && all_idx <= length(all_geos)) {
        return(names(all_geos)[all_idx])
      }
      # If 0 or [Back...], loop back to common list
      next
    }

    # Custom string option
    if (geo_idx == length(common_geos) + 2) {
      custom_in <- readline(prompt = "Enter custom geography name (e.g. 'county subdivision', 'public use microdata area'): ")
      custom_trimmed <- trimws(custom_in)
      if (nzchar(custom_trimmed)) {
        return(custom_trimmed)
      }
      next
    }
  }
}

prompt_query_parameters <- function(year = 2024,
                                    survey = "acs5",
                                    geography = "state",
                                    state = NULL) {
  if (!interactive()) {
    return(list(
      year = year,
      survey = survey,
      geography = geography,
      state = state
    ))
  }

  cli::cli_h2("Step 2: Configure Download Parameters")

  # Year prompt
  year_input <- readline(prompt = paste0("ACS Vintage Year [default: ", year, "]: "))
  year_val <- if (nzchar(trimws(year_input))) as.integer(trimws(year_input)) else year
  if (is.na(year_val)) year_val <- year

  # Survey prompt
  survey_choices <- c("acs5 (5-Year Estimates - Recommended for all geographies)", "acs1 (1-Year Estimates - Areas with pop 65,000+)")
  survey_idx <- utils::menu(survey_choices, title = "Select Survey Dataset:")
  survey_val <- if (survey_idx == 2) "acs1" else "acs5"

  # Geography prompt (Common list -> Full list / Custom)
  geo_val <- prompt_geography_selection(default_geography = geography)

  # State filter prompt
  state_val <- state
  if (geo_val != "us") {
    default_state_txt <- if (!is.null(state) && nzchar(state)) paste0(" [default: ", state, "]") else " (e.g., 'MA', 'NV', or press enter for none)"
    state_input <- readline(prompt = paste0("State filter", default_state_txt, ": "))
    state_trimmed <- trimws(state_input)
    if (nzchar(state_trimmed)) {
      state_val <- toupper(state_trimmed)
    }
  }

  list(
    year = year_val,
    survey = survey_val,
    geography = geo_val,
    state = state_val
  )
}

prompt_destination <- function(topic_id, year, output_dir = NULL, filename = NULL) {
  default_fname <- paste0("get_", topic_id, "_", year, ".R")

  if (!interactive() || (!is.null(output_dir) && !is.null(filename))) {
    target_dir <- output_dir %||% "."
    target_fname <- filename %||% default_fname
    dir.create(target_dir, recursive = TRUE, showWarnings = FALSE)
    return(list(
      is_temp = FALSE,
      path = file.path(target_dir, target_fname)
    ))
  }

  cli::cli_h2("Step 3: Choose Output Destination")

  dest_options <- c(
    "Temporary scratchpad file (Quick copy & paste)",
    "Save file to current project directory"
  )
  dest_choice <- utils::menu(dest_options, title = "Where would you like to create the script?")

  if (dest_choice == 1) {
    tmp <- tempfile(pattern = paste0("acs_", topic_id, "_"), fileext = ".R")
    return(list(is_temp = TRUE, path = tmp))
  }

  # Discover existing directories in current working directory
  all_entries <- list.dirs(path = ".", full.names = FALSE, recursive = FALSE)
  # Filter out hidden or build directories
  candidate_dirs <- all_entries[!grepl("^(\\.|renv|revdep)", all_entries)]

  dir_choices <- c(
    "Project Root (./)",
    candidate_dirs,
    "Create a new folder..."
  )

  dir_idx <- utils::menu(dir_choices, title = "Select destination folder:")
  if (dir_idx == 0 || dir_idx == 1) {
    selected_dir <- "."
  } else if (dir_idx == length(dir_choices)) {
    new_folder <- readline(prompt = "Enter new folder path (e.g. 'scripts/acs' or 'analysis'): ")
    selected_dir <- trimws(new_folder)
    if (!nzchar(selected_dir)) selected_dir <- "."
    dir.create(selected_dir, recursive = TRUE, showWarnings = FALSE)
  } else {
    selected_dir <- dir_choices[dir_idx]
  }

  # Filename prompt
  fname_input <- readline(prompt = paste0("Filename [default: ", default_fname, "]: "))
  fname_trimmed <- trimws(fname_input)
  final_fname <- if (nzchar(fname_trimmed)) {
    if (!grepl("\\.[Rr]$", fname_trimmed)) paste0(fname_trimmed, ".R") else fname_trimmed
  } else {
    default_fname
  }

  final_path <- file.path(selected_dir, final_fname)
  list(is_temp = FALSE, path = final_path)
}
