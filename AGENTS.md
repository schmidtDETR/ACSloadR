# Agent & Developer Guide for ACSloadR

This document provides architectural guidance and procedures for AI coding agents and human developers modifying or extending `ACSloadR`.

---

## 1. Codebase Architecture Overview

`ACSloadR` organizes Census Bureau American Community Survey (ACS) data extraction into modular layers:

```
R/
├── acs-core.R          # Core table loader (load_acs_lmi_table), share calculations, bundle constructor
├── table-registry.R    # Master registry of ACS table configurations and metadata (acs_table_registry)
├── topic-parsers.R     # Tidy label tokenizers, table-specific parsers, and dispatch router (parse_acs_topic)
├── get-acs-lmi.R       # Public exported topic getter functions (get_acs_* returning acs_lmi_bundle)
├── globals.R           # Global variable declarations for R CMD check (globalVariables)
├── wizard-topics.R     # Topic catalog metadata (acs_topic_catalog) for CLI wizard and code generator
├── wizard.R            # Interactive terminal wizard (acs_wizard) & script builder (generate_acs_script)
└── explore_census_data.R # Shiny interactive data explorer app launcher
```

---

## 2. Table Changes & Wizard Impact

### Why Table Changes Impact the Wizard
The interactive CLI wizard (`acs_wizard()`), script generator (`generate_acs_script()`), and topic explorer rely on `acs_topic_catalog()` in [`R/wizard-topics.R`](file:///Users/mremb/projects/ACSloadR/R/wizard-topics.R). 

Whenever you:
- **Add a new ACS table or topic getter**
- **Modify existing table codes or survey coverage (ACS 1-yr vs ACS 5-yr)**
- **Add or rename returned bundle components**

...you **MUST** update [`R/wizard-topics.R`](file:///Users/mremb/projects/ACSloadR/R/wizard-topics.R) so that the wizard catalog remains 100% in sync with the exported getter functions.

If `acs_topic_catalog()` is not updated:
- The interactive prompt in `acs_wizard()` will not display new topics to users.
- `generate_acs_script()` will produce invalid or missing code.
- Unit tests in `tests/testthat/test-wizard.R` will fail.

---

## 3. Checklist: Adding or Modifying ACS Tables

When adding new tables or updating existing table logic, follow these steps in order:

### Step 1: Register Tables in [`R/table-registry.R`](file:///Users/mremb/projects/ACSloadR/R/table-registry.R)
Add entry to `acs_table_registry()` with:
- `tables`: ACS table ID(s) (e.g. `"B07001"`, `paste0("B07004", LETTERS[1:9])`)
- `dataset_type`: `"detailed"` or `"subject"`
- `parser`: Name of the parser function in `topic-parsers.R`
- `universe`: Human-readable population universe description
- `shares`: `TRUE` if percentage share rows should be derived, `FALSE` for medians/aggregates

### Step 2: Implement Parsers in [`R/topic-parsers.R`](file:///Users/mremb/projects/ACSloadR/R/topic-parsers.R)
- Add switch case to `parse_acs_topic()`.
- Implement `parse_<topic>_data(data, config)` using `acs_label_tokens()`, `token_at()`, and `deepest_token()`.
- Ensure derived share rows are generated when appropriate and call `finalize_acs_data(data, key_cols)`.

### Step 3: Export Public Getter in [`R/get-acs-lmi.R`](file:///Users/mremb/projects/ACSloadR/R/get-acs-lmi.R)
- Define and export `get_acs_<topic>(year, survey, geography, ..., cache_table = TRUE)`.
- Use roxygen2 tags (`#' @param`, `#' @return`, `#' @export`, `#' @examples`).
- Handle survey routing (e.g. switching between `B` tables for `acs1` and `C` tables for `acs5` where applicable).
- Return an `acs_lmi_bundle` via `new_acs_lmi_bundle(components, topic_name, year, survey)`.

### Step 4: Register Dimension Variables in [`R/globals.R`](file:///Users/mremb/projects/ACSloadR/R/globals.R)
- Add any newly introduced tidy column names (e.g. `migration_status`, `travel_time_bracket`) to `globalVariables()`.

### Step 5: Update Wizard Catalog in [`R/wizard-topics.R`](file:///Users/mremb/projects/ACSloadR/R/wizard-topics.R)
Add or update the topic specification entry in `acs_topic_catalog()`:
```r
my_topic = list(
  id = "my_topic",
  category = c("Category Name"),
  title = "Human Readable Title",
  getter = "get_acs_my_topic",
  tables = c("B12345"),
  universe = "Universe description",
  components = c("component_1", "component_2"),
  description = "Detailed description.",
  default_var = "my_var"
)
```

### Step 6: Update Fixtures & Unit Tests
- Add mock Census API rows to [`tests/testthat/fixtures/table_rows.csv`](file:///Users/mremb/projects/ACSloadR/tests/testthat/fixtures/table_rows.csv).
- Add parser tests in [`tests/testthat/test-topic-parsers.R`](file:///Users/mremb/projects/ACSloadR/tests/testthat/test-topic-parsers.R).
- Add bundle print tests in [`tests/testthat/test-bundle.R`](file:///Users/mremb/projects/ACSloadR/tests/testthat/test-bundle.R).
- Run wizard tests in [`tests/testthat/test-wizard.R`](file:///Users/mremb/projects/ACSloadR/tests/testthat/test-wizard.R).

### Step 7: Regenerate Documentation & Run Verification
- Run `roxygen2::roxygenise()` to update `NAMESPACE` and `man/*.Rd`.
- Run full test suite: `Rscript -e "pkgload::load_all(); testthat::test_dir('tests/testthat')"`.
- Run live API verification against Census API.
- Update [`README.md`](file:///Users/mremb/projects/ACSloadR/README.md) and [`vignettes/getting-started.Rmd`](file:///Users/mremb/projects/ACSloadR/vignettes/getting-started.Rmd).

---

## 4. Testing Protocols

Before committing any changes, run:
```bash
# 1. Regenerate docs and NAMESPACE
Rscript -e "roxygen2::roxygenise()"

# 2. Run unit test suite
Rscript -e "pkgload::load_all(); testthat::test_dir('tests/testthat')"
```

All 380+ tests must pass with 0 failures and 0 warnings.
