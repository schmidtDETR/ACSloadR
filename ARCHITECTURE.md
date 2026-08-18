# ACSloadR Package Architecture & Developer Guide

This document describes the architecture of `ACSloadR` and serves as a step-by-step reference guide for developers and contributors adding new Census Bureau American Community Survey (ACS) tables, defining declarative schemas, exporting getter functions, or updating the interactive wizard.

---

## 1. Architecture Overview & Data Flow

`ACSloadR` transforms raw Census Bureau ACS API data (downloaded via `tidycensus`) into tidy long-data tibbles wrapped in structured `acs_lmi_bundle` objects.

```
                           +-------------------------------------+
                           | 1. User / Public Getter Function    |
                           |    get_acs_migration(...)           |
                           +------------------+------------------+
                                              |
                                              v
                           +-------------------------------------+
                           | 2. Master Table Registry            |
                           |    R/table-registry.R               |
                           |    (Declarative Schema Configuration)|
                           +------------------+------------------+
                                              |
                                              v
                           +-------------------------------------+
                           | 3. Raw Census Data Loader           |
                           |    R/acs-core.R                     |
                           |    (load_acs_lmi_table via tidycensus|
                           +------------------+------------------+
                                              |
                                              v
                           +-------------------------------------+
                           | 4. Declarative Schema Parser Engine |
                           |    R/topic-parsers.R                |
                           |    parse_generic_table(data, config)|
                           +------------------+------------------+
                                              |
                                              v
                           +-------------------------------------+
                           | 5. Tidy S3 Output Bundle            |
                           |    acs_lmi_bundle(migration = ...)  |
                           +-------------------------------------+
```

---

## 2. Directory & Codebase Map

```
R/
├── table-registry.R      # Master table registry & declarative schemas (acs_table_registry)
├── topic-parsers.R       # Generic schema engine (parse_generic_table) & custom escape hatches
├── get-acs-lmi.R         # Exported public topic getter functions (get_acs_* returning acs_lmi_bundle)
├── label-parsing.R       # Label tokenization helpers (acs_label_tokens, token_at, deepest_token)
├── acs-core.R            # Core table loader (load_acs_lmi_table), run_topic_getter helper, S3 bundles
├── globals.R             # Global NSE variable declarations for R CMD check (globalVariables)
├── wizard-topics.R       # Topic catalog metadata (acs_topic_catalog) for CLI wizard & script generator
├── wizard.R              # Terminal CLI wizard (acs_wizard) & script builder (generate_acs_script)
└── explore_census_data.R # Shiny interactive data explorer app launcher

tests/testthat/
├── fixtures/
│   └── table_rows.csv    # Mock Census API responses for unit tests
├── test-bundle.R         # S3 bundle construction and print tests
├── test-label-parsing.R  # Tokenizer and label parsing tests
├── test-topic-parsers.R  # Topic parser tests
├── test-wizard.R         # Catalog consistency and script builder tests
└── test-live-census.R    # Optional live Census API tests
```

---

## 3. End-to-End Guide: Adding a New Table (Start-to-Finish)

Adding a new standard ACS table to `ACSloadR` requires **zero custom parsing code**. Follow these 5 steps in order:

### Step 1: Inspect Raw `tidycensus` API Output

Suppose you are adding ACS table **`B07001`** (*Geographical Mobility 1 Year Ago by Age*). Pull the raw table using `tidycensus` to inspect the `label` column:

```r
raw_census_data <- tidycensus::get_acs(
  geography = "state",
  table = "B07001",
  year = 2024,
  survey = "acs1"
)
```

#### What `tidycensus` Returns:
| `variable` | `label` | `estimate` |
| :--- | :--- | :--- |
| `B07001_001` | `Estimate!!Total:` | `7,025,000` |
| `B07001_002` | `Estimate!!Total:!!1 to 4 years:` | `320,000` |
| `B07001_003` | `Estimate!!Total:!!1 to 4 years:!!Same house 1 year ago` | `280,000` |
| `B07001_004` | `Estimate!!Total:!!1 to 4 years:!!Moved; same county` | `25,000` |

#### How `ACSloadR` Tokenizes the Labels (`acs_label_tokens()`):
When `acs_label_tokens()` strips `"Estimate!!"` and trailing colons, it converts each label into a 1-indexed vector:
- **Token Index `1L`**: `"Total"` (always position 0 of demographic breakdowns).
- **Token Index `2L`**: `"1 to 4 years"` (the 1st demographic breakdown level).
- **Token Index `3L`**: `"Same house 1 year ago"` (the 2nd demographic category level).

---

### Step 2: Register Table & Declarative Schema in [`R/table-registry.R`](file:///Users/mremb/projects/ACSloadR/R/table-registry.R)

Add your topic entry to `acs_table_registry()`. Set `parser = "generic"` and provide a `schema`:

```r
# In R/table-registry.R -> acs_table_registry()
migration_current_age_acs1 = list(
  tables = "B07001",
  dataset_type = "detailed",
  parser = "generic",
  universe = "Population 1 year and over in current residence",
  shares = TRUE,
  schema = list(
    levels = c(age_group = 2L),              # Token index 2 (1st level after Total) -> age_group column
    category_col = "migration_status",        # Innermost token -> migration_status column
    category_start_level = 2L,                # Look for category starting at token index 2 (skipping Total)
    measure = "population",
    unit = "count",
    key_cols = c("age_group", "migration_status")
  )
)
```

#### Declarative Schema Parameters Reference:
- `levels`: Named integer vector mapping token depth index to column names (e.g. `c(sex = 2L, age_group = 3L)`).
- `category_col`: Name of the column capturing the innermost category token (e.g. `"migration_status"`, `"transportation_mode"`).
- `category_start_level`: Starting token depth level to search for the category token (defaults to `1L`).
- `default_category`: Fallback value if category token is missing (defaults to `"Total"`).
- `race_suffix`: Set `TRUE` for `A`-`I` race/ethnicity tables to parse suffixes automatically.
- `sex_cross`: Set `TRUE` to cross-tabulate `sex` with a secondary dimension.
- `measure`: Value for the `measure` column (e.g. `"population"`, `"workers"`, `"median_income"`).
- `unit`: Value for the `unit` column (e.g. `"count"`, `"dollars"`, `"years"`).
- `key_cols`: Character vector specifying output column sorting order.

---

### Step 3: Export Public Getter Function in [`R/get-acs-lmi.R`](file:///Users/mremb/projects/ACSloadR/R/get-acs-lmi.R)

Exporting a public getter function is simplified using the 1-line `run_topic_getter()` helper!

#### A. Standard Single-Component Getter (Simplified):
```r
#' Get tidy ACS migration status data
#'
#' Downloads Census table B07001 containing geographical mobility status
#' broken down by age group for current residence.
#'
#' @inheritParams get_acs_employment
#'
#' @return An `acs_lmi_bundle` containing a `migration` tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' migration <- get_acs_migration(2024, "acs5", "state", state = "MA")
#' migration$migration
#' }
get_acs_migration <- function(year, survey = c("acs5", "acs1"), geography, ...,
                              cache_table = TRUE) {
  survey <- match.arg(survey)
  run_topic_getter(
    registry_name = "migration_current_age_acs1",
    topic = "Geographical Mobility",
    component_name = "migration",
    year = year,
    survey = survey,
    geography = geography,
    cache_table = cache_table,
    ...
  )
}
```

#### B. Multi-Component Getter (e.g. Total Population + Race Breakdown):
If your topic combines multiple table structures into a single bundle:
```r
get_acs_age <- function(year, survey = c("acs5", "acs1"), geography, ...,
                        cache_table = TRUE) {
  survey <- match.arg(survey)
  registry <- acs_table_registry()
  
  total_raw <- load_acs_lmi_table(registry$age_total_population, year, survey, geography, cache_table, ...)
  race_raw  <- load_acs_lmi_table(registry$age_race_ethnicity, year, survey, geography, cache_table, ...)

  components <- list(
    total_population = parse_acs_topic(total_raw, registry$age_total_population$parser, registry$age_total_population),
    race_ethnicity   = parse_acs_topic(race_raw, registry$age_race_ethnicity$parser, registry$age_race_ethnicity)
  )
  new_acs_lmi_bundle(components, "Age and sex", year, survey)
}
```

---

### Step 4: Synchronize Topic Catalog in [`R/wizard-topics.R`](file:///Users/mremb/projects/ACSloadR/R/wizard-topics.R)

To make your topic accessible in the terminal wizard (`acs_wizard()`) and R script generator (`generate_acs_script()`), register it in `acs_topic_catalog()`:

```r
# In R/wizard-topics.R -> acs_topic_catalog()
migration = list(
  id = "migration",
  category = c("Demographics & Population"),
  title = "Geographical Mobility & Migration Status",
  getter = "get_acs_migration",
  tables = c("B07001"),
  universe = "Population 1 year and over in current residence",
  components = c("migration"),
  description = "Geographical mobility (same house, moved within same county, moved within same state, etc.) by age group.",
  default_var = "migration_status"
)
```

---

### Step 5: Add Fixtures & Verify Unit Tests

1. Add mock Census API rows to [`tests/testthat/fixtures/table_rows.csv`](file:///Users/mremb/projects/ACSloadR/tests/testthat/fixtures/table_rows.csv).
2. Add parser tests in [`tests/testthat/test-topic-parsers.R`](file:///Users/mremb/projects/ACSloadR/tests/testthat/test-topic-parsers.R).
3. Run the verification command:
   ```bash
   Rscript -e "pkgload::load_all(); testthat::test_dir('tests/testthat')"
   ```

---

## 4. Resulting Tidy Long Data Structure

When a user invokes your exported getter function `get_acs_migration(2024, "acs5", "state", state = "MA")`, `parse_generic_table()` automatically formats the data into this tidy long tibble:

| `variable` | `age_group` | `migration_status` | `estimate` | `moe` | `measure` | `unit` | `value_source` |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `B07001_001` | `Total` | `Total` | `7025000` | `10000` | `population` | `count` | `published` |
| `B07001_002` | `1 to 4 years` | `Total` | `320000` | `4000` | `population` | `count` | `published` |
| `B07001_003` | `1 to 4 years` | `Same house 1 year ago` | `280000` | `3500` | `population` | `count` | `published` |
| `B07001_004` | `1 to 4 years` | `Moved; same county` | `25000` | `1200` | `population` | `count` | `published` |
| `B07001_004` | `1 to 4 years` | `Moved; same county` | `7.81` | `0.38` | `share` | `percent` | `derived_share` |

---

## 5. Custom Escape-Hatch Parsers (Only for Complex Subject Tables)

For non-standard subject tables (such as `S2301` or `S2401`) where the label structure cannot be expressed with declarative schemas, write a custom imperative parser function in [`R/topic-parsers.R`](file:///Users/mremb/projects/ACSloadR/R/topic-parsers.R):

```r
# In R/topic-parsers.R
parse_custom_subject_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  ...
  finalize_acs_data(data, key_cols = c("dim1", "dim2"))
}
```

In `parse_acs_topic()`, add a switch case:
```r
parse_acs_topic <- function(data, parser, config) {
  switch(parser,
    generic = parse_generic_table(data, config),
    custom_subject = parse_custom_subject_data(data, config),
    stop("Unknown parser: ", parser)
  )
}
```
