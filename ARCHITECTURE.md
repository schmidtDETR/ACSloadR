# ACSloadR Package Architecture & Developer Guide

This document describes the internal architecture of `ACSloadR` and provides guidance for developers adding new Census Bureau American Community Survey (ACS) tables, modifying parsers, or extending the interactive CLI wizard.

---

## 1. Overview & Design Philosophy

`ACSloadR` provides frictionless, tidy access to Census Bureau ACS data for Labor Market Information (LMI) and socioeconomic analysis. It follows these key design principles:

1. **Tidy Long-Data Format**: Raw ACS variables are transformed into standardized long-data tibbles containing explicit dimension columns (e.g. `age_group`, `sex`, `income_bracket`, `migration_status`).
2. **Automated Share Derivation**: Where appropriate, percentage shares are derived automatically (`value_source = "derived_share"`), propagating 90% Margins of Error (MOEs) using Census Bureau formulas.
3. **Survey Table Routing**: Automatically manages survey differences between 1-year and 5-year ACS releases (e.g., routing to detailed `B` tables for ACS 1-year and collapsed `C` tables for ACS 5-year).
4. **Structured S3 Bundles**: Related ACS tables are grouped into cohesive `acs_lmi_bundle` objects for intuitive downstream analysis.
5. **Interactive Exploration & Script Generation**: Provides CLI wizard (`acs_wizard()`) and Shiny explorer (`explore_census_data()`) backed by a central topic catalog.

---

## 2. Directory & Codebase Map

```
R/
├── acs-core.R            # Core table loader (load_acs_lmi_table), share calculations, S3 bundle constructor
├── table-registry.R      # Central master registry of ACS table configurations (acs_table_registry)
├── topic-parsers.R       # Label tokenizers, topic-specific parsers, and dispatch router (parse_acs_topic)
├── get-acs-lmi.R         # Public exported topic getter functions (get_acs_* returning acs_lmi_bundle)
├── label-parsing.R       # Tidy Census label tokenization helpers (acs_label_tokens, token_at, deepest_token)
├── globals.R             # Global NSE variable declarations for R CMD check (globalVariables)
├── wizard-topics.R       # Topic catalog metadata (acs_topic_catalog) for wizard and script generator
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

## 3. Core Data Flow & Layer Responsibilities

```
                                  +-----------------------+
                                  | User / Public API     |
                                  | (get_acs_migration_*) |
                                  +-----------+-----------+
                                              |
                                              v
                                  +-----------------------+
                                  |  R/table-registry.R   |
                                  | (acs_table_registry)  |
                                  +-----------+-----------+
                                              |
                                              v
                                  +-----------------------+
                                  |    R/acs-core.R       |
                                  | (load_acs_lmi_table)  |
                                  +-----------+-----------+
                                              |
                                              v
                                  +-----------------------+
                                  |  R/topic-parsers.R    |
                                  |  (parse_acs_topic)    |
                                  +-----------+-----------+
                                              |
                                              v
                                  +-----------------------+
                                  | S3 acs_lmi_bundle     |
                                  +-----------------------+
```

---

## 4. Impact of Table Changes on the Interactive Wizard

The terminal wizard (`acs_wizard()`), script generator (`generate_acs_script()`), and variable explorer rely directly on `acs_topic_catalog()` defined in [`R/wizard-topics.R`](file:///Users/mremb/projects/ACSloadR/R/wizard-topics.R).

### Why Catalog Synchronization is Mandatory
Whenever you:
- **Add a new ACS table or public getter function**
- **Modify existing table codes or survey routing (ACS 1-yr vs ACS 5-yr)**
- **Add, remove, or rename returned bundle components**

...you **MUST** update [`R/wizard-topics.R`](file:///Users/mremb/projects/ACSloadR/R/wizard-topics.R) to maintain complete synchronization between the package's public API and the topic catalog.

If `acs_topic_catalog()` is out of date:
- `acs_wizard()` will not present new topics to users in interactive CLI prompts.
- `generate_acs_script()` will produce broken or incomplete R code.
- Unit tests in `tests/testthat/test-wizard.R` will fail.

---

## 5. Developer Step-by-Step Checklist for Adding/Modifying Tables

When adding a new Census table or updating table logic, follow these steps in order:

### Step 1: Add Table Configuration to [`R/table-registry.R`](file:///Users/mremb/projects/ACSloadR/R/table-registry.R)
Add entry to `acs_table_registry()`:
```r
my_topic_acs1 = list(
  tables = "B12345",
  dataset_type = "detailed",
  parser = "my_topic",
  universe = "Population description",
  shares = TRUE
)
```

### Step 2: Implement Tidy Parser in [`R/topic-parsers.R`](file:///Users/mremb/projects/ACSloadR/R/topic-parsers.R)
- Add switch case to `parse_acs_topic()`.
- Write `parse_my_topic_data(data, config)` using `acs_label_tokens()`, `token_at()`, and `deepest_token()`.
- Call `add_share_rows()` if derived shares are enabled, then `finalize_acs_data(data, key_cols)`.
- *For detailed step-by-step guidance on writing topic parsers, see Section 6 below.*

### Step 3: Export Public Getter Function in [`R/get-acs-lmi.R`](file:///Users/mremb/projects/ACSloadR/R/get-acs-lmi.R)
- Define `get_acs_my_topic(year, survey, geography, ..., cache_table = TRUE)`.
- Use roxygen2 doc tags (`#' @export`, `#' @return`, etc.).
- Return an `acs_lmi_bundle` via `new_acs_lmi_bundle(components, topic_name, year, survey)`.

### Step 4: Register NSE Columns in [`R/globals.R`](file:///Users/mremb/projects/ACSloadR/R/globals.R)
- Add any newly introduced column names to `globalVariables()` to maintain clean `R CMD check` runs.

### Step 5: Update Topic Catalog in [`R/wizard-topics.R`](file:///Users/mremb/projects/ACSloadR/R/wizard-topics.R)
Add or update the topic specification in `acs_topic_catalog()`:
```r
my_topic = list(
  id = "my_topic",
  category = c("Category Name"),
  title = "Human Readable Title",
  getter = "get_acs_my_topic",
  tables = c("B12345"),
  universe = "Population description",
  components = c("component_1", "component_2"),
  description = "Detailed topic description.",
  default_var = "my_var"
)
```

### Step 6: Add Fixtures & Unit Tests
- Add mock Census API rows to [`tests/testthat/fixtures/table_rows.csv`](file:///Users/mremb/projects/ACSloadR/tests/testthat/fixtures/table_rows.csv).
- Add parser tests in [`tests/testthat/test-topic-parsers.R`](file:///Users/mremb/projects/ACSloadR/tests/testthat/test-topic-parsers.R).
- Add bundle print tests in [`tests/testthat/test-bundle.R`](file:///Users/mremb/projects/ACSloadR/tests/testthat/test-bundle.R).
- Ensure [`tests/testthat/test-wizard.R`](file:///Users/mremb/projects/ACSloadR/tests/testthat/test-wizard.R) passes.

### Step 7: Documentation & Verification
- Run `roxygen2::roxygenise()` to update `NAMESPACE` and `man/*.Rd`.
- Run unit test suite: `Rscript -e "pkgload::load_all(); testthat::test_dir('tests/testthat')"`.
- Update [`README.md`](file:///Users/mremb/projects/ACSloadR/README.md) and [`vignettes/getting-started.Rmd`](file:///Users/mremb/projects/ACSloadR/vignettes/getting-started.Rmd).

---

## 6. Deep Dive: Topic Parser Mechanics & Implementation Guide

Converting raw Census Bureau API rows into tidy long data is the core transformation engine of `ACSloadR`. This section explains label tokenization, parser architecture, edge-case handling, and share derivation.

### 6.1 Understanding Census Variable Labels
Raw Census variable labels are returned as colon-delimited hierarchical strings:
```
"Estimate!!Total:"
"Estimate!!Total:!!Male:"
"Estimate!!Total:!!Male:!!Management, business, science, and arts occupations:"
"Estimate!!Total:!!Male:!!Management, business, science, and arts occupations:!!Management occupations"
```

### 6.2 Tokenizer Helpers (`R/label-parsing.R`)
[`R/label-parsing.R`](file:///Users/mremb/projects/ACSloadR/R/label-parsing.R) provides 3 core tokenization functions used by all parsers:

1. **`acs_label_tokens(labels, remove_measure = TRUE)`**:
   Strips `"Estimate!!"` and `"Margin of Error!!"`, splits on `"!!"`, trims trailing colons, and returns a list of token vectors:
   - Input: `"Estimate!!Total:!!Male:!!Management occupations:"`
   - Output: `c("Total", "Male", "Management occupations")`

2. **`token_at(tokens, position)`**:
   Extracts the token at specific 1-indexed position across all rows, returning `NA_character_` if the row token depth is smaller:
   - `token_at(tokens, 1L)` -> `"Total"`, `"Male"`, `"Female"`

3. **`deepest_token(tokens, start = 1L)`**:
   Extracts the innermost (leaf) node token starting at or after index `start`. Essential for extracting specific categories regardless of hierarchy depth.

---

### 6.3 Anatomy of a Standard Topic Parser

Every parser function takes two arguments: `data` (a downloaded data frame) and `config` (the table configuration list from `acs_table_registry()`).

```r
parse_my_topic_data <- function(data, config) {
  # 1. Tokenize labels
  tokens <- acs_label_tokens(data$label)
  first <- token_at(tokens, 1L)

  # 2. Assign standard metadata
  data$universe <- config$universe
  data$measure <- "population"      # or "workers", "median_income", "median_age", etc.
  data$unit <- "count"             # or "dollars", "years", "minutes", etc.

  # 3. Extract dimension columns using token helpers
  data$group_level <- dplyr::if_else(!is.na(first), first, "Total")
  data$category <- deepest_token(tokens, start = 2L)
  data$category[is.na(data$category)] <- "Total"

  # 4. Set default value source
  data$value_source <- "published"
  data$denominator_variable <- NA_character_

  # 5. Derive percentage shares (if enabled in registry config)
  denominator <- paste0(data$table, "_001")
  data <- add_share_rows(data, rep(config$shares, nrow(data)), denominator)

  # 6. Finalize output column order and sort keys
  finalize_acs_data(data, c("group_level", "category"))
}
```

---

### 6.4 The Parser Switch Router
In [`R/topic-parsers.R`](file:///Users/mremb/projects/ACSloadR/R/topic-parsers.R), `parse_acs_topic()` dispatches table data based on `config$parser`:

```r
parse_acs_topic <- function(data, parser, config) {
  switch(
    parser,
    employment_status = parse_employment_status_data(data, config),
    migration_age     = parse_migration_age_data(data, config),
    commuting_mode    = parse_commuting_mode_data(data, config),
    ...
    stop("Unknown ACS parser: ", parser, call. = FALSE)
  )
}
```

---

### 6.5 Handling Complex Table Types & Edge Cases

#### Case A: Racial Iteration Companion Tables (`A` through `I` Suffixes)
Census publishes racial iterations of standard tables using letter suffixes (`B01001A` = White Alone, `B01001B` = Black Alone, etc.).
Use `parse_income_race_suffix(table)` to automatically attach racial group names:
```r
parse_migration_race_data <- function(data, config) {
  tokens <- acs_label_tokens(data$label)
  race <- parse_income_race_suffix(data$table[[1]])  # Maps "B07004A" -> "White alone"

  data$race_ethnicity <- if (!is.na(race)) race else NA_character_
  data$universe <- if (!is.na(race)) paste0(race, " population 1 year and over") else config$universe
  ...
}
```

#### Case B: Tables Lacking Total Sex Rows (`B24082`, `B24032`, `B24012`)
Some Census earnings tables break down categories by `Male` and `Female` but omit total sex rows.
In these parsers, `ACSloadR` calculates derived `sex = "Total"` rows by summing estimates and combining MOEs with $\sqrt{\text{MOE}_1^2 + \text{MOE}_2^2}$:
```r
data$value_source <- "derived"
data$source_variables <- paste(male_var, female_var, sep = ", ")
```

#### Case C: Collapsed Companion Series (`B` vs. `C` Tables)
ACS 1-year uses detailed `B` series tables (e.g. `B24010`), while ACS 5-year uses collapsed `C` series tables (e.g. `C24010`).
The parser uses `deepest_token()` so that both detailed and collapsed category labels map seamlessly to the same dimension columns.

---

### 6.6 Share Derivation & Finalization

1. **`add_share_rows(data, eligible, denominator_variable)`**:
   - Calculates $\text{share} = 100 \times \frac{\text{estimate}}{\text{denominator\_estimate}}$.
   - Computes margin of error using the Census proportion MOE formula:
     $$\text{MOE}_{\text{share}} = \frac{100}{\text{denom}} \sqrt{\text{MOE}_{\text{num}}^2 - \left(\text{share}^2 \times \text{MOE}_{\text{denom}}^2\right)}$$
   - Adds derived share rows with `value_source = "derived_share"`, `measure = "share_of_table_universe"`, `unit = "percent"`.

2. **`finalize_acs_data(data, key_cols)`**:
   - Reorders columns into standard schema: `GEOID`, `NAME`, `variable`, `label`, `concept`, `table`, `year`, `survey`, `universe`, `measure`, `unit`, `estimate`, `moe`, `value_source`, `denominator_variable`, `source_variables`, followed by topic dimension columns (`key_cols`).
   - Sorts rows deterministically by geography and variable keys.

---

## 7. Testing & Quality Assurance Protocols

To verify package integrity before submitting pull requests or committing:

```bash
# 1. Regenerate roxygen documentation and NAMESPACE
Rscript -e "roxygen2::roxygenise()"

# 2. Execute unit test suite
Rscript -e "pkgload::load_all(); testthat::test_dir('tests/testthat')"
```

All 380+ unit tests must pass with **0 failures** and **0 warnings**.
