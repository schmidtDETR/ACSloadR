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

## 6. Testing & Quality Assurance Protocols

To verify package integrity before submitting pull requests or committing:

```bash
# 1. Regenerate roxygen documentation and NAMESPACE
Rscript -e "roxygen2::roxygenise()"

# 2. Execute unit test suite
Rscript -e "pkgload::load_all(); testthat::test_dir('tests/testthat')"
```

All 380+ unit tests must pass with **0 failures** and **0 warnings**.
